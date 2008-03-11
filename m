Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Mar 2008 11:39:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2BIcvIW001276
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 11:38:58 -0700
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A3467F65FC8
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 11:39:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id IWeqE0YATyBk6vIp for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 11:39:28 -0700 (PDT)
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m2BHlesE023789
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 13:47:40 -0400
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2BHleTs030920
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 13:47:40 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id m2BHle13026923
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 13:47:40 -0400
Message-ID: <47D6C5BB.4040106@sandeen.net>
Date: Tue, 11 Mar 2008 12:47:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: can I shrink an xfs?
References: <20080311172958.GA31833@apartia.fr>
In-Reply-To: <20080311172958.GA31833@apartia.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Louis-David Mitterrand wrote:
> Hi,
> 
> Is it possible to shrink an xfs? I tried using xfs_growfs to no avail.

Nope.

 http://oss.sgi.com/projects/xfs/faq.html#resize

-Eric

> 	zenon:~# xfs_growfs -D 650000000 /backup
> 	meta-data=/dev/md2               isize=256    agcount=32, agsize=20539552 blks
> 			 =                       sectsz=4096  attr=1
> 	data     =                       bsize=4096   blocks=657265248, imaxpct=25
> 			 =                       sunit=16     swidth=48 blks
> 	naming   =version 2              bsize=4096  
> 	log      =internal               bsize=4096   blocks=32768, version=2
> 			 =                       sectsz=4096  sunit=1 blks, lazy-count=0
> 	realtime =none                   extsz=196608 blocks=0, rtextents=0
> 	data size 650000000 too small, old size is 657265248
> 
> ... even though the fs is 80% full only.
> 
> Thanks,
> 
> 
