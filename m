Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 16:24:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3UNOJPh006451
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 16:24:27 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A5952AD4646
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 16:25:03 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id YF4GjDBwV4bxUUep for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 16:25:03 -0700 (PDT)
Message-ID: <4818FFCB.5060106@sandeen.net>
Date: Wed, 30 Apr 2008 18:24:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Problems with xfs_grow on large LVM + XFS filesystem 20TB size
 check 2 failed
References: <6A32BC807C106440B7E23208F280DDAF01D21F36FD@bcmail1.VIDMARK.LOCAL> <481650F5.40205@sandeen.net> <6A32BC807C106440B7E23208F280DDAF01D21F3718@bcmail1.VIDMARK.LOCAL> <481656F6.5030300@sandeen.net> <48166E18.10008@sgi.com> <48166F42.50104@sandeen.net> <6A32BC807C106440B7E23208F280DDAF01D21F384B@bcmail1.VIDMARK.LOCAL> <48175046.5050405@sandeen.net> <6A32BC807C106440B7E23208F280DDAF01D21F3870@bcmail1.VIDMARK.LOCAL> <481752F9.8040600@sandeen.net> <6A32BC807C106440B7E23208F280DDAF01D21F3BA8@bcmail1.VIDMARK.LOCAL>
In-Reply-To: <6A32BC807C106440B7E23208F280DDAF01D21F3BA8@bcmail1.VIDMARK.LOCAL>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lance Reed <lreed@brightcove.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Lance Reed wrote:
> Great!
> That is exactly what I needed to know.
> 
> One follow up question:
> 
> Can I assume that the bug:
> TAKE 959978 - growing an XFS filesystem by more than 2TB is broken
> is a problem only with the the xfs_growfs code?  The reason I asked is that when I first made the original filesystem, I created it using mkfs.xfs and it succeeded fine for 10.5 TB.
> 
> # mkfs.xfs /dev/VolGroupNAS200/LogVolNAS200
> meta-data=/dev/VolGroupNAS200/LogVolNAS200 isize=256    agcount=32, agsize=83886080 blks
>          =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=2684354560, imaxpct=25
>          =                       sunit=0      swidth=0 blks, unwritten=1
> naming   =version 2              bsize=4096
> log      =internal log           bsize=4096   blocks=32768, version=1
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=
> 
> so I am assuming the rest of the XFS setup can handle large Filesystems fine.  I am just trying to confirm that the probem is TAKE 959978 and that doing it in less than 2 TB increments should be fine.

yes, it was just in the growth path.

-Eric
