Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1B7257CBF
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 16:34:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9C96DAC001
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 14:34:33 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	21Y8AGjErJzAizfD for <xfs@oss.sgi.com>;
	Wed, 19 Jun 2013 14:34:31 -0700 (PDT)
Date: Thu, 20 Jun 2013 07:34:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/60] xfs: patch queue for 3.11
Message-ID: <20130619213417.GI29338@dastard>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<20130619091538.GA359@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130619091538.GA359@infradead.org>
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

On Wed, Jun 19, 2013 at 02:15:38AM -0700, Christoph Hellwig wrote:
> Hi Dave,
> 
> I like this version a lot better from a quick glance.
> 
> A few more comments:
> 
>  - do we really want all that many separate _format.h headers?
>    I'd be really tempted to say we have just a single xfs_format.h
>    header, which should declare everything.  It's still not all that
>    large, and it would be a really good start to ease our include mess.

I don't see any problem with doing that, though I would like to keep
some of it separate - the dir2 stuff is complex enough that I would
like to keep it separate, but stuff like all the log item format
headers can be aggregated.

How about we end up with xfs_log_format.h for the log and log item
formats, xfs_da_format.h for all the dir2/da/attr format definitions,
and xfs_format.h for everything else?

>  - xfs_extent_ops.c still has that odd _ops.c name I hate because it
>    tends to imply it's an implementation of some ops vector.  How about
>    xfs_alloc_util.c to go with the other _util name you added?

Yup, sounds reasonable. sed can sort that one out.

>  - any chance to reorder the inode.c split so that stuff doesn't get
>    move around multiple times?

I was waiting for that question - I have been considering doing that
but I've been putting it off because it is a fair bit of shuffling
that I'd have to do from scratch. Sounds like another vote for :redo
it"...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
