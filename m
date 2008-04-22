Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Apr 2008 08:42:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3MFg6ae024379
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 08:42:08 -0700
Received: from rv-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 195B615B1B4B
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 08:42:46 -0700 (PDT)
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.238]) by cuda.sgi.com with ESMTP id dP9YAuCKYRraRlqY for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 08:42:46 -0700 (PDT)
Received: by rv-out-0506.google.com with SMTP id g37so1054884rvb.32
        for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 08:42:46 -0700 (PDT)
Message-ID: <1d3e8bf0804220842r26411f51vc714da371255aa90@mail.gmail.com>
Date: Tue, 22 Apr 2008 15:42:45 +0000
From: "Dovydas Sankauskas" <laisve@gmail.com>
Subject: disk I/O error
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi.

I have an external USB HDD, which I wanted to use as a temporary
storage for my personal data while I clean up my local hdd. And while
moving files from local hdd to external hdd, it stopped responding. I
tried xfs_repair, but no luck.

Any insight on what has happened and what are my chances to restore
data? Here are my logs.

# xfs_repair /dev/sdb1
        - creating 2 worker thread(s)
Phase 1 - find and verify superblock...
superblock read failed, offset 0, size 524288, ag 0, rval -1

fatal error -- Input/output error


# xfs_check /dev/sdb1
xfs_check: read failed: Input/output error
Segmentation fault


# uname -a
Linux pasaka 2.6.22-14-generic #1 SMP Sun Oct 14 23:05:12 GMT 2007
i686 GNU/Linux


relevant /var/log/syslog

Dec  7 11:51:38 localhost kernel: [1784909.352000] usb 4-1: USB
disconnect, address 15
Dec  7 11:51:38 localhost kernel: [1784909.352000] sd 12:0:0:0: [sdb]
Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Dec  7 11:51:38 localhost kernel: [1784909.352000] end_request: I/O
error, dev sdb, sector 118489959
Dec  7 11:51:38 localhost kernel: [1784909.352000]
xfs_force_shutdown(sdb1,0x1) called from line 423 of file
/build/buildd/linux-source-2.6.22-2.6.22/fs/xfs/xfs_rw.c.  Return
address = 0xf8cc2c7c
Dec  7 11:51:38 localhost kernel: [1784909.352000] Filesystem "sdb1":
I/O Error Detected.  Shutting down filesystem: sdb1
Dec  7 11:51:38 localhost kernel: [1784909.352000] Please umount the
filesystem, and rectify the problem(s)
Dec  7 11:51:38 localhost kernel: [1784909.352000]
xfs_force_shutdown(sdb1,0x1) called from line 423 of file
/build/buildd/linux-source-2.6.22-2.6.22/fs/xfs/xfs_rw.c.  Return
address = 0xf8cc2c7c
Dec  7 11:51:38 localhost kernel: [1784909.424000] I/O error in
filesystem ("sdb1") meta-data dev sdb1 block 0x7100328
("xfs_trans_read_buf") error 5 buf count 8192
Dec  7 15:37:02 localhost kernel: [1798432.984000] scsi17 : SCSI
emulation for USB Mass Storage devices
Dec  7 15:37:02 localhost kernel: [1798432.984000] usb-storage: device
found at 20
Dec  7 15:37:02 localhost kernel: [1798432.984000] usb-storage:
waiting for device to settle before scanning
Dec  7 15:37:07 localhost kernel: [1798437.984000] usb-storage: device
scan complete
Dec  7 15:37:07 localhost kernel: [1798437.988000] scsi 17:0:0:0:
Direct-Access     Maxtor 6 L300R0           0811 PQ: 0 ANSI: 0
Dec  7 15:37:07 localhost kernel: [1798437.992000] sd 17:0:0:0: [sdb]
586114704 512-byte hardware sectors (300091 MB)
Dec  7 15:37:07 localhost kernel: [1798437.992000] sd 17:0:0:0: [sdb]
Test WP failed, assume Write Enabled
Dec  7 15:37:07 localhost kernel: [1798437.992000] sd 17:0:0:0: [sdb]
Assuming drive cache: write through
Dec  7 15:37:07 localhost kernel: [1798437.992000] sd 17:0:0:0: [sdb]
586114704 512-byte hardware sectors (300091 MB)
Dec  7 15:37:07 localhost kernel: [1798437.996000] sd 17:0:0:0: [sdb]
Test WP failed, assume Write Enabled
Dec  7 15:37:07 localhost kernel: [1798437.996000] sd 17:0:0:0: [sdb]
Assuming drive cache: write through
Dec  7 15:37:07 localhost kernel: [1798437.996000]  sdb: sdb1
Dec  7 15:37:07 localhost kernel: [1798438.012000] sd 17:0:0:0: [sdb]
Attached SCSI disk
Dec  7 15:37:07 localhost kernel: [1798438.012000] sd 17:0:0:0:
Attached scsi generic sg2 type 0
Dec  7 15:37:18 localhost kernel: [1798448.764000] sd 17:0:0:0: [sdb]
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Dec  7 15:37:18 localhost kernel: [1798448.764000] sd 17:0:0:0: [sdb]
Sense Key : Hardware Error [current]
Dec  7 15:37:18 localhost kernel: [1798448.764000] sd 17:0:0:0: [sdb]
Add. Sense: Data phase error
Dec  7 15:37:18 localhost kernel: [1798448.764000] end_request: I/O
error, dev sdb, sector 112
Dec  7 15:37:18 localhost kernel: [1798448.764000] Buffer I/O error on
device sdb, logical block 14
Dec  7 15:37:18 localhost kernel: [1798448.764000] Buffer I/O error on
device sdb, logical block 15
Dec  7 15:37:18 localhost kernel: [1798448.764000] Buffer I/O error on
device sdb, logical block 16
Dec  7 15:37:26 localhost kernel: [1798456.976000] XFS mounting filesystem sdb1
Dec  7 15:37:26 localhost kernel: [1798457.220000] Starting XFS
recovery on filesystem: sdb1 (logdev: internal)
Dec  7 15:37:38 localhost kernel: [1798469.300000] sd 17:0:0:0: [sdb]
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Dec  7 15:37:38 localhost kernel: [1798469.300000] sd 17:0:0:0: [sdb]
Sense Key : Hardware Error [current]
Dec  7 15:37:38 localhost kernel: [1798469.300000] sd 17:0:0:0: [sdb]
Add. Sense: Data phase error
Dec  7 15:37:38 localhost kernel: [1798469.300000] end_request: I/O
error, dev sdb, sector 127
Dec  7 15:37:38 localhost kernel: [1798469.304000] I/O error in
filesystem ("sdb1") meta-data dev sdb1 block 0x40
("xfs_trans_read_buf") error 5 buf count 8192
Dec  7 15:37:38 localhost kernel: [1798469.304000] XFS: failed to read
root inode


relevant /var/log/messages

Dec  7 15:37:02 localhost kernel: [1798432.852000] usb 4-1: new high
speed USB device using ehci_hcd and address 20
Dec  7 15:37:02 localhost kernel: [1798432.984000] usb 4-1:
configuration #1 chosen from 1 choice
Dec  7 15:37:02 localhost kernel: [1798432.984000] scsi17 : SCSI
emulation for USB Mass Storage devices
Dec  7 15:37:07 localhost kernel: [1798437.988000] scsi 17:0:0:0:
Direct-Access     Maxtor 6 L300R0           0811 PQ: 0 ANSI: 0
Dec  7 15:37:07 localhost kernel: [1798437.992000] sd 17:0:0:0: [sdb]
586114704 512-byte hardware sectors (300091 MB)
Dec  7 15:37:07 localhost kernel: [1798437.992000] sd 17:0:0:0: [sdb]
Test WP failed, assume Write Enabled
Dec  7 15:37:07 localhost kernel: [1798437.992000] sd 17:0:0:0: [sdb]
586114704 512-byte hardware sectors (300091 MB)
Dec  7 15:37:07 localhost kernel: [1798437.996000] sd 17:0:0:0: [sdb]
Test WP failed, assume Write Enabled
Dec  7 15:37:07 localhost kernel: [1798437.996000]  sdb: sdb1
Dec  7 15:37:07 localhost kernel: [1798438.012000] sd 17:0:0:0: [sdb]
Attached SCSI disk
Dec  7 15:37:07 localhost kernel: [1798438.012000] sd 17:0:0:0:
Attached scsi generic sg2 type 0
Dec  7 15:37:18 localhost kernel: [1798448.764000] sd 17:0:0:0: [sdb]
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Dec  7 15:37:18 localhost kernel: [1798448.764000] sd 17:0:0:0: [sdb]
Sense Key : Hardware Error [current]
Dec  7 15:37:18 localhost kernel: [1798448.764000] sd 17:0:0:0: [sdb]
Add. Sense: Data phase error
Dec  7 15:37:18 localhost kernel: [1798448.764000] end_request: I/O
error, dev sdb, sector 112
Dec  7 15:37:26 localhost kernel: [1798456.976000] XFS mounting filesystem sdb1
Dec  7 15:37:26 localhost kernel: [1798457.220000] Starting XFS
recovery on filesystem: sdb1 (logdev: internal)
Dec  7 15:37:38 localhost kernel: [1798469.300000] sd 17:0:0:0: [sdb]
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Dec  7 15:37:38 localhost kernel: [1798469.300000] sd 17:0:0:0: [sdb]
Sense Key : Hardware Error [current]
Dec  7 15:37:38 localhost kernel: [1798469.300000] sd 17:0:0:0: [sdb]
Add. Sense: Data phase error
Dec  7 15:37:38 localhost kernel: [1798469.300000] end_request: I/O
error, dev sdb, sector 127
Dec  7 15:37:38 localhost kernel: [1798469.304000] XFS: failed to read
root inode
Dec  7 15:37:38 localhost kernel: [1798469.416000] XFS mounting filesystem sdb1
Dec  7 15:37:38 localhost kernel: [1798469.588000] Starting XFS
recovery on filesystem: sdb1 (logdev: internal)
Dec  7 15:37:52 localhost kernel: [1798483.084000] sd 17:0:0:0: [sdb]
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Dec  7 15:37:52 localhost kernel: [1798483.084000] sd 17:0:0:0: [sdb]
Sense Key : Hardware Error [current]
Dec  7 15:37:52 localhost kernel: [1798483.084000] sd 17:0:0:0: [sdb]
Add. Sense: Data phase error
Dec  7 15:37:52 localhost kernel: [1798483.084000] end_request: I/O
error, dev sdb, sector 127
Dec  7 15:37:52 localhost kernel: [1798483.092000] XFS: failed to read
root inode
Dec  7 15:40:18 localhost kernel: [1798629.192000] sd 17:0:0:0: [sdb]
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Dec  7 15:40:18 localhost kernel: [1798629.192000] sd 17:0:0:0: [sdb]
Sense Key : Hardware Error [current]
Dec  7 15:40:18 localhost kernel: [1798629.192000] sd 17:0:0:0: [sdb]
Add. Sense: Data phase error
Dec  7 15:40:18 localhost kernel: [1798629.192000] end_request: I/O
error, dev sdb, sector 126
Dec  7 15:44:32 localhost kernel: [1798883.420000] sd 17:0:0:0: [sdb]
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Dec  7 15:44:32 localhost kernel: [1798883.420000] sd 17:0:0:0: [sdb]
Sense Key : Hardware Error [current]
Dec  7 15:44:32 localhost kernel: [1798883.420000] sd 17:0:0:0: [sdb]
Add. Sense: Data phase error
Dec  7 15:44:32 localhost kernel: [1798883.420000] end_request: I/O
error, dev sdb, sector 131


Any help would be appreciated.

-- 

Dovydas Sankauskas
