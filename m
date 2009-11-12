Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nACAPHxC242180 for <xfs@oss.sgi.com>; Thu, 12 Nov 2009 04:25:17 -0600
Date: Thu, 12 Nov 2009 05:25:35 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/14] repair: switch block usage bitmap to a btree
Message-ID: <20091112102535.GA5154@infradead.org>
References: <20090902175841.875447973@bombadil.infradead.org>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE83ADFE@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ADFE@cf--amer001e--3.americas.sgi.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com

On Thu, Oct 22, 2009 at 11:22:42AM -0500, Alex Elder wrote:
> I have a few minor things I would like to see changed at some
> point, but nothing looks obviously incorrect so I'll wait and
> post a patch against this once it's committed.
> 
> Here are a couple other general thoughts:
> - One minor concern is that the btree code has cases in which
>   the peek routines don't work (when the keys_valid flag in the
>   btree root is zero) and this code doesn't check for that.
>   I'll just assume for now that never happens here.

It should not happen, but yes - making this explicit would be good.

> - The bitfield code used for the real-time volume map is
>   generally useful and could be separated into its own module.

Not sure.  It's really a crufty leftover.  It should probably also use
a btree instead, but I fear any effort spent on the RT subvolume is
pretty much wasted anyway.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
