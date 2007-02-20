Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Feb 2007 06:16:45 -0800 (PST)
Received: from mail.edu.haifa.ac.il (mail.edu.haifa.ac.il [132.74.40.10])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1KEGZm7030989
	for <xfs@oss.sgi.com>; Tue, 20 Feb 2007 06:16:38 -0800
Received: from localhost (localhost [127.0.0.1])
	by mail.edu.haifa.ac.il (Postfix) with ESMTP id 62CD914A891
	for <xfs@oss.sgi.com>; Tue, 20 Feb 2007 16:21:14 +0200 (IST)
Received: from mail.edu.haifa.ac.il ([127.0.0.1])
	by localhost (mail.edu.haifa.ac.il [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id XVMCPRS-r8v7 for <xfs@oss.sgi.com>;
	Tue, 20 Feb 2007 16:21:14 +0200 (IST)
Received: from kozanostra (leon.edu.haifa.ac.il [132.74.41.33])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by mail.edu.haifa.ac.il (Postfix) with ESMTP id 2B52C1C9C6
	for <xfs@oss.sgi.com>; Tue, 20 Feb 2007 16:21:14 +0200 (IST)
From: "Leon Kolchinsky" <leonk@construct.haifa.ac.il>
Subject: xfsdump/xfsrestore question
Date: Tue, 20 Feb 2007 16:16:31 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1255"
Content-Transfer-Encoding: 7bit
Message-Id: <20070220142114.2B52C1C9C6@mail.edu.haifa.ac.il>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello All,

I have a question about xfsdump/xfsrestore usage on Linux.

I'm running Linux 2.6.19-gentoo-r5.

Now I have 2 disks, 
/dev/hda is my system disk
/dev/hdc is a disk I want to use for backups.

This is how my fstab looks like:

/dev/hda1               /                       xfs
noatime,nodiratime,logbufs=8    1 1
/dev/hda2               none                    swap            sw
0 0
/dev/hdc3               /var/tmp/portage        xfs
noatime,nodiratime,logbufs=8    0 0
/dev/hdc2               /data                   xfs
noatime,nodiratime,logbufs=8    0 0
/dev/hdc1               none                    swap            sw
0 0
/dev/cdrom              /mnt/cdrom              iso9660         noauto,ro
0 0
/dev/fd0                /mnt/floppy             auto            noauto
0 0

# NOTE: The next line is critical for boot!
proc                    /proc           proc            defaults        0 0

shm                     /dev/shm        tmpfs           nodev,nosuid,noexec
0 0

########################################

Now the questions:

1) If I get the xfsdump synax correctly I just have to do:

# cd /
# xfsdump -f /data/backup.file /

Is it right?
What about opened and "currently in use by the system" files? Are they
backuped in a proper way? What about tmpfs like /proc, are they been
ignored?

2) If I'd have to restore my system from the dump, how would you recommend
to do it? Booting from LiveCD and making # xfsrestore -f / data/backup.file
/ ?

Would it be a bootable/operational system?
What are the expected glitches?


Best Regards,
Leon Kolchinsky
 
