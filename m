Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LKDUNU173299 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 15:13:30 -0500
Subject: Re: [PATCH 1/4] libxfs: handle read errors in libxfs_trans_read_buf
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110921194936.GA20400@infradead.org>
References: <20110920215917.508421839@bombadil.infradead.org>
	<20110920220030.204339904@bombadil.infradead.org>
	<1316630707.5872.13.camel@doink> <20110921194936.GA20400@infradead.org>
Date: Wed, 21 Sep 2011 15:13:26 -0500
Message-ID: <1316636006.5872.25.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2011-09-21 at 15:49 -0400, Christoph Hellwig wrote:
> On Wed, Sep 21, 2011 at 01:45:07PM -0500, Alex Elder wrote:
> > Probably wouldn't hurt to initialize b_fsprivate2 even
> > if the transaction pointer is null.  Looks good though.
> 
> It would - given that another transaction could be set in there.
> Fairly unlikely in userspace, but quite possible in the kernel.
> 

You're right.	-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
