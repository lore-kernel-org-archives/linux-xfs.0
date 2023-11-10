Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6625C4167D
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Nov 2023 18:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345189AbjKJSRa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Nov 2023 13:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346020AbjKJSQ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Nov 2023 13:16:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6BB5FC2
        for <linux-xfs@vger.kernel.org>; Thu,  9 Nov 2023 22:17:17 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE632C433CA;
        Fri, 10 Nov 2023 04:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699590776;
        bh=WrtGLywe6Mqbm8Gy9hPY2/HDTKKorUImy8/nr/kTkkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ui1tHXWuv4wtcj8renDLHOFHNXteKaSCkIdaY5Y643Y6IYYAHBhOXZT1+adbRALRE
         +Ncn26ZG1AJhnLOpM0BYOdCPn9K2YK1RM5odlxY9tPygWKfgxCvOiHEZJUrQl6dujE
         ZvzQrl99U5TDbvdxfL5rXTJrbm3ncHPqwQj7j+DHBFlYvrq74HLacowHHMP5a3QU8b
         wyblKqYSrWLILIYqV2+075BpYYCbS4HEHC5vTXQJkWrookgiATf0jdxfZWmeNc7qL0
         zgRBZ37Szqbf3wtPCTFyYXWEAx9aFkuO34EqpiUFa6ymU4TjsfwQr+SmCljfLJEW1O
         scwDmgDDAbAKw==
Date:   Thu, 9 Nov 2023 20:32:56 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, Carlos Maiolino <carlos@maiolino.me>
Subject: Re: [Bug report][fstests generic/047] Internal error !(flags &
 XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.
 Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
Message-ID: <20231110043256.GI1205143@frogsfrogsfrogs>
References: <20231107080522.5lowalssbmi6lus3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUnxswEfoeZQhw5P@dread.disaster.area>
 <20231107151314.angahkixgxsjwbot@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUstA+1+IvHJ87eP@dread.disaster.area>
 <CAN=2_H+CdEK_rEUmYbmkCjSRqhX2cwi5yRHQcKAmKDPF16vqOw@mail.gmail.com>
 <ZUx429/S9H07xLrA@dread.disaster.area>
 <20231109140929.jq7bpnuustsup3xf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZU1nltE2X6qLJ8EL@dread.disaster.area>
 <20231110013651.fw3j6khkdtjfe2bj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZU2PhTKqwNEbjK13@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZU2PhTKqwNEbjK13@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 10, 2023 at 01:03:49PM +1100, Dave Chinner wrote:
> On Fri, Nov 10, 2023 at 09:36:51AM +0800, Zorro Lang wrote:
> > The g/047 still fails with this 2nd patch. So I did below steps [1],
> > and get the trace output as [2], those dump_inodes() messages you
> > added have been printed, please check.
> 
> And that points me at the bug.
> 
> dump_inodes: disk ino 0x83: init nblocks 0x8 nextents 0x0/0x0 anextents 0x0/0x0 v3_pad 0x0 nrext64_pad 0x0 di_flags2 0x18
> dump_inodes: log ino 0x83: init nblocks 0x8 nextents 0x0/0x1 anextents 0x0/0x0 v3_pad 0x1 nrext64_pad 0x0 di_flags2 0x18 big
>                                                      ^^^^^^^
> The initial log inode is correct.
> 
> dump_inodes: disk ino 0x83: pre nblocks 0x8 nextents 0x0/0x0 anextents 0x0/0x0 v3_pad 0x0 nrext64_pad 0x0 di_flags2 0x18
> dump_inodes: log ino 0x83: pre nblocks 0x8 nextents 0x0/0x0 anextents 0x0/0x0 v3_pad 0x0 nrext64_pad 0x0 di_flags2 0x18 big
>                                                     ^^^^^^^
> 
> .... but on the second sample, it's been modified and the extent
> count has been zeroed? Huh, that is unexpected - what did that?
> 
> Oh.
> 
> Can you test the patch below and see if it fixes the issue? Keep
> the first verifier patch I sent, then apply the patch below. You can
> drop the debug traceprintk patch - the patch below should fix it.
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> xfs: recovery should not clear di_flushiter unconditionally
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because on v3 inodes, di_flushiter doesn't exist. It overlaps with
> zero padding in the inode, except when NREXT64=1 configurations are
> in use and the zero padding is no longer padding but holds the 64
> bit extent counter.
> 
> This manifests obviously on big endian platforms (e.g. s390) because
> the log dinode is in host order and the overlap is the LSBs of the
> extent count field. It is not noticed on little endian machines
> because the overlap is at the MSB end of the extent count field and
> we need to get more than 2^^48 extents in the inode before it
> manifests. i.e. the heat death of the universe will occur before we
> see the problem in little endian machines.
> 
> This is a zero-day issue for NREXT64=1 configuraitons on big endian
> machines. Fix it by only clearing di_flushiter on v2 inodes during
> recovery.
> 
> Fixes: 9b7d16e34bbe ("xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers")
> cc: stable@kernel.org # 5.19+
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode_item_recover.c | 32 +++++++++++++++++---------------
>  1 file changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index f4c31c2b60d5..dbdab4ce7c44 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -371,24 +371,26 @@ xlog_recover_inode_commit_pass2(
>  	 * superblock flag to determine whether we need to look at di_flushiter
>  	 * to skip replay when the on disk inode is newer than the log one
>  	 */
> -	if (!xfs_has_v3inodes(mp) &&
> -	    ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
> -		/*
> -		 * Deal with the wrap case, DI_MAX_FLUSH is less
> -		 * than smaller numbers
> -		 */
> -		if (be16_to_cpu(dip->di_flushiter) == DI_MAX_FLUSH &&
> -		    ldip->di_flushiter < (DI_MAX_FLUSH >> 1)) {
> -			/* do nothing */
> -		} else {
> -			trace_xfs_log_recover_inode_skip(log, in_f);
> -			error = 0;
> -			goto out_release;
> +	if (!xfs_has_v3inodes(mp)) {
> +		if (ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
> +			/*
> +			 * Deal with the wrap case, DI_MAX_FLUSH is less
> +			 * than smaller numbers
> +			 */
> +			if (be16_to_cpu(dip->di_flushiter) == DI_MAX_FLUSH &&
> +			    ldip->di_flushiter < (DI_MAX_FLUSH >> 1)) {
> +				/* do nothing */
> +			} else {
> +				trace_xfs_log_recover_inode_skip(log, in_f);
> +				error = 0;
> +				goto out_release;
> +			}
>  		}
> +
> +		/* Take the opportunity to reset the flush iteration count */
> +		ldip->di_flushiter = 0;
>  	}
>  
> -	/* Take the opportunity to reset the flush iteration count */
> -	ldip->di_flushiter = 0;

That's an unfortunate logic bomb left over from the V5 introduction.  I
guess it was benign until we finally reused that part of the xfs_dinode.

If this fixes zorro's machine, then:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

I wonder, if we made XFS_SUPPORT_V4=n turn xfs_has_v3inodes and
xfs_has_crc into #define'd true symbols, could we then rename all the
V4-only fields to see what stops compiling?

(Probably not, gcc will still want to parse it all even if the source
code itself is dead...)

--D

>  
>  	if (unlikely(S_ISREG(ldip->di_mode))) {
>  		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
