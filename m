Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5MMvNhu127123 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 17:57:24 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 954A6134C45E
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 15:57:21 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	JxJffGXQTqtLrDQD for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2011 15:57:21 -0700 (PDT)
Date: Thu, 23 Jun 2011 08:57:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Test Case:252 - Shows Wrong Output
Message-ID: <20110622225718.GU32466@dastard>
References: <BANLkTinBNa9ox+jDaorBoKdhoQQzTUA58A@mail.gmail.com>
	<BANLkTi=wHAxYuLE33AVsc2rp0eEm5GB40w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTi=wHAxYuLE33AVsc2rp0eEm5GB40w@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 22, 2011 at 04:18:52PM +0530, Amit Sahrawat wrote:
> Dear All,
> **
> *Test Case:13
> *        echo "  13. data -> unwritten -> data"
>         rm -f $testfile
>         $XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
>                 -c "$alloc_cmd 0 20k" \
>                 -c "pwrite 0k 8k" -c "fsync" \
>                 -c "pwrite 12k 8k" -c "fsync" \
>                 -c "$zero_cmd 4k 12k" \
>                 -c "$map_cmd -v" $testfile | $filter_cmd
>         [ $? -ne 0 ] && die_now
> 
> *After executing individual case like this:
> *testfile=/data/usb/sda3/252.testfile
> 
> echo "13. data -> unwritten -> data"
> rm -f $testfile
> xfs_io -f -c "truncate 20k" -c \
> "falloc 0 20k" -c "pwrite 0k 8k" -c "fsync" -c "pwrite 12k 8k" -c  \
> "fsync" -c "fpunch 4k 12k" -c "fiemap -v" $testfile | $filter_cmd
> 
> *Original Output(Taken from 252.out):
> *        13. data -> unwritten -> data
> 0: [0..7]: data
> 1: [8..31]: hole
> 2: [32..39]: data
> *Output in my case*
>   13. data -> unwritten -> data
> 0: [0..15]: data
> 1: [16..23]: unwritten
> 2: [24..39]: data

FWIW, it would be much easier for us to understand your problem if
you simply posted the output of a failing "check 252" (it's a diff
of the output vs the golden output!) rather than a bunch of strange
mangled script outputs from whatever wrapper you are using to run
xfstests that nobody but you understand.

Anyway, I'm pretty sure that 2.6.35.y doesn't support punching holes
via the fallocate operation and so this check in the test:

_require_xfs_io_falloc_punch

is probably not detecting that punch is not supported correctly.
Perhaps that is what you need to check first...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
