Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E8EC00140
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Aug 2022 09:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbiHOJbn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Aug 2022 05:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbiHOJbm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Aug 2022 05:31:42 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B401117F;
        Mon, 15 Aug 2022 02:31:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F3B4B20134;
        Mon, 15 Aug 2022 09:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660555900;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5h+6dMJXLvTUhDdgYsCYGE7DqfaiThyuBXafm3lVxnk=;
        b=psJt9Ek0Mz6wTogTcV2x4KyVeR5jUkh7Ddsmp80L0+m8lbvb8m26j4Rh91pYtO7oV5dw6C
        NPKyHtrJAJ990nI1PifeWLtdJyyw4As6NZa1O4Ktyl7lejv1s06CnrUIQlA4OGNrllFEIW
        pUAuIR5uZz+rsWcqb5ynh/chHvomIkQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660555900;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5h+6dMJXLvTUhDdgYsCYGE7DqfaiThyuBXafm3lVxnk=;
        b=gSY3g1TpOIVFTT+Sp3UoBhTUnI33ePw+tJXSno2WTdLB9uVK6dqh0zM6WC+XSKFYp38QEX
        cSZkSX5WlB1KZOCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 90D8D13A93;
        Mon, 15 Aug 2022 09:31:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id i8EqIXsS+mKCWwAAMHmgww
        (envelope-from <pvorel@suse.cz>); Mon, 15 Aug 2022 09:31:39 +0000
Date:   Mon, 15 Aug 2022 11:31:37 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.de>,
        linux-xfs@vger.kernel.org, ltp@lists.linux.it
Subject: Re: LTP test df01.sh detected different size of loop device in v5.19
Message-ID: <YvoSeTmLoQVxq7p9@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <YvZc+jvRdTLn8rus@pevik>
 <YvZUfq+3HYwXEncw@pevik>
 <YvZTpQFinpkB06p9@pevik>
 <20220814224440.GR3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220814224440.GR3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

> On Fri, Aug 12, 2022 at 03:20:37PM +0200, Petr Vorel wrote:
> > Hi all,

> > LTP test df01.sh found different size of loop device in v5.19.
> > Test uses loop device formatted on various file systems, only XFS fails.
> > It randomly fails during verifying that loop size usage changes:

> > grep ${TST_DEVICE} output | grep -q "${total}.*${used}" [1]

> > How to reproduce:
> > # PATH="/opt/ltp/testcases/bin:$PATH" df01.sh -f xfs # it needs several tries to hit

> > df saved output:
> > Filesystem     1024-blocks    Used Available Capacity Mounted on
> > ...
> > /dev/loop0          256672   16208    240464       7% /tmp/LTP_df01.1kRwoUCCR7/mntpoint
> > df output:
> > Filesystem     1024-blocks    Used Available Capacity Mounted on
> > ...
> > tmpfs               201780       0    201780       0% /run/user/0
> > /dev/loop0          256672   15160    241512       6% /tmp/LTP_df01.1kRwoUCCR7/mntpoint
> > => different size
> > df01 4 TFAIL: 'df -k -P' failed, not expected.

> Yup, most likely because we changed something in XFS related to
> internal block reservation spaces. That is, the test is making
> fundamentally flawed assumptions about filesystem used space
> accounting.

> It is wrong to assuming that the available capacity of a given empty
> filesystem will never change.  Assumptions like this have been
> invalid for decades because the available space can change based on
> the underlying configuration or the filesystem. e.g. different
> versions of mkfs.xfs set different default parameters and so simply
> changing the version of xfsprogs you use between the two comparision
> tests will make it fail....

> And, well, XFS also has XFS_IOC_{GS}ET_RESBLKS ioctls that allow
> userspace to change the amount of reserved blocks. They were
> introduced in 1997, and since then we've changed the default
> reservation the filesystem takes at least a dozen times.

Thanks a lot for valuable info.

> > > It might be a false positive / bug in the test, but it's at least a changed behavior.

> Yup, any test that assumes "available space" does not change from
> kernel version to kernel version is flawed. There is no guarantee
> that this ever stays the same, nor that it needs to stay the same.
I'm sorry I was not clear. Test [1] does not measure "available space" between
kernel releases. It just run df command with parameters, saves it's output
and compares "1024-blocks" and "Used" columns of df output with stat output:

		local total=$(stat -f mntpoint --printf=%b)
		local free=$(stat -f mntpoint --printf=%f)
		local used=$((total-free))

		local bsize=$(stat -f mntpoint --printf=%s)
		total=$((($total * $bsize + 512)/ 1024))
		used=$((($used * $bsize + 512) / 1024))

And comparison with "$used" is what sometimes fails.

BTW this happens on both distros when loop device is on tmpfs. I'm trying to
trigger it on ext4 and btrfs, not successful so far. Looks like it's tmpfs
related.

If that's really expected, we might remove this check for used for XFS
(not sure if check only for total makes sense).

> > > I was able to reproduce it on v5.19 distro kernels (openSUSE, Debian).
> > > I haven't bisected (yet), nor checked Jens' git tree (maybe it has been fixed).

> > Forget to note dmesg "operation not supported error" warning on *each* run (even
> > successful) on affected v5.19:
> > [ 5097.594021] loop0: detected capacity change from 0 to 524288
> > [ 5097.658201] operation not supported error, dev loop0, sector 262192 op 0x9:(WRITE_ZEROES) flags 0x8000800 phys_seg 0 prio class 0
> > [ 5097.675670] XFS (loop0): Mounting V5 Filesystem
> > [ 5097.681668] XFS (loop0): Ending clean mount
> > [ 5097.956445] XFS (loop0): Unmounting Filesystem

> That warning is from mkfs attempting to use fallocate(ZERO_RANGE) to
> offload the zeroing of the journal to the block device. It would
> seem that the loop device image file is being hosted on a filesystem
> that does not support the fallocate() ZERO_RANGE (or maybe
> PUNCH_HOLE) operation. That warning should simply be removed - it
> serves no useful purpose to a user...
Interesting. Which one of these two is not supported on tmpfs?

Kind regards,
Petr

> CHeers,

> Dave.

[1] https://github.com/linux-test-project/ltp/blob/f42f6f3b4671f447b743afe8612917ba4362b8a6/testcases/commands/df/df01.sh
