Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A26DB7F56
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2013 16:00:43 -0600 (CST)
Message-ID: <51196A0C.8080405@sgi.com>
Date: Mon, 11 Feb 2013 16:00:44 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs: limit speculative prealloc size on sparse files
References: <1360559102-20432-1-git-send-email-david@fromorbit.com>
	<1360559102-20432-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1360559102-20432-2-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 02/10/13 23:05, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Speculative preallocation based on the current file size works well
> for contiguous files, but is sub-optimal for sparse files where the
> EOF preallocation can fill holes and result in large amounts of
> zeros being written when it is not necessary.
>
> The algorithm is modified to prevent EOF speculative preallocation
> from triggering larger allocations on IO patterns of
> truncate--to-zero-seek-write-seek-write-....  which results in
> non-sparse files for large files. This, unfortunately, is the way cp
> now behaves when copying sparse files and so needs to be fixed.
>
> What this code does is that it looks at the existing extent adjacent
> to the current EOF and if it determines that it is a hole we disable
> speculative preallocation altogether. To avoid the next write from
> doing a large prealloc, it takes the size of subsequent
> preallocations from the current size of the existing EOF extent.
> IOWs, if you leave a hole in the file, it resets preallocation
> behaviour to the same as if it was a zero size file.
>
> Example new behaviour:
>
> $ xfs_io -f -c "pwrite 0 31m" \
>              -c "pwrite 33m 1m" \
>              -c "pwrite 128m 1m" \
>              -c "fiemap -v" /mnt/scratch/blah
> wrote 32505856/32505856 bytes at offset 0
> 31 MiB, 7936 ops; 0.0000 sec (1.608 GiB/sec and 421432.7439 ops/sec)
> wrote 1048576/1048576 bytes at offset 34603008
> 1 MiB, 256 ops; 0.0000 sec (1.462 GiB/sec and 383233.5329 ops/sec)
> wrote 1048576/1048576 bytes at offset 134217728
> 1 MiB, 256 ops; 0.0000 sec (1.719 GiB/sec and 450704.2254 ops/sec)
> /mnt/scratch/blah:
>   EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>     0: [0..65535]:      96..65631        65536   0x0
>     1: [65536..67583]:  hole              2048
>     2: [67584..69631]:  67680..69727      2048   0x0
>     3: [69632..262143]: hole             192512
>     4: [262144..264191]: 262240..264287    2048   0x1
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Works great. The above xfs_io example makes a good start of a test.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
