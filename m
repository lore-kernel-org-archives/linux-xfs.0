Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0CFC4Lc023850 for <xfs@oss.sgi.com>; Mon, 12 Jan 2009 09:12:06 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 467AD7E9B4
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2009 07:12:04 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id TNa8Hp2d1kl3zgoC for
	<xfs@oss.sgi.com>; Mon, 12 Jan 2009 07:12:04 -0800 (PST)
Date: Mon, 12 Jan 2009 10:11:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: spurious -ENOSPC on XFS
Message-ID: <20090112151133.GA24852@infradead.org>
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jan 12, 2009 at 06:14:36AM -0500, Mikulas Patocka wrote:
> Hi
> 
> I discovered a bug in XFS in delayed allocation.
> 
> When you take a small partition (52MB in my case) and copy many small 
> files on it (source code) that barely fits there, you get -ENOSPC. Then 
> sync the partition, some free space pops up, click "retry" in MC an the 
> copy continues. They you get again -ENOSPC, you must sync, click "retry" 
> and go on. And so on few times until the source code finally fits on the 
> XFS partition.
> 
> This misbehavior is apparently caused by delayed allocation, delayed 
> allocation does not exactly know how much space will be occupied by data, 
> so it makes some upper bound guess. Because free space count is only a 
> guess, not the actual data being consumed, XFS should not return -ENOSPC 
> on behalf of it. When the free space overflows, XFS should sync itself, 
> retry allocation and only return -ENOSPC if it fails the second time, 
> after the sync.

This looks a lot like: http://oss.sgi.com/bugzilla/show_bug.cgi?id=724
It's on my short-term todo list to turn the testcase in that entry
into a proper xfsqa testcase and followup on the investigation by
Dave and Eric.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
