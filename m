Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Mar 2008 04:26:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2BBQ4ab003211
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 04:26:05 -0700
Received: from wr-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E4C6683BA1
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 04:26:34 -0700 (PDT)
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.236]) by cuda.sgi.com with ESMTP id qBQkO3XuZUGMXVi4 for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 04:26:34 -0700 (PDT)
Received: by wr-out-0506.google.com with SMTP id c53so1273787wra.20
        for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 04:26:34 -0700 (PDT)
Message-ID: <1a4a774c0803110419n645da456leaedd98593300726@mail.gmail.com>
Date: Tue, 11 Mar 2008 12:19:29 +0100
From: "=?ISO-8859-1?Q?Christian_R=F8snes?=" <christian.rosnes@gmail.com>
Subject: Re: XFS internal error xfs_trans_cancel at line 1150 of file fs/xfs/xfs_trans.c
In-Reply-To: <20080311093406.GN155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <1a4a774c0802130251h657a52f7lb97942e7afdf6e3f@mail.gmail.com>
	 <1a4a774c0803050553h7f6294cfq41c38f34ea92ceae@mail.gmail.com>
	 <1a4a774c0803060310w2642224w690ac8fa13f96ec@mail.gmail.com>
	 <1a4a774c0803070319j1eb8790ek3daae4a16b3e6256@mail.gmail.com>
	 <20080310000809.GU155407@sgi.com>
	 <1a4a774c0803100302y17530814wee7522aa0dfd7668@mail.gmail.com>
	 <1a4a774c0803100134k258e1bcfma95e7969bc44b2af@mail.gmail.com>
	 <20080310222135.GZ155407@sgi.com>
	 <1a4a774c0803110108u3f01813fs7f9540f886be055@mail.gmail.com>
	 <20080311093406.GN155407@sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 11, 2008 at 10:34 AM, David Chinner <dgc@sgi.com> wrote:
>
> On Tue, Mar 11, 2008 at 09:08:31AM +0100, Christian Røsnes wrote:

>  > I'll try to add some printk statements to the codepaths you mentioned,
>  > and see where it leads.
>
>  Definitely worth confirming this is where the error is coming from.
>

	if (tagno == agno) {
			printk("XFS: xfs_dialloc:0021\n");
			*inop = NULLFSINO;
			return noroom ? ENOSPC : 0;
		}

seems to be what triggers this inside xfs_dialloc.

Here a trace which give some indication to the codepath taken inside
xfs_dialloc (xfs_ialloc.c):

mount:
/dev/sdb1 on /data type xfs (rw,noatime,logbufs=8,nobarrier)

# mkdir /data/test
mkdir: cannot create directory `/data/test': No space left on device


Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0001
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0002
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0003
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0005
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0006
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0010
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0012
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0013
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0014
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0018
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0020
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0013
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0014
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0018
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0020
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0013
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0014
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0018
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0020
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0013
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0014
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0018
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0020
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0013
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0014
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0018
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0020
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0013
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0014
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0018
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0020
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0013
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0014
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0018
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0020
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0013
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0014
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0018
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0020
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0013
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0014
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0018
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0020
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0013
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0014
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0018
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0020
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0013
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0014
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0018
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0020
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0013
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0014
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0018
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0020
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0013
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0014
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0018
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0020
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0013
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0014
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0018
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0020
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0013
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0014
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0018
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0020
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0013
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0014
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0018
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0020
Mar 11 11:47:00 linux kernel: XFS: xfs_dialloc:0021
Mar 11 11:47:00 linux kernel: Filesystem "sdb1": XFS internal error
xfs_trans_cancel at line 1163 of file fs/xfs/xfs_trans.c.  Caller
0xc021a390
Mar 11 11:47:00 linux kernel: Pid: 5598, comm: mkdir Not tainted 2.6.24.3FC #9
Mar 11 11:47:00 linux kernel:  [<c02129f8>] xfs_trans_cancel+0x5d/0xe6
Mar 11 11:47:00 linux kernel:  [<c021a390>] xfs_mkdir+0x45a/0x493
Mar 11 11:47:00 linux kernel:  [<c021a390>] xfs_mkdir+0x45a/0x493
Mar 11 11:47:00 linux kernel:  [<c01cbb8f>] xfs_acl_vhasacl_default+0x33/0x44
Mar 11 11:47:00 linux kernel:  [<c02230f0>] xfs_vn_mknod+0x165/0x243
Mar 11 11:47:00 linux kernel:  [<c0217f1e>] xfs_access+0x2f/0x35
Mar 11 11:47:00 linux kernel:  [<c02231ed>] xfs_vn_mkdir+0x12/0x14
Mar 11 11:47:00 linux kernel:  [<c016057b>] vfs_mkdir+0xa3/0xe2
Mar 11 11:47:00 linux kernel:  [<c0160644>] sys_mkdirat+0x8a/0xc3
Mar 11 11:47:00 linux kernel:  [<c016069c>] sys_mkdir+0x1f/0x23
Mar 11 11:47:00 linux kernel:  [<c01025ee>] syscall_call+0x7/0xb
Mar 11 11:47:00 linux kernel:  [<c03b0000>] svc_proc_register+0x3c/0x4b
Mar 11 11:47:00 linux kernel:  =======================
Mar 11 11:47:00 linux kernel: xfs_force_shutdown(sdb1,0x8) called from
line 1164 of file fs/xfs/xfs_trans.c.  Return address = 0xc0212a10
Mar 11 11:47:00 linux kernel: Filesystem "sdb1": Corruption of
in-memory data detected.  Shutting down filesystem: sdb1
Mar 11 11:47:00 linux kernel: Please umount the filesystem, and
rectify the problem(s)


instrumented code:

int
xfs_dialloc(
	xfs_trans_t	*tp,		/* transaction pointer */
	xfs_ino_t	parent,		/* parent inode (directory) */
	mode_t		mode,		/* mode bits for new inode */
	int		okalloc,	/* ok to allocate more space */
	xfs_buf_t	**IO_agbp,	/* in/out ag header's buffer */
	boolean_t	*alloc_done,	/* true if we needed to replenish
					   inode freelist */
	xfs_ino_t	*inop)		/* inode number allocated */
{
	xfs_agnumber_t	agcount;	/* number of allocation groups */
	xfs_buf_t	*agbp;		/* allocation group header's buffer */
	xfs_agnumber_t	agno;		/* allocation group number */
	xfs_agi_t	*agi;		/* allocation group header structure */
	xfs_btree_cur_t	*cur;		/* inode allocation btree cursor */
	int		error;		/* error return value */
	int		i;		/* result code */
	int		ialloced;	/* inode allocation status */
	int		noroom = 0;	/* no space for inode blk allocation */
	xfs_ino_t	ino;		/* fs-relative inode to be returned */
	/* REFERENCED */
	int		j;		/* result code */
	xfs_mount_t	*mp;		/* file system mount structure */
	int		offset;		/* index of inode in chunk */
	xfs_agino_t	pagino;		/* parent's a.g. relative inode # */
	xfs_agnumber_t	pagno;		/* parent's allocation group number */
	xfs_inobt_rec_incore_t rec;	/* inode allocation record */
	xfs_agnumber_t	tagno;		/* testing allocation group number */
	xfs_btree_cur_t	*tcur;		/* temp cursor */
	xfs_inobt_rec_incore_t trec;	/* temp inode allocation record */


	printk("XFS: xfs_dialloc:0001\n");
	if (*IO_agbp == NULL) {
		printk("XFS: xfs_dialloc:0002\n");
		/*
		 * We do not have an agbp, so select an initial allocation
		 * group for inode allocation.
		 */
		agbp = xfs_ialloc_ag_select(tp, parent, mode, okalloc);
		printk("XFS: xfs_dialloc:0003\n");
		/*
		 * Couldn't find an allocation group satisfying the
		 * criteria, give up.
		 */
		if (!agbp) {
			printk("XFS: xfs_dialloc:0004\n");
			*inop = NULLFSINO;
			return 0;
		}
		printk("XFS: xfs_dialloc:0005\n");
		agi = XFS_BUF_TO_AGI(agbp);
		ASSERT(be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC);
		printk("XFS: xfs_dialloc:0006\n");
	} else {
		printk("XFS: xfs_dialloc:0007\n");
		/*
		 * Continue where we left off before.  In this case, we
		 * know that the allocation group has free inodes.
		 */
		agbp = *IO_agbp;
		agi = XFS_BUF_TO_AGI(agbp);
		ASSERT(be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC);
		printk("XFS: xfs_dialloc:0008\n");
		ASSERT(be32_to_cpu(agi->agi_freecount) > 0);
		printk("XFS: xfs_dialloc:0009\n");
	}
	printk("XFS: xfs_dialloc:0010\n");
	mp = tp->t_mountp;
	agcount = mp->m_sb.sb_agcount;
	agno = be32_to_cpu(agi->agi_seqno);
	tagno = agno;
	pagno = XFS_INO_TO_AGNO(mp, parent);
	pagino = XFS_INO_TO_AGINO(mp, parent);

	/*
	 * If we have already hit the ceiling of inode blocks then clear
	 * okalloc so we scan all available agi structures for a free
	 * inode.
	 */

	if (mp->m_maxicount &&
	    mp->m_sb.sb_icount + XFS_IALLOC_INODES(mp) > mp->m_maxicount) {
		printk("XFS: xfs_dialloc:0011\n");
		noroom = 1;
		okalloc = 0;
	}

	/*
	 * Loop until we find an allocation group that either has free inodes
	 * or in which we can allocate some inodes.  Iterate through the
	 * allocation groups upward, wrapping at the end.
	 */
	printk("XFS: xfs_dialloc:0012\n");
	*alloc_done = B_FALSE;
	while (!agi->agi_freecount) {
		printk("XFS: xfs_dialloc:0013\n");
		/*
		 * Don't do anything if we're not supposed to allocate
		 * any blocks, just go on to the next ag.
		 */
		if (okalloc) {
			printk("XFS: xfs_dialloc:0014\n");
			/*
			 * Try to allocate some new inodes in the allocation
			 * group.
			 */
			if ((error = xfs_ialloc_ag_alloc(tp, agbp, &ialloced))) {
				printk("XFS: xfs_dialloc:0015\n");
				xfs_trans_brelse(tp, agbp);
				if (error == ENOSPC) {
					printk("XFS: xfs_dialloc:0016\n");
					*inop = NULLFSINO;
					return 0;
				} else {
					printk("XFS: xfs_dialloc:0017\n");
					return error;
				}
			}
			printk("XFS: xfs_dialloc:0018\n");
			if (ialloced) {
				/*
				 * We successfully allocated some inodes, return
				 * the current context to the caller so that it
				 * can commit the current transaction and call
				 * us again where we left off.
				 */
				printk("XFS: xfs_dialloc:0019\n");
				ASSERT(be32_to_cpu(agi->agi_freecount) > 0);
				*alloc_done = B_TRUE;
				*IO_agbp = agbp;
				*inop = NULLFSINO;
				return 0;
			}
		}
		printk("XFS: xfs_dialloc:0020\n");
		/*
		 * If it failed, give up on this ag.
		 */
		xfs_trans_brelse(tp, agbp);
		/*
		 * Go on to the next ag: get its ag header.
		 */
nextag:
		if (++tagno == agcount)
			tagno = 0;
		if (tagno == agno) {
			printk("XFS: xfs_dialloc:0021\n");
			*inop = NULLFSINO;
			return noroom ? ENOSPC : 0;
		}
		down_read(&mp->m_peraglock);
		if (mp->m_perag[tagno].pagi_inodeok == 0) {
			up_read(&mp->m_peraglock);
			printk("XFS: xfs_dialloc:0022\n");
			goto nextag;
		}
		error = xfs_ialloc_read_agi(mp, tp, tagno, &agbp);
		up_read(&mp->m_peraglock);
		if (error) {
			printk("XFS: xfs_dialloc:0023\n");
			goto nextag;
		}
		agi = XFS_BUF_TO_AGI(agbp);
		ASSERT(be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC);
	}
	/*
	 * Here with an allocation group that has a free inode.
	 * Reset agno since we may have chosen a new ag in the
	 * loop above.
	 */
	printk("XFS: xfs_dialloc:0024\n");
	agno = tagno;
	*IO_agbp = NULL;
	cur = xfs_btree_init_cursor(mp, tp, agbp, be32_to_cpu(agi->agi_seqno),
				    XFS_BTNUM_INO, (xfs_inode_t *)0, 0);

       ...


Christian
