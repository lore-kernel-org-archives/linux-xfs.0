Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0RHYFiR062860 for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 11:34:16 -0600
Received: from can12.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EDAD81868B63
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 09:33:33 -0800 (PST)
Received: from can12.de (can12.de [213.203.199.141]) by cuda.sgi.com with
	ESMTP id QfCd8slzDqqKA23G for <xfs@oss.sgi.com>;
	Tue, 27 Jan 2009 09:33:33 -0800 (PST)
Received: from [192.168.0.3] (p54AAD276.dip.t-dialin.net [84.170.210.118])
	by can12.de (can12.de) with ESMTP id 6C6B42B4CCA
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2009 18:33:33 +0100 (CET)
Message-Id: <A22069E0-B39A-41CF-9467-4524055B1970@hal-9k.de>
From: Julian Einwag <julian@hal-9k.de>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: XFS trouble: task xfssyncd blocked for more than 120 seconds. 
Date: Tue, 27 Jan 2009 18:33:29 +0100
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

we're currently using XFS on our POP/IMAP server for storage of the  
user's mailboxes (Linux kernel version 2.6.27.10, x86_64).
Howevere, we're experencing some seemingly random filesystem lockups  
during which the filesystem can still be read, but not written. The  
following error messages show in in the system logs:

Jan 27 17:03:01 postman-64b kernel: "echo 0 > /proc/sys/kernel/ 
hung_task_timeout_secs" disables this message.
Jan 27 17:03:01 postman-64b kernel: xfssyncd      D  
0000000100921c06     0  3090      2
Jan 27 17:03:01 postman-64b kernel:  ffff88067b1cbd70 0000000000000046  
0000000000000000 0000000000000001
Jan 27 17:03:01 postman-64b kernel:  ffff88067a6124c0 ffff88067cc7c980  
ffff88067a612718 00000002a8421200
Jan 27 17:03:01 postman-64b kernel:  00000000fffffffd 0000000000001000  
0000000000000000 0000000000000001
Jan 27 17:03:01 postman-64b kernel: Call Trace:
Jan 27 17:03:01 postman-64b kernel:  [<ffffffff8041d432>]  
schedule_timeout+0x1e/0xad
Jan 27 17:03:01 postman-64b kernel:  [<ffffffffa01ce88e>]  
xfs_buf_iorequest+0x5d/0x61 [xfs]
Jan 27 17:03:01 postman-64b kernel:  [<ffffffffa01d2352>]  
xfs_bdstrat_cb+0x36/0x3a [xfs]
Jan 27 17:03:01 postman-64b kernel:  [<ffffffff8041c9e4>]  
wait_for_common+0xc8/0x132
Jan 27 17:03:01 postman-64b kernel:  [<ffffffff8022b373>]  
default_wake_function+0x0/0xe
Jan 27 17:03:01 postman-64b kernel:  [<ffffffffa01c70ba>]  
xfs_finish_reclaim+0x110/0x13b [xfs]
Jan 27 17:03:01 postman-64b kernel:  [<ffffffffa01c7169>]  
xfs_finish_reclaim_all+0x84/0xc9 [xfs]
Jan 27 17:03:01 postman-64b kernel:  [<ffffffffa01c634b>] xfs_syncsub 
+0x4c/0x226 [xfs]
Jan 27 17:03:01 postman-64b kernel:  [<ffffffffa01d3d54>]  
xfs_sync_worker+0x17/0x36 [xfs]
Jan 27 17:03:01 postman-64b kernel:  [<ffffffffa01d4cb3>] xfssyncd 
+0x133/0x182 [xfs]
Jan 27 17:03:01 postman-64b kernel:  [<ffffffffa01d4b80>] xfssyncd 
+0x0/0x182 [xfs]
Jan 27 17:03:01 postman-64b kernel:  [<ffffffff80244a68>] kthread 
+0x47/0x73
Jan 27 17:03:01 postman-64b kernel:  [<ffffffff8022f77f>] schedule_tail 
+0x27/0x5f
Jan 27 17:03:01 postman-64b kernel:  [<ffffffff8020ccf9>] child_rip 
+0xa/0x11
Jan 27 17:03:01 postman-64b kernel:  [<ffffffff802f9395>]  
generic_unplug_device+0x0/0x2d
Jan 27 17:03:01 postman-64b kernel:  [<ffffffff80244a21>] kthread 
+0x0/0x73
Jan 27 17:03:01 postman-64b kernel:  [<ffffffff8020ccef>] child_rip 
+0x0/0x11

Only rebooting helps.

The filesystem is hosted on a hardware-based RAID5 array.

We're currently out of ideas on what might be causing this, so any  
hints would be greately appreciated.

Best regards,
Julian Einwag

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
