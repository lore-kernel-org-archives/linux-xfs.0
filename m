Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n13LkGnu095629 for <xfs@oss.sgi.com>; Tue, 3 Feb 2009 15:46:17 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E132E2340
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 13:45:36 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	6d6PLcGjHp8ZUHP4 for <xfs@oss.sgi.com>;
	Tue, 03 Feb 2009 13:45:36 -0800 (PST)
Date: Wed, 4 Feb 2009 08:42:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: reproducible xfs/vmap oops
Message-ID: <20090203214245.GJ24173@disturbed>
References: <20090201081224.GA22398@infradead.org>
	<20090201161458.GA5930@infradead.org>
	<20090203155147.GB21278@infradead.org>
	<200902040303.13933.nickpiggin@yahoo.com.au>
	<20090203160515.GA30986@infradead.org>
	<20090203184409.GA22204@infradead.org>
	<20090203210423.GA26628@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090203210423.GA26628@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, xfs@oss.sgi.com

On Tue, Feb 03, 2009 at 04:04:23PM -0500, Christoph Hellwig wrote:
> [ 3138.799436] XFS mounting filesystem vde
> [ 3138.813184] va->va_start = 4290777088, va->va_end = 4096
> [ 3138.834754] tmp->va_start = 4195352576, tmp->va_end = 4196401152
> [ 3138.846352] ------------[ cut here ]------------
> [ 3138.850332] kernel BUG at mm/vmalloc.c:298!
> [ 3138.850332] invalid opcode: 0000 [#1] SMP 
> 
> The first va_end looks suspicious to me..

That is on i386, Christoph? If so, I'd suspect a 32 bit overflow
as 4290777088 = 0xFFC01000 and va_start/va_end are unsigned longs.
If we tried to map exactly 4MB the with va_start at 0xFFC01000 we'd
end up with va_end at 0x100001000 which would wrap to 0x1000 = 4096.

Nick - this one is probably yours ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
