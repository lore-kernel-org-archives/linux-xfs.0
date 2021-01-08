Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30282C433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 04:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E082722E02
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 04:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbhAHE4U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jan 2021 23:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbhAHE4U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jan 2021 23:56:20 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD9AC0612F4
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jan 2021 20:55:39 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id e2so5031628plt.12
        for <linux-xfs@vger.kernel.org>; Thu, 07 Jan 2021 20:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pQVcPsoXcSaGHmqWOwHWOM8wGM5nbwotSc34B0He78U=;
        b=L/Ul5LKHPKGo4Nq7nX5+UCt+81WA/nQcDuF4R98YmF9uV6X4vtaWvivjtNZSpMSsXG
         iECrb4+rJlRsweDCZHAPfef2bLALHYszHOggUCeo9Vt20Gn0BAoO2O3HhjMnQBD8eVCp
         EztKaKWXA9nMeBQQ/Ai+/wbKNJocHqAd3YO/+U6NSsziuNw0bn+NdHd6RPEdwhv0bfSN
         +ivWs/YCTdJDcXbE91B5s3lrzK1MPgXmnz0d3l8E+IwCasYIqihM/QZemBrJgVJiH6zv
         eTEcC3/rxFoXoIR6vsZVjA1Be8Z+d7a20/NR9VndND0df7IfefF3v9ASMMSJinsxcNHN
         jmZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pQVcPsoXcSaGHmqWOwHWOM8wGM5nbwotSc34B0He78U=;
        b=OjJPqco4pzNyWmLI0lTFwdTDtv7j0tVfcpThF9juTf0BXWFXII/GauCM49g5cziT4b
         gI0bIEBE9laiDYETiUbjbfn+9+XZup00m5oHD2NdxikaA3QOqELbm249FzQ+foy73rb3
         /Yl65xfEfaItazd7LWZ0e8kuz04y8paVwdt5TmlN18JrRPkRL/u5+i/0pWjZLndoOzBX
         04AwB6dxMFRnkN4hpFdQmyuHDRvy4BDckCCYGKrVe16/8quVWlGDBeeSe8zi5RW9JcxB
         oW2I+fMisK72bAMfPzITKB9NoMxxysm9VIMAZewbzzISIrrnzj2SV8Vta7ugK6W5dYgy
         mhZA==
X-Gm-Message-State: AOAM532EwX3K3boHVcWJKoOH+YSZrlwvseURMJbHxDyDn+YdcrUOqd6u
        CMLhGEbhNvRVRdigb2PLNQyCJ5ooCns=
X-Google-Smtp-Source: ABdhPJzIDcQDd3TKnHzKdAx/iZyZMg5Ef2DmrseKlUc/CR+6QSJdaNwW2MFwVky0wvGT44xU6eCOsg==
X-Received: by 2002:a17:90a:fe8e:: with SMTP id co14mr1895793pjb.105.1610081739062;
        Thu, 07 Jan 2021 20:55:39 -0800 (PST)
Received: from garuda.localnet ([122.171.33.94])
        by smtp.gmail.com with ESMTPSA id 6sm7415585pfj.216.2021.01.07.20.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 20:55:38 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: Re: [PATCH V12 04/14] xfs: Check for extent overflow when adding/removing dir entries
Date:   Fri, 08 Jan 2021 10:25:35 +0530
Message-ID: <2055679.3ixLThe9JB@garuda>
In-Reply-To: <20210108011713.GP38809@magnolia>
References: <20210104103120.41158-1-chandanrlinux@gmail.com> <20210104103120.41158-5-chandanrlinux@gmail.com> <20210108011713.GP38809@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 07 Jan 2021 17:17:13 -0800, Darrick J. Wong wrote:
> On Mon, Jan 04, 2021 at 04:01:10PM +0530, Chandan Babu R wrote:
> > Directory entry addition can cause the following,
> > 1. Data block can be added/removed.
> >    A new extent can cause extent count to increase by 1.
> > 2. Free disk block can be added/removed.
> >    Same behaviour as described above for Data block.
> > 3. Dabtree blocks.
> >    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these
> >    can be new extents. Hence extent count can increase by
> >    XFS_DA_NODE_MAXDEPTH.
> > 
> > Directory entry remove and rename (applicable only to the source
> > directory entry) operations are handled specially to allow them to
> > succeed in low extent count availability scenarios
> > i.e. xfs_bmap_del_extent_real() will now return -ENOSPC when a possible
> > extent count overflow is detected. -ENOSPC is already handled by higher
> > layers of XFS by letting,
> > 1. Empty Data/Free space index blocks to linger around until a future
> >    remove operation frees them.
> > 2. Dabtree blocks would be swapped with the last block in the leaf space
> >    followed by unmapping of the new last block.
> > 
> > Also, Extent overflow check is performed for the target directory entry
> > of the rename operation only when the entry does not exist and a
> > non-zero space reservation is obtained successfully.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c       | 15 ++++++++++++
> >  fs/xfs/libxfs/xfs_inode_fork.h | 13 ++++++++++
> >  fs/xfs/xfs_inode.c             | 45 ++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_symlink.c           |  5 ++++
> >  4 files changed, 78 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 32aeacf6f055..5fd804534e67 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -5151,6 +5151,21 @@ xfs_bmap_del_extent_real(
> >  		/*
> >  		 * Deleting the middle of the extent.
> >  		 */
> > +
> > +		/*
> > +		 * For directories, -ENOSPC will be handled by higher layers of
> > +		 * XFS by letting the corresponding empty Data/Free blocks to
> > +		 * linger around until a future remove operation. Dabtree blocks
> > +		 * would be swapped with the last block in the leaf space and
> > +		 * then the new last block will be unmapped.
> > +		 */
> > +		if (S_ISDIR(VFS_I(ip)->i_mode) &&
> > +		    whichfork == XFS_DATA_FORK &&
> > +		    xfs_iext_count_may_overflow(ip, whichfork, 1)) {
> > +			error = -ENOSPC;
> > +			goto done;
> 
> Hmm... it strikes me as a little odd that we're checking file mode and
> fork type in the middle of the bmap code.  However, I think it's the
> case that the only place where anyone would punch a hole in the /middle/
> of an extent is xattr trees and regular files, right?  And both of those
> cases are checked before we end up in the bmap code, right?

Yes, your observation is correct. I will remove the file mode and fork type
checks.

> 
> So we only really need this check to prevent extent count overflows when
> removing dirents from directories, like the comment says, and only
> because directories don't have a hard requirement that the bunmapi
> succeeds.  And I think this logic covers xfs_remove too?  That's a bit
> subtle, but as there's no extent count check in that function, there's
> not much to attach a comment to... :)

Yes, To provide more clarity, I should replace the above comment with
following,

  /*
   * -ENOSPC is returned since a directory entry remove operation must not fail
   * due to low extent count availability. -ENOSPC will be handled by higher
   * layers of XFS by letting the corresponding empty Data/Free blocks to linger
   * around until a future remove operation. Dabtree blocks would be swapped with
   * the last block in the leaf space and then the new last block will be
   * unmapped.
   *
   * The above logic also applies to the source directory entry of a rename
   * operation.
   */

> 
> Hm.  I think I'd like xfs_rename to get a brief comment that we're
> protected from extent count overflows in xfs_remove() by virtue of this
> "leave the dir block in place if we ENOSPC" capability:
> 
> 	/*
> 	 * NOTE: We don't need to check for extent overflows here
> 	 * because the dir removename code will leave the dir block
> 	 * in place if the extent count would overflow.
> 	 */
> 	error = xfs_dir_removename(...);

Sure, I will add that.

> 
> Do xattr trees also have the same ability?  I think they do, at least
> for the dabtree part...?

The following code snippet from xfs_da_shrink_inode() does the special casing
only for the data fork i.e. for blocks holding directory entries.

   for (;;) {
           /*
            * Remove extents.  If we get ENOSPC for a dir we have to move
            * the last block to the place we want to kill.
            */
           error = xfs_bunmapi(tp, dp, dead_blkno, count,
                               xfs_bmapi_aflag(w), 0, &done);
           if (error == -ENOSPC) {
                   if (w != XFS_DATA_FORK)
                           break;
                   error = xfs_da3_swap_lastblock(args, &dead_blkno,
                                                 &dead_buf);

So this facility is available only for directory entries.

Hence for xattrs, if we ever reach the extent count limit, the only way out is
to delete the corresponding file.

> 
> I think I would've split this patch into three pieces:
> 
>  - create, link, and symlink in one patch (adding dirents),
>  - the xfs_bmap_del_extent_real change and a comment for xfs_remove
>    (removing dirents)
>  - all the xfs_rename changes (adding and removing dirents)
> 
> Though I dunno, this series is already 14 patches, and the part that I
> care most about is not leaving that subtlety in xfs_remove(). :)

I think you are right about that. I will split this patch according to what
you have mentioned above.

> 
> Other than that, I follow the logic in this patch and will give it a
> testrun tonight.

Thank you!

> 
> --D
> 
> > +		}
> > +
> >  		old = got;
> >  
> >  		got.br_blockcount = del->br_startoff - got.br_startoff;
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > index bcac769a7df6..ea1a9dd8a763 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > @@ -47,6 +47,19 @@ struct xfs_ifork {
> >   */
> >  #define XFS_IEXT_PUNCH_HOLE_CNT		(1)
> >  
> > +/*
> > + * Directory entry addition can cause the following,
> > + * 1. Data block can be added/removed.
> > + *    A new extent can cause extent count to increase by 1.
> > + * 2. Free disk block can be added/removed.
> > + *    Same behaviour as described above for Data block.
> > + * 3. Dabtree blocks.
> > + *    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these can be new
> > + *    extents. Hence extent count can increase by XFS_DA_NODE_MAXDEPTH.
> > + */
> > +#define XFS_IEXT_DIR_MANIP_CNT(mp) \
> > +	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
> > +
> >  /*
> >   * Fork handling.
> >   */
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index b7352bc4c815..0db21368c7e1 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1042,6 +1042,11 @@ xfs_create(
> >  	if (error)
> >  		goto out_trans_cancel;
> >  
> > +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> > +			XFS_IEXT_DIR_MANIP_CNT(mp));
> > +	if (error)
> > +		goto out_trans_cancel;
> > +
> >  	/*
> >  	 * A newly created regular or special file just has one directory
> >  	 * entry pointing to them, but a directory also the "." entry
> > @@ -1258,6 +1263,11 @@ xfs_link(
> >  	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
> >  	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
> >  
> > +	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
> > +			XFS_IEXT_DIR_MANIP_CNT(mp));
> > +	if (error)
> > +		goto error_return;
> > +
> >  	/*
> >  	 * If we are using project inheritance, we only allow hard link
> >  	 * creation in our tree when the project IDs are the same; else
> > @@ -3106,6 +3116,35 @@ xfs_rename(
> >  	/*
> >  	 * Check for expected errors before we dirty the transaction
> >  	 * so we can return an error without a transaction abort.
> > +	 *
> > +	 * Extent count overflow check:
> > +	 *
> > +	 * From the perspective of src_dp, a rename operation is essentially a
> > +	 * directory entry remove operation. Hence the only place where we check
> > +	 * for extent count overflow for src_dp is in
> > +	 * xfs_bmap_del_extent_real(). xfs_bmap_del_extent_real() returns
> > +	 * -ENOSPC when it detects a possible extent count overflow and in
> > +	 * response, the higher layers of directory handling code do the
> > +	 * following:
> > +	 * 1. Data/Free blocks: XFS lets these blocks linger around until a
> > +	 *    future remove operation removes them.
> > +	 * 2. Dabtree blocks: XFS swaps the blocks with the last block in the
> > +	 *    Leaf space and unmaps the last block.
> > +	 *
> > +	 * For target_dp, there are two cases depending on whether the
> > +	 * destination directory entry exists or not.
> > +	 *
> > +	 * When destination directory entry does not exist (i.e. target_ip ==
> > +	 * NULL), extent count overflow check is performed only when transaction
> > +	 * has a non-zero sized space reservation associated with it.  With a
> > +	 * zero-sized space reservation, XFS allows a rename operation to
> > +	 * continue only when the directory has sufficient free space in its
> > +	 * data/leaf/free space blocks to hold the new entry.
> > +	 *
> > +	 * When destination directory entry exists (i.e. target_ip != NULL), all
> > +	 * we need to do is change the inode number associated with the already
> > +	 * existing entry. Hence there is no need to perform an extent count
> > +	 * overflow check.
> >  	 */
> >  	if (target_ip == NULL) {
> >  		/*
> > @@ -3116,6 +3155,12 @@ xfs_rename(
> >  			error = xfs_dir_canenter(tp, target_dp, target_name);
> >  			if (error)
> >  				goto out_trans_cancel;
> > +		} else {
> > +			error = xfs_iext_count_may_overflow(target_dp,
> > +					XFS_DATA_FORK,
> > +					XFS_IEXT_DIR_MANIP_CNT(mp));
> > +			if (error)
> > +				goto out_trans_cancel;
> >  		}
> >  	} else {
> >  		/*
> > diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> > index 1f43fd7f3209..0b8136a32484 100644
> > --- a/fs/xfs/xfs_symlink.c
> > +++ b/fs/xfs/xfs_symlink.c
> > @@ -220,6 +220,11 @@ xfs_symlink(
> >  	if (error)
> >  		goto out_trans_cancel;
> >  
> > +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> > +			XFS_IEXT_DIR_MANIP_CNT(mp));
> > +	if (error)
> > +		goto out_trans_cancel;
> > +
> >  	/*
> >  	 * Allocate an inode for the symlink.
> >  	 */
> 


-- 
chandan



