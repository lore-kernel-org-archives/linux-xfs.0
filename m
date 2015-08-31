Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DE1707F47
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 13:56:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BF0418F804B
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 11:56:15 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id HXqF4LA8wMHXlda0 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 31 Aug 2015 11:56:14 -0700 (PDT)
Date: Mon, 31 Aug 2015 11:56:12 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] xfs: Introduce writeback context for writepages
Message-ID: <20150831185612.GB349@infradead.org>
References: <1440479153-1584-1-git-send-email-david@fromorbit.com>
	<1440479153-1584-3-git-send-email-david@fromorbit.com>
	<20150831180221.GA16371@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150831180221.GA16371@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 31, 2015 at 02:02:22PM -0400, Brian Foster wrote:
> Ok, but the comment for blk_start_plug() mentions some kind of flush on
> task sleep mechanism. I could be wrong, but I take this to mean there
> are cases where I/O can initiate before the plug is stopped. Does
> deferring the I/O submission across writepages defeat that heuristic in
> any way? My (preliminary) understanding is that while the I/O submission
> would still be deferred by the plug in the same way in most cases, we're
> potentially holding back I/Os from the block infrastructure until the
> entire writepages sequence is complete.

Yes, we do.  But the reason why the block layer needs to flush the
plug on context switch is because we only have a limited bio mempool,
and if processes that are not running consume that we can't make
guaranteed progress.  The XFS writeback code doesn't allocate bios
until the end we are not affected by that particular issues, although
we still need to worry about our own ioend mempools.

Sidenote:  Jens now has the arbitrarily sized bio code in his queue
for 4.3.  With that we could replace our ioends with bios that have
a little private data and simplify the submission phase of the
writeback code significantly.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
