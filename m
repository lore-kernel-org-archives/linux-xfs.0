Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49520 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbeLaSvp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 13:51:45 -0500
Date: Mon, 31 Dec 2018 10:51:37 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/9] xfs-5.0: inode scrubber fixes
Message-ID: <20181231185137.GA21010@magnolia>
References: <154344761877.3835.7785580513047409388.stgit@magnolia>
 <13458322.z1pYrAaifT@localhost.localdomain>
 <20181219203359.GC27176@magnolia>
 <4040942.PUtEGDS0su@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4040942.PUtEGDS0su@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.ibm.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org

On Mon, Dec 31, 2018 at 05:09:47PM +0530, Chandan Rajendra wrote:
> On Thursday, December 20, 2018 2:03:59 AM IST Darrick J. Wong wrote:
> > On Wed, Dec 19, 2018 at 06:45:26PM +0530, Chandan Rajendra wrote:
> > > On Wednesday, December 19, 2018 2:01:13 PM IST Chandan Rajendra wrote:
> > > > On Thursday, November 29, 2018 4:56:58 AM IST Darrick J. Wong wrote:
> > > > > Hi all,
> > > > > 
> > > > > Here are fixes for some problems with the inode btree scrub code, namely
> > > > > that the existing code does not handle the case where a single inode
> > > > > cluster is mapped by multiple inobt records.
> > > > > 
> > > > > Patch 1 teaches the inode record block counting code to handle the case
> > > > > where there's more than one inobt record per inode cluster.  We do this
> > > > > by counting inodes and converting to blocks only at the end.
> > > > > 
> > > > > Patch 2 corrects a condition where we needed to clamp the number of
> > > > > inodes checked for a given inobt record to the inode chunk size.
> > > > > 
> > > > > Patches 3-4 move the inobt record alignment checks to a separate
> > > > > function and enhance the function to check that when we have more than
> > > > > one inobt record per cluster we actually check that *all* of the
> > > > > necessary records are present and in the correct order.
> > > > > 
> > > > > Patches 5-7 reorganize the inobt free data checks to deal with the
> > > > > "multiple inobt records per icluster" situation.  In restructuring the
> > > > > code to do so, we also rename variables and functions to be less
> > > > > confusing about what they're there for.  We also fix the 'is the inode
> > > > > free?' check to calculate dinode buffer offsets correctly in the
> > > > > "multiple inobt records per icluster" situation.
> > > > > 
> > > > > Patch 8 aborts the xattr scrub loop if there are pending fatal signals.
> > > > > 
> > > > > Patch 9 checks that for any directory or attr fork there are no extent
> > > > > maps that stretch beyond what a xfs_dablk_t can map.
> > > > > 
> > > > > If you're going to start using this mess, you probably ought to just
> > > > > pull from my git trees.  The kernel patches[1] should apply against
> > > > > 4.20-rc4.
> > > > > 
> > > > > Comments and questions are, as always, welcome.
> > > > 
> > > > Hi Darrick,
> > > > 
> > > > I reviewed patches 1 through 7. The fixes look good.
> > > > 
> > > > I am not well versed with the XFS code that deals with xattrs &
> > > > directories. Hence I could not review patches 8 and 9.
> > > > 
> > > > I did a simple scrub test on a 64k blocksized filesystem running a kernel
> > > > having the following commit as the HEAD,
> > > > 
> > > > commit 6c4e1579b332e52566c11416e0dd0fa91a3b8f70 (HEAD -> djwong-devel, djwong-xfs-linux/djwong-devel)
> > > > Author: Darrick J. Wong <darrick.wong@oracle.com>
> > > > Date:   Thu Oct 18 17:35:49 2018 -0700
> > > > 
> > > >     xfs: repair quotas
> > > >     
> > > >     Fix anything that causes the quota verifiers to fail.
> > > >     
> > > >     Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > 
> > > > Xfsprogs had the following as the topmost commit,
> > > > 
> > > > commit 633eec2a893c3be9796dad188144b00e084560ec (HEAD -> djwong-devel, djwong/djwong-devel)
> > > > Author: Darrick J. Wong <darrick.wong@oracle.com>
> > > > Date:   Tue Nov 13 17:38:31 2018 -0800
> > > > 
> > > >     xfs: repair extended attributes
> > > >     
> > > >     If the extended attributes look bad, try to sift through the rubble to
> > > >     find whatever keys/values we can, zap the attr tree, and re-add the
> > > >     values.
> > > >     
> > > >     Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > 
> > > > The test filesystem had 2000 files with each being 64k in size.
> > > > 
> > > > root@ubuntu:~# xfs_scrub -d -n -v /mnt/
> > > > EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
> > > > Phase 1: Find filesystem geometry.
> > > > /mnt/: using 8 threads to scrub.
> > > > Phase 2: Check internal metadata.
> > > > Info: AG 1 superblock: Optimization is possible. (scrub.c line 269)
> > > > Info: AG 3 superblock: Optimization is possible. (scrub.c line 269)
> > > > Info: AG 2 superblock: Optimization is possible. (scrub.c line 269)
> > > > Error: AG 0 free inode btree: Repairs are required. (scrub.c line 253)
> > > > Phase 3: Scan all inodes.
> > > > Phase 5: Check directory tree.
> > > > Info: /mnt/: Filesystem has errors, skipping connectivity checks. (phase5.c line 295)
> > > > Phase 7: Check summary counters.
> > > > 163.9MiB data used;  1.9K inodes used.
> > > > 152.7MiB data found; 1.9K inodes found.
> > > > 1.9K inodes counted; 1.9K inodes checked.
> > > > /mnt/: errors found: 1
> > > > /mnt/: Re-run xfs_scrub without -n.
> > > > 
> > > > Looks like we have a bug when scrubbing the Free inode btree. I will work on
> > > > figuring out the root cause and also plan to execute scrub tests shipped with
> > > > xfstests.
> > > > 
> > > > 
> > > 
> > > We do have an unaligned finobt record,
> > > 
> > > xfs_scrub 27247 [004] 18014.774762: probe:xchk_iallocbt_rec_alignment: (c00000000075941c) ir_startino=176960 ig_cluster_align_inodes=128 imask_u32=127
> > >         c00000000075941c xchk_iallocbt_rec_alignment+0x10c (/boot/vmlinux)
> > >         c00000000075966c xchk_iallocbt_rec+0x14c (/boot/vmlinux)
> > >                        0 [unknown] ([unknown])
> > >         c000000000752968 xchk_btree+0x288 (/boot/vmlinux)
> > >         c0000000007598c4 xchk_iallocbt+0x64 (/boot/vmlinux)
> > >         c00000000075dc1c xfs_scrub_metadata+0x4ac (/boot/vmlinux)
> > >         c0000000006e4b88 xfs_ioc_scrub_metadata+0x68 (/boot/vmlinux)
> > >         c0000000006e7d5c xfs_file_ioctl+0xbbc (/boot/vmlinux)
> > >         c000000000425e04 do_vfs_ioctl+0xd4 (/boot/vmlinux)
> > >         c000000000426874 ksys_ioctl+0x64 (/boot/vmlinux)
> > >         c000000000426928 __se_sys_ioctl+0x28 (/boot/vmlinux)
> > >         c00000000000bae4 system_call+0x5c (/boot/vmlinux)
> > >             7ffff77d7694 __GI___ioctl+0x114 (/lib/powerpc64le-linux-gnu/libc-2.27.so)
> > >                10000e4e0 xfs_check_metadata+0x100 (/root/repos/xfsprogs-dev/scrub/xfs_scrub)
> > >                10000e484 xfs_check_metadata+0xa4 (/root/repos/xfsprogs-dev/scrub/xfs_scrub)
> > >                10000ec48 xfs_scrub_metadata+0xd8 (/root/repos/xfsprogs-dev/scrub/xfs_scrub)
> > >                100008dac xfs_scan_ag_metadata+0x12c (/root/repos/xfsprogs-dev/scrub/xfs_scrub)
> > >                1000198c8 workqueue_thread+0x108 (/root/repos/xfsprogs-dev/scrub/xfs_scrub)
> > >             7ffff7f2885c start_thread+0x10c (/lib/powerpc64le-linux-gnu/libpthread-2.27.so)
> > >             7ffff77e9028 __clone+0x98 (/lib/powerpc64le-linux-gnu/libc-2.27.so)
> > > 
> > > Maybe this is due to a bug in the finobt code. I will continue debugging and
> > > report my findings.
> > 
> > Ok.  Feel free to send along a metadump if you have one.
> > 
> 
> 
> Indeed, XFS does not align finobt records according to inode cluster size.
> 
> More precisely, For big block filesystems, When freeing inodes (please refer
> to xfs_difree_inobt()), XFS does not delete inobt records due to the following
> code evaluating to false,
> 
>         if (!(mp->m_flags & XFS_MOUNT_IKEEP) &&
>             rec.ir_free == XFS_INOBT_ALL_FREE &&
>             mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK) {
> 
> However there is no such conditional check when deleting finobt records.
> Hence I wrote the following patch,
> 
> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 85 +++++++++++++++++++++++++++-----------
>  fs/xfs/scrub/ialloc.c      |  2 +
>  2 files changed, 64 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index f32be0c85f93..8d3edd758413 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1399,14 +1399,19 @@ xfs_dialloc_ag_finobt_near(
>  	struct xfs_btree_cur		*lcur = *ocur;	/* left search cursor */
>  	struct xfs_btree_cur		*rcur;	/* right search cursor */
>  	struct xfs_inobt_rec_incore	rrec;
> +	xfs_agino_t			agino;
>  	int				error;
>  	int				i, j;
>  
> -	error = xfs_inobt_lookup(lcur, pagino, XFS_LOOKUP_LE, &i);
> -	if (error)
> -		return error;
> +	agino = pagino;
> +	while (1) {
> +		error = xfs_inobt_lookup(lcur, agino, XFS_LOOKUP_LE, &i);
> +		if (error)
> +			return error;
> +
> +		if (i != 1)
> +			break;
>  
> -	if (i == 1) {
>  		error = xfs_inobt_get_rec(lcur, rec, &i);
>  		if (error)
>  			return error;
> @@ -1417,23 +1422,39 @@ xfs_dialloc_ag_finobt_near(
>  		 * only tracks chunks with at least one free inode, so record
>  		 * existence is enough.
>  		 */
> -		if (pagino >= rec->ir_startino &&
> -		    pagino < (rec->ir_startino + XFS_INODES_PER_CHUNK))
> -			return 0;
> +		if (rec->ir_freecount) {
> +			if (pagino >= rec->ir_startino &&
> +				pagino < (rec->ir_startino + XFS_INODES_PER_CHUNK))
> +				return 0;
> +			else
> +				break;
> +		}
> +
> +		agino = rec->ir_startino - 1;
>  	}
>  
>  	error = xfs_btree_dup_cursor(lcur, &rcur);
>  	if (error)
>  		return error;
>  
> -	error = xfs_inobt_lookup(rcur, pagino, XFS_LOOKUP_GE, &j);
> -	if (error)
> -		goto error_rcur;
> -	if (j == 1) {
> +	agino = pagino;
> +	while (1) {
> +		error = xfs_inobt_lookup(rcur, agino, XFS_LOOKUP_GE, &j);
> +		if (error)
> +			goto error_rcur;
> +
> +		if (j != 1)
> +			break;
> +
>  		error = xfs_inobt_get_rec(rcur, &rrec, &j);
>  		if (error)
>  			goto error_rcur;
>  		XFS_WANT_CORRUPTED_GOTO(lcur->bc_mp, j == 1, error_rcur);
> +
> +		if (rrec.ir_freecount)
> +			break;
> +
> +		agino = rrec.ir_startino + XFS_INODES_PER_CHUNK;
>  	}
>  
>  	XFS_WANT_CORRUPTED_GOTO(lcur->bc_mp, i == 1 || j == 1, error_rcur);
> @@ -1477,6 +1498,7 @@ xfs_dialloc_ag_finobt_newino(
>  	struct xfs_btree_cur		*cur,
>  	struct xfs_inobt_rec_incore	*rec)
>  {
> +	xfs_agino_t agino;
>  	int error;
>  	int i;
>  
> @@ -1490,22 +1512,32 @@ xfs_dialloc_ag_finobt_newino(
>  			if (error)
>  				return error;
>  			XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, i == 1);
> -			return 0;
> +
> +			if (rec->ir_freecount)
> +				return 0;
>  		}
>  	}
>  
>  	/*
>  	 * Find the first inode available in the AG.
>  	 */
> -	error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &i);
> -	if (error)
> -		return error;
> -	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, i == 1);
> +	agino = 0;
> +	while (1) {
> +		error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_GE, &i);
> +		if (error)
> +			return error;
> +		XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, i == 1);
>  
> -	error = xfs_inobt_get_rec(cur, rec, &i);
> -	if (error)
> -		return error;
> -	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, i == 1);
> +		error = xfs_inobt_get_rec(cur, rec, &i);
> +		if (error)
> +			return error;
> +		XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, i == 1);
> +
> +		if (rec->ir_freecount)
> +			break;
> +
> +		agino += XFS_INODES_PER_CHUNK;
> +	}
>  
>  	return 0;
>  }
> @@ -1615,10 +1647,17 @@ xfs_dialloc_ag(
>  	 */
>  	rec.ir_free &= ~XFS_INOBT_MASK(offset);
>  	rec.ir_freecount--;
> -	if (rec.ir_freecount)
> +	if (rec.ir_freecount) {
>  		error = xfs_inobt_update(cur, &rec);
> -	else
> -		error = xfs_btree_delete(cur, &i);
> +	} else {
> +		if (!(mp->m_flags & XFS_MOUNT_IKEEP) &&
> +			/* TODO: Add a condition to check hole mask */
> +			mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK)
> +			error = xfs_btree_delete(cur, &i);
> +		else
> +			error = xfs_inobt_update(cur, &rec);
> +	}
> +
>  	if (error)
>  		goto error_cur;
>  
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 9269f5158cdc..838161f25db4 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -79,9 +79,11 @@ xchk_iallocbt_chunk_xref_other(
>  	error = xfs_ialloc_has_inode_record(*pcur, agino, agino, &has_irec);
>  	if (!xchk_should_check_xref(sc, &error, pcur))
>  		return;
> +#if 0
>  	if (((irec->ir_freecount > 0 && !has_irec) ||
>  	     (irec->ir_freecount == 0 && has_irec)))
>  		xchk_btree_xref_set_corrupt(sc, *pcur, 0);
> +#endif
>  }
>  
>  /* Cross-reference with the other btrees. */
> -- 
> 
> The "cross reference" check had to be disabled since the above patch now
> causes finobt entries with freecount value set to be 0 in big block
> filesystem instances.

I don't think this is a good idea, because this now breaks the notion
that the free inode btree contains only records for where there actually
/are/ free inodes.  AFAICT, the entire point of the finobt is to be a
condensed version of the inobt that only points to the free inodes, to
save time while creating files.  If we start writing ir_freecount == 0
finobt records now, what will older kernels think of this?

Furthermore, for these 'big block' filesystems we've already been
writing out individual finobt records that aren't aligned to anything
more than the cluster size.  These filesystems are already out in the
wild, so it is scrub that must adapt to this circumstance.

I think it's better to change xchk_iallocbt_rec_alignment to have a
different check at the top when we're checking finobt records:

/*
 * finobt records have different positioning requirements than inobt
 * records: each finobt record must have a corresponding inobt record.
 * That is checked in the xref function, so for now we only catch the
 * obvious case where the record isn't even chunk-aligned.
 *
 * Note also that if a fs block contains more than a single chunk of
 * inodes, we will have finobt records only for those chunks containing
 * free inodes.
 */
if (bs->cur->bc_btnum == XFS_BTNUM_FINO) {
	imask = XFS_INODES_PER_CHUNK - 1;
	if (irec->ir_startino & imask)
		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
	return;
}

> The following trivial tests have been executed on a kernel compiled with the
> above patch,
> 
> 1. For both 4k and 64k block sized filesystems,
>    1. Create 2000 files and execute xfs_scrub.
> 2. Repeat step 1 with sparse inode feature disabled.
> 3. Build linux kernel on the test filesystem.
> 
> I am planning to test it more thoroughly after I get review comments for the
> code changes provided above.
> 
> I have attached xz compressed image of xfs_metadump output of the test
> filesystem along with this mail.
> 
> PS: Apologies for the delayed response. It took me some time to understand the
> relevant code and write the patch provided above.

No worries, most of us have been on vacation for a week+ anyway.

--D

> -- 
> chandan
