Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8F0677F3F
	for <xfs@oss.sgi.com>; Thu,  9 Jan 2014 09:27:20 -0600 (CST)
Received: from whiskey.americas.sgi.com (whiskey.americas.sgi.com
	[128.162.233.19])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F5A0AC004
	for <xfs@oss.sgi.com>; Thu,  9 Jan 2014 07:27:14 -0800 (PST)
Date: Thu, 9 Jan 2014 09:19:03 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: require 64-bit sector_t
Message-ID: <20140109151903.GF1935@sgi.com>
References: <20131114164603.GA13628@infradead.org>
	<20131216221559.GO1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131216221559.GO1935@sgi.com>
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

On Mon, Dec 16, 2013 at 04:15:59PM -0600, Ben Myers wrote:
> Hey Christoph,
> 
> On Thu, Nov 14, 2013 at 08:46:03AM -0800, Christoph Hellwig wrote:
> > Trying to support tiny disks only and saving a bit memory might have
> > made sense on an SGI O2 15 years ago, but is pretty pointless today.
> > 
> > Remove the rarely tested codepath that uses various smaller in-memory
> > types to reduce our test matrix and make the codebase a little bit
> > smaller and less complicated.
> > 
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> This looks ok to me.  I'm not seeing much downside to removing the smaller
> in-memory types.
> 
> Reviewed-by: Ben Myers <bpm@sgi.com>

Anyone else have an opinion on this one?  I think its 3.14 material and I'd
like to pull it in.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
