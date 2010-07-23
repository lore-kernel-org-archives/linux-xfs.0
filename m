Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6N3tIhk178042 for <xfs@oss.sgi.com>; Thu, 22 Jul 2010 22:55:18 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 752FE46AD76
	for <xfs@oss.sgi.com>; Thu, 22 Jul 2010 20:58:19 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	FOT1MF7YCLOPsRrB for <xfs@oss.sgi.com>;
	Thu, 22 Jul 2010 20:58:19 -0700 (PDT)
Date: Fri, 23 Jul 2010 13:58:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 240: test non-aligned AIO hole-filling
Message-ID: <20100723035811.GE32635@dastard>
References: <4C489676.2000605@redhat.com> <20100723024938.GD32635@dastard>
	<4C490D4D.603@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C490D4D.603@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Thu, Jul 22, 2010 at 10:32:29PM -0500, Eric Sandeen wrote:
> Dave Chinner wrote:
> 
> > On Thu, Jul 22, 2010 at 02:05:26PM -0500, Eric Sandeen wrote:
> >   
> >> This replicates file corruption we've seen with qemu-kvm when
> >> we use if=virtio,cache=none,aio=native for IO to a sparse
> >> ext4- or xfs-hosted file, and the partitions/filesystems
> >> within that file image are not block-aligned.  (think sector
> >> 63 here...)  This results in AIO IOs not aligned to the
> >> filesystem blocks.
> >>
> >> This test modifies aiodio_sparse2.c to add an option to start
> >> the file IO at an offset.
> >>
> >> When we do 4k writes to a 16k file in 2 threads, starting
> >> at offset 512, we get 0s interspersed in the file where they
> >> should not be:
> >>
> >> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> >> *
> >> 00000200  01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01  |................|
> >> *
> >> 00001000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> >> *
> >> 00001200  01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01  |................|
> >> ....
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> >>     
> >
> > looks good - it needs to remove the $TEST_DIR/aiodio_sparse file
> > before the test starts, though, so that repeated tests fail
> > correctly. Otherwise:
> >
> >   
> hm, but:
> 
> +rm -f "$TEST_DIR/aiodio_sparse*"
> +
> +# 2 threads, 4k writes, 16k filesize, stride throug file by 4k, start at 512 offset
> +$here/src/aio-dio-regress/aiodio_sparse2 -i 2 -w 4k -s 16k -n 4k -o 512 "$TEST_DIR/aiodio_sparse"
> 
> It does remove it ... no?

Sorry, my bad - that went in one eye and out the other when I read
through the whole patch.

When i was testing I was getting a repeatable fail - pass - fail -
pass ... pattern occurring without any kernel patches applied, and
the test warns about removing the file after failure, so I just
connected the dots up in the obvious manner and got it completely
wrong....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
