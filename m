Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7MESKbx071533 for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 09:28:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4DBE71C0242D
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 07:28:19 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	NBp4Ci4rjO7DAsI1 for <xfs@oss.sgi.com>;
	Mon, 22 Aug 2011 07:28:19 -0700 (PDT)
Date: Mon, 22 Aug 2011 10:28:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] xfs: defer AIO/DIO completions
Message-ID: <20110822142819.GB24433@infradead.org>
References: <20110814222412.359079843@bombadil.infradead.org>
	<20110814222517.807217901@bombadil.infradead.org>
	<20110822064028.GL3162@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110822064028.GL3162@dastard>
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

On Mon, Aug 22, 2011 at 04:40:28PM +1000, Dave Chinner wrote:
> There's a 4 byte hole in the xfs_ioend structure where you could put
> a flags field to communicate this and not grow the structure....

I'll respin it using a separate field.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
