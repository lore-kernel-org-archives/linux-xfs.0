Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D654B29DFF
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 17:30:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4EB88AC002
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 15:30:45 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Ap4XbiiJQf5Bstwg for <xfs@oss.sgi.com>;
	Fri, 10 Apr 2015 15:30:42 -0700 (PDT)
Date: Sat, 11 Apr 2015 08:30:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfs: direct IO needs to use append ioends
Message-ID: <20150410223040.GN13731@dastard>
References: <1428673080-23052-1-git-send-email-david@fromorbit.com>
	<1428673080-23052-3-git-send-email-david@fromorbit.com>
	<20150410202147.GB2846@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150410202147.GB2846@laptop.bfoster>
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

On Fri, Apr 10, 2015 at 04:21:47PM -0400, Brian Foster wrote:
> On Fri, Apr 10, 2015 at 11:37:57PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now we have an ioend being passed unconditionally to the direct IO
> > write completion context, we can pass a preallocated transaction
> > handle for on-disk inode size updates that are run in completion.
> > 
> > At this point we really need to be passing the correct block range
> > that the IO spans through the ioend, so calculate the last block in
> > the mapping before we map the allocated range and use that instead
> > of the size desired by the direct IO.
> > 
> > This enables us to keep track of multiple get-blocks calls in the
> > same direct IO - the ioend will keep coming back to us, and we can
> > keep extending it's range as new allocations and mappings are done.
> > 
> > There are some new trace points added for debugging, and a small
> > hack to actually make the tracepoints work (enums in tracepoints
> > that use __print_symbolic don't work correctly) that should be fixed
> > in the 4.1 merge window. THis hack can be removed when the
> > tracepoint fix is upstream.
> > 
> > There are lots of comments explaining the intricacies of passing the
> > ioend and append transaction in the code; they are better placed in
> > the code because we're going to need them to understand why this
> > code does what it does in a few years time....
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> I still need to look at this one (and grok the dio code more)... but an
> initial question: is this multiple get_blocks() call aggregation a
> requirement for the append ioend mechanism or an optimization? If the
> latter, I think a separate patch is more appropriate...

Requirement. Direct Io is a twisty maze of passages loaded with
deadly traps. e.g. non AIO path:

->direct_IO
  alloc dio(off, len)
    loop until all IO issued {
      get_blocks
      dio->private = bh_result->b_private
      build bio
      dio->ref++
      submit bio
    }

  dio_await_completion(dio)
  dio_complete(dio)
    dio->ref--  => goes to zero
     dio->end_io(filp, off, len, dio->private)
       xfs_end_io_direct_write(... off, len, ioend)


So, essentially, for as many bios that are mapped and submitted for
the direct IO, there is only one end IO completion call for the
entire IO. The multiple mappings we make need to aggregate the state
of the entire IO, not just the single instance....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
