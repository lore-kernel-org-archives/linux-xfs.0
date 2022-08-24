Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B18CC00140
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Aug 2022 10:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236692AbiHXKVm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Aug 2022 06:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236712AbiHXKVk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Aug 2022 06:21:40 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9361B5C364
        for <linux-xfs@vger.kernel.org>; Wed, 24 Aug 2022 03:21:39 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DF99634130;
        Wed, 24 Aug 2022 10:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1661336497;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qfAsUdGPIwFM+BwBjh/0loP+iKjGevDQutOmBqVD0Q4=;
        b=Cg1LobxsCHG962UAsvUIVfAVgZCoR4+nbUDsz4R+2uUumX7tEaxeveS8WfQNLynLH88sfh
        HcwTqmmT44UQIOCHnBN89VWDMdX0badUmqgVUxhgoBVfRd47KIZM0GyDEU6DkbEeC9RWmC
        2rKR/AC7gHufxLVOcO0PFo4e+QFYOmE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1661336497;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qfAsUdGPIwFM+BwBjh/0loP+iKjGevDQutOmBqVD0Q4=;
        b=qS8UQgznt0gsg0JSAsVBfl+8uFumrQSrU0ghbFBFxTXnqBwCZuyTBxPBFXEursHLnlCVAQ
        RKdrAGloKayH6aAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9565E13AC0;
        Wed, 24 Aug 2022 10:21:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id aDiPIrH7BWPzGAAAMHmgww
        (envelope-from <pvorel@suse.cz>); Wed, 24 Aug 2022 10:21:37 +0000
Date:   Wed, 24 Aug 2022 12:21:35 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     ltp@lists.linux.it
Cc:     Cyril Hrubis <chrubis@suse.cz>, Li Wang <liwang@redhat.com>,
        Martin Doucha <mdoucha@suse.cz>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        automated-testing@lists.yoctoproject.org
Subject: Re: [RFC PATCH 1/1] API: Allow to use xfs filesystems < 300 MB
Message-ID: <YwX7r5VWrGRzaXoa@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20220817204015.31420-1-pvorel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817204015.31420-1-pvorel@suse.cz>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Could we in the end accept this patch?

It'd fix the issue for now and I could set size of the XFS loop device smaller
than 300 MB (better for embedded). i.e. 16 MB (or 32 or 64 MB or anything higher
if XFS developers are convinced it's needed).

As I wrote before I plan to suggest sizes:
btrfs 110 MB
the rest (ext[234], xfs, ntfs, vfat, exfat, tmpfs): 16 MB

Based on quick test:
https://lore.kernel.org/ltp/Yv%2FkVXSK0xJGb3RO@pevik/
btrfs: 109 MB, ntfs: 2 MB, ext3: 2 MB, ext[24]: 1 MB, vfat: 1 MB, exfat: 1 MB.

Kind regards,
Petr

> mkfs.xfs since v5.19.0-rc1 [1] refuses to create filesystems < 300 MB.
> Reuse workaround intended for fstests: set 3 environment variables:
> export TEST_DIR=1 TEST_DEV=1 QA_CHECK_FS=1

> Workaround added to both C API (for .needs_device) and shell API (for
> TST_NEEDS_DEVICE=1).

> Fix includes any use of filesystem (C API: .all_filesystems,
> .format_device, shell API: TST_MOUNT_DEVICE=1, TST_FORMAT_DEVICE=1).

> Fixes various C and shell API failures, e.g.:

> ./mkfs01.sh -f xfs
> mkfs01 1 TINFO: timeout per run is 0h 5m 0s
> tst_device.c:89: TINFO: Found free device 0 '/dev/loop0'
> mkfs01 1 TFAIL: 'mkfs -t xfs  -f /dev/loop0 ' failed.
> Filesystem must be larger than 300MB.

> ./creat09
> ...
> tst_test.c:1599: TINFO: Testing on xfs
> tst_test.c:1064: TINFO: Formatting /dev/loop0 with xfs opts='' extra opts=''
> Filesystem must be larger than 300MB.

> Link: https://lore.kernel.org/all/164738662491.3191861.15611882856331908607.stgit@magnolia/

> Reported-by: Martin Doucha <mdoucha@suse.cz>
> Signed-off-by: Petr Vorel <pvorel@suse.cz>
> ---
> Dave, please next time remember there are other testsuites testing XFS,
> not just fstests :). How long do you plan to keep this workaround?

> LTP community: do we want to depend on this behavior or we just increase from 256MB to 301 MB
> (either for XFS or for all). It might not be a good idea to test size users are required
> to use.

> Kind regards,
> Petr
>  lib/tst_test.c            | 7 +++++++
>  testcases/lib/tst_test.sh | 6 +++++-
>  2 files changed, 12 insertions(+), 1 deletion(-)

> diff --git a/lib/tst_test.c b/lib/tst_test.c
> index 4b4dd125d..657348732 100644
> --- a/lib/tst_test.c
> +++ b/lib/tst_test.c
> @@ -1160,6 +1160,13 @@ static void do_setup(int argc, char *argv[])
>  	if (tst_test->all_filesystems)
>  		tst_test->needs_device = 1;

> +	/* allow to use XFS filesystem < 300 MB */
> +	if (tst_test->needs_device) {
> +		putenv("TEST_DIR=1");
> +		putenv("TEST_DEV=1");
> +		putenv("QA_CHECK_FS=1");
> +	}
> +
>  	if (tst_test->min_cpus > (unsigned long)tst_ncpus())
>  		tst_brk(TCONF, "Test needs at least %lu CPUs online", tst_test->min_cpus);

> diff --git a/testcases/lib/tst_test.sh b/testcases/lib/tst_test.sh
> index 24a3d29d8..b42e54ca1 100644
> --- a/testcases/lib/tst_test.sh
> +++ b/testcases/lib/tst_test.sh
> @@ -671,7 +671,11 @@ tst_run()

>  	[ "$TST_MOUNT_DEVICE" = 1 ] && TST_FORMAT_DEVICE=1
>  	[ "$TST_FORMAT_DEVICE" = 1 ] && TST_NEEDS_DEVICE=1
> -	[ "$TST_NEEDS_DEVICE" = 1 ] && TST_NEEDS_TMPDIR=1
> +	if [ "$TST_NEEDS_DEVICE" = 1 ]; then
> +		TST_NEEDS_TMPDIR=1
> +		# allow to use XFS filesystem < 300 MB
> +		export TEST_DIR=1 TEST_DEV=1 QA_CHECK_FS=1
> +	fi

>  	if [ "$TST_NEEDS_TMPDIR" = 1 ]; then
>  		if [ -z "$TMPDIR" ]; then
