Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q79MV5h5233960 for <xfs@oss.sgi.com>; Thu, 9 Aug 2012 17:31:05 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	KIMMd3JUAC18qnTB for <xfs@oss.sgi.com>;
	Thu, 09 Aug 2012 15:31:03 -0700 (PDT)
Date: Fri, 10 Aug 2012 08:31:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests: standard way of handling loop devices
Message-ID: <20120809223100.GX2877@dastard>
References: <1664629800.716769.1344498186489.JavaMail.root@redhat.com>
	<1855221844.724464.1344501021962.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1855221844.724464.1344501021962.JavaMail.root@redhat.com>
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
To: Tomas Racek <tracek@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 09, 2012 at 04:30:21AM -0400, Tomas Racek wrote:
> Hi,
> 
> I am currently working on tests that check FITRIM implementation (251, 260 and one new I'm writing now) and I want to use loopback device as fallback if $SCRATCH_DEV doesn't support discard. Has anybody been working on some xfstests' standard way of creating/destroying loop devices?
> 
> I could do with something as simple as this (in common.rc):

Probably a good idea given the random failures we get with loopback
device unmounting due to the racy unmount-based automatic device
destruction.

> 
> _create_loop_device()
> {
>         size=${1}
>         dev=`losetup -f`
>         file="$TEST_DIR/$(basename $dev).fs"

That won't work - we create loop devices with files on the scratch
device, too, and some tests create more than one. This is also racy
in that two threads could both get then same next free loopback
device, but I'm not sure we care about that case very much.

>         truncate -s $size $file || _fail "Cannot create image file $file"

It's better to use xfs_io that introduce new external tool
dependencies.

>         losetup $dev $file || _fail "Cannot associate $file with $dev"
>         echo $dev
> }
> 
> _destroy_loop_device()
> {
>         dev=${1}
>         umount $dev 2>&1

If unmount fails, what then?

>         file=`losetup -a | grep $dev | sed -n "s/.*(\(.*\))$/\1/p"`
>         losetup -d $dev && rm -f $file || _fail "Cannot destroy loop device"

And if unmount destroys the loop device automatically? That will fail
the test, right?

Also, what happens if we unmount the filesystem first so we can run
consistency checks on the image before we destroy it?

I'd suggest that it is the test's responsibility to create, mount,
unmount, check and destroy the image file as those vary from test to
test. Hence a better idea is to just use an image path/device API.
i.e:

_create_loop_device()
{
	file=$1
        dev=`losetup -f`
        losetup $dev $file || _fail "Cannot associate $file with $dev"
        echo $dev
}

_destroy_loop_device()
{
	dev=$1
	losetup -d $dev || _fail "Cannot destroy loop device"
}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
