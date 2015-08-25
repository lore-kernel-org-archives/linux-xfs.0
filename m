Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 90DD97F37
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 03:25:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2A41FAC005
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 01:25:27 -0700 (PDT)
Received: from mail.zbfmail.de (mail.zbfmail.de [176.9.84.12]) by cuda.sgi.com
	with ESMTP id Zlb3D7D4NxAxlrQb (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 01:25:21 -0700 (PDT)
Received: from mail.zbfmail.de (localhost [127.0.0.1])
	by mail.zbfmail.de (Postfix) with ESMTP id 494A26EE0EA
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 10:25:16 +0200 (CEST)
MIME-Version: 1.0
Date: Tue, 25 Aug 2015 10:25:16 +0200
From: Marko Weber|8000 <weber@zbfmail.de>
Subject: Cant mount xfs lvm. Experimental Features?
Message-ID: <8a6d5afa8829aec73d911f35815d7b92@zbfmail.de>
Reply-To: weber@zbfmail.de
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Xfs <xfs@oss.sgi.com>


Hello List, Hello Dave...


i try to mount on my backup server an Lvm Partition and get errors in 
stdout and log:




stdout:

mount: wrong fs type, bad option, bad superblock on 
/dev/mapper/VolGroup01-storage01,
        missing codepage or helper program, or other error

        In some cases useful info is found in syslog - try
        dmesg | tail or so.



/var/log/messages:

Aug 25 10:20:31 backupserver kernel: XFS (dm-2): Version 5 superblock 
detected. This kernel has EXPERIMENTAL support enabled!
Aug 25 10:20:31 backupserver kernel: Use of these features in this 
kernel is at your own risk!
Aug 25 10:20:31 backupserver kernel: XFS (dm-2): Superblock has unknown 
read-only compatible features (0x1) enabled.
Aug 25 10:20:31 backupserver kernel: XFS (dm-2): Attempted to mount 
read-only compatible filesystem read-write.
Aug 25 10:20:31 backupserver kernel: Filesystem can only be safely 
mounted read only.
Aug 25 10:20:31 backupserver kernel: XFS (dm-2): SB validate failed with 
error 22.



How do i solve this?
I dont remember to have activated any experimental features in kernel.


thanks,

marko




-- 
zbfmail - Mittendrin statt nur Datei!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
