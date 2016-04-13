Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5BFCF7CA4
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 12:16:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 90D90AC003
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 10:16:26 -0700 (PDT)
Received: from na01-bl2-obe.outbound.protection.outlook.com
	(mail-eopbgr640114.outbound.protection.outlook.com
	[40.107.64.114]) by cuda.sgi.com with ESMTP id 42WGfqFDw2AQpOoK
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 Apr 2016 10:16:23 -0700 (PDT)
Subject: Re: list_add corruption after "xfs: mode di_mode to vfs inode"
References: <56FC9FA6.1080700@stratus.com>
	<20160401024413.GB2072@devil.localdomain>
	<20160412075423.GG9088@dastard>
From: Joe Lawrence <joe.lawrence@stratus.com>
Message-ID: <570E7EE0.2020004@stratus.com>
Date: Wed, 13 Apr 2016 13:16:16 -0400
MIME-Version: 1.0
In-Reply-To: <20160412075423.GG9088@dastard>
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
To: xfs@oss.sgi.com, dchinner@redhat.com

On 04/12/2016 03:54 AM, Dave Chinner wrote:
> On Fri, Apr 01, 2016 at 01:44:13PM +1100, Dave Chinner wrote:
>> On Wed, Mar 30, 2016 at 11:55:18PM -0400, Joe Lawrence wrote:
>>> Hi Dave,
>>>
>>> Upon loading 4.6-rc1, I noticed a few linked list corruption messages in
>>> dmesg shortly after boot up.  I bisected the kernel, landing on:
>>>
>>>   [c19b3b05ae440de50fffe2ac2a9b27392a7448e9] xfs: mode di_mode to vfs inode
>>>
>>> If I revert c19b3b05ae44 from 4.6-rc1, the warnings stop.
>>>
>>> WARNING: CPU: 35 PID: 6715 at lib/list_debug.c:29 __list_add+0x65/0xc0
>>> list_add corruption. next->prev should be prev (ffff882030928a00), but was ffff88103f00c300. (next=ffff88100fde5ce8).
>> .....
>>>  [<ffffffff812488f0>] ? bdev_test+0x20/0x20
>>>  [<ffffffff813551a5>] __list_add+0x65/0xc0
>>>  [<ffffffff81249bd8>] bd_acquire+0xc8/0xd0
>>>  [<ffffffff8124aa59>] blkdev_open+0x39/0x70
>>>  [<ffffffff8120bc27>] do_dentry_open+0x227/0x320
>>>  [<ffffffff8124aa20>] ? blkdev_get_by_dev+0x50/0x50
>>>  [<ffffffff8120d057>] vfs_open+0x57/0x60
>>>  [<ffffffff8121c9fa>] path_openat+0x1ba/0x1340
>>>  [<ffffffff8121eff1>] do_filp_open+0x91/0x100
>>>  [<ffffffff8122c806>] ? __alloc_fd+0x46/0x180
>>>  [<ffffffff8120d3b4>] do_sys_open+0x124/0x210
>>>  [<ffffffff8120d4be>] SyS_open+0x1e/0x20
>>>  [<ffffffff81003c12>] do_syscall_64+0x62/0x110
>>>  [<ffffffff8169ade1>] entry_SYSCALL64_slow_path+0x25/0x25
>> ....
>>> According to the bd_acquire+0xc8 offset, we're in bd_acquire()
>>> attempting the list add:
>> ....
>>>  713         bdev = bdget(inode->i_rdev);
>>>  714         if (bdev) {
>>>  715                 spin_lock(&bdev_lock);
>>>  716                 if (!inode->i_bdev) {
>>>  717                         /*
>>>  718                          * We take an additional reference to bd_inode,
>>>  719                          * and it's released in clear_inode() of inode.
>>>  720                          * So, we can access it via ->i_mapping always
>>>  721                          * without igrab().
>>>  722                          */
>>>  723                         bdgrab(bdev);
>>>  724                         inode->i_bdev = bdev;
>>>  725                         inode->i_mapping = bdev->bd_inode->i_mapping;
>>>  726                         list_add(&inode->i_devices, &bdev->bd_inodes);
>>
>> So the bdev->bd_inodes list is corrupt, and this call trace is
>> just the messenger.
> ....
>>> I'm not really sure why the bisect landed on c19b3b05ae44 "xfs: mode
>>> di_mode to vfs inode", but as I mentioned, reverting it made the list
>>> warnings go away.
>>
>> Neither am I at this point as it's the bdev inode (not an xfs
>> inode) that has a corrupted list. I'll have to try to reproduce this.
> 
> Patch below should fix the problem. Smoke tested only at this point.

Thanks Dave, this looks good on both the QEMU and on the originating
hardware instances.

Let me know if there are any additional tests that I can run, otherwise
consider this Tested-by.

BTW, cuda.sgi.com is rejecting my mail to the list (even though I
subscribed), so apologies for this not making it out to xfs@oss.sgi.com.

Thanks again,

-- Joe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
