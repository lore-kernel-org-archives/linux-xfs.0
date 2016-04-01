Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8A2427CA2
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 21:44:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4C969304032
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 19:44:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Mo1s320MPi3ROne7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 31 Mar 2016 19:44:18 -0700 (PDT)
Date: Fri, 1 Apr 2016 13:44:13 +1100
From: Dave Chinner <dchinner@redhat.com>
Subject: Re: list_add corruption after "xfs: mode di_mode to vfs inode"
Message-ID: <20160401024413.GB2072@devil.localdomain>
References: <56FC9FA6.1080700@stratus.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56FC9FA6.1080700@stratus.com>
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
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 30, 2016 at 11:55:18PM -0400, Joe Lawrence wrote:
> Hi Dave,
> 
> Upon loading 4.6-rc1, I noticed a few linked list corruption messages in
> dmesg shortly after boot up.  I bisected the kernel, landing on:
> 
>   [c19b3b05ae440de50fffe2ac2a9b27392a7448e9] xfs: mode di_mode to vfs inode
> 
> If I revert c19b3b05ae44 from 4.6-rc1, the warnings stop.
> 
> WARNING: CPU: 35 PID: 6715 at lib/list_debug.c:29 __list_add+0x65/0xc0
> list_add corruption. next->prev should be prev (ffff882030928a00), but was ffff88103f00c300. (next=ffff88100fde5ce8).
.....
>  [<ffffffff812488f0>] ? bdev_test+0x20/0x20
>  [<ffffffff813551a5>] __list_add+0x65/0xc0
>  [<ffffffff81249bd8>] bd_acquire+0xc8/0xd0
>  [<ffffffff8124aa59>] blkdev_open+0x39/0x70
>  [<ffffffff8120bc27>] do_dentry_open+0x227/0x320
>  [<ffffffff8124aa20>] ? blkdev_get_by_dev+0x50/0x50
>  [<ffffffff8120d057>] vfs_open+0x57/0x60
>  [<ffffffff8121c9fa>] path_openat+0x1ba/0x1340
>  [<ffffffff8121eff1>] do_filp_open+0x91/0x100
>  [<ffffffff8122c806>] ? __alloc_fd+0x46/0x180
>  [<ffffffff8120d3b4>] do_sys_open+0x124/0x210
>  [<ffffffff8120d4be>] SyS_open+0x1e/0x20
>  [<ffffffff81003c12>] do_syscall_64+0x62/0x110
>  [<ffffffff8169ade1>] entry_SYSCALL64_slow_path+0x25/0x25
....
> According to the bd_acquire+0xc8 offset, we're in bd_acquire()
> attempting the list add:
....
>  713         bdev = bdget(inode->i_rdev);
>  714         if (bdev) {
>  715                 spin_lock(&bdev_lock);
>  716                 if (!inode->i_bdev) {
>  717                         /*
>  718                          * We take an additional reference to bd_inode,
>  719                          * and it's released in clear_inode() of inode.
>  720                          * So, we can access it via ->i_mapping always
>  721                          * without igrab().
>  722                          */
>  723                         bdgrab(bdev);
>  724                         inode->i_bdev = bdev;
>  725                         inode->i_mapping = bdev->bd_inode->i_mapping;
>  726                         list_add(&inode->i_devices, &bdev->bd_inodes);

So the bdev->bd_inodes list is corrupt, and this call trace is
just the messenger.

> crash> ps -a | grep mdadm
> ...
> PID: 6715   TASK: ffff882033ac2d40  CPU: 35  COMMAND: "mdadm"
> ARG: /sbin/mdadm --detail --export /var/opt/ft/osm/osm_temporary_md_device_node
> ...
> 
> I traced the proprietary-driver-dependent user program to figure out
> what it was doing and boiled that down to a repro that hits the same
> corruption when running *stock* 4.6-rc1.  (Note /tmp is hosted on an 
> XFS volume):
> 
> --
> 
> MD=/dev/md1
> LOOP_A=/dev/loop0
> LOOP_B=/dev/loop1
> TMP_A=/tmp/diska
> TMP_B=/tmp/diskb
> 
> echo
> echo Setting up ...
> 
> dd if=/dev/zero of=$TMP_A bs=1M count=200
> dd if=/dev/zero of=$TMP_B bs=1M count=200
> losetup $LOOP_A $TMP_A
> losetup $LOOP_B $TMP_B
> 
> mdadm --create $MD \
>         --metadata=1 \
>         --level=1 \
>         --raid-devices=2 \
>         --bitmap=internal \
>         $LOOP_A $LOOP_B
> 
> MAJOR=$(stat -c %t $MD)
> MINOR=$(stat -c %T $MD)
> 
> echo
> echo Testing major: $MAJOR minor: $MINOR ...
> 
> for i in {0..100}; do
>   mknod --mode=0600 /tmp/tmp_node b $MAJOR $MINOR
>   mdadm --detail --export /tmp/tmp_node
>   rm -f /tmp/tmp_node
> done
> 
> echo
> echo Cleanup ...
> 
> mdadm --stop $MD
> losetup -d $LOOP_A $LOOP_B
> rm -f $TMP_A $TMP_B
> 
> echo
> echo Done.
> 
> --
> 
> I'm not really sure why the bisect landed on c19b3b05ae44 "xfs: mode
> di_mode to vfs inode", but as I mentioned, reverting it made the list
> warnings go away.

Neither am I at this point as it's the bdev inode (not an xfs
inode) that has a corrupted list. I'll have to try to reproduce this.

Cheers,

Dave.
-- 
Dave Chinner
dchinner@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
