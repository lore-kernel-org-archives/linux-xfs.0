Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8L7l72G125475 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 02:47:08 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 886BD16088EA
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 00:52:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UaIzr9FLzzogxDJd for
	<xfs@oss.sgi.com>; Wed, 21 Sep 2011 00:52:29 -0700 (PDT)
Date: Wed, 21 Sep 2011 09:46:59 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v2] xfs: fix possible overflow in xfs_ioc_trim()
In-Reply-To: <20110920171220.GA17204@infradead.org>
Message-ID: <alpine.LFD.2.00.1109210945130.3876@dhcp-27-109.brq.redhat.com>
References: <1315322977-22736-1-git-send-email-lczerner@redhat.com>
	<20110906153301.GA21675@infradead.org>
	<alpine.LFD.2.00.1109071200480.4579@dhcp-27-109.brq.redhat.com>
	<20110907112155.GA1017@infradead.org>
	<alpine.LFD.2.00.1109071333110.4579@dhcp-27-109.brq.redhat.com>
	<20110920171220.GA17204@infradead.org>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

On Tue, 20 Sep 2011, Christoph Hellwig wrote:

> > 
> > I am not sure what do you mean ? There already is a check when both
> > start and len are huge numbers. I am not sure if we can do more without
> > significantly complicating the test to cover various start, or len
> > numbers where can the fsblock->group_number overflow for various file
> > systems.
> 
> Add a testcase where start is a relatively small number (smaller than an
> AG/BG), but start + len is outside the fs.

Already done in the second version of the xfstests patch.

> 
> > @@ -145,7 +145,7 @@ xfs_ioc_trim(
> >  	struct request_queue	*q = mp->m_ddev_targp->bt_bdev->bd_disk->queue;
> >  	unsigned int		granularity = q->limits.discard_granularity;
> >  	struct fstrim_range	range;
> > +	xfs_fsblock_t		start, end, minlen;
> >  	xfs_agnumber_t		start_agno, end_agno, agno;
> >  	__uint64_t		blocks_trimmed = 0;
> >  	int			error, last_error = 0;
> > @@ -165,19 +165,21 @@ xfs_ioc_trim(
> >  	 * matter as trimming blocks is an advisory interface.
> >  	 */
> >  	start = XFS_B_TO_FSBT(mp, range.start);
> > +	end = start + XFS_B_TO_FSBT(mp, range.len) - 1;
> >  	minlen = XFS_B_TO_FSB(mp, max_t(u64, granularity, range.minlen));
> >  
> > +	if (start >= mp->m_sb.sb_dblocks)
> >  		return -XFS_ERROR(EINVAL);
> > +	start_agno = XFS_FSB_TO_AGNO(mp, start);
> >  
> > +	if (end >= mp->m_sb.sb_dblocks) {
> > +		end = mp->m_sb.sb_dblocks - 1;
> >  		end_agno = mp->m_sb.sb_agcount - 1;
> > +	} else
> > +		end_agno = XFS_FSB_TO_AGNO(mp, end);
> 
> I'd rather do something like:
> 
> 	if (start >= mp->m_sb.sb_dblocks)
>   		return -XFS_ERROR(EINVAL);
> 	if (end > mp->m_sb.sb_dblocks - 1)
> 		end = mp->m_sb.sb_dblocks - 1;
> 
> 
> 	start_agno = XFS_FSB_TO_AGNO(mp, start);
> 	end_agno = XFS_FSB_TO_AGNO(mp, end)
> 
> here.
> 
> Otherwise the patch looks fine.
> 

Thanks!
-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
