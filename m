Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q64FGrK1224075 for <xfs@oss.sgi.com>; Wed, 4 Jul 2012 10:16:53 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Ap4y6py0gbxNf66U (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Jul 2012 08:16:52 -0700 (PDT)
Date: Wed, 4 Jul 2012 11:16:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: do not call xfs_bdstrat_cb in
	xfs_buf_iodone_callbacks
Message-ID: <20120704151650.GB25762@infradead.org>
References: <20120702100003.960640484@bombadil.infradead.org>
	<20120702100034.921366796@bombadil.infradead.org>
	<20120703002857.GY19223@dastard>
	<20120703160531.GA855@infradead.org>
	<20120703232923.GC19223@dastard>
	<20120704055723.GB27500@infradead.org>
	<20120704083234.GG19223@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120704083234.GG19223@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jul 04, 2012 at 06:32:34PM +1000, Dave Chinner wrote:
> IMO, using uncached buffers in transactions is dangerous because
> concurrent transactions can't find buffers uncached buffers at the
> same address and so such buffers need higher level synchronisation
> interfaces (as the superblock has).
> 
> I'm happy to leave the superblock as uncached and work around it in
> some way, but it just seems wrong to me to have one buffer behaves
> differently to all the cached and other uncached buffers in the
> system. It doesn't sit well in my mind to do that when the problem
> simply goes away if we make the superblock a cached buffer again....

The superblock buffer always has been more special than others, remember
the old FS_MANAGED flag before we went for uncached buffers?

If you want to move it back to normal buffers how do you want to look
it up, given that IIRC we read it before setting up the perag buffers.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
