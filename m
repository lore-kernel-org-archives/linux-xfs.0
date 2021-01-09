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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C725CC433E0
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 05:27:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D99023A68
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 05:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbhAIF12 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 00:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbhAIF12 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 00:27:28 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E771FC061573
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jan 2021 21:26:47 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id j1so6796340pld.3
        for <linux-xfs@vger.kernel.org>; Fri, 08 Jan 2021 21:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=r21AzQfz8Hp1Vq7D6zGuzdLQuTirHpf5GtiI0TmLmi8=;
        b=YembH6y/P+4Bow1hHMmhqm2EsB7AKq3xa00/HODTfTCq5pZquchZ8vYOc+ZUWRRBqF
         4+7sgQUcto1SiDNhfqRKY99Cwe6OsrFoR/xwTRMrdOqnLXuSNvDDzDs7RIczge+NxKu6
         brMG8GrS1M6IL+v4VlGeExkMCXP/vXPME4v9+U9xqTDM2u5zOp9qQEPF5At1H2SfRXsB
         8SqVfaXT8FrfTaX27I3ewVJrRCsqmz4N5zh5F1cMy/xa/JoMR6jGUCesgFIJvbLejgMW
         ViBGDsqUo/5ShlFZDa1gk31CpXpNLibFiSY1cvkR6G+ywyQ/9Bfok4ANxB+6CSuiwpk7
         Ppog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=r21AzQfz8Hp1Vq7D6zGuzdLQuTirHpf5GtiI0TmLmi8=;
        b=KO2pGdqn69LYrhvHYHHEVJOB9HDzSvZMrdCbz4uQkZd3EdRzKGD2DbzNilA7Iz3F2N
         nkhB0teHlTqRMZBD8mqsFe1MSIRPlYnCmEaJiuGgfO//HB1rrNcvXPtz2m0KLaznBuzC
         ushDJ9CM7fZlOep+owKR5t8xbXecBJVMaVoAxk9rx8kBF6GsFPGDP6aQO9ri8yXN79uQ
         eJ1NsOw2OlVCHIsSzj0SmK3t/QVu7O9ZhPu9ZCNjbwctbPMOpm/W4cmbnRTH0zN5qBQ5
         CRVzYylL6GLx15qzwJSGzYD41vnGpH3udjpLp8COTm6BqIQbYjYfrTdll7/yVdl8tNGl
         lYcA==
X-Gm-Message-State: AOAM531/c3Mmi+lzH02b68jX+VwnnmvwZGAqXVff9IsPTxzXkypmsYrM
        UXS6tmtbk5SVcsEiw1z8cH5Nm+uPZyw=
X-Google-Smtp-Source: ABdhPJzJsI2gdJTDBrLXCNUPiVkhlyN31Cn4x4fu1hSvmOCZ0XMvyE07Rs6a+zc/NErFTyDPK6a1GQ==
X-Received: by 2002:a17:90a:4a85:: with SMTP id f5mr7232079pjh.117.1610170007131;
        Fri, 08 Jan 2021 21:26:47 -0800 (PST)
Received: from garuda ([122.179.56.226])
        by smtp.gmail.com with ESMTPSA id p9sm9691305pjb.3.2021.01.08.21.26.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Jan 2021 21:26:46 -0800 (PST)
References: <20210104103120.41158-1-chandanrlinux@gmail.com> <20210104103120.41158-5-chandanrlinux@gmail.com> <20210108011713.GP38809@magnolia> <2055679.3ixLThe9JB@garuda> <20210109013351.GS6918@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, hch@lst.de, allison.henderson@oracle.com
Subject: Re: [PATCH V12 04/14] xfs: Check for extent overflow when adding/removing dir entries
In-reply-to: <20210109013351.GS6918@magnolia>
Date:   Sat, 09 Jan 2021 10:56:42 +0530
Message-ID: <87y2h2r88d.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 09 Jan 2021 at 07:03, Darrick J. Wong wrote:
> On Fri, Jan 08, 2021 at 10:25:35AM +0530, Chandan Babu R wrote:
>> On Thu, 07 Jan 2021 17:17:13 -0800, Darrick J. Wong wrote:
>> > On Mon, Jan 04, 2021 at 04:01:10PM +0530, Chandan Babu R wrote:
>> > > Directory entry addition can cause the following,
>> > > 1. Data block can be added/removed.
>> > >    A new extent can cause extent count to increase by 1.
>> > > 2. Free disk block can be added/removed.
>> > >    Same behaviour as described above for Data block.
>> > > 3. Dabtree blocks.
>> > >    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these
>> > >    can be new extents. Hence extent count can increase by
>> > >    XFS_DA_NODE_MAXDEPTH.
>> > > 
>> > > Directory entry remove and rename (applicable only to the source
>> > > directory entry) operations are handled specially to allow them to
>> > > succeed in low extent count availability scenarios
>> > > i.e. xfs_bmap_del_extent_real() will now return -ENOSPC when a possible
>> > > extent count overflow is detected. -ENOSPC is already handled by higher
>> > > layers of XFS by letting,
>> > > 1. Empty Data/Free space index blocks to linger around until a future
>> > >    remove operation frees them.
>> > > 2. Dabtree blocks would be swapped with the last block in the leaf space
>> > >    followed by unmapping of the new last block.
>> > > 
>> > > Also, Extent overflow check is performed for the target directory entry
>> > > of the rename operation only when the entry does not exist and a
>> > > non-zero space reservation is obtained successfully.
>> > > 
>> > > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>> > > ---
>> > >  fs/xfs/libxfs/xfs_bmap.c       | 15 ++++++++++++
>> > >  fs/xfs/libxfs/xfs_inode_fork.h | 13 ++++++++++
>> > >  fs/xfs/xfs_inode.c             | 45 ++++++++++++++++++++++++++++++++++
>> > >  fs/xfs/xfs_symlink.c           |  5 ++++
>> > >  4 files changed, 78 insertions(+)
>> > > 
>> > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>> > > index 32aeacf6f055..5fd804534e67 100644
>> > > --- a/fs/xfs/libxfs/xfs_bmap.c
>> > > +++ b/fs/xfs/libxfs/xfs_bmap.c
>> > > @@ -5151,6 +5151,21 @@ xfs_bmap_del_extent_real(
>> > >  		/*
>> > >  		 * Deleting the middle of the extent.
>> > >  		 */
>> > > +
>> > > +		/*
>> > > +		 * For directories, -ENOSPC will be handled by higher layers of
>> > > +		 * XFS by letting the corresponding empty Data/Free blocks to
>> > > +		 * linger around until a future remove operation. Dabtree blocks
>> > > +		 * would be swapped with the last block in the leaf space and
>> > > +		 * then the new last block will be unmapped.
>> > > +		 */
>> > > +		if (S_ISDIR(VFS_I(ip)->i_mode) &&
>> > > +		    whichfork == XFS_DATA_FORK &&
>> > > +		    xfs_iext_count_may_overflow(ip, whichfork, 1)) {
>> > > +			error = -ENOSPC;
>> > > +			goto done;
>> > 
>> > Hmm... it strikes me as a little odd that we're checking file mode and
>> > fork type in the middle of the bmap code.  However, I think it's the
>> > case that the only place where anyone would punch a hole in the /middle/
>> > of an extent is xattr trees and regular files, right?  And both of those
>> > cases are checked before we end up in the bmap code, right?
>> 
>> Yes, your observation is correct. I will remove the file mode and fork type
>> checks.
>
> You might want to leave an assert there just in case someone else trips
> over that...

Ok.

>
>> 
>> > 
>> > So we only really need this check to prevent extent count overflows when
>> > removing dirents from directories, like the comment says, and only
>> > because directories don't have a hard requirement that the bunmapi
>> > succeeds.  And I think this logic covers xfs_remove too?  That's a bit
>> > subtle, but as there's no extent count check in that function, there's
>> > not much to attach a comment to... :)
>> 
>> Yes, To provide more clarity, I should replace the above comment with
>> following,
>> 
>>   /*
>>    * -ENOSPC is returned since a directory entry remove operation must not fail
>>    * due to low extent count availability. -ENOSPC will be handled by higher
>>    * layers of XFS by letting the corresponding empty Data/Free blocks to linger
>
> grammar nit: "...by letting the corresponding empty Data/Free blocks linger
> until a future remove operation."
>

Ok, I will fix that.

>>    * around until a future remove operation. Dabtree blocks would be swapped with
>>    * the last block in the leaf space and then the new last block will be
>>    * unmapped.
>>    *
>>    * The above logic also applies to the source directory entry of a rename
>>    * operation.
>>    */
>> 
>> > 
>> > Hm.  I think I'd like xfs_rename to get a brief comment that we're
>> > protected from extent count overflows in xfs_remove() by virtue of this
>> > "leave the dir block in place if we ENOSPC" capability:
>> > 
>> > 	/*
>> > 	 * NOTE: We don't need to check for extent overflows here
>> > 	 * because the dir removename code will leave the dir block
>> > 	 * in place if the extent count would overflow.
>> > 	 */
>> > 	error = xfs_dir_removename(...);
>> 
>> Sure, I will add that.
>> 
>> > 
>> > Do xattr trees also have the same ability?  I think they do, at least
>> > for the dabtree part...?
>> 
>> The following code snippet from xfs_da_shrink_inode() does the special casing
>> only for the data fork i.e. for blocks holding directory entries.
>> 
>>    for (;;) {
>>            /*
>>             * Remove extents.  If we get ENOSPC for a dir we have to move
>>             * the last block to the place we want to kill.
>>             */
>>            error = xfs_bunmapi(tp, dp, dead_blkno, count,
>>                                xfs_bmapi_aflag(w), 0, &done);
>>            if (error == -ENOSPC) {
>>                    if (w != XFS_DATA_FORK)
>>                            break;
>>                    error = xfs_da3_swap_lastblock(args, &dead_blkno,
>>                                                  &dead_buf);
>> 
>> So this facility is available only for directory entries.
>> 
>> Hence for xattrs, if we ever reach the extent count limit, the only way out is
>> to delete the corresponding file.
>
> Ok.  Just checking. :)
>
>> > 
>> > I think I would've split this patch into three pieces:
>> > 
>> >  - create, link, and symlink in one patch (adding dirents),
>> >  - the xfs_bmap_del_extent_real change and a comment for xfs_remove
>> >    (removing dirents)
>> >  - all the xfs_rename changes (adding and removing dirents)
>> > 
>> > Though I dunno, this series is already 14 patches, and the part that I
>> > care most about is not leaving that subtlety in xfs_remove(). :)
>> 
>> I think you are right about that. I will split this patch according to what
>> you have mentioned above.
>
>
> Thanks!
>
> FWIW I didn't see any regressions in fstests...

Cool. Thanks for the test run.

>
>> > 
>> > Other than that, I follow the logic in this patch and will give it a
>> > testrun tonight.
>> 
>> Thank you!
>> 
>> > 
>> > --D
>> > 
>> > > +		}
>> > > +
>> > >  		old = got;
>> > >  
>> > >  		got.br_blockcount = del->br_startoff - got.br_startoff;
>> > > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
>> > > index bcac769a7df6..ea1a9dd8a763 100644
>> > > --- a/fs/xfs/libxfs/xfs_inode_fork.h
>> > > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
>> > > @@ -47,6 +47,19 @@ struct xfs_ifork {
>> > >   */
>> > >  #define XFS_IEXT_PUNCH_HOLE_CNT		(1)
>> > >  
>> > > +/*
>> > > + * Directory entry addition can cause the following,
>> > > + * 1. Data block can be added/removed.
>> > > + *    A new extent can cause extent count to increase by 1.
>> > > + * 2. Free disk block can be added/removed.
>> > > + *    Same behaviour as described above for Data block.
>> > > + * 3. Dabtree blocks.
>> > > + *    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these can be new
>> > > + *    extents. Hence extent count can increase by XFS_DA_NODE_MAXDEPTH.
>> > > + */
>> > > +#define XFS_IEXT_DIR_MANIP_CNT(mp) \
>> > > +	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
>> > > +
>> > >  /*
>> > >   * Fork handling.
>> > >   */
>> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> > > index b7352bc4c815..0db21368c7e1 100644
>> > > --- a/fs/xfs/xfs_inode.c
>> > > +++ b/fs/xfs/xfs_inode.c
>> > > @@ -1042,6 +1042,11 @@ xfs_create(
>> > >  	if (error)
>> > >  		goto out_trans_cancel;
>> > >  
>> > > +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
>> > > +			XFS_IEXT_DIR_MANIP_CNT(mp));
>> > > +	if (error)
>> > > +		goto out_trans_cancel;
>> > > +
>> > >  	/*
>> > >  	 * A newly created regular or special file just has one directory
>> > >  	 * entry pointing to them, but a directory also the "." entry
>> > > @@ -1258,6 +1263,11 @@ xfs_link(
>> > >  	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
>> > >  	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
>> > >  
>> > > +	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
>> > > +			XFS_IEXT_DIR_MANIP_CNT(mp));
>> > > +	if (error)
>> > > +		goto error_return;
>> > > +
>> > >  	/*
>> > >  	 * If we are using project inheritance, we only allow hard link
>> > >  	 * creation in our tree when the project IDs are the same; else
>> > > @@ -3106,6 +3116,35 @@ xfs_rename(
>> > >  	/*
>> > >  	 * Check for expected errors before we dirty the transaction
>> > >  	 * so we can return an error without a transaction abort.
>> > > +	 *
>> > > +	 * Extent count overflow check:
>> > > +	 *
>> > > +	 * From the perspective of src_dp, a rename operation is essentially a
>> > > +	 * directory entry remove operation. Hence the only place where we check
>> > > +	 * for extent count overflow for src_dp is in
>> > > +	 * xfs_bmap_del_extent_real(). xfs_bmap_del_extent_real() returns
>> > > +	 * -ENOSPC when it detects a possible extent count overflow and in
>> > > +	 * response, the higher layers of directory handling code do the
>> > > +	 * following:
>> > > +	 * 1. Data/Free blocks: XFS lets these blocks linger around until a
>> > > +	 *    future remove operation removes them.
>> > > +	 * 2. Dabtree blocks: XFS swaps the blocks with the last block in the
>> > > +	 *    Leaf space and unmaps the last block.
>> > > +	 *
>> > > +	 * For target_dp, there are two cases depending on whether the
>> > > +	 * destination directory entry exists or not.
>> > > +	 *
>> > > +	 * When destination directory entry does not exist (i.e. target_ip ==
>> > > +	 * NULL), extent count overflow check is performed only when transaction
>> > > +	 * has a non-zero sized space reservation associated with it.  With a
>> > > +	 * zero-sized space reservation, XFS allows a rename operation to
>> > > +	 * continue only when the directory has sufficient free space in its
>> > > +	 * data/leaf/free space blocks to hold the new entry.
>> > > +	 *
>> > > +	 * When destination directory entry exists (i.e. target_ip != NULL), all
>> > > +	 * we need to do is change the inode number associated with the already
>> > > +	 * existing entry. Hence there is no need to perform an extent count
>> > > +	 * overflow check.
>> > >  	 */
>> > >  	if (target_ip == NULL) {
>> > >  		/*
>> > > @@ -3116,6 +3155,12 @@ xfs_rename(
>> > >  			error = xfs_dir_canenter(tp, target_dp, target_name);
>> > >  			if (error)
>> > >  				goto out_trans_cancel;
>> > > +		} else {
>> > > +			error = xfs_iext_count_may_overflow(target_dp,
>> > > +					XFS_DATA_FORK,
>> > > +					XFS_IEXT_DIR_MANIP_CNT(mp));
>> > > +			if (error)
>> > > +				goto out_trans_cancel;
>> > >  		}
>> > >  	} else {
>> > >  		/*
>> > > diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
>> > > index 1f43fd7f3209..0b8136a32484 100644
>> > > --- a/fs/xfs/xfs_symlink.c
>> > > +++ b/fs/xfs/xfs_symlink.c
>> > > @@ -220,6 +220,11 @@ xfs_symlink(
>> > >  	if (error)
>> > >  		goto out_trans_cancel;
>> > >  
>> > > +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
>> > > +			XFS_IEXT_DIR_MANIP_CNT(mp));
>> > > +	if (error)
>> > > +		goto out_trans_cancel;
>> > > +
>> > >  	/*
>> > >  	 * Allocate an inode for the symlink.
>> > >  	 */
>> > 
>> 

-- 
chandan
