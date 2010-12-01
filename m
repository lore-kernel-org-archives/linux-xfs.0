Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB14gF50172500 for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 22:42:16 -0600
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 02CB91402E34
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 20:43:58 -0800 (PST)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	3VsSgiNYF55tPfXx for <xfs@oss.sgi.com>;
	Tue, 30 Nov 2010 20:43:58 -0800 (PST)
Received: by qyk11 with SMTP id 11so2216693qyk.5
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 20:43:58 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 1 Dec 2010 10:13:57 +0530
Message-ID: <AANLkTinsLNNbzDoTUpPsss6HL7YjPf3uZ9ivu5VDVpqz@mail.gmail.com>
Subject: issue with unmount of XFS partation
From: naveen yadav <yad.naveen@gmail.com>
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

Hi all,

I am running XFS 2.6.34  on ARM target, When i do USB plug and uplug
some 30~40 times i found that system show USB mounted, but there is no
USB,
The USB have two partation FAT and XFS, FAT on First and XFS on Second.
FAT got unmounted every time, but XFS does not,

/dev/sda2 on /dtv/usb/sda2 type xfs (rw,relatime,nouuid,attr2,noquota)
/dev/sdb2 on /dtv/usb/sdb2 type xfs (rw,relatime,nouuid,attr2,noquota)

If I do sync on Shell I got below error.

xfs_force_shutdown(sda2,0x1) called from line 1004 of file fs/xfs/linux-2.6/xfs_
buf.c.  Return address = 0x801c7aa8
xfs_force_shutdown(sdb2,0x1) called from line 1004 of file fs/xfs/linux-2.6/xfs_
buf.c.  Return address = 0x801c7aa8But If i do manual umount

and this message continues display

 Filesystem "sda2": xfs_log_force: error 5 returned.
Filesystem "sdb2": xfs_log_force: error 5 returned.
Filesystem "sda2": xfs_log_force: error 5 returned.
Filesystem "sdb2": xfs_log_force: error 5 returned.
Filesystem "sda2": xfs_log_force: error 5 returned.
Filesystem "sdb2": xfs_log_force: error 5 returned.
Filesystem "sda2": xfs_log_force: error 5 returned.
Filesystem "sdb2": xfs_log_force: error 5 returned.
Filesystem "sda2": xfs_log_force: error 5 returned.
Filesystem "sdb2": xfs_log_force: error 5 returned.
Filesystem "sda2": xfs_log_force: error 5 returned.
Filesystem "sdb2": xfs_log_force: error 5 returned.
Filesystem "sda2": xfs_log_force: error 5 returned.
Filesystem "sdb2": xfs_log_force: error 5 returned.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
