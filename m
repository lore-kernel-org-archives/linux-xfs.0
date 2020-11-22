Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAA95C56202
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Nov 2020 14:36:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF1CA2078E
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Nov 2020 14:36:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgKVOg1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Nov 2020 09:36:27 -0500
Received: from out20-13.mail.aliyun.com ([115.124.20.13]:40475 "EHLO
        out20-13.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbgKVOg0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Nov 2020 09:36:26 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.08755226|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.0377145-0.00088181-0.961404;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047193;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.IzrUXFb_1606055752;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.IzrUXFb_1606055752)
          by smtp.aliyun-inc.com(10.147.41.158);
          Sun, 22 Nov 2020 22:35:53 +0800
Date:   Sun, 22 Nov 2020 22:35:52 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/6] check: run tests in a systemd scope for mandatory
 test cleanup
Message-ID: <20201122143552.GL3853@desktop>
References: <160505537312.1388647.14788379902518687395.stgit@magnolia>
 <160505539618.1388647.12413009405934961273.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160505539618.1388647.12413009405934961273.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 10, 2020 at 04:43:16PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> TLDR: If systemd is available, run each test in its own temporary
> systemd scope.  This enables the test harness to forcibly clean up all
> of the test's child processes (if it does not do so itself) so that we
> can move into the post-test unmount and check cleanly.
> 
> I frequently run fstests in "low" memory situations (2GB!) to force the
> kernel to do interesting things.  There are a few tests like generic/224
> and generic/561 that put processes in the background and occasionally
> trigger the OOM killer.  Most of the time the OOM killer correctly
> shoots down fsstress or duperemove, but once in a while it's stupid
> enough to shoot down the test control process (i.e. tests/generic/224)
> instead.  fsstress is still running in the background, and the one
> process that knew about that is dead.
> 
> When the control process dies, ./check moves on to the post-test fsck,
> which fails because fsstress is still running and we can't unmount.
> After fsck fails, ./check moves on to the next test, which fails because
> fsstress is /still/ writing to the filesystem and we can't unmount or
> format.
> 
> The end result is that that one OOM kill causes cascading test failures,
> and I have to re-start fstests to see if I get a clean(er) run.
> 
> So, the solution I present in this patch is to teach ./check to try to
> run the test script in a systemd scope.  If that succeeds, ./check will
> tell systemd to kill the scope when the test script exits and returns
> control to ./check.  Concretely, this means that systemd creates a new
> cgroup, stuffs the processes in that cgroup, and when we kill the scope,
> systemd kills all the processes in that cgroup and deletes the cgroup.
> 
> The end result is that fstests now has an easy way to ensure that /all/
> child processes of a test are dead before we try to unmount the test and
> scratch devices.  I've designed this to be optional, because not
> everyone does or wants or likes to run systemd, but it makes QA easier.

Currently it uses systemd if the host has systemd enabled. Perhaps we
could add an env to control the systemd usage in the future so we have a
knob to turn it off even on hosts with systemd enabled. e.g.

USE_SYSTEMD_SCOPES=yes

But I'd take it as is for now.

Thanks,
Eryu

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  check |   26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/check b/check
> index 5072dd82..83f6fc8b 100755
> --- a/check
> +++ b/check
> @@ -521,6 +521,12 @@ _expunge_test()
>  	return 0
>  }
>  
> +# Can we run systemd scopes?
> +HAVE_SYSTEMD_SCOPES=
> +systemctl reset-failed "fstests-check" &>/dev/null
> +systemd-run --quiet --unit "fstests-check" --scope bash -c "exit 77" &> /dev/null
> +test $? -eq 77 && HAVE_SYSTEMD_SCOPES=yes
> +
>  # Make the check script unattractive to the OOM killer...
>  OOM_SCORE_ADJ="/proc/self/oom_score_adj"
>  test -w ${OOM_SCORE_ADJ} && echo -1000 > ${OOM_SCORE_ADJ}
> @@ -528,8 +534,26 @@ test -w ${OOM_SCORE_ADJ} && echo -1000 > ${OOM_SCORE_ADJ}
>  # ...and make the tests themselves somewhat more attractive to it, so that if
>  # the system runs out of memory it'll be the test that gets killed and not the
>  # test framework.
> +#
> +# If systemd is available, run the entire test script in a scope so that we can
> +# kill all subprocesses of the test if it fails to clean up after itself.  This
> +# is essential for ensuring that the post-test unmount succeeds.  Note that
> +# systemd doesn't automatically remove transient scopes that fail to terminate
> +# when systemd tells them to terminate (e.g. programs stuck in D state when
> +# systemd sends SIGKILL), so we use reset-failed to tear down the scope.
>  _run_seq() {
> -	bash -c "test -w ${OOM_SCORE_ADJ} && echo 250 > ${OOM_SCORE_ADJ}; exec ./$seq"
> +	local cmd=(bash -c "test -w ${OOM_SCORE_ADJ} && echo 250 > ${OOM_SCORE_ADJ}; exec ./$seq")
> +
> +	if [ -n "${HAVE_SYSTEMD_SCOPES}" ]; then
> +		local unit="$(systemd-escape "fs$seq").scope"
> +		systemctl reset-failed "${unit}" &> /dev/null
> +		systemd-run --quiet --unit "${unit}" --scope "${cmd[@]}"
> +		res=$?
> +		systemctl stop "${unit}" &> /dev/null
> +		return "${res}"
> +	else
> +		"${cmd[@]}"
> +	fi
>  }
>  
>  _detect_kmemleak
