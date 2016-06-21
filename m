Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E736E7CA4
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 05:48:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B90AC304039
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 03:48:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HQ13buoEbFn4doAu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 21 Jun 2016 03:48:18 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 68569D2EC9
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 10:48:17 +0000 (UTC)
Received: from laptop.bfoster (dhcp-41-198.bos.redhat.com [10.18.41.198])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u5LAmF6h019730
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 06:48:17 -0400
Date: Tue, 21 Jun 2016 06:48:15 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs_check: process sparse inode chunks correctly
Message-ID: <20160621104815.GA3108@laptop.bfoster>
References: <1466441562-12317-1-git-send-email-bfoster@redhat.com>
	<1466441562-12317-3-git-send-email-bfoster@redhat.com>
	<20160621090153.GB28212@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160621090153.GB28212@redhat.com>
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

On Tue, Jun 21, 2016 at 11:01:53AM +0200, Carlos Maiolino wrote:
> On Mon, Jun 20, 2016 at 12:52:42PM -0400, Brian Foster wrote:
> > Update the inode btree scanning functions to process sparse inode chunks
> > correctly. For filesystems with sparse inode support enabled, process
> > each chunk a cluster at a time. Each cluster is checked against the
> > inobt record to determine if it is a hole and skipped if so.
> > 
> > Note that since xfs_check is deprecated in favor of xfs_repair,  this
> > adds the minimum support necessary to process sparse inode enabled
> > filesystems. In other words, this adds no sparse inode specific checks
> > or verifications. We only update the inobt scanning functions to extend
> > the existing level of verification to sparse inode enabled filesystems
> > (e.g., avoid incorrectly tracking sparse regions as inodes). Problems
> > or corruptions associated with sparse inode records must be detected and
> > recovered via xfs_repair.
> > 
> 
> Hi,
> 
> I'm not quite sure, but a while ago, I thought I've heard some rumors about
> deprecating xfs_check, is this true or something that my mind made up for some
> weird reason?
> 

I actually thought it already was. :) xfstests still runs check in
certain cases, however, and these patches just fix a regression.
Personally, I'd be fine with just dumping an "fs has sparse inodes, use
repair" message from xfs_check, but the basic sparse inode support had
already been added.

Brian

> 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  db/check.c | 143 +++++++++++++++++++++++++++++++++++++++++++------------------
> >  1 file changed, 102 insertions(+), 41 deletions(-)
> > 
> > diff --git a/db/check.c b/db/check.c
> > index 750ecc1..25146e5 100644
> > --- a/db/check.c
> > +++ b/db/check.c
> > @@ -4324,10 +4324,24 @@ scanfunc_ino(
> >  	int			i;
> >  	int			isfree;
> >  	int			j;
> > +	int			freecount;
> >  	int			nfree;
> >  	int			off;
> >  	xfs_inobt_ptr_t		*pp;
> >  	xfs_inobt_rec_t		*rp;
> > +	xfs_agblock_t		agbno;
> > +	xfs_agblock_t		end_agbno;
> > +	struct xfs_dinode	*dip;
> > +	int			blks_per_buf;
> > +	int			inodes_per_buf;
> > +	int			ioff;
> > +
> > +	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
> > +		blks_per_buf = xfs_icluster_size_fsb(mp);
> > +	else
> > +		blks_per_buf = mp->m_ialloc_blks;
> > +	inodes_per_buf = min(blks_per_buf << mp->m_sb.sb_inopblog,
> > +			     XFS_INODES_PER_CHUNK);
> >  
> >  	if (be32_to_cpu(block->bb_magic) != XFS_IBT_MAGIC &&
> >  	    be32_to_cpu(block->bb_magic) != XFS_IBT_CRC_MAGIC) {
> > @@ -4357,54 +4371,74 @@ scanfunc_ino(
> >  		rp = XFS_INOBT_REC_ADDR(mp, block, 1);
> >  		for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++) {
> >  			agino = be32_to_cpu(rp[i].ir_startino);
> > -			off = XFS_INO_TO_OFFSET(mp, agino);
> > +			agbno = XFS_AGINO_TO_AGBNO(mp, agino);
> > +			off = XFS_AGINO_TO_OFFSET(mp, agino);
> > +			end_agbno = agbno + mp->m_ialloc_blks;
> >  			if (off == 0) {
> >  				if ((sbversion & XFS_SB_VERSION_ALIGNBIT) &&
> >  				    mp->m_sb.sb_inoalignmt &&
> >  				    (XFS_INO_TO_AGBNO(mp, agino) %
> >  				     mp->m_sb.sb_inoalignmt))
> >  					sbversion &= ~XFS_SB_VERSION_ALIGNBIT;
> > -				set_dbmap(seqno, XFS_AGINO_TO_AGBNO(mp, agino),
> > -					(xfs_extlen_t)MAX(1,
> > -						XFS_INODES_PER_CHUNK >>
> > -						mp->m_sb.sb_inopblog),
> > -					DBM_INODE, seqno, bno);
> >  			}
> > -			icount += XFS_INODES_PER_CHUNK;
> > -			agicount += XFS_INODES_PER_CHUNK;
> > -			ifree += be32_to_cpu(rp[i].ir_u.f.ir_freecount);
> > -			agifreecount += be32_to_cpu(rp[i].ir_u.f.ir_freecount);
> > +
> >  			push_cur();
> > -			set_cur(&typtab[TYP_INODE],
> > -				XFS_AGB_TO_DADDR(mp, seqno,
> > -						 XFS_AGINO_TO_AGBNO(mp, agino)),
> > -				(int)XFS_FSB_TO_BB(mp, mp->m_ialloc_blks),
> > -				DB_RING_IGN, NULL);
> > -			if (iocur_top->data == NULL) {
> > -				if (!sflag)
> > -					dbprintf(_("can't read inode block "
> > -						 "%u/%u\n"),
> > -						seqno,
> > -						XFS_AGINO_TO_AGBNO(mp, agino));
> > -				error++;
> > -				pop_cur();
> > -				continue;
> > -			}
> > -			for (j = 0, nfree = 0; j < XFS_INODES_PER_CHUNK; j++) {
> > -				isfree = XFS_INOBT_IS_FREE_DISK(&rp[i], j);
> > -				if (isfree)
> > -					nfree++;
> > -				process_inode(agf, agino + j,
> > -					(xfs_dinode_t *)((char *)iocur_top->data + ((off + j) << mp->m_sb.sb_inodelog)),
> > -						isfree);
> > +
> > +			ioff = 0;
> > +			nfree = 0;
> > +			while (agbno < end_agbno &&
> > +			       ioff < XFS_INODES_PER_CHUNK) {
> > +				if (xfs_inobt_is_sparse_disk(&rp[i], ioff))
> > +					goto next_buf;
> > +
> > +				if (off < XFS_INODES_PER_CHUNK)
> > +					set_dbmap(seqno, agbno, blks_per_buf,
> > +						  DBM_INODE, seqno, bno);
> > +
> > +				icount += inodes_per_buf;
> > +				agicount += inodes_per_buf;
> > +
> > +				set_cur(&typtab[TYP_INODE],
> > +					XFS_AGB_TO_DADDR(mp, seqno, agbno),
> > +					XFS_FSB_TO_BB(mp, blks_per_buf),
> > +					DB_RING_IGN, NULL);
> > +				if (iocur_top->data == NULL) {
> > +					if (!sflag)
> > +						dbprintf(_("can't read inode block "
> > +							   "%u/%u\n"), seqno,
> > +							 agbno);
> > +					error++;
> > +					goto next_buf;
> > +				}
> > +
> > +				for (j = 0; j < inodes_per_buf; j++) {
> > +					isfree = XFS_INOBT_IS_FREE_DISK(&rp[i], ioff + j);
> > +					if (isfree)
> > +						nfree++;
> > +					dip = (xfs_dinode_t *)((char *)iocur_top->data +
> > +						((off + j) << mp->m_sb.sb_inodelog));
> > +					process_inode(agf, agino + ioff + j, dip, isfree);
> > +				}
> > +
> > +next_buf:
> > +				agbno += blks_per_buf;
> > +				ioff += inodes_per_buf;
> >  			}
> > -			if (nfree != be32_to_cpu(rp[i].ir_u.f.ir_freecount)) {
> > +
> > +			if (xfs_sb_version_hassparseinodes(&mp->m_sb))
> > +				freecount = rp[i].ir_u.sp.ir_freecount;
> > +			else
> > +				freecount = be32_to_cpu(rp[i].ir_u.f.ir_freecount);
> > +
> > +			ifree += freecount;
> > +			agifreecount += freecount;
> > +
> > +			if (nfree != freecount) {
> >  				if (!sflag)
> >  					dbprintf(_("ir_freecount/free mismatch, "
> >  						 "inode chunk %u/%u, freecount "
> >  						 "%d nfree %d\n"),
> > -						seqno, agino,
> > -						be32_to_cpu(rp[i].ir_u.f.ir_freecount), nfree);
> > +						seqno, agino, freecount, nfree);
> >  				error++;
> >  			}
> >  			pop_cur();
> > @@ -4439,6 +4473,18 @@ scanfunc_fino(
> >  	int			off;
> >  	xfs_inobt_ptr_t		*pp;
> >  	struct xfs_inobt_rec	*rp;
> > +	xfs_agblock_t		agbno;
> > +	xfs_agblock_t		end_agbno;
> > +	int			blks_per_buf;
> > +	int			inodes_per_buf;
> > +	int			ioff;
> > +
> > +	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
> > +		blks_per_buf = xfs_icluster_size_fsb(mp);
> > +	else
> > +		blks_per_buf = mp->m_ialloc_blks;
> > +	inodes_per_buf = min(blks_per_buf << mp->m_sb.sb_inopblog,
> > +			     XFS_INODES_PER_CHUNK);
> >  
> >  	if (be32_to_cpu(block->bb_magic) != XFS_FIBT_MAGIC &&
> >  	    be32_to_cpu(block->bb_magic) != XFS_FIBT_CRC_MAGIC) {
> > @@ -4468,19 +4514,34 @@ scanfunc_fino(
> >  		rp = XFS_INOBT_REC_ADDR(mp, block, 1);
> >  		for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++) {
> >  			agino = be32_to_cpu(rp[i].ir_startino);
> > -			off = XFS_INO_TO_OFFSET(mp, agino);
> > +			agbno = XFS_AGINO_TO_AGBNO(mp, agino);
> > +			off = XFS_AGINO_TO_OFFSET(mp, agino);
> > +			end_agbno = agbno + mp->m_ialloc_blks;
> >  			if (off == 0) {
> >  				if ((sbversion & XFS_SB_VERSION_ALIGNBIT) &&
> >  				    mp->m_sb.sb_inoalignmt &&
> >  				    (XFS_INO_TO_AGBNO(mp, agino) %
> >  				     mp->m_sb.sb_inoalignmt))
> >  					sbversion &= ~XFS_SB_VERSION_ALIGNBIT;
> > -				check_set_dbmap(seqno, XFS_AGINO_TO_AGBNO(mp, agino),
> > -					(xfs_extlen_t)MAX(1,
> > -						XFS_INODES_PER_CHUNK >>
> > -						mp->m_sb.sb_inopblog),
> > -					DBM_INODE, DBM_INODE, seqno, bno);
> >  			}
> > +
> > +			ioff = 0;
> > +			while (agbno < end_agbno &&
> > +			       ioff < XFS_INODES_PER_CHUNK) {
> > +				if (xfs_inobt_is_sparse_disk(&rp[i], ioff))
> > +					goto next_buf;
> > +
> > +                                check_set_dbmap(seqno, agbno,
> > +                                        (xfs_extlen_t)MAX(1,
> > +                                                inodes_per_buf >>
> > +                                                mp->m_sb.sb_inopblog),
> > +                                        DBM_INODE, DBM_INODE, seqno, bno);
> > +
> > +next_buf:
> > +				agbno += blks_per_buf;
> > +				ioff += inodes_per_buf;
> > +			}
> > +
> >  		}
> >  		return;
> >  	}
> > -- 
> > 2.5.5
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> -- 
> Carlos
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
