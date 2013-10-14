Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 09D997F6A
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 02:30:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EDD6E304039
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 00:30:48 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id dkADGzkvoI7TBJ88 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 14 Oct 2013 00:30:48 -0700 (PDT)
Date: Mon, 14 Oct 2013 00:30:47 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] xfs: simplify the fallocate path
Message-ID: <20131014073047.GB21013@infradead.org>
References: <20131012075503.370510641@bombadil.infradead.org>
	<20131012075640.467511096@bombadil.infradead.org>
	<20131014050424.GI4446@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131014050424.GI4446@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Oct 14, 2013 at 04:04:24PM +1100, Dave Chinner wrote:
> Seems a bit clunky to do all this work when we've got to repeat most
> of it when when we call xfs_setattr_size() if the size has changed.
> Any thoughts on how we might reduce to a single transaction?

I tried that, but the helper becomes a complete mess of flag values for the
possible inode modifications.  You also pointed this out the last time
around.  If anyone can come up with a saner helper than I tired feel
free to send a patch on top.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
