Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n09MQb3Y029077 for <xfs@oss.sgi.com>; Fri, 9 Jan 2009 16:26:37 -0600
Received: from yx-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CDEEF76DDD
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2009 14:26:36 -0800 (PST)
Received: from yx-out-1718.google.com (yx-out-1718.google.com [74.125.44.154])
	by cuda.sgi.com with ESMTP id QeQSvMYzEybisd39 for
	<xfs@oss.sgi.com>; Fri, 09 Jan 2009 14:26:36 -0800 (PST)
Received: by yx-out-1718.google.com with SMTP id 36so4007254yxh.32
	for <xfs@oss.sgi.com>; Fri, 09 Jan 2009 14:26:36 -0800 (PST)
Message-ID: <a4423d670901091418j5c7fdfb2oeba2f4640f8e29d0@mail.gmail.com>
Date: Sat, 10 Jan 2009 01:18:41 +0300
From: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: Re: [xfs-masters] 2.6.29-rc: kernel BUG at fs/xfs/support/debug.c:108
In-Reply-To: <a4423d670901091353s7ff12207gcb38eb093d77d401@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <20090109044121.GA31280@orion> <20090109053858.GP9448@disturbed>
	<a4423d670901091353s7ff12207gcb38eb093d77d401@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Dave Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com, kernel-testers@vger.kernel.org

2009/1/10 Alexander Beregalov <a.beregalov@gmail.com>:
> 2009/1/9 Dave Chinner <david@fromorbit.com>:
>> On Fri, Jan 09, 2009 at 07:41:21AM +0300, Alexander Beregalov wrote:
>> Looks like the same btree corruption problem as this:
>>
>> http://oss.sgi.com/archives/xfs/2009-01/msg00118.html
>>
>> We're working to find the cause right now, but I find it interesting
>> that you are running a CONFIG_XFS_DEBUG=y kernel and the first
>> point that something is found wrong is the same place that the
>> above non-debug case is detecting corruption.
>>
>> Can you reproduce it/have a reproducable test case?
> Yes, it is easy reproducible for me, it happens every time I run
> `rtorrent` during few minutes after boot.
> I will try to provide simpler testcase.
>

This time I get it during log replaing before mounting.

* Mounting local filesystems...
[  214.039447] XFS mounting filesystem sda3
[  214.190773] Ending clean XFS mount for filesystem: sda3
[  214.321525] XFS mounting filesystem sdb1
[  214.453029] Starting XFS recovery on filesystem: sdb1 (logdev: internal)
[  215.062964] Ending XFS recovery on filesystem: sdb1 (logdev: internal)
[  215.163358] Assertion failed: fs_is_ok, file: fs/xfs/xfs_btree.c, line: 3327
[  215.248223] ------------[ cut here ]------------
[  215.257815] kernel BUG at fs/xfs/support/debug.c:108!
[  215.257815] invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[  215.257815] last sysfs file: /sys/kernel/uevent_seqnum
[  215.257815] Modules linked in: i2c_nforce2
[  215.257815]
[  215.257815] Pid: 764, comm: async/1 Not tainted (2.6.28-08160-g7c51d57 #1)

It seems I need to downgrade the kernel to boot the machine.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
