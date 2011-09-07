Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p87A6du8147851 for <xfs@oss.sgi.com>; Wed, 7 Sep 2011 05:06:39 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C6381992C86
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2011 03:06:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8JrQBJm4w397WJpL for
	<xfs@oss.sgi.com>; Wed, 07 Sep 2011 03:06:38 -0700 (PDT)
Date: Wed, 7 Sep 2011 12:05:14 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v2] xfs: fix possible overflow in xfs_ioc_trim()
In-Reply-To: <20110906153301.GA21675@infradead.org>
Message-ID: <alpine.LFD.2.00.1109071200480.4579@dhcp-27-109.brq.redhat.com>
References: <1315322977-22736-1-git-send-email-lczerner@redhat.com>
	<20110906153301.GA21675@infradead.org>
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

On Tue, 6 Sep 2011, Christoph Hellwig wrote:

> On Tue, Sep 06, 2011 at 05:29:37PM +0200, Lukas Czerner wrote:
> > In xfs_ioc_trim it is possible that start+len might overflow. Fix it by
> > decrementing the len so that start+len equals to the file system size in
> > the worst case.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> > @@ -146,6 +146,7 @@ xfs_ioc_trim(
> >  	unsigned int		granularity = q->limits.discard_granularity;
> >  	struct fstrim_range	range;
> >  	xfs_fsblock_t		start, len, minlen;
> > +	xfs_fsblock_t		max_blks = mp->m_sb.sb_dblocks;
> >  	xfs_agnumber_t		start_agno, end_agno, agno;
> >  	__uint64_t		blocks_trimmed = 0;
> >  	int			error, last_error = 0;
> > @@ -171,7 +172,8 @@ xfs_ioc_trim(
> >  	start_agno = XFS_FSB_TO_AGNO(mp, start);
> >  	if (start_agno >= mp->m_sb.sb_agcount)
> >  		return -XFS_ERROR(EINVAL);
> > -
> > +	if (len > max_blks)
> > +		len = max_blks - start;
> 
> Is this really the correct check?
> 
> Shouldn't it be
> 
> 	if (start + len > max_blks)
> 		len = max_blks - start;
> 
> I'd also just use the mp->m_sb.sb_dblocks value directly instead
> of assigning it to a local variable.
> 

Agh, you're right. I am bit too hasty I guess. I thought that

if (start_agno >= mp->m_sb.sb_agcount)
	return -XFS_ERROR(EINVAL);

will cover us from the unreasonably big start, however if the file
system has really huge number of AGs than it will fail to prevent the
overflow, I am not sure if that is possible to happen, but what you
proposed is definitely better.

Thanks!
-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
