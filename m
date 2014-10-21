Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 499E67F47
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 08:02:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DB240AC002
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 06:02:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id O54ceylUUbQ64RGe (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Oct 2014 06:02:19 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9LD2JZo026549
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 09:02:19 -0400
Received: from hades.localdomain (ovpn-113-52.phx2.redhat.com [10.3.113.52])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s9LD2FNn019135
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 09:02:18 -0400
Date: Tue, 21 Oct 2014 11:02:15 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] Add support to RENAME_EXCHANGE flag
Message-ID: <20141021130214.GB26932@hades.localdomain>
References: <1413397042-32229-1-git-send-email-cmaiolino@redhat.com>
	<1413397042-32229-3-git-send-email-cmaiolino@redhat.com>
	<20141016210536.GB33732@bfoster.bfoster>
	<20141020002528.GI7169@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141020002528.GI7169@dastard>
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
To: xfs@oss.sgi.com

Thanks for the review guys, I'm going to apply the suggestions and send a V2

On Mon, Oct 20, 2014 at 11:25:28AM +1100, Dave Chinner wrote:
> On Thu, Oct 16, 2014 at 05:05:37PM -0400, Brian Foster wrote:
> > On Wed, Oct 15, 2014 at 03:17:22PM -0300, Carlos Maiolino wrote:
> > > Adds a new function named xfs_cross_rename(), responsible to handle requests
> > > from sys_renameat2() using RENAME_EXCHANGE flag.
> > > 
> > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > ---
> > 
> > Hi Carlos,
> > 
> > Some high-level comments from a first pass...
> > 
> > >  fs/xfs/xfs_inode.c | 187 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/xfs_inode.h |   4 ++
> > >  fs/xfs/xfs_iops.c  |   7 +-
> > >  3 files changed, 197 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index fea3c92..a5bc88d 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -2920,6 +2920,193 @@ xfs_rename(
> > >  	return error;
> > >  }
> > >  
> > > +/* xfs_cross_rename()
> > > + *
> > > + * responsible to handle RENAME_EXCHANGE flag
> > > + * in renameat2() sytemcall
> > > + */
> > > +int
> > > +xfs_cross_rename(
> > > +	xfs_inode_t	*src_dp,
> > > +	struct xfs_name	*src_name,
> > > +	xfs_inode_t	*src_ip,
> > > +	xfs_inode_t	*target_dp,
> > > +	struct xfs_name	*target_name,
> > > +	xfs_inode_t	*target_ip)
> > > +{
> > > +	xfs_trans_t	*tp = NULL;
> > > +	xfs_mount_t	*mp = src_dp->i_mount;
> > > +	int		new_parent;		/* Crossing from different parents */
> > > +	int		src_is_directory;
> > > +	int		tgt_is_directory;
> > > +	int		error;
> > > +	xfs_bmap_free_t	free_list;
> > > +	xfs_fsblock_t	first_block;
> > > +	int		cancel_flags;
> > > +	int		committed;
> > > +	xfs_inode_t	*inodes[4];
> > > +	int		spaceres;
> > > +	int		num_inodes;
> > > +
> > > +	new_parent = (src_dp != target_dp);
> > > +	src_is_directory = S_ISDIR(src_ip->i_d.di_mode);
> > > +	tgt_is_directory = S_ISDIR(target_ip->i_d.di_mode);
> > > +
> > > +	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip,
> > > +				inodes, &num_inodes);
> > > +
> > > +	xfs_bmap_init(&free_list, &first_block);
> > > +	tp = xfs_trans_alloc(mp, XFS_TRANS_RENAME);
> > > +	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
> > > +	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
> > > +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, spaceres, 0);
> > > +
> > 
> > It seems to me that the existing block and log reservations would
> > "cover" the rename exchange case, but it might be worth defining new
> > reservations for the purpose of clarity and to prevent future problems.
> > 
> > XFS_RENAME_SPACE_RES() covers directory removal and insertion. Here we
> > are doing neither, which makes me wonder whether we need a block
> > reservation at all. It does appear that we have a sf dir case where the
> > inode number could cause a format conversion. Perhaps we need something
> > that calculates the blocks required for the insertion of the max of both
> > names (it seems like the conversion would only happen once, but we don't
> > know which way)? I haven't spent a ton of time in directory code, so I
> > could easily be missing something.
> 
> The shortform replace can result in shortform->block conversion,
> therefore we need the reservation.
> 
> > The tr_rename log reservation considers four inodes, two directory
> > modifications, a target inode unlink (the overwrite case), and alloc
> > btree mods for directory blocks being freed. IIUC, the exchange case
> > should only ever log four inodes and the possible dir format conversion
> > (e.g., no unlink, no dir block frees). We could define a new
> > tr_rename_xchg reservation that encodes that and documents it
> > appropriately in the comment.
> 
> The rename log reservation is the worse case that a rename operation
> requires - it is not specific to a particular rename instance. This
> new reanme type fits within the existing definition, so we should
> just use it unchanged.
> 
> What it comes down to is that there is no point in trying to define
> reservations for every single possible type of operation we can do -
> it's just too much maintenance overhead to verify that they are
> correct after some incidental change. If we define the worst case,
> then everything else is covered and we don't have to care about
> whether we have the reservation for a specific case right, or indeed
> whether we are using the correct reservation for a specific rename
> transaction....
> 
> 
> > > +	if (error == -ENOSPC) {
> > > +		spaceres = 0;
> > > +		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, 0, 0);
> > > +	}
> > > +	if (error) {
> > > +		xfs_trans_cancel(tp, 0);
> > > +		goto std_return;
> > > +	}
> 
> This is not necessary. The spaceres == 0 case in the rename is for
> adding new directory entries at ENOSPC and that is checked by
> xfs_dir_canenter(). We are not calling that function (because we
> aren't adding a name) and therefore we can't run without a full
> space reservation.
> 
> Oh, and kill that "std_return" name.
> 
> 	if (error) {
> 		cancel_flags = 0;
> 		goto out_trans_cancel;
> 	}
> 
> > > +
> > > +	/*
> > > +	 * Attach the dquots to the inodes
> > > +	 */
> > > +	error = xfs_qm_vop_rename_dqattach(inodes);
> > > +	if (error) {
> > > +		xfs_trans_cancel(tp, cancel_flags);
> > > +		goto std_return;
> > > +	}
> 
> 	if (error)
> 		goto out_trans_cancel;
> 
> > > +
> > > +	/*
> > > +	 * Lock all participating inodes. In case of RENAME_EXCHANGE, target
> > > +	 * must exist, so we'll be locking at least 3 inodes here.
> > > +	 */
> > > +	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
> > > +
> > > +	/*
> > > +	 * Join all the inodes to the transaction. From this point on,
> > > +	 * we can rely on either trans_commit or trans_cancel to unlock
> > > +	 * them.
> > > +	 * target_ip will always exist, so, no need to check its existence.
> > > +	 */
> > > +	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
> > > +	if (new_parent)
> > > +		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
> > > +
> > > +	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
> > > +	xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
> > > +
> > > +	/*
> > > +	* If we are using project inheritance, we only allow RENAME_EXCHANGE
> > > +	* into our tree when the project IDs are the same; else the tree quota
> > > +	* mechanism would be circumvented.
> > > +	*/
> > > +	if (unlikely(((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) ||
> > > +		     (src_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)) &&
> > > +		     (xfs_get_projid(src_dp) != xfs_get_projid(target_dp)) )) {
> > > +		error = -EXDEV;
> > > +		goto error_return;
> > > +	}
> > > +
> > 
> > I think that having a separate helper for the rename exchange case is
> > generally the right thing. That said, I wonder if we're splitting things
> > at the right level because it looks like xfs_rename() could handle
> > everything we have in xfs_cross_rename() up to about this point.
> 
> Right. I think that splitting out the internal part of xfs_rename
> after all this common setup code is the best way to proceed.
> 
> > I definitely don't think we should go too far and try to handle all of
> > this in one function, even if there is some duplication in the directory
> > name replacement and inode link management. The logic would probably end
> > up unnecessarily hairy and difficult to reason about.
> > 
> > > +	error = xfs_dir_replace(tp, src_dp, src_name,
> > > +				target_ip->i_ino,
> > > +				&first_block, &free_list, spaceres);
> > > +	if (error)
> > > +		goto abort_return;
> > > +
> > > +	/*
> > > +	 * Update ".." entry to match the new parent
> > > +	 */
> > > +	if (new_parent && tgt_is_directory) {
> > > +		error = xfs_dir_replace(tp, target_ip, &xfs_name_dotdot,
> > > +					src_dp->i_ino, &first_block, &free_list, spaceres);
> > > +		if (error)
> > > +			goto abort_return;
> > > +	}
> > > +
> > > +	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> > > +
> > > +	error = xfs_dir_replace(tp, target_dp, target_name,
> > > +				src_ip->i_ino,
> > > +				&first_block, &free_list, spaceres);
> > > +	if (error)
> > > +		goto abort_return;
> > > +
> > > +	/*
> > > +	 * Update ".." entry to match the new parent
> > > +	 */
> > > +	if (new_parent && src_is_directory) {
> > > +		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
> > > +					target_dp->i_ino, &first_block, &free_list, spaceres);
> > > +		if (error)
> > > +			goto abort_return;
> > > +	}
> 
> So you do a bunch of work based on new_parent and
> tgt/src_is_directory, and then:
> 
> > > +
> > > +	/*
> > > +	 * In case we are crossing different file types between different
> > > +	 * parents, we must update parent's link count to match the ".."
> > > +	 * entry of the new child (or the removal of it).
> > > +	 */
> > > +	if (new_parent) {
> > > +		xfs_trans_ichgtime(tp, target_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> > > +
> > > +		if (src_is_directory && !tgt_is_directory) {
> > > +			error = xfs_droplink(tp, src_dp);
> > > +				if (error)
> > > +					goto abort_return;
> 
> [whitespace is screwed up]
> 
> > > +			error = xfs_bumplink(tp, target_dp);
> > > +				if (error)
> > > +					goto abort_return;
> > > +		}
> > > +
> > > +		if (tgt_is_directory && !src_is_directory) {
> > > +			error = xfs_droplink(tp, target_dp);
> > > +				if (error)
> > > +					goto abort_return;
> > > +			error = xfs_bumplink(tp, src_dp);
> > > +				if (error)
> > > +					goto abort_return;
> > > +		}
> > > +
> > > +		/*
> > > +		 * We don't need to log the source dir if
> > > +		 * this is the same as the target.
> > > +		 */
> > > +		xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
> > > +	}
> 
> You do a bunch more work based on the same variables. THis should
> reall ybe combined into a single set of logic to manipulate the
> directory states.
> 
> 	if (new_parent) {
> 		if (tgt_is_directory) {
> 			error = xfs_dir_replace(tp, target_ip, &xfs_name_dotdot,
> 						src_dp->i_ino, &first_block, &free_list, spaceres);
> 			if (error)
> 				goto out_abort;
> 			if (!src_is_directory) {
> 				error = xfs_droplink(tp, target_dp);
> 				if (error)
> 					goto out_abort;
> 				error = xfs_bumplink(tp, src_dp);
> 				if (error)
> 					goto out_abort;
> 			}
> 		}
> 
> 		if (src_is_directory) {
> 			error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
> 						target_dp->i_ino, &first_block, &free_list, spaceres);
> 			if (error)
> 				goto out_abort;
> 		.....
> 
> 
> > 
> > > +	/*
> > > +	 * If this is a synchronous mount, make sure the rename transaction goes
> > > +	 * to disk before returning to the user.
> > > +	 */
> > > +	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
> > > +		xfs_trans_set_sync(tp);
> > > +
> > > +	error = xfs_bmap_finish(&tp, &free_list, &committed);
> > > +	if (error) {
> > > +		xfs_bmap_cancel(&free_list);
> > > +		xfs_trans_cancel(tp, (XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT));
> > > +		goto std_return;
> > > +	}
> > > +	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> 
> 	error = xfs_bmap_finish(&tp, &free_list, &committed);
> 	if (!error)
> 		return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> 
> > > +abort_return:
> > > +	cancel_flags |= XFS_TRANS_ABORT;
> > > +error_return:
> > > +	xfs_bmap_cancel(&free_list);
> > > +	xfs_trans_cancel(tp, cancel_flags);
> > > +std_return:
> > > +	return error;
> 
> out_abort:
> 	cancel_flags |= XFS_TRANS_ABORT;
> out_bmap_cancel:
> 	xfs_bmap_cancel(&free_list);
> out_trans_cancel:
> 	xfs_trans_cancel(tp, cancel_flags);
> 	return error;
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
