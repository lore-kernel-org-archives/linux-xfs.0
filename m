Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB60PKrj160700 for <xfs@oss.sgi.com>; Mon, 5 Dec 2011 18:25:21 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F3401565C2A
	for <xfs@oss.sgi.com>; Mon,  5 Dec 2011 16:25:18 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	uiNeHnAqd8LHo0Yh for <xfs@oss.sgi.com>;
	Mon, 05 Dec 2011 16:25:18 -0800 (PST)
Date: Tue, 6 Dec 2011 11:25:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/16] xfs: flatten the dquot lock ordering
Message-ID: <20111206002511.GC28326@dastard>
References: <20111128082722.604873274@bombadil.infradead.org>
	<20111128082837.808570926@bombadil.infradead.org>
	<20111205050428.GP7046@dastard>
	<20111205091121.GA22018@infradead.org>
	<20111205093437.GA28326@dastard>
	<20111205115021.GA21604@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111205115021.GA21604@infradead.org>
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

On Mon, Dec 05, 2011 at 06:50:21AM -0500, Christoph Hellwig wrote:
> On Mon, Dec 05, 2011 at 08:34:37PM +1100, Dave Chinner wrote:
> > Hmmmm. My unmodified tree just has the declaration without
> > initialisation, and I didn't find any place where the initialisation
> > was added in the preceding patches. I'll go back and have another
> > look.
> 
> It's actually in this patch:
> 
> @@ -489,8 +498,8 @@ xfs_qm_dqpurge_int(
>         struct xfs_quotainfo    *q = mp->m_quotainfo;
> 	struct xfs_dquot        *dqp, *n;
> 	uint                    dqtype;
> -       int                     nrecl;
> -       int                     nmisses;
> +       int			nmisses = 0;
> +       LIST_HEAD		(dispose_list);
> 

OK, so I'm blind. :/

Move along, nothing to see here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
