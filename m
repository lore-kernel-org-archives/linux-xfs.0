Return-Path: <SRS0=AlMJ=EI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B3AFC388F9
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 21:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EF4F22258
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 21:40:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="s4bgtLwa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgKBVkC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 16:40:02 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38320 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbgKBVkB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 16:40:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A2LZ6U1129680;
        Mon, 2 Nov 2020 21:39:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=nzuqmNkfFI7Urn8rFfVQrG+qE6j7V0bHGpyv7sLYHb8=;
 b=s4bgtLwatB9ULRzyx0zXxgS2FlDG9id+xwfy8gxxSumTFdoWfPRgsi3nS/97fKM1AwU9
 0pwl4o1H0ns/8NYIaDEs83QxIz4lv+ryeFMgGLNWjOPJ0PYqdQ/9pwmLkCDo6V/BeQ6J
 CgsXMDfMuH0mh4O/CAmw6MnQGIrvRIkF1YG0xLIzU7881TcOLu2A7kvGMSwt4nn34SuS
 OX9TplV8FmxOPgdl9FjzskqTKLpBXHQsV/kchaz8O0oxlGW+aW0JNu1S4Z2mM2nwa4nE
 o81ZvCDnJxWNIdRLKn9w+FDHqDIXNJy6U5l22nzCPXgBTVAafFOg7xxhfwXSKPJaM8eZ FA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34hhw2ea6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 02 Nov 2020 21:39:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A2LYjpf035737;
        Mon, 2 Nov 2020 21:37:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34jf477dqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Nov 2020 21:37:58 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A2LbvvX031883;
        Mon, 2 Nov 2020 21:37:57 GMT
Received: from localhost (/10.159.228.245)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Nov 2020 13:37:57 -0800
Date:   Mon, 2 Nov 2020 13:37:56 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 8/9] check: run tests in a systemd scope for mandatory
 test cleanup
Message-ID: <20201102213756.GA7118@magnolia>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
 <160382534122.1202316.7161591166906029132.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160382534122.1202316.7161591166906029132.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=3 mlxscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011020163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=3 clxscore=1015 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011020163
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 12:02:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If systemd is available, run each test in its own temporary systemd
> scope.  This enables the test harness to forcibly clean up all of the
> test's child processes (if it does not do so itself) so that we can move
> into the post-test unmount and check cleanly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  check |   21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/check b/check
> index 5072dd82..47c72fa2 100755
> --- a/check
> +++ b/check
> @@ -521,6 +521,11 @@ _expunge_test()
>  	return 0
>  }
>  
> +# Can we run systemd scopes?
> +HAVE_SYSTEMD_SCOPES=
> +systemd-run --quiet --unit "fstests-check" --scope bash -c "exit 77" &> /dev/null
> +test $? -eq 77 && HAVE_SYSTEMD_SCOPES=yes
> +
>  # Make the check script unattractive to the OOM killer...
>  OOM_SCORE_ADJ="/proc/self/oom_score_adj"
>  test -w ${OOM_SCORE_ADJ} && echo -1000 > ${OOM_SCORE_ADJ}
> @@ -528,8 +533,22 @@ test -w ${OOM_SCORE_ADJ} && echo -1000 > ${OOM_SCORE_ADJ}
>  # ...and make the tests themselves somewhat more attractive to it, so that if
>  # the system runs out of memory it'll be the test that gets killed and not the
>  # test framework.
> +#
> +# If systemd is available, run the entire test script in a scope so that we can
> +# kill all subprocesses of the test if it fails to clean up after itself.  This
> +# is essential for ensuring that the post-test unmount succeeds.
>  _run_seq() {
> -	bash -c "test -w ${OOM_SCORE_ADJ} && echo 250 > ${OOM_SCORE_ADJ}; exec ./$seq"
> +	local cmd=(bash -c "test -w ${OOM_SCORE_ADJ} && echo 250 > ${OOM_SCORE_ADJ}; exec ./$seq")
> +
> +	if [ -n "${HAVE_SYSTEMD_SCOPES}" ]; then
> +		local unit="$(systemd-escape "fs$seq").scope"
> +		systemd-run --quiet --unit "${unit}" --scope "${cmd[@]}"

/me discovers that systemd preserves failed transient scopes (where
"failed" means the processes get killed, not that they return nonzero),
so this patch has to reset-failed the scope in case the user calls
fstests before rebooting.

Hence, self NAK.

--D

> +		res=$?
> +		systemctl stop "${unit}" &> /dev/null
> +		return "${res}"
> +	else
> +		"${cmd[@]}"
> +	fi
>  }
>  
>  _detect_kmemleak
> 
