Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 30 Mar 2008 17:31:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2V0V5HB026469
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2008 17:31:08 -0700
Received: from server.dwo.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B8956711F00
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2008 17:31:40 -0700 (PDT)
Received: from server.dwo.hu (server.dwo.hu [87.229.110.63]) by cuda.sgi.com with ESMTP id gvCtP355gFjnfKoa for <xfs@oss.sgi.com>; Sun, 30 Mar 2008 17:31:40 -0700 (PDT)
From: =?iso-8859-2?Q?Husz=E1r_Viktor_D=E9nes?= <hvd@dwo.hu>
Subject: RE: free space problem
Date: Mon, 31 Mar 2008 02:31:16 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
In-Reply-To: <20080330235444.7d357bb6@galadriel.home>
Message-Id: <20080331003140.B8956711F00@cuda.sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Emmanuel Florac' <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

There is nothing extraordinary in it, you can see umount-mount and that it
was mounted after all xfs activity (check, repair, db).

root@mailslave:/home/void# grep -i xfs /var/log/{messages,kern.log,syslog}
/var/log/kern.log:Mar 18 01:46:08 mailslave kernel: SGI XFS with ACLs,
security attributes, realtime, large block/inode numbers, no debug enabled
/var/log/kern.log:Mar 18 01:46:08 mailslave kernel: SGI XFS Quota
Management subsystem
/var/log/kern.log:Mar 18 01:46:08 mailslave kernel: XFS mounting
filesystem md1
/var/log/kern.log:Mar 18 01:46:08 mailslave kernel: Ending clean XFS mount
for filesystem: md1
/var/log/kern.log:Mar 18 01:46:08 mailslave kernel: XFS mounting
filesystem dm-0
/var/log/kern.log:Mar 18 01:46:08 mailslave kernel: Ending clean XFS mount
for filesystem: dm-0
/var/log/kern.log:Mar 18 02:23:16 mailslave kernel: SGI XFS with ACLs,
security attributes, realtime, large block/inode numbers, no debug enabled
/var/log/kern.log:Mar 18 02:23:16 mailslave kernel: SGI XFS Quota
Management subsystem
/var/log/kern.log:Mar 18 02:23:16 mailslave kernel: XFS mounting
filesystem md1
/var/log/kern.log:Mar 18 02:23:16 mailslave kernel: Ending clean XFS mount
for filesystem: md1
/var/log/kern.log:Mar 18 02:23:16 mailslave kernel: XFS mounting
filesystem dm-0
/var/log/kern.log:Mar 18 02:23:16 mailslave kernel: Ending clean XFS mount
for filesystem: dm-0
/var/log/kern.log:Mar 18 02:34:13 mailslave kernel: SGI XFS with ACLs,
security attributes, realtime, large block/inode numbers, no debug enabled
/var/log/kern.log:Mar 18 02:34:13 mailslave kernel: SGI XFS Quota
Management subsystem
/var/log/kern.log:Mar 18 02:34:13 mailslave kernel: XFS mounting
filesystem md1
/var/log/kern.log:Mar 18 02:34:13 mailslave kernel: Ending clean XFS mount
for filesystem: md1
/var/log/kern.log:Mar 18 02:34:13 mailslave kernel: XFS mounting
filesystem dm-0
/var/log/kern.log:Mar 18 02:34:13 mailslave kernel: Ending clean XFS mount
for filesystem: dm-0
/var/log/kern.log:Mar 20 09:57:50 mailslave kernel: SGI XFS with ACLs,
security attributes, realtime, large block/inode numbers, no debug enabled
/var/log/kern.log:Mar 20 09:57:50 mailslave kernel: SGI XFS Quota
Management subsystem
/var/log/kern.log:Mar 20 09:57:50 mailslave kernel: XFS mounting
filesystem md1
/var/log/kern.log:Mar 20 09:57:50 mailslave kernel: Ending clean XFS mount
for filesystem: md1
/var/log/kern.log:Mar 20 09:57:50 mailslave kernel: XFS mounting
filesystem dm-0
/var/log/kern.log:Mar 20 09:57:50 mailslave kernel: Ending clean XFS mount
for filesystem: dm-0
/var/log/kern.log:Mar 26 22:05:54 mailslave kernel: XFS mounting
filesystem dm-0
/var/log/kern.log:Mar 26 22:05:54 mailslave kernel: Ending clean XFS mount
for filesystem: dm-0
/var/log/kern.log:Mar 27 04:32:09 mailslave kernel: XFS mounting
filesystem dm-0
/var/log/kern.log:Mar 27 04:32:09 mailslave kernel: Ending clean XFS mount
for filesystem: dm-0
/var/log/kern.log:Mar 27 04:36:54 mailslave kernel: XFS mounting
filesystem dm-0
/var/log/kern.log:Mar 27 04:36:54 mailslave kernel: Ending clean XFS mount
for filesystem: dm-0
/var/log/kern.log:Mar 27 05:02:29 mailslave kernel: XFS mounting
filesystem dm-0
/var/log/kern.log:Mar 27 05:02:29 mailslave kernel: Ending clean XFS mount
for filesystem: dm-0

-----Original Message-----
From: Emmanuel Florac [mailto:eflorac@intellique.com] 
Sent: Sunday, March 30, 2008 11:55 PM
To: Huszár Viktor Dénes
Cc: xfs@oss.sgi.com
Subject: Re: free space problem

Le Sun, 30 Mar 2008 22:29:06 +0200 vous écriviez:

>  We run
> 2.6.23 kernel.

Look in /var/log/messages and the output of dmesg command for xfs
related messages and post them here, please. 

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------


__________ Information from ESET NOD32 Antivirus, version of virus signature
database 2985 (20080330) __________

The message was checked by ESET NOD32 Antivirus.

http://www.eset.com

 

__________ Information from ESET NOD32 Antivirus, version of virus signature
database 2985 (20080330) __________

The message was checked by ESET NOD32 Antivirus.

http://www.eset.com
 
