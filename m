Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q798UOX9141118 for <xfs@oss.sgi.com>; Thu, 9 Aug 2012 03:30:24 -0500
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id kJpBTFj1sbeC9kgs for
	<xfs@oss.sgi.com>; Thu, 09 Aug 2012 01:30:22 -0700 (PDT)
Received: from zmail19.collab.prod.int.phx2.redhat.com
	(zmail19.collab.prod.int.phx2.redhat.com [10.5.83.22])
	by mx3-phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q798ULQw018426
	for <xfs@oss.sgi.com>; Thu, 9 Aug 2012 04:30:22 -0400
Date: Thu, 9 Aug 2012 04:30:21 -0400 (EDT)
From: Tomas Racek <tracek@redhat.com>
Message-ID: <1855221844.724464.1344501021962.JavaMail.root@redhat.com>
In-Reply-To: <1664629800.716769.1344498186489.JavaMail.root@redhat.com>
Subject: xfstests: standard way of handling loop devices
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

Hi,

I am currently working on tests that check FITRIM implementation (251, 260 and one new I'm writing now) and I want to use loopback device as fallback if $SCRATCH_DEV doesn't support discard. Has anybody been working on some xfstests' standard way of creating/destroying loop devices?

I could do with something as simple as this (in common.rc):

_create_loop_device()
{
        size=${1}
        dev=`losetup -f`
        file="$TEST_DIR/$(basename $dev).fs"
        truncate -s $size $file || _fail "Cannot create image file $file"
        losetup $dev $file || _fail "Cannot associate $file with $dev"
        echo $dev
}

_destroy_loop_device()
{
        dev=${1}
        umount $dev 2>&1
        file=`losetup -a | grep $dev | sed -n "s/.*(\(.*\))$/\1/p"`
        losetup -d $dev && rm -f $file || _fail "Cannot destroy loop device"
}

Do you think it's sufficient or do you have different opinion on handling this?

Thanks for comments!

Tomas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
