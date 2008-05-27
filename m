Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 27 May 2008 09:12:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4RGCnkd021668
	for <xfs@oss.sgi.com>; Tue, 27 May 2008 09:12:50 -0700
Received: from mail07do.versatel.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66B98119C341
	for <xfs@oss.sgi.com>; Tue, 27 May 2008 09:13:40 -0700 (PDT)
Received: from mail07do.versatel.de (mail07do.versatel.de [89.245.129.27]) by cuda.sgi.com with ESMTP id HIi4BeuDWt23wnFa for <xfs@oss.sgi.com>; Tue, 27 May 2008 09:13:40 -0700 (PDT)
Received: from webmail02.versatel-nord.de ([62.214.102.232])
          (envelope-sender <andre.nitschke@versanet.de>)
          by mail07do.versatel.de (qmail-ldap-1.03) with SMTP
          for <xfs@oss.sgi.com>; 27 May 2008 16:13:38 -0000
Message-ID: <20080527181336.22qjfcgcfdlwsg40@webmail.versatel.de>
Date: Tue, 27 May 2008 18:13:36 +0200
From: Andre Nitschke <andre.nitschke@versanet.de>
Subject: Question for XFS (mounting and clean bit)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,
i am a Linux User from Germany and chanched to xfs. I use Debian 4 and the
installer creates lilo. Because of a wrong configuration i destroyed the
lilo.conf and rebootet with a systemrescuecd. from here i mount the xfs
partition and try to run lilo, but it fails.
then i had a realy bad idea. i unmount the xfs partition and then mount it as
root, but there exit a root file system.
i type
mount /dev/sda2 /
no error appears. i could not access the partiton from the hdd, only see the
tmpfs from the live-boot cd. hm
i type mount and the mount command says:
tmpfs on / as tmpfs (rw)
....(some entrys...)
/dev/sda2 on / as xfs (rw)
ok, both devices were mountet as /
but i could only access the tmpfs system from the live cd.
i try to reboot. the system sends the term and kill signal, then hang up.
nothing happesn.
i press reset.
then linux startet normal and says ...

 XFS mounting filesystem sda2
 Ending clean XFS mount for filesystem: sda2

so i think nothing should happens to the xfs.
but i cant stop thinking, go to my testpc with linux and xfs and create the same
situtation. everytime ... clean xfs.
when i start writing data and then press reset comes this message:

 SGI XFS Quota Management subsystem
 XFS mounting filesystem hda2
 Starting XFS recovery on filesystem: hda2 (logdev: internal)
 Ending XFS recovery on filesystem: hda2 (logdev: internal)

i have two questions. first, is the xfs on my working-machine damaged by my bad
idea mounting two devices as root
and secound, is the clean bit removed when mounting a xfs or when i first write
data on it?

thanks

andre
