Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2EL5KHL258777 for <xfs@oss.sgi.com>; Wed, 14 Mar 2012 16:05:20 -0500
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id 6Bd58rzU1WdoyOxh for
	<xfs@oss.sgi.com>; Wed, 14 Mar 2012 14:05:19 -0700 (PDT)
Date: Wed, 14 Mar 2012 21:05:14 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: How to deal with XFS stripe geometry mismatch with hardware RAID5
Message-ID: <20120314210514.GA46448@nsrc.org>
References: <33498437.post@talk.nabble.com>
	<4F605877.2030304@hardwarefreak.com> <33504048.post@talk.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <33504048.post@talk.nabble.com>
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
To: troby <Thorn.Roby@harlandfs.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 14, 2012 at 10:43:44AM -0700, troby wrote:
> Mongo pre-allocates its datafiles and zero-fills them (there is a short
> header at the start of each, not rewritten as far as I know)  and then
> writes to them sequentially, wrapping around when it hits the end. In this
> case the entire load is inserts, no updates, hence the sequential writes.
> The data will not wrap around for about 6 months, at which time old files
> will be overwritten starting from the beginning. The BBU is functioning and
> the cache is set to write-back. The files are memory-mapped, I'll check
> whether fsync is used. Flushing is done about every 30 seconds and takes
> about 8 seconds.

How much data has been added to mongodb in those 30 seconds?

If everything really was being written sequentially then I reckon you could
write about 6.6GB in that time (11 disks x 75MB/sec x 8 seconds). From your
posting I suspect you are not achieving that level of performance :-)

If it really is being written sequentially to a continguous file then the
stripe alignment won't make any difference, because this is just a big
pre-allocated file, and XFS will do its best to give one big contiguous
chunk of space for it.

Anwyay, you don't need to guess these things, you can easily find out.

(1) Is the file preallocated and contiguous, or fragmented?

    # xfs_bmap /path/to/file

This will show you if you get one huge extent. If you get a number of large
extents (say 100MB+) that would be fine for performance too.  If you get
lots of shrapnel then there's a problem.

(2) Are you really writing sequentially?

    # btrace /dev/whatever | grep ' [DC] '

This will show you block requests dispatched [D] and completed [C] to the
controller.

And at a higher level:

    # strace -p <pid-of-mongodb-process>

will show you the seek/write/read operations that the application is
performing.

Once you have the answers to those, you can make a better judgement as to
what's happening.

(3) One other thing to check:

cat /sys/block/xxx/bdi/read_ahead_kb
cat /sys/block/xxx/queue/max_sectors_kb

Increasing those to 1024 (echo 1024 > ....) may make some improvement.

> One thing I'm wondering is whether the incorrect stripe structure I
> specified with mkfs is actually written into the file system structure

I am guessing that probably things like chunks of inodes are stripe-aligned. 
But if you're really writing sequentially to a huge contiguous file then it
won't matter anyway.

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
