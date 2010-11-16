Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAGD540B050328 for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 07:05:05 -0600
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 54C601C46572
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 05:06:35 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.171]) by cuda.sgi.com with ESMTP id
	SHTqd2ztKSs5IHPf for <xfs@oss.sgi.com>;
	Tue, 16 Nov 2010 05:06:35 -0800 (PST)
Message-ID: <4CE282DB.8060200@open-e.com>
Date: Tue, 16 Nov 2010 14:10:51 +0100
From: Piotr Kandziora <piotr.kandziora@open-e.com>
MIME-Version: 1.0
Subject: XFS: I/O Error Detected / 2.6.27.39
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Artur Piechocki <artur.piechocki@open-e.com>, Janusz Bak <jb@open-e.com>, lukasz.wittig@open-e.com

Hi,

Our environment is following:
- we have 24GB RAM,
- we are using 3ware controller (and it does not report any errors),
- we have one big logical volume (20TB) exported via NFS with large 
amount of small files (about 150k),
- we are doing periodically backup of this logical volume using rsync to 
another server.
- we have kernel 2.6.27.39,

Unfortunately our system is freezing unexpectedly without reason. We 
started investigating this problem and noticed that cache memory is 
slowly increasing.

We tried to dump this cache memory using:
/bin/echo "3" > /proc/sys/vm/drop_caches

In a result, cache was dumped, but in logs we noticed a lot of errors 
with XFS:

[kern.warning] kernel: xfs_iunlink_remove: xfs_inotobp()  returned an 
error 22 on dm-16.  Returning error.
[kern.notice] kernel: xfs_inactive:\011xfs_ifree() returned an error = 
22 on dm-16
[kern.notice] kernel: xfs_force_shutdown(dm-16,0x1) called from line 
1406 of file fs/xfs/xfs_vnodeops.c.  Return address = 0x
[kern.alert] kernel: Filesystem \"dm-16\": I/O Error Detected.  Shutting 
down filesystem: dm-16
[kern.alert] kernel: Please umount the filesystem, and rectify the 
problem(s)
[kern.warning] kernel: xfs_imap_to_bp: xfs_trans_read_buf()returned an 
error 5 on dm-16.  Returning error.
[kern.warning] kernel: xfs_imap_to_bp: xfs_trans_read_buf()returned an 
error 5 on dm-16.  Returning error.
[kern.warning] kernel: xfs_imap_to_bp: xfs_trans_read_buf()returned an 
error 5 on dm-16.  Returning error.

We are wondering if this is problem connected to hardware or rather this 
is XFS problem (if yes, was it fixed?).

Best regards
Piotr K

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
