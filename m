Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 Feb 2007 01:19:41 -0800 (PST)
Received: from mail.edu.haifa.ac.il (mail.edu.haifa.ac.il [132.74.40.10])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1D9JWm7028495
	for <linux-xfs@oss.sgi.com>; Tue, 13 Feb 2007 01:19:33 -0800
Received: from localhost (localhost [127.0.0.1])
	by mail.edu.haifa.ac.il (Postfix) with ESMTP id 63F931CB17
	for <linux-xfs@oss.sgi.com>; Tue, 13 Feb 2007 10:50:37 +0200 (IST)
Received: from mail.edu.haifa.ac.il ([127.0.0.1])
	by localhost (mail.edu.haifa.ac.il [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id m0pG+k-tE4+j for <linux-xfs@oss.sgi.com>;
	Tue, 13 Feb 2007 10:50:37 +0200 (IST)
Received: from kozanostra (leon.edu.haifa.ac.il [132.74.41.33])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by mail.edu.haifa.ac.il (Postfix) with ESMTP id 216BE12C53
	for <linux-xfs@oss.sgi.com>; Tue, 13 Feb 2007 10:50:37 +0200 (IST)
From: "Leon Kolchinsky" <leonk@construct.haifa.ac.il>
Subject: mkfs and mount tips?
Date: Tue, 13 Feb 2007 10:48:15 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1255"
Message-Id: <20070213085037.216BE12C53@mail.edu.haifa.ac.il>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hello All, 

I have Pentium II (Deschutes) with first 10GB (/dev/hda) and second
60GB(/dev/hdc) disk. 
After reading gentoo xfs threads on their forum and some SGI docs and FAQs I
came with this options for creating FS and mounting the disks: 

1) To create XFS on hda: 

Code:	
# mkfs.xfs -l internal,size=128m -d agcount=2 /dev/hda	


I've also seen "–d unwritten=0" option: 

So my question: 
Is it safe to add –d unwritten=0 option to increase performance like this
(or will I lose some essential functionality)?: 

Is this how the code should look?:	
# mkfs.xfs -l internal,size=128m -d agcount=2 –d unwritten=0 /dev/hda	


2) To prevent data lost in case of power outage(Disabling the write back
cache): 
Add the following to local.start: 

Code:	
# hdparm -W0 /dev/hda 
# hdparm -W0 /dev/hdc 
# blktool /dev/hda wcache off 
# blktool /dev/hdc wcache off	


Right? 

3) Mount options: 

On gentoo xfs thread it's suggested that the mount options should be
"noatime,logbufs=8" 

But what about "osyncisdsync" mount option. 

"• osyncisdsync 
– Writes to files opened with the O_SYNC flag set will behave as if the
O_DSYNC flag 
had been used instead. 
– This can result in better performance without compromising data safety. 
– However timestamp updates from O_SYNC writes can be lost if the system
crashes. 
Use osyncisosync to disable this setting."

So do you think it is safe to add "osyncisdsync" mount option to fstab? 


I'd appreciate any comments/tips/answers.


Best Regards,
Leon Kolchinsky
