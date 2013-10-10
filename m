Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 90B767F5D
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 02:00:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 74576304032
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 00:00:16 -0700 (PDT)
Received: from mail-pd0-f179.google.com (mail-pd0-f179.google.com
	[209.85.192.179]) by cuda.sgi.com with ESMTP id
	ERYfH5j7bpTrvak8 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 10 Oct 2013 00:00:14 -0700 (PDT)
Received: by mail-pd0-f179.google.com with SMTP id v10so2172115pde.10
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 00:00:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131010005154.GS4446@dastard>
References: <1381090388-2761-1-git-send-email-linkinjeon@gmail.com>
	<20131010005154.GS4446@dastard>
Date: Thu, 10 Oct 2013 16:00:13 +0900
Message-ID: <CAKYAXd8=ZKESV5Fmw7hqwL=G8L=BG6h0LQpc2cVjN9uTkj7nYw@mail.gmail.com>
Subject: Re: [PATCH RESEND 2/7] xfs: add support FALLOC_FL_COLLAPSE_RANGE for
	fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: elder@kernel.org, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, bpm@sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, mtk.manpages@gmail.com

>
> /*
>  * Shift extent records to the left to cover a hole.
>  *
>  * The maximum number of extents to be shifted in a single operation
>  * is @count, and @current_ext keeps track of the current extent
>  * index we have shifted. If there is no hole to shift the extents
>  * into, then we abort immediately.
>  */
Thanks for your help. I will change this comment instead of original one.

>> +int
>> +xfs_bmap_shift_extents(
>> +     struct xfs_trans        *tp,
>> +     struct xfs_inode        *ip,
>> +     int                     *done,
>> +     xfs_fileoff_t           start_fsb,
>> +     xfs_fileoff_t           shift,
>
> Shift means ...? Number of extents to shift, a length, a number of
> block, or something else?
Ah, yes, shift_len would be a more proper name

>
>> +     xfs_extnum_t            *current_ext,
>> +     xfs_fsblock_t           *firstblock,
>> +     struct xfs_bmap_free    *flist,
>> +     int                     count)
>
> if count is the number of extents to shift, then it should be named
> "num_exts" or something similar to describe what it is a count of.
Right, I will change num_exts.

>
>> +{
>> +     struct xfs_btree_cur            *cur;
>> +     struct xfs_bmbt_rec_host        *gotp;
>> +     struct xfs_bmbt_irec            left;
>> +     struct xfs_mount                *mp = ip->i_mount;
>> +     struct xfs_ifork                *ifp;
>> +     xfs_extnum_t                    nexts = 0;
>> +     xfs_fileoff_t                   startoff;
>> +     int                             error = 0;
>> +     int                             i;
>> +     int                             whichfork = XFS_DATA_FORK;
>> +     int                             state;
>> +     int                             logflags;
>> +     xfs_filblks_t                   blockcount = 0;
>> +
>> +     if (unlikely(XFS_TEST_ERROR(
>> +         (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
>> +          XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
>> +          mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
>> +             XFS_ERROR_REPORT("xfs_bmap_shift_extents",
>> +                              XFS_ERRLEVEL_LOW, mp);
>> +             return XFS_ERROR(EFSCORRUPTED);
>> +     }
>> +
>> +     if (XFS_FORCED_SHUTDOWN(mp))
>> +             return XFS_ERROR(EIO);
>> +
>> +     ifp = XFS_IFORK_PTR(ip, whichfork);
>> +
>> +     if (!(ifp->if_flags & XFS_IFEXTENTS)) {
>> +             /* Read in all the extents */
>> +             error = xfs_iread_extents(tp, ip, whichfork);
>> +             if (error)
>> +                     return error;
>> +     }
>> +
>> +     if (!*current_ext) {
>
> I had to do a double take on that, because I thought it was checking
> for a null pointer at first. It's not, so at the start of the
> function:
>
>         ASSERT(current_ext != NULL);
>
> secondly, it's checking for a zero count, so make it clear in this
> case:
>
>         if (*current_ext == 0) {
Okay, I will update like this.

>         ....
>> +             gotp = xfs_iext_bno_to_ext(ifp, start_fsb, current_ext);
>> +             /*
>> +              * gotp can be null in 2 cases: 1) if there are no extents
>> +              * or 2) start_fsb lies in a hole beyond which there are
>> +              * no extents. Either way, we are done.
>> +              */
>> +             if (!gotp) {
>> +                     *done = 1;
>> +                     return 0;
>> +             }
>
> What does "gotp" mean in this context? Yes, it's the extent we got
> from a lookup, but what extent is that? Is it the extent we are
> shifting, the extent we are shifting it up against, or something
> else?
>
>> +     }
>> +
>> +     /* We are going to change core inode */
>> +     logflags = XFS_ILOG_CORE;
>> +
>> +     if (ifp->if_flags & XFS_IFBROOT) {
>> +             cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
>> +             cur->bc_private.b.firstblock = *firstblock;
>> +             cur->bc_private.b.flist = flist;
>> +             cur->bc_private.b.flags = 0;
>> +             }
>> +     else {
>> +             cur = NULL;
>> +             logflags |= XFS_ILOG_DEXT;
>> +     }
>> +
>> +     while (nexts++ < count &&
>> +            *current_ext <  XFS_IFORK_NEXTENTS(ip, whichfork)) {
>> +             state = 0;
>> +
>> +             gotp = xfs_iext_get_ext(ifp, *current_ext);
>> +             startoff = xfs_bmbt_get_startoff(gotp);
>> +             startoff -= shift;
>
>                 xfs_bmbt_get_all(gotp, &got);
>
> and then you can drop all the xfs_bmbt_get*() wrappers.
Okay, I will check it.

>
>> +
>> +             /*
>> +              * Before shifting extent into hole, make sure that the hole
>> +              * is large enough to accomodate the shift.
>> +              */
>> +             if (*current_ext) {
>> +                     state |= BMAP_LEFT_VALID;
>> +                     xfs_bmbt_get_all(xfs_iext_get_ext(ifp,
>> +                                             *current_ext - 1), &left);
>> +
>> +                     if (isnullstartblock(left.br_startblock))
>> +                             state |= BMAP_LEFT_DELAY;
>> +
>> +                     if (startoff < left.br_startoff + left.br_blockcount)
>> +                             error = XFS_ERROR(EFSCORRUPTED);
>
> Why is the filesystem corrupted if the shift we asked for is too
> large for the hole in the file? I haven't seen any checks before
> this that guarantee that the hole is big enough for the shift...

we call xfs_free_file_space to free enough blocks for shifting.
If still the space is not big enough will it be considered as fs corrupted?
What error could we return in this case?

>
>> +
>> +             } else if (startoff > xfs_bmbt_get_startoff(gotp))
>> +                     /* Hole is at the start but not large enough */
>> +                     error = XFS_ERROR(EFSCORRUPTED);
>
> Same question....
>
>> +
>> +             if (error)
>> +                     goto del_cursor;
>> +
>> +             /* Check if we can merge 2 adjacent extents */
>> +             if ((state & BMAP_LEFT_VALID) && !(state & BMAP_LEFT_DELAY) &&
>> +                 left.br_startoff + left.br_blockcount == startoff &&
>> +                 left.br_startblock + left.br_blockcount ==
>> +                 xfs_bmbt_get_startblock(gotp) &&
>> +                 xfs_bmbt_get_state(gotp) == left.br_state &&
>> +                 left.br_blockcount + xfs_bmbt_get_blockcount(gotp) <=
>> +                 MAXEXTLEN) {
>
> The indenting needs work here - whitespace gives lots of context
> that is missing here:
>
>                 if ((state & BMAP_LEFT_VALID) &&
>                     !(state & BMAP_LEFT_DELAY) &&
>                     left.br_startoff + left.br_blockcount == startoff &&
>                     left.br_startblock + left.br_blockcount ==
>                                     xfs_bmbt_get_startblock(gotp) &&
>                     xfs_bmbt_get_state(gotp) == left.br_state &&
>                     left.br_blockcount + xfs_bmbt_get_blockcount(gotp) <=
>                                     MAXEXTLEN) {
>
> And it can be simplified, too:
>
>                 if ((state & BMAP_LEFT_VALID) &&
>                     !(state & BMAP_LEFT_DELAY) &&
>
> is exactly the same as:
>
>                 if (state == BMAP_LEFT_VALID &&
Right. I will update your points.

>
>> +                     blockcount =
>> +                     left.br_blockcount + xfs_bmbt_get_blockcount(gotp);
>> +                     state |= BMAP_LEFT_CONTIG;
>> +                     xfs_iext_remove(ip, *current_ext, 1, 0);
>> +                     XFS_IFORK_NEXT_SET(ip, whichfork
>> +                             XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
>
> Ok, so you remove and extent from the in-memory tree, but I don't
> see where you remove it from the on-disk btree.

Okay, I will add code to remove on-disk btree also.
>
>> +                     gotp = xfs_iext_get_ext(ifp, --*current_ext);
>
>                         xfs_bmbt_get_all(gotp, &got);
>
>> +             }
>> +
>> +             if (cur) {
>> +                     error = xfs_bmbt_lookup_eq(cur,
>> +                                     xfs_bmbt_get_startoff(gotp),
>> +                                     xfs_bmbt_get_startblock(gotp),
>> +                                     xfs_bmbt_get_blockcount(gotp),
>> +                                     &i);
>> +                     if (error)
>> +                             goto del_cursor;
>> +                     XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
>> +             }
>
> This needs to be done before merging extents so the cursor points at
> the record that needs to be deleted from the btree when you merge
> the extent records. i.e. you need to completely separate the extent
> merge case from the update case for both the in-memory extent tree
> update and the on-disk btree update....
Okay.

>
>> +
>>       return xfs_trans_commit(tp, 0);
>>  }
>>
>> +
>> +/*
>> + * xfs_collapse_file_space: Implements the FALLOC_FL_COLLAPSE_SPACE flag.
>> + */
>> +int
>> +xfs_collapse_file_space(
>> +     struct xfs_inode        *ip,
>> +     loff_t                  offset,
>> +     loff_t                  len,
>> +     int                     attr_flags)
>> +{
>> +     int                     done = 0;
>> +     struct xfs_mount        *mp = ip->i_mount;
>> +     uint                    resblks;
>> +     struct xfs_trans        *tp;
>> +     int                     error;
>> +     xfs_extnum_t            current_ext = 0;
>> +     struct xfs_bmap_free    free_list;
>> +     xfs_fsblock_t           first_block;
>> +     int                     committed;
>> +     xfs_fileoff_t   start_fsb = XFS_B_TO_FSB(mp, offset + len);
>> +     xfs_fileoff_t   shift_fsb = XFS_B_TO_FSB(mp, len);
>> +
>> +     resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
>
> Why do we need a stack variable for this?
Ah. I will directly use it instead of stack varable.

>
>> +
>> +     /*
>> +      * The first thing we do is to free data blocks in the specified range
>> +      * by calling xfs_free_file_space(). It would also sync dirty data
>> +      * and invalidate page cache over the region on which collapse range
>> +      * is working.
>> +      */
>> +
>> +     error = xfs_free_file_space(ip, offset, len, attr_flags);
>> +     if (error)
>> +             return error;
>
> This separation of punching the hole and collapsing the range means
> that the operation is not atomic w.r.t. concurrent IO, truncate or
> other hole punch/preallocate operations if the XFS_IOLOCK_EXCL is
> not held. Hence we need to ensure this operation is executed with
> the correct locks held by the caller, and the correct flags passed
> into the function. That is, we need these asserts before doing
> anything else in this function:
>
>         ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
>         ASSERT((attr_flags & XFS_ATTR_NOLOCK) == XFS_ATTR_NOLOCK);
>
> This makes it clear that there's a bug in the function's locking in
> the "out" case....
>
Yes, right. I will check.

>> +     while (!error && !done) {
>> +             tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
>> +             tp->t_flags |= XFS_TRANS_RESERVE;
>> +             /*
>> +              * We would need to reserve permanent block for transaction.
>> +              * This will come into picture when after shifting extent into
>> +              * hole we found that adjacent extents can be merged which
>> +              * may lead to freeing of a block during record update.
>> +              */
>> +             error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write, resblks, 0);
>> +             if (error) {
>> +                     ASSERT(error == ENOSPC || XFS_FORCED_SHUTDOWN(mp));
>> +                     xfs_trans_cancel(tp, 0);
>> +                     break;
>> +             }
>> +
>> +             xfs_ilock(ip, XFS_ILOCK_EXCL);
>> +             error = xfs_trans_reserve_quota(tp, mp,
>> +                             ip->i_udquot, ip->i_gdquot, ip->i_pdquot,
>> +                             resblks, 0, XFS_QMOPT_RES_REGBLKS);
>> +             if (error)
>> +                     goto out;
>> +
>> +             xfs_trans_ijoin(tp, ip, 0);
>> +
>> +             xfs_bmap_init(&free_list, &first_block);
>> +
>> +             /*
>> +              * We are using the write transaction in which max 2 bmbt
>> +              * updates are allowed
>> +              */
>> +             error = xfs_bmap_shift_extents(tp, ip, &done, start_fsb,
>> +                             shift_fsb, &current_ext,
>> +                             &first_block, &free_list, 2);
>> +             if (error)
>> +                     goto out;
>> +
>> +             error = xfs_bmap_finish(&tp, &free_list, &committed);
>> +             if (error)
>> +                     goto out;
>> +
>> +             error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
>> +             xfs_iunlock(ip, XFS_ILOCK_EXCL);
>> +     }
>> +
>> +     return error;
>> +
>> +out:
>> +     xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
>> +     xfs_iunlock(ip, XFS_IOLOCK_EXCL);
>
> That should be XFS_ILOCK_EXCL....
Yes :)

>
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index 818c623..9c9c1ff 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -807,7 +807,8 @@ xfs_file_fallocate(
>>       int             cmd = XFS_IOC_RESVSP;
>>       int             attr_flags = XFS_ATTR_NOLOCK;
>>
>> -     if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
>> +     if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
>> +                  FALLOC_FL_COLLAPSE_RANGE))
>>               return -EOPNOTSUPP;
>>
>>       bf.l_whence = 0;
>> @@ -819,10 +820,19 @@ xfs_file_fallocate(
>>       if (mode & FALLOC_FL_PUNCH_HOLE)
>>               cmd = XFS_IOC_UNRESVSP;
>>
>> -     /* check the new inode size is valid before allocating */
>> -     if (!(mode & FALLOC_FL_KEEP_SIZE) &&
>> -         offset + len > i_size_read(inode)) {
>> +     /* Shrink size in case of FALLOC_FL_COLLAPSE_RANGE */
>> +     if (mode & FALLOC_FL_COLLAPSE_RANGE) {
>> +             cmd = XFS_COLLAPSE_RANGE;
>> +             if ((offset + len) > i_size_read(inode))
>> +                     new_size = offset;
>
> That's an illegal case according to the higher layers. Don't handle
> it here, replace it with:
>
>                 ASSERT(offset + len < i_size_read(inode));
Okay.

>
>> +             else
>> +                     new_size = i_size_read(inode) - len;
>
>> +     } else if (!(mode & FALLOC_FL_KEEP_SIZE) &&
>> +         offset + len > i_size_read(inode))
>>               new_size = offset + len;
>> +
>> +     /* check the new inode size is valid before allocating */
>> +     if (new_size || mode & FALLOC_FL_COLLAPSE_RANGE) {
>
> That's a bit ugly.
>
>         if (new_size != i_size_read(inode)) {
>                 ....
>
> would be better, and it handles the case of the new size being zero.
Right. Will update it.

>
>>               error = inode_newsize_ok(inode, new_size);
>>               if (error)
>>                       goto out_unlock;
>> @@ -836,7 +846,7 @@ xfs_file_fallocate(
>>               goto out_unlock;
>>
>>       /* Change file size if needed */
>> -     if (new_size) {
>> +     if (new_size ||  mode & FALLOC_FL_COLLAPSE_RANGE) {
>>               struct iattr iattr;
>>
>>               iattr.ia_valid = ATTR_SIZE;
>
> Same again.
okay.

>
>
>> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
>> index 1edb5cc..99f5244 100644
>> --- a/fs/xfs/xfs_fs.h
>> +++ b/fs/xfs/xfs_fs.h
>> @@ -516,6 +516,12 @@ typedef struct xfs_swapext
>>  #define XFS_IOC_GETBMAPX     _IOWR('X', 56, struct getbmap)
>>  #define XFS_IOC_ZERO_RANGE   _IOW ('X', 57, struct xfs_flock64)
>>  #define XFS_IOC_FREE_EOFBLOCKS       _IOR ('X', 58, struct xfs_eofblocks)
>> +/*
>> + * Although there is no ioctl implemented yet, we reserve an ioctl number for
>> + * representing collapse range operation to avoid any possible collision in
>> + * switch case of xfs_change_file_space.
>> + */
>> +#define XFS_COLLAPSE_RANGE   _IOW('X', 59, struct xfs_flock64)
>
> XFS_IOC_COLLAPSE_RANGE.
Okay.

Thanks for review!
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
