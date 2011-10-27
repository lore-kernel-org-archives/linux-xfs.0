Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9RGgYB1106221 for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 11:42:34 -0500
Date: Thu, 27 Oct 2011 12:42:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfs: replace i_pin_wait with a bit waitqueue
Message-ID: <20111027164229.GA18033@infradead.org>
References: <20111019182343.762985925@bombadil.infradead.org>
	<20111019182421.048260722@bombadil.infradead.org>
	<1319663253.5239.75.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1319663253.5239.75.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Oct 26, 2011 at 04:07:33PM -0500, Alex Elder wrote:
> > +	xfs_iunpin(ip);
> > +
> 
> This initially struck me as unsafe or something,
> assuming the inode was pinned.  But I was thinking
> of it more like an unlock request, which it is not.
> It's more like unplugging something so the inode
> will eventually get unpinned.  (Just thinking aloud
> here, nevermind me...)

After the next series I am about to post there will be just one caller of
xfs_iunpin left.  We can probably simply fold it at that point.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
