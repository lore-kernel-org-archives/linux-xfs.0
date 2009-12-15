Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBF4kkgg203959 for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 22:46:46 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 3/3] xfs: event tracing support
Date: Mon, 14 Dec 2009 22:47:22 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A684E@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20091214231459.GA24262@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Mon, Dec 14, 2009 at 04:40:36PM -0600, Alex Elder wrote:
>> There is a problem with trace_xfs_bmap_insert().  It is
>> referenced once (in xfs_bmap_trace_exlist()), but never defined.
>> The reference does not match the prototype defined for the other bmap tracepoints either.
>> 
>> Rather than trying to figure out what you intended I thought I'd
>> give you a chance to offer a fix.  If you do, please just send me
>> an update of that portion of the code if possible.  Meanwhile
>> I've commented out that reference and am going to try to complete
>> my review of this patch shortly.
>> 
>> Details are in the excerpts below.  I didn't add any commentary,
>> I'm just calling attention to the code I'm referring to.
> 
> Yeah, that was some debug build that got missed in the last iteration of
> the patch.  Updated version below:

OK, this looks good.  Compared to the first time around, I gave
it a very cursory review.  But we'll get it in.

Signed-off-by: Alex Elder <aelder@sgi.com>

> Subject: xfs: event tracing support
> From: Christoph Hellwig <hch@lst.de>
> 
> Convert the old xfs tracing support that could only be used with the out
> of tree kdb and xfsidbg patches to use the generic event tracer.
> 
> To use it make sure CONFIG_EVENT_TRACING is enabled and then enable all
> xfs trace channels by:
> 
>    echo 1 > /sys/kernel/debug/tracing/events/xfs/enable
> 
> or alternatively enable single events by just doing the same in one
> event subdirectory, e.g.
> 
>    echo 1 > /sys/kernel/debug/tracing/events/xfs/xfs_ihold/enable
> 
> or set more complex filters, etc. In Documentation/trace/events.txt all

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
