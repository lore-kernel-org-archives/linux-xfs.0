Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FFDCC00140
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Aug 2022 09:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243064AbiHRJCF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Aug 2022 05:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235263AbiHRJCE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Aug 2022 05:02:04 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9648FAE9DE
        for <linux-xfs@vger.kernel.org>; Thu, 18 Aug 2022 02:02:02 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 19E723EEAA;
        Thu, 18 Aug 2022 09:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660813318;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2NpSkHQI7sjHC98RybX6I3TUEI/WeHC22AFP/KWPXQc=;
        b=xY484MugSZ7zQoQs64ik4Gkh2LIq0J9JrPBayorA4y6czvsDlg8/jMNuxjIesyqw9AaBod
        M5k64QLsSCOvZKyRZTKlMrtmISqXmBPm+kQwQcKkBzncGCH7PAAFnIHATpC+NDJOcmXmz7
        cWu61iFx73Ozg6XB7wVe4QJlNlCQDeM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660813318;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2NpSkHQI7sjHC98RybX6I3TUEI/WeHC22AFP/KWPXQc=;
        b=DLMd15xBO4z0Dzq7ChXcbLoGMp1Eyh5KEt7LGKUbyu0fDFN+Raiaudsvr1ofmCeLFr9hbX
        BrQFLyRjQqOUi+CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B8629133B5;
        Thu, 18 Aug 2022 09:01:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Vl54KwYA/mJEdAAAMHmgww
        (envelope-from <pvorel@suse.cz>); Thu, 18 Aug 2022 09:01:58 +0000
Date:   Thu, 18 Aug 2022 11:01:56 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     ltp@lists.linux.it, Cyril Hrubis <chrubis@suse.cz>,
        Li Wang <liwang@redhat.com>, Martin Doucha <mdoucha@suse.cz>,
        automated-testing@yoctoproject.org, linux-xfs@vger.kernel.org,
        automated-testing@lists.yoctoproject.org
Subject: Re: [RFC PATCH 1/1] API: Allow to use xfs filesystems < 300 MB
Message-ID: <Yv4ABHlsP+BZ3bRD@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20220817204015.31420-1-pvorel@suse.cz>
 <Yv2A9Ggkv/NBrTd4@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv2A9Ggkv/NBrTd4@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Wed, Aug 17, 2022 at 10:40:15PM +0200, Petr Vorel wrote:
> > mkfs.xfs since v5.19.0-rc1 [1] refuses to create filesystems < 300 MB.
> > Reuse workaround intended for fstests: set 3 environment variables:
> > export TEST_DIR=1 TEST_DEV=1 QA_CHECK_FS=1

> > Workaround added to both C API (for .needs_device) and shell API (for
> > TST_NEEDS_DEVICE=1).

> > Fix includes any use of filesystem (C API: .all_filesystems,
> > .format_device, shell API: TST_MOUNT_DEVICE=1, TST_FORMAT_DEVICE=1).

> > Fixes various C and shell API failures, e.g.:

> > ./mkfs01.sh -f xfs
> > mkfs01 1 TINFO: timeout per run is 0h 5m 0s
> > tst_device.c:89: TINFO: Found free device 0 '/dev/loop0'
> > mkfs01 1 TFAIL: 'mkfs -t xfs  -f /dev/loop0 ' failed.
> > Filesystem must be larger than 300MB.

> > ./creat09
> > ...
> > tst_test.c:1599: TINFO: Testing on xfs
> > tst_test.c:1064: TINFO: Formatting /dev/loop0 with xfs opts='' extra opts=''
> > Filesystem must be larger than 300MB.

> > Link: https://lore.kernel.org/all/164738662491.3191861.15611882856331908607.stgit@magnolia/

> > Reported-by: Martin Doucha <mdoucha@suse.cz>
> > Signed-off-by: Petr Vorel <pvorel@suse.cz>
> > ---
> > Dave, please next time remember there are other testsuites testing XFS,

> Dave?? <cough>
Eh, I'm sorry.

> > not just fstests :). How long do you plan to keep this workaround?

> Forever.  In the ideal world we'll some day get around to restructuring
> all the xfstests that do tricky things with sub-500M filesystems, but
> that's the unfortunate part of removing support for small disks.

> Most of the fstests don't care about the fs size and so they'll run with
> the configured storage (some tens or millions of gigabytes) so we're
> mostly using the same fs sizes that users are expected to have.

Thanks for info.

> > LTP community: do we want to depend on this behavior or we just increase from 256MB to 301 MB
> > (either for XFS or for all). It might not be a good idea to test size users are required
> > to use.

> It might *not*? <confused>
Again, I'm sorry, missing another not. I.e. I suppose normal users will not try
to go below 301MB, therefore LTP probably should not do it either. That's why
RFC.

Kind regards,
Petr

> --D


> > Kind regards,
> > Petr
> >  lib/tst_test.c            | 7 +++++++
> >  testcases/lib/tst_test.sh | 6 +++++-
> >  2 files changed, 12 insertions(+), 1 deletion(-)

> > diff --git a/lib/tst_test.c b/lib/tst_test.c
> > index 4b4dd125d..657348732 100644
> > --- a/lib/tst_test.c
> > +++ b/lib/tst_test.c
> > @@ -1160,6 +1160,13 @@ static void do_setup(int argc, char *argv[])
> >  	if (tst_test->all_filesystems)
> >  		tst_test->needs_device = 1;

> > +	/* allow to use XFS filesystem < 300 MB */
> > +	if (tst_test->needs_device) {
> > +		putenv("TEST_DIR=1");
> > +		putenv("TEST_DEV=1");
> > +		putenv("QA_CHECK_FS=1");
> > +	}
> > +
> >  	if (tst_test->min_cpus > (unsigned long)tst_ncpus())
> >  		tst_brk(TCONF, "Test needs at least %lu CPUs online", tst_test->min_cpus);

> > diff --git a/testcases/lib/tst_test.sh b/testcases/lib/tst_test.sh
> > index 24a3d29d8..b42e54ca1 100644
> > --- a/testcases/lib/tst_test.sh
> > +++ b/testcases/lib/tst_test.sh
> > @@ -671,7 +671,11 @@ tst_run()

> >  	[ "$TST_MOUNT_DEVICE" = 1 ] && TST_FORMAT_DEVICE=1
> >  	[ "$TST_FORMAT_DEVICE" = 1 ] && TST_NEEDS_DEVICE=1
> > -	[ "$TST_NEEDS_DEVICE" = 1 ] && TST_NEEDS_TMPDIR=1
> > +	if [ "$TST_NEEDS_DEVICE" = 1 ]; then
> > +		TST_NEEDS_TMPDIR=1
> > +		# allow to use XFS filesystem < 300 MB
> > +		export TEST_DIR=1 TEST_DEV=1 QA_CHECK_FS=1
> > +	fi

> >  	if [ "$TST_NEEDS_TMPDIR" = 1 ]; then
> >  		if [ -z "$TMPDIR" ]; then
> > -- 
> > 2.37.1

