Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KHCMfA072151 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 12:12:23 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D89431C29DA8
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 10:12:21 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	iJNwEKG3HC7jDkhR for <xfs@oss.sgi.com>;
	Tue, 20 Sep 2011 10:12:21 -0700 (PDT)
Date: Tue, 20 Sep 2011 13:12:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: fix possible overflow in xfs_ioc_trim()
Message-ID: <20110920171220.GA17204@infradead.org>
References: <1315322977-22736-1-git-send-email-lczerner@redhat.com>
	<20110906153301.GA21675@infradead.org>
	<alpine.LFD.2.00.1109071200480.4579@dhcp-27-109.brq.redhat.com>
	<20110907112155.GA1017@infradead.org>
	<alpine.LFD.2.00.1109071333110.4579@dhcp-27-109.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1109071333110.4579@dhcp-27-109.brq.redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Sep 07, 2011 at 02:26:54PM +0200, Lukas Czerner wrote:
> I do not think that start + len can overflow since we are doing
> XFS_B_TO_FSBT() on it first. Am I missing something ?

They don't have to overflow, but they can easily be outside
the range of valid AGs.

> > Care to update the test case to cover these cases as well?
> > 
> 
> I am not sure what do you mean ? There already is a check when both
> start and len are huge numbers. I am not sure if we can do more without
> significantly complicating the test to cover various start, or len
> numbers where can the fsblock->group_number overflow for various file
> systems.

Add a testcase where start is a relatively small number (smaller than an
AG/BG), but start + len is outside the fs.

> @@ -145,7 +145,7 @@ xfs_ioc_trim(
>  	struct request_queue	*q = mp->m_ddev_targp->bt_bdev->bd_disk->queue;
>  	unsigned int		granularity = q->limits.discard_granularity;
>  	struct fstrim_range	range;
> +	xfs_fsblock_t		start, end, minlen;
>  	xfs_agnumber_t		start_agno, end_agno, agno;
>  	__uint64_t		blocks_trimmed = 0;
>  	int			error, last_error = 0;
> @@ -165,19 +165,21 @@ xfs_ioc_trim(
>  	 * matter as trimming blocks is an advisory interface.
>  	 */
>  	start = XFS_B_TO_FSBT(mp, range.start);
> +	end = start + XFS_B_TO_FSBT(mp, range.len) - 1;
>  	minlen = XFS_B_TO_FSB(mp, max_t(u64, granularity, range.minlen));
>  
> +	if (start >= mp->m_sb.sb_dblocks)
>  		return -XFS_ERROR(EINVAL);
> +	start_agno = XFS_FSB_TO_AGNO(mp, start);
>  
> +	if (end >= mp->m_sb.sb_dblocks) {
> +		end = mp->m_sb.sb_dblocks - 1;
>  		end_agno = mp->m_sb.sb_agcount - 1;
> +	} else
> +		end_agno = XFS_FSB_TO_AGNO(mp, end);

I'd rather do something like:

	if (start >= mp->m_sb.sb_dblocks)
  		return -XFS_ERROR(EINVAL);
	if (end > mp->m_sb.sb_dblocks - 1)
		end = mp->m_sb.sb_dblocks - 1;


	start_agno = XFS_FSB_TO_AGNO(mp, start);
	end_agno = XFS_FSB_TO_AGNO(mp, end)

here.

Otherwise the patch looks fine.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
