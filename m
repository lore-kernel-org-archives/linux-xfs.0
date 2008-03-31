Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Mar 2008 10:37:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2VHaonV007831
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2008 10:36:52 -0700
Received: from server.dwo.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 24BB68D1DF4
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2008 10:37:24 -0700 (PDT)
Received: from server.dwo.hu (server.dwo.hu [87.229.110.63]) by cuda.sgi.com with ESMTP id WDQQNwaApTK0tr7l for <xfs@oss.sgi.com>; Mon, 31 Mar 2008 10:37:24 -0700 (PDT)
From: =?iso-8859-2?Q?Husz=E1r_Viktor_D=E9nes?= <hvd@dwo.hu>
Subject: RE: free space problem
Date: Mon, 31 Mar 2008 19:36:56 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
In-Reply-To: <20080331093951.100ec125@galadriel.home>
Message-Id: <20080331173724.24BB68D1DF4@cuda.sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Emmanuel Florac' <eflorac@intellique.com>, xfs@oss.sgi.com

-----Original Message-----
From: Emmanuel Florac [mailto:eflorac@intellique.com] 
Sent: Monday, March 31, 2008 9:40 AM
To: Huszár Viktor Dénes; xfs@oss.sgi.com
Subject: Re: free space problem

Le Mon, 31 Mar 2008 02:31:16 +0200 vous écriviez:

>Then maybe you simply ran out of inodes. It's common if you have lots
>of small files. There is a way to increase the number of inodes but I
>don't remember it right now.
--
No, unfortunately not. There are not many small files and the inode usage is
1%. See.

/bin/df -i
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/md0             5494272  154415 5339857    3% /
tmpfs                2056252       5 2056247    1% /lib/init/rw
udev                 2056252     487 2055765    1% /dev
tmpfs                2056252      10 2056242    1% /dev/shm
/dev/mapper/a-a      88427616  867107 87560509    1% /var/www/users
 

__________ Information from ESET NOD32 Antivirus, version of virus signature
database 2987 (20080331) __________

The message was checked by ESET NOD32 Antivirus.

http://www.eset.com
 
