Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4E2657F3F
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2014 01:36:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 08E6530404E
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 23:35:59 -0700 (PDT)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33]) by
	cuda.sgi.com with ESMTP id o2swrEE7UZ3HUR9q (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 08 Jul 2014 23:35:57 -0700 (PDT)
Received: from epcpsbgr2.samsung.com
	(u142.gpu120.samsung.co.kr [203.254.230.142])
	by mailout3.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0N8F001AHMBV5200@mailout3.samsung.com> for
	xfs@oss.sgi.com; Wed, 09 Jul 2014 15:35:55 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
References: <004001cf9aa4$2670e280$7352a780$@samsung.com>
	<alpine.LFD.2.00.1407081558280.2180@localhost.localdomain>
In-reply-to: <alpine.LFD.2.00.1407081558280.2180@localhost.localdomain>
Subject: RE: [PATCH 3/3] ext4: Add support IOC_MOV_DATA ioctl
Date: Wed, 09 Jul 2014 15:35:54 +0900
Message-id: <001901cf9b40$08994b70$19cbe250$@samsung.com>
MIME-version: 1.0
Content-language: ko
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?iso-8859-2?Q?'Luk=E1=B9_Czerner'?= <lczerner@redhat.com>
Cc: 'Theodore Ts'o' <tytso@mit.edu>, 'Brian Foster' <bfoster@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, 'Christoph Hellwig' <hch@infradead.org>, 'Ashish Sangwan' <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, 'linux-ext4' <linux-ext4@vger.kernel.org>

> On Tue, 8 Jul 2014, Namjae Jeon wrote:
> =

> > Date: Tue, 08 Jul 2014 21:00:02 +0900
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> > To: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>
> > Cc: linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.=
org,
> >     linux-kernel@vger.kernel.org, Luk=E1=B9 Czerner <lczerner@redhat.co=
m>,
> >     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@infradead=
.org>,
> >     Ashish Sangwan <a.sangwan@samsung.com>, xfs@oss.sgi.com
> > Subject: [PATCH 3/3] ext4: Add support IOC_MOV_DATA ioctl
> >
> > This patch implements fs ioctl's IOC_MOV_DATA for Ext4.
> =

> Hmm isn't this basically what ext4_move_extents() does ? eg.
> EXT4_IOC_MOVE_EXT ?
> =

> I guess that the intention here is to do the move, without actually
> moving the data right ? =

Yes, Right.


> But nevertheless maybe some code can be
> shared with ext4_move_extents() ?
Yes, I will try to share IOC_MOV_DATA and EXT4_IOC_MOVE_EXT code as the rep=
ly for Christoph.

Thanks!
> =

> -Lukas
> =

> >
> > The semantics of this ioctl are:
> > 1) Like collapse range, offsets and length should be file system block =
size
> >    aligned.
> > 2) In the receiver file, atleast length size hole should be present at
> >    receiver_offset
> > 3) It does not change file size of any of donor or receiver file.
> > 4) It leaves a hole at the place from where blocks are moved out in don=
or file.
> > 5) Both (donor_offset + length) and (receiver_offset + length) should b=
e within
> >    size of donor file and receiver file respectively.
> >    Only unwritten extents resides beyond file size and it does not make=
 sense
> >    to transfer unwritten extents, leave apart the security issues it ma=
y raise.
> > 6) If the range to be transfered from donor file contain any holes, the=
y are
> >    replicated as it is in receiver file. It mean holes are preserved and
> >    the length of hole will be added to moved_len signifying that the ho=
le range
> >    is succesfully transfered.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > ---
> >  fs/ext4/ext4.h    |   2 +
> >  fs/ext4/extents.c | 375 ++++++++++++++++++++++++++++++++++++++++++++++=
++++++++
> >  fs/ext4/file.c    |   1 +
> >  3 files changed, 378 insertions(+)
> >
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index 6386c5f..26478eb 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -2725,6 +2725,8 @@ extern int ext4_fiemap(struct inode *inode, struc=
t fiemap_extent_info *fieinfo,
> >  extern int ext4_ext_precache(struct inode *inode);
> >  extern int ext4_collapse_range(struct inode *inode, loff_t offset, lof=
f_t len);
> >  extern int ext4_insert_range(struct file *file, loff_t offset, loff_t =
len);
> > +extern int ext4_mov_data(struct inode *, struct inode *, loff_t, loff_=
t, loff_t,
> > +			 loff_t *);
> >
> >  /* move_extent.c */
> >  extern void ext4_double_down_write_data_sem(struct inode *first,
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 0c2432e..511db03 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -5811,3 +5811,378 @@ out_mutex:
> >  	mutex_unlock(&inode->i_mutex);
> >  	return ret;
> >  }
> > +
> > +/*
> > + * If offset_lblk does not lie on the extent start boundary, split ext=
ent
> > + */
> > +int ext4_find_and_split_extent_at(struct inode *inode, ext4_lblk_t off=
set_lblk)
> > +{
> > +	struct ext4_ext_path *path;
> > +	handle_t *handle;
> > +	int credits, err =3D 0, split_flag, ex_len;
> > +	struct ext4_extent *ex;
> > +	int depth =3D ext_depth(inode);
> > +	ext4_lblk_t ex_start;
> > +
> > +	path =3D ext4_ext_find_extent(inode, offset_lblk, NULL, 0);
> > +	if (IS_ERR(path))
> > +		return PTR_ERR(path);
> > +
> > +	ex =3D path[depth].p_ext;
> > +	if (!ex)
> > +		goto free_path;
> > +	ex_start =3D le32_to_cpu(ex->ee_block);
> > +	ex_len =3D ext4_ext_get_actual_len(ex);
> > +
> > +	if (offset_lblk > ex_start && offset_lblk < (ex_start + ex_len)) {
> > +		credits =3D ext4_writepage_trans_blocks(inode);
> > +		handle =3D ext4_journal_start(inode, EXT4_HT_TRUNCATE, credits);
> > +		if (IS_ERR(handle)) {
> > +			err =3D PTR_ERR(handle);
> > +			goto free_path;
> > +		}
> > +		if (ext4_ext_is_unwritten(ex))
> > +			split_flag =3D EXT4_EXT_MARK_UNWRIT1 |
> > +				     EXT4_EXT_MARK_UNWRIT2;
> > +		else
> > +			split_flag =3D 0;
> > +
> > +		err =3D ext4_split_extent_at(handle, inode, path, offset_lblk,
> > +					   split_flag, EXT4_EX_NOCACHE |
> > +					   EXT4_GET_BLOCKS_PRE_IO);
> > +		ext4_journal_stop(handle);
> > +	}
> > +
> > +free_path:
> > +	ext4_ext_drop_refs(path);
> > +	kfree(path);
> > +	return err;
> > +}
> > +
> > +/*
> > + * Compute the size of hole in terms of filesystem blocks present at o=
ffset_lblk
> > + * until the next extent is found OR till we reach the last block with=
in isize.
> > + * Store the computed value in hole_blkcnt.
> > + * offset_lblk should be within isize of inode.
> > + */
> > +int ext4_compute_hole_size(struct inode *inode, ext4_lblk_t offset_lbl=
k,
> > +			   ext4_lblk_t *hole_blkcnt)
> > +{
> > +	struct ext4_ext_path *path;
> > +	struct ext4_extent *ex;
> > +	ext4_lblk_t ex_start, isize_lblk;
> > +	int ret =3D 0, depth, ex_len;
> > +
> > +	isize_lblk =3D (inode->i_size + EXT4_BLOCK_SIZE(inode->i_sb) - 1) >>
> > +		     EXT4_BLOCK_SIZE_BITS(inode->i_sb);
> > +
> > +	if (offset_lblk > isize_lblk)
> > +		return -EINVAL;
> > +
> > +	*hole_blkcnt =3D 0;
> > +	path =3D ext4_ext_find_extent(inode, offset_lblk, NULL, 0);
> > +	if (IS_ERR(path))
> > +		return PTR_ERR(path);
> > +
> > +	depth =3D ext_depth(inode);
> > +	ex =3D path[depth].p_ext;
> > +	if (!ex) {
> > +		/* No blocks allocated in this file */
> > +		*hole_blkcnt =3D isize_lblk - offset_lblk;
> > +		goto out;
> > +	}
> > +	ex_start =3D le32_to_cpu(ex->ee_block);
> > +	ex_len =3D ext4_ext_get_actual_len(ex);
> > +
> > +	/* if offset_lblk lies within extent? */
> > +	if (offset_lblk >=3D ex_start && offset_lblk < (ex_start + ex_len))
> > +		goto out;
> > +
> > +	if (ex_start < offset_lblk) {
> > +		ret =3D mext_next_extent(inode, path, &ex);
> > +		if (!ret) {
> > +			ex_start =3D le32_to_cpu(ex->ee_block);
> > +		} else {
> > +			if (ret =3D=3D 1) {
> > +				*hole_blkcnt =3D isize_lblk - offset_lblk;
> > +				ret =3D 0;
> > +			}
> > +			goto out;
> > +		}
> > +	}
> > +	*hole_blkcnt =3D (ex_start < isize_lblk) ? (ex_start - offset_lblk) :
> > +						 (isize_lblk - offset_lblk);
> > +out:
> > +	ext4_ext_drop_refs(path);
> > +	kfree(path);
> > +
> > +	return ret;
> > +}
> > +
> > +/*
> > + * Remove a complete extent from in memory and on-disk extent tree
> > + * without freeing any data blocks covered by the extent. Caller must =
call
> > + * ext4_mark_inode_dirty() to sync the changes to disk.
> > + */
> > +int ext4_ext_rm_extent(handle_t *handle, struct inode *inode,
> > +		       struct ext4_ext_path *path, struct ext4_extent *ex)
> > +{
> > +	struct ext4_extent_header *eh;
> > +	int depth =3D ext_depth(inode);
> > +	int credits, err, correct_index =3D 0;
> > +	int ex_ee_len =3D ext4_ext_get_actual_len(ex);
> > +
> > +	if (!path[depth].p_hdr)
> > +		path[depth].p_hdr =3D ext_block_hdr(path[depth].p_bh);
> > +	eh =3D path[depth].p_hdr;
> > +
> > +	credits =3D 7 + 2*(ex_ee_len/EXT4_BLOCKS_PER_GROUP(inode->i_sb));
> > +	if (ex =3D=3D EXT_FIRST_EXTENT(eh)) {
> > +		correct_index =3D 1;
> > +		credits +=3D (ext_depth(inode)) + 1;
> > +	}
> > +	credits +=3D EXT4_MAXQUOTAS_TRANS_BLOCKS(inode->i_sb);
> > +	err =3D ext4_ext_truncate_extend_restart(handle, inode, credits);
> > +	if (err)
> > +		return err;
> > +
> > +	err =3D ext4_ext_get_access(handle, inode, path + depth);
> > +	if (err)
> > +		return err;
> > +
> > +	ext4_ext_store_pblock(ex, 0);
> > +	memmove(ex, ex+1,
> > +		(EXT_LAST_EXTENT(eh) - ex) * sizeof(struct ext4_extent));
> > +	memset(EXT_LAST_EXTENT(eh), 0, sizeof(struct ext4_extent));
> > +	le16_add_cpu(&eh->eh_entries, -1);
> > +
> > +	err =3D ext4_ext_dirty(handle, inode, path + depth);
> > +	if (err)
> > +		return err;
> > +
> > +	if (correct_index && eh->eh_entries)
> > +		err =3D ext4_ext_correct_indexes(handle, inode, path);
> > +
> > +	if (err =3D=3D 0 && eh->eh_entries =3D=3D 0 && path[depth].p_bh !=3D =
NULL)
> > +		err =3D ext4_ext_rm_idx(handle, inode, path, depth);
> > +
> > +	return err;
> > +}
> > +
> > +/*
> > + * Move len_lblk amount of blocks from donor inode to receiver inode.
> > + * Blocks are to be moved from doffset_lblk and moved to roffset_lblk.
> > + * Caller of this function must make sure there is atleast len_lblk si=
ze
> > + * hole at roffset_lblk. Also doffset_lblk and doffset_lblk + len_lblk
> > + * should fall on extent boundary.
> > + */
> > +int ext4_ext_mov_data(struct inode *donor, struct inode *receiver,
> > +		      ext4_lblk_t doffset_lblk, ext4_lblk_t roffset_lblk,
> > +		      ext4_lblk_t len_lblk, loff_t *bytes_moved)
> > +{
> > +	int error =3D 0, depth =3D ext_depth(donor);
> > +	struct ext4_ext_path *path;
> > +	struct ext4_extent *ex;
> > +	loff_t blocks_moved =3D 0;
> > +	handle_t *handle;
> > +	int credits =3D ext4_writepage_trans_blocks(donor) +
> > +		      ext4_writepage_trans_blocks(receiver);
> > +
> > +	while (blocks_moved < len_lblk && !error) {
> > +		struct ext4_ext_path *rpath =3D NULL;
> > +		ext4_lblk_t ex_start;
> > +		int ex_len;
> > +
> > +		path =3D ext4_ext_find_extent(donor, doffset_lblk, NULL, 0);
> > +		if (IS_ERR(path)) {
> > +			error =3D PTR_ERR(path);
> > +			break;
> > +		}
> > +		ex =3D path[depth].p_ext;
> > +		/*
> > +		 * No allocated blocks? This could only happen during
> > +		 * 1st iteration. Otherwise it is en error.
> > +		 */
> > +		if (!ex) {
> > +			if (blocks_moved)
> > +				error =3D -EIO;
> > +			else
> > +				blocks_moved =3D len_lblk;
> > +			goto out;
> > +		}
> > +		ex_start =3D le32_to_cpu(ex->ee_block);
> > +		ex_len =3D ext4_ext_get_actual_len(ex);
> > +
> > +		if (doffset_lblk !=3D ex_start) {
> > +			/* Hole within range, move to the next extent */
> > +			if (ex_start < doffset_lblk)
> > +				error =3D mext_next_extent(donor, path, &ex);
> > +			/* Below if will also handle ex_start > doffset_lblk */
> > +			if (error =3D=3D 0) {
> > +				ex_start =3D le32_to_cpu(ex->ee_block);
> > +				blocks_moved +=3D ex_start - doffset_lblk;
> > +				roffset_lblk +=3D ex_start - doffset_lblk;
> > +				doffset_lblk =3D ex_start;
> > +			}
> > +			if (error =3D=3D 1) {
> > +				/* doffset_lblk till EOF is hole. Success!! */
> > +				blocks_moved =3D len_lblk;
> > +				error =3D 0;
> > +			}
> > +			goto out;
> > +		}
> > +
> > +		/* Add this extent to receiver */
> > +		handle =3D ext4_journal_start(donor, EXT4_HT_TRUNCATE, credits);
> > +		if (IS_ERR(handle)) {
> > +			error =3D PTR_ERR(handle);
> > +			goto out;
> > +		}
> > +
> > +		rpath =3D ext4_ext_find_extent(receiver, roffset_lblk, NULL, 0);
> > +		if (IS_ERR(rpath)) {
> > +			error =3D PTR_ERR(rpath);
> > +			ext4_journal_stop(handle);
> > +			goto out;
> > +		}
> > +		ex->ee_block =3D cpu_to_le32(roffset_lblk);
> > +		error =3D ext4_ext_insert_extent(handle, receiver, rpath, ex, 0);
> > +		if (error)
> > +			goto hout;
> > +
> > +		/* Remove this extent from donor */
> > +		error =3D ext4_ext_rm_extent(handle, donor, path, ex);
> > +		if (error)
> > +			goto hout;
> > +
> > +		/* Extent moved successfully */
> > +		roffset_lblk +=3D ex_len;
> > +		doffset_lblk +=3D ex_len;
> > +		blocks_moved +=3D ex_len;
> > +
> > +		donor->i_blocks -=3D (ex_len << (donor->i_blkbits - 9));
> > +		receiver->i_blocks +=3D (ex_len << (receiver->i_blkbits - 9));
> > +		donor->i_mtime =3D donor->i_ctime =3D ext4_current_time(donor);
> > +		receiver->i_mtime =3D receiver->i_ctime =3D
> > +						ext4_current_time(receiver);
> > +		ext4_mark_inode_dirty(handle, donor);
> > +		ext4_mark_inode_dirty(handle, receiver);
> > +hout:
> > +		ext4_journal_stop(handle);
> > +		ext4_ext_drop_refs(rpath);
> > +		kfree(rpath);
> > +out:
> > +		ext4_ext_drop_refs(path);
> > +		kfree(path);
> > +	}
> > +
> > +	/* This can happen when (doffset_lblk + len_lblk) is in a hole */
> > +	if (blocks_moved > len_lblk)
> > +		blocks_moved =3D len_lblk;
> > +
> > +	*bytes_moved =3D blocks_moved << EXT4_BLOCK_SIZE_BITS(donor->i_sb);
> > +	return error;
> > +}
> > +
> > +int ext4_mov_data(struct inode *donor, struct inode *receiver, loff_t =
doffset,
> > +		  loff_t roffset, loff_t len, loff_t *moved_len)
> > +{
> > +	struct super_block *sb =3D donor->i_sb;
> > +	loff_t d_pg_off, r_pg_off, pg_len;
> > +	ext4_lblk_t doffset_lblk, roffset_lblk, len_lblk, hole_size;
> > +	int error;
> > +
> > +	if (doffset & (EXT4_BLOCK_SIZE(sb) - 1) ||
> > +	    roffset & (EXT4_BLOCK_SIZE(sb) - 1) ||
> > +	    len & (EXT4_BLOCK_SIZE(sb) - 1))
> > +		return -EINVAL;
> > +
> > +	if (EXT4_SB(sb)->s_cluster_ratio > 1)
> > +		return -EOPNOTSUPP;
> > +
> > +	if (!ext4_test_inode_flag(donor, EXT4_INODE_EXTENTS) ||
> > +	    !ext4_test_inode_flag(receiver, EXT4_INODE_EXTENTS))
> > +		return -EOPNOTSUPP;
> > +
> > +	doffset_lblk =3D doffset >> EXT4_BLOCK_SIZE_BITS(sb);
> > +	roffset_lblk =3D roffset >> EXT4_BLOCK_SIZE_BITS(sb);
> > +	len_lblk =3D len >> EXT4_BLOCK_SIZE_BITS(sb);
> > +
> > +	d_pg_off =3D round_down(doffset, PAGE_SIZE);
> > +	r_pg_off =3D round_down(roffset, PAGE_SIZE);
> > +	pg_len =3D round_up(len, PAGE_SIZE);
> > +
> > +	if (ext4_should_journal_data(donor)) {
> > +		error =3D ext4_force_commit(donor->i_sb);
> > +		if (error)
> > +			return error;
> > +		error =3D ext4_force_commit(receiver->i_sb);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	error =3D filemap_write_and_wait_range(donor->i_mapping,
> > +					     d_pg_off, d_pg_off + pg_len);
> > +	if (error)
> > +		return error;
> > +	error =3D filemap_write_and_wait_range(receiver->i_mapping,
> > +					     r_pg_off, r_pg_off + pg_len);
> > +	if (error)
> > +		return error;
> > +
> > +	lock_two_nondirectories(donor, receiver);
> > +
> > +	/* Check for isize limits for both files */
> > +	if (doffset + len > donor->i_size ||
> > +	    roffset + len > receiver->i_size) {
> > +		error =3D -EINVAL;
> > +		goto out_mutex;
> > +	}
> > +
> > +	truncate_pagecache_range(donor, d_pg_off, d_pg_off + pg_len - 1);
> > +	truncate_pagecache_range(receiver, r_pg_off, r_pg_off + pg_len - 1);
> > +
> > +	ext4_inode_block_unlocked_dio(donor);
> > +	inode_dio_wait(donor);
> > +	ext4_inode_block_unlocked_dio(receiver);
> > +	inode_dio_wait(receiver);
> > +
> > +	ext4_discard_preallocations(donor);
> > +	ext4_discard_preallocations(receiver);
> > +
> > +	error =3D ext4_es_remove_extent(donor, doffset_lblk, len_lblk);
> > +	if (error)
> > +		goto out_sem;
> > +	error =3D ext4_es_remove_extent(receiver, roffset_lblk, len_lblk);
> > +	if (error)
> > +		goto out_sem;
> > +
> > +	error =3D ext4_compute_hole_size(receiver, roffset_lblk, &hole_size);
> > +	if (error)
> > +		goto out_sem;
> > +	if (len_lblk > hole_size) {
> > +		error =3D -EINVAL;
> > +		goto out_sem;
> > +	}
> > +
> > +	error =3D ext4_find_and_split_extent_at(donor, doffset_lblk);
> > +	if (error)
> > +		goto out_sem;
> > +
> > +	error =3D ext4_find_and_split_extent_at(donor, doffset_lblk + len_lbl=
k);
> > +	if (error)
> > +		goto out_sem;
> > +
> > +	error =3D ext4_ext_mov_data(donor, receiver, doffset_lblk,
> > +				  roffset_lblk, len_lblk, moved_len);
> > +
> > +	ext4_discard_preallocations(donor);
> > +	ext4_discard_preallocations(receiver);
> > +out_sem:
> > +	ext4_inode_resume_unlocked_dio(donor);
> > +	ext4_inode_resume_unlocked_dio(receiver);
> > +
> > +out_mutex:
> > +	unlock_two_nondirectories(donor, receiver);
> > +	return error;
> > +}
> > diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> > index 8695f70..d2feaba 100644
> > --- a/fs/ext4/file.c
> > +++ b/fs/ext4/file.c
> > @@ -614,5 +614,6 @@ const struct inode_operations ext4_file_inode_opera=
tions =3D {
> >  	.get_acl	=3D ext4_get_acl,
> >  	.set_acl	=3D ext4_set_acl,
> >  	.fiemap		=3D ext4_fiemap,
> > +	.mov_data	=3D ext4_mov_data,
> >  };
> >
> >

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
