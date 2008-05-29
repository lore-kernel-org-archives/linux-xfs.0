Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 03:20:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4TAKHs2022886
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 03:20:17 -0700
Received: from server.dwo.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 73D6D1CA6D0
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 03:21:07 -0700 (PDT)
Received: from server.dwo.hu (server.dwo.hu [87.229.110.63]) by cuda.sgi.com with ESMTP id HlTfqxF6H0I8Dkba for <xfs@oss.sgi.com>; Thu, 29 May 2008 03:21:07 -0700 (PDT)
From: =?iso-8859-2?Q?Husz=E1r_Viktor_D=E9nes?= <hvd@dwo.hu>
Subject: RE: free space problem
Date: Thu, 29 May 2008 12:20:49 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
In-Reply-To: <20080331093951.100ec125@galadriel.home>
Message-Id: <20080529102107.73D6D1CA6D0@cuda.sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Emmanuel Florac' <eflorac@intellique.com>, xfs@oss.sgi.com

Okay guys, we figured out what is the real problem with the xfs, I just need
your help now.

Currently our server has an 880448 number as icount, which we figured out
like this:

xfs_db -r -c sb -c p /dev/a/a | egrep icount\|ifree
icount = 880448
ifree = 0

although df -i sates this:

df -i
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/md0                5.3M    301K    5.0M    6% /
tmpfs                   2.0M       5    2.0M    1% /lib/init/rw
udev                    2.0M     475    2.0M    1% /dev
tmpfs                   2.0M       1    2.0M    1% /dev/shm
/dev/mapper/a-a          60M    860K     59M    2% /var/www/users

If we delete a file ifree is going to be 1. if we delete 200 files, ifree
becomes 200 so there is an obvious relationship here. If ifree is 0, we can
not upload anymore.

So the question is: how can we increase the icount without formatting the
partition?

Please help!! Thank you in advance,

Viktor

-----Original Message-----
From: Emmanuel Florac [mailto:eflorac@intellique.com] 
Sent: Monday, March 31, 2008 9:40 AM
To: Huszár Viktor Dénes; xfs@oss.sgi.com
Subject: Re: free space problem

Le Mon, 31 Mar 2008 02:31:16 +0200 vous écriviez:

> There is nothing extraordinary in it, you can see umount-mount and
> that it was mounted after all xfs activity (check, repair, db).

Then maybe you simply ran out of inodes. It's common if you have lots
of small files. There is a way to increase the number of inodes but I
don't remember it right now.

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------


__________ Information from ESET NOD32 Antivirus, version of virus signature
database 2986 (20080331) __________

The message was checked by ESET NOD32 Antivirus.

http://www.eset.com

 

__________ Information from ESET NOD32 Antivirus, version of virus signature
database 3143 (20080529) __________

The message was checked by ESET NOD32 Antivirus.

http://www.eset.com
 
