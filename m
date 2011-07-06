Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p668YTjB093796 for <xfs@oss.sgi.com>; Wed, 6 Jul 2011 03:34:29 -0500
Date: Wed, 6 Jul 2011 04:34:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 15/27] xfs: cleanup the defintion of struct
	xfs_dir2_sf_entry
Message-ID: <20110706083427.GC19861@infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094605.415405585@bombadil.infradead.org>
	<1309923211.3381.27.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1309923211.3381.27.camel@doink>
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

On Tue, Jul 05, 2011 at 10:33:31PM -0500, Alex Elder wrote:
> On Fri, 2011-07-01 at 05:43 -0400, Christoph Hellwig wrote:
> > Remove the inumber member which is at a variable offset after the actual
> > name, and make name a real variable sized C99 array instead of the incorrect
> > one-sized array which confuses (not only) gcc.  Based on this clean up
> > the helpers to calculate the entry size.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Why was the inode put after then name in the
> first place?

I've wondered that, too.  But it's been long before my time.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
