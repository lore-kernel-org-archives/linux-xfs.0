Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q471NAtY142307 for <xfs@oss.sgi.com>; Sun, 6 May 2012 20:23:10 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	txqLFm20GT5hqpQH for <xfs@oss.sgi.com>;
	Sun, 06 May 2012 18:23:07 -0700 (PDT)
Date: Mon, 7 May 2012 11:23:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: make 275 xfs specific.
Message-ID: <20120507012304.GV5091@dastard>
References: <1336230429-2939-1-git-send-email-tm@tao.ma>
	<20120505233744.GE25351@dastard> <4FA692B7.9040006@tao.ma>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FA692B7.9040006@tao.ma>
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
To: Tao Ma <tm@tao.ma>
Cc: xfs@oss.sgi.com

On Sun, May 06, 2012 at 11:03:19PM +0800, Tao Ma wrote:
> On 05/06/2012 07:37 AM, Dave Chinner wrote:
> > On Sat, May 05, 2012 at 11:07:09PM +0800, Tao Ma wrote:
> >> From: Tao Ma <boyu.mt@taobao.com>
> >>
> >> In my test with ext4, 275 can't pass because ext4
> >> can create a 8k file in the end not like what xfs
> >> does. So make this test case xfs only for now.
> > 
> > It's not an XFS specific test - it's a test that is supposed to test
> > POSIX write behaviour. i.e. if the filesystem is full, and then you
> > free 4k of space, then an 8k write should only be able to write 4k,
> > yes?
> Yes, but it doesn't work as expected for ext4.

It won't work as expected for many XFS configurations, too. e.g.
filesystem block size > 4k on 16/64k page machines, or if the
filesystem is configured with an inheritable extent size hint on the
root directory (XFS has been able to do per-file "bigalloc"
for years ;)

> > So doesn't a failure on ext4 indicate that there's something wrong
> > with ext4 (either it's ENOSPC detection or the short write
> > handling), not the test?
> Actually in my test, ext4 can create the file with 8K file size, not a
> short write. I haven't looked into it yet. But AFAICS, if we have an
> ext4 volume with 8k cluster size, a 4k file can occupy a 8k cluster and
> the final write of 8k will succeed instead of the short write.

IOws, you are testing with bigalloc?

Many tests make the assumption that allocation/extent size is the
same as the filesystem block size, and many more make the assumption
that the filesystem block size is always 4k. These tests generally
fail on differently configured filesystems, and so need massaging to
make work on these sorts of configs.

In this case, just make the write larger than the largest possible
allocation size (say 2MB), and fail the test if the write is
complete rather than short...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
