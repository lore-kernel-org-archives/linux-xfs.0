Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7024A7F72
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 12:52:56 -0600 (CST)
Date: Mon, 9 Dec 2013 12:52:56 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 04/11] xfs: add xfs_ilock_attr_map_shared
Message-ID: <20131209185256.GV1935@sgi.com>
References: <20131206203006.914776999@bombadil.infradead.org>
	<20131206203128.663030833@bombadil.infradead.org>
	<20131208223610.GE31386@dastard>
	<20131209181612.GA22183@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131209181612.GA22183@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Dec 09, 2013 at 10:16:12AM -0800, Christoph Hellwig wrote:
> On Mon, Dec 09, 2013 at 09:36:10AM +1100, Dave Chinner wrote:
> > > +			/*
> > > +			 * Even after flushing the inode, there can still be
> > > +			 * delalloc blocks on the inode beyond EOF due to
> > > +			 * speculative reallocation.  These are not removed
> > 
> > "speculative preallocation"
> 
> I just re-indented the comment, the wording is the original one.  Maybe
> we'll get a commit that cares enought to fix it on the fly..

Sure...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
