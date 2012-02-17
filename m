Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HHmlKv100035 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 11:48:47 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Qn1x5fBjbXao4eR7 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Feb 2012 09:48:46 -0800 (PST)
Date: Fri, 17 Feb 2012 12:48:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/9] xfs: user per-cpu stats for the total dquot numbers
Message-ID: <20120217174845.GF21796@infradead.org>
References: <20120215022926.577682146@bombadil.infradead.org>
	<20120215023147.612027782@bombadil.infradead.org>
	<20120216000243.GQ14132@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120216000243.GQ14132@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Feb 16, 2012 at 11:02:43AM +1100, Dave Chinner wrote:
> > +	__uint32_t		xs_qm_dquots;
> > +	__uint32_t		xs_qm_dquots_unused;
> > +#define XQMSTAT_END_XQM		(XQMSTAT_END_XQMSTAT + 4)
> 
> Shouldn't that be (XQMSTAT_END_XQMSTAT + 2)?

Yes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
