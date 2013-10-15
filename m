Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2322F7F73
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 15:55:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BD7D5AC007
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 13:55:06 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	RrDBUnjZOyAHVWOK for <xfs@oss.sgi.com>;
	Tue, 15 Oct 2013 13:55:05 -0700 (PDT)
Date: Wed, 16 Oct 2013 07:54:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: syslinux xfs support
Message-ID: <20131015205434.GT4446@dastard>
References: <20131015203319.GA20191@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131015203319.GA20191@infradead.org>
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
Cc: pcacjr@zytor.com, xfs@oss.sgi.com

On Tue, Oct 15, 2013 at 01:33:19PM -0700, Christoph Hellwig wrote:
> Hi Paulo,
> 
> just wondering what the state of the xfs support for syslinux is?  I
> talked to Peter at Linuxcon and he thought it's merged, but looking at
> the kernel.org tree I can't find the support.
> 
> Also when looking over your branches I noticed that you're using a free
> sector in the first filesystem block to store the bootloader.  If we
> want to go down that route we need to make sure to reserve this sector,
> otherwise it might get taken up by newly added metadata.

It's also worth pointing out that there's no guarantee that there's
a free sector in the first filesystem block. It's only by luck that
there's free sectors on the default config (512 byte sector, 4
sector sized AG headers, 4k filesystem block). If we have <= 2k filesystem
block there are no free "pad" sectors that can be used, 4k sectors
mean no free sectors either, etc.

Much better would be to create a sector sized file and use fiemap to
get the disk address of the block and feed that into the
bootloader. That works for all filesystems without needing to know
anything about the underlying filesystem structures......

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
