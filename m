Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 06:25:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4TDPW56008049
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 06:25:32 -0700
Received: from server.dwo.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3CDCC0D418
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 06:26:24 -0700 (PDT)
Received: from server.dwo.hu (server.dwo.hu [87.229.110.63]) by cuda.sgi.com with ESMTP id ci9g3ELOcUmWjRGF for <xfs@oss.sgi.com>; Thu, 29 May 2008 06:26:24 -0700 (PDT)
From: =?iso-8859-2?Q?Husz=E1r_Viktor_D=E9nes?= <hvd@dwo.hu>
Subject: RE: free space problem
Date: Thu, 29 May 2008 15:26:16 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
In-Reply-To: <20080529125509.136aa653@harpe.intellique.com>
Message-Id: <20080529132624.E3CDCC0D418@cuda.sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Emmanuel Florac' <eflorac@intellique.com>, xfs@oss.sgi.com

YES! Finally the problem is solved! Thank you Emmanuel and everyone else!
After adding inode64 to the mount option [only umount and mount worked, with
remount it didn't] it works. Although the icount and ifree numbers have not
changed, we can write to the disk. 

Hope this will help anyone who encounters this problem. In the xfs man and
debian docs we could not find anything about this inode64, so thank you once
again for the help!!!! 

Viktor

-----Original Message-----
From: Emmanuel Florac [mailto:eflorac@intellique.com] 
Sent: Thursday, May 29, 2008 12:55 PM
To: xfs@oss.sgi.com
Cc: Huszár Viktor Dénes
Subject: Re: free space problem

Le Thu, 29 May 2008 12:29:25 +0200
Emmanuel Florac <eflorac@intellique.com> écrivait:

> Is it mounted with the inode64 option? 

You should try it then. You must unmount it and remount it for this to
take effect. Either add "inode64" to the option line in /etc/fstab, or
use mount -t xfs -o inode64 /some/device /some/mountpoint

-- 
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------



__________ Information from ESET NOD32 Antivirus, version of virus signature
database 3143 (20080529) __________

The message was checked by ESET NOD32 Antivirus.

http://www.eset.com

 

__________ Information from ESET NOD32 Antivirus, version of virus signature
database 3143 (20080529) __________

The message was checked by ESET NOD32 Antivirus.

http://www.eset.com
 
