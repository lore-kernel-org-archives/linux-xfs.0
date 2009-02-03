Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n13M8mj5096656 for <xfs@oss.sgi.com>; Tue, 3 Feb 2009 16:08:49 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E966FE2584
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 14:08:09 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id KPRVAqmjlmrfRowT for
	<xfs@oss.sgi.com>; Tue, 03 Feb 2009 14:08:09 -0800 (PST)
Date: Tue, 3 Feb 2009 17:08:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: reproducible xfs/vmap oops
Message-ID: <20090203220808.GA9195@infradead.org>
References: <20090201081224.GA22398@infradead.org>
	<20090201161458.GA5930@infradead.org>
	<20090203155147.GB21278@infradead.org>
	<200902040303.13933.nickpiggin@yahoo.com.au>
	<20090203160515.GA30986@infradead.org>
	<20090203184409.GA22204@infradead.org>
	<20090203210423.GA26628@infradead.org>
	<20090203214245.GJ24173@disturbed>
	<20090203214711.GA24837@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090203214711.GA24837@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Nick Piggin <nickpiggin@yahoo.com.au>, xfs@oss.sgi.com

On Tue, Feb 03, 2009 at 04:47:11PM -0500, Christoph Hellwig wrote:
> On Wed, Feb 04, 2009 at 08:42:45AM +1100, Dave Chinner wrote:
> > On Tue, Feb 03, 2009 at 04:04:23PM -0500, Christoph Hellwig wrote:
> > > [ 3138.799436] XFS mounting filesystem vde
> > > [ 3138.813184] va->va_start = 4290777088, va->va_end = 4096
> > > [ 3138.834754] tmp->va_start = 4195352576, tmp->va_end = 4196401152
> > > [ 3138.846352] ------------[ cut here ]------------
> > > [ 3138.850332] kernel BUG at mm/vmalloc.c:298!
> > > [ 3138.850332] invalid opcode: 0000 [#1] SMP 
> > > 
> > > The first va_end looks suspicious to me..
> > 
> > That is on i386, Christoph? If so, I'd suspect a 32 bit overflow
> > as 4290777088 = 0xFFC01000 and va_start/va_end are unsigned longs.
> > If we tried to map exactly 4MB the with va_start at 0xFFC01000 we'd
> > end up with va_end at 0x100001000 which would wrap to 0x1000 = 4096.
> 
> Yeah, this is 32-bit x86.  Exactly my thoughts, but just to make sure
> the overflow is in vmap and not in XFS I'm running with your checking
> patch included now.

Nope, your check doesn't trigger.  Looks like it's indeed in vmap.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
