Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBANesDV127147 for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 17:40:55 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 995B1DFAAB0
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 15:41:28 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	8pLKTx7tSRk82jSQ for <xfs@oss.sgi.com>;
	Thu, 10 Dec 2009 15:41:28 -0800 (PST)
Date: Fri, 11 Dec 2009 10:41:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] [XFS] Don't directly reference m_perag in
	allocation code
Message-ID: <20091210234124.GE30608@discord.disaster>
References: <1259734299-20306-1-git-send-email-david@fromorbit.com>
	<1259734299-20306-3-git-send-email-david@fromorbit.com>
	<20091210231856.GB6389@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091210231856.GB6389@infradead.org>
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
Cc: xfs@oss.sgi.com

On Thu, Dec 10, 2009 at 06:18:56PM -0500, Christoph Hellwig wrote:
> On Wed, Dec 02, 2009 at 05:11:35PM +1100, Dave Chinner wrote:
> > +		pag = xfs_perag_get(mp, agno);
> > +		pag->pagf_freeblks += len;
> > +		xfs_perag_put(pag);
> > +
> >  		agf = XFS_BUF_TO_AGF(agbp);
> > -		pag = &mp->m_perag[agno];
> >  		be32_add_cpu(&agf->agf_freeblks, len);
> >  		xfs_trans_agblocks_delta(tp, len);
> > -		pag->pagf_freeblks += len;
> 
> Currently not too deep into this code, but did you make sure moving the
> in-core addition before the logging of the transaction doesn't matter/

xfs_trans_agblocks_delta() is debug-only accounting, so moving the
perag update does not change anything. It's still changed inside
the AGF buffer lock, so should be correct.

> 
> > +		args->pag = xfs_perag_get(mp, args->agno);
> >  		down_read(&mp->m_peraglock);
> > -		args->pag = &mp->m_perag[args->agno];
> 
> This adds another place where we could hit the growfs race until your
> later patches go in.

Ah, will fix up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
