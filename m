Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jan 2008 12:14:38 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0TKEXv7012325
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 12:14:35 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F0546D3A2EA
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 12:14:52 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id ZuU2D4lRcabcQvmI for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 12:14:52 -0800 (PST)
Message-ID: <479F893A.1030402@sandeen.net>
Date: Tue, 29 Jan 2008 14:14:50 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mkfs.xfs doesn't detect size of storage correctly
References: <20080129093201.GA16203@citd.de> <20080129171658.GB21228@citd.de>
In-Reply-To: <20080129171658.GB21228@citd.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matthias Schniedermeyer <ms@citd.de>
Cc: xfs@oss.sgi.com

Matthias Schniedermeyer wrote:
> I just found a workaround. :-)
> As can be seen above the agcount is 3.
> 
> For a reason that lays years in the past, when there were issues with 
> the agcount (actually agsize), that to the best of my knowledge are 
> fixed years ago (but still cause a weird feeling whenever i see that 
> word) i just tried '-d agcount=4'
> 
> #> mkfs.xfs -l size=1024b -d agcount=4 /dev/loop6 -f
> meta-data=/dev/loop6             isize=256    agcount=4, agsize=45785912 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=183143645, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096
> log      =internal log           bsize=4096   blocks=32768, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> As can be seen the "blocks"-number is much higher.
> 
> #> df -k /mnt
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/loop6           732570484      4256 732566228   1% /mnt
> 
> matches(tm) with the loop-size.
> 

Ohh.. um... Barry?  problems :)

[root@magnesium tmp]# mkfs.xfs -dfile,name=xfsfile,size=750156369920
meta-data=xfsfile                isize=256    agcount=3, agsize=45785911
blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=137357733, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@magnesium tmp]# bc
bc 1.06
Copyright 1991-1994, 1997, 1998, 2000 Free Software Foundation, Inc.
This is free software with ABSOLUTELY NO WARRANTY.
For details type `warranty'.
137357733*4096
562617274368

ouch... that's, um, not the right size :)

-Eric
