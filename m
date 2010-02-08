Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o18NiBcf170140 for <xfs@oss.sgi.com>; Mon, 8 Feb 2010 17:44:12 -0600
Received: from omr10.networksolutionsemail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 40F481BB5D0
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2010 15:45:23 -0800 (PST)
Received: from omr10.networksolutionsemail.com
	(omr10.networksolutionsemail.com [205.178.146.60]) by
	cuda.sgi.com with ESMTP id IqtmNexhuo6u5D9e for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2010 15:45:23 -0800 (PST)
Received: from mail.networksolutionsemail.com (mail.networksolutionsemail.com
	[205.178.146.50])
	by omr10.networksolutionsemail.com (8.13.6/8.13.6) with SMTP id
	o18NjNIU017440 for <xfs@oss.sgi.com>; Mon, 8 Feb 2010 18:45:23 -0500
Message-ID: <4B70A213.1020002@chaven.com>
Date: Mon, 08 Feb 2010 17:45:23 -0600
From: Steve Costaras <stevecs@chaven.com>
MIME-Version: 1.0
Subject: Re: format and xfs_info don't match
References: <20100208144035.GA12922@erebus.underworld.local>
In-Reply-To: <20100208144035.GA12922@erebus.underworld.local>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6460985537507714969=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============6460985537507714969==
Content-Type: multipart/alternative;
 boundary="------------080700030001050308060402"

This is a multi-part message in MIME format.
--------------080700030001050308060402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


I've seen this as well under ubuntu 8.04.3LTS (xfsprogs for that distro 
is 2.9.4).   I grabbed 3.1.0 and use that now which agree.

Steve


On 02/08/2010 08:40, Cory Coager wrote:
> For some reason the format attributes don't match the mounted
> attributes.  If you look below, lazy-count and attr aren't getting set.
> Why is this happening?
>
> # mkfs.xfs -f -i size=1024,attr=2 -l version=2,size=128m,lazy-count=1 /dev/mapper/360a9800050334c59543455596d625a77
> meta-data=/dev/mapper/360a9800050334c59543455596d625a77 isize=1024
> agcount=32, agsize=8388744 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=268439808, imaxpct=25
>          =                       sunit=0      swidth=0 blks, unwritten=1
> naming   =version 2              bsize=4096
> log      =internal log           bsize=4096   blocks=32768, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
>
> # mount -t xfs -o noatime,nodiratime,nobarrier
> /dev/mapper/360a9800050334c59543455596d625a77 /mnt/new-homes/
>
> # xfs_info /mnt/new-homes/
> meta-data=/dev/mapper/360a9800050334c59543455596d625a77 isize=1024
> agcount=32, agsize=8388744 blks
>          =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=268439808, imaxpct=25
>          =                       sunit=0      swidth=0 blks, unwritten=1
> naming   =version 2              bsize=4096
> log      =internal               bsize=4096   blocks=32768, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>
>
>    

--------------080700030001050308060402
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
<font face="Courier New"><br>
I've seen this as well under ubuntu 8.04.3LTS (xfsprogs for that distro
is 2.9.4).&nbsp;&nbsp; I grabbed 3.1.0 and use that now which agree.<br>
<br>
Steve<br>
<br>
</font><br>
On 02/08/2010 08:40, Cory Coager wrote:
<blockquote cite="mid:20100208144035.GA12922@erebus.underworld.local"
 type="cite">
  <pre wrap="">For some reason the format attributes don't match the mounted 
attributes.  If you look below, lazy-count and attr aren't getting set.  
Why is this happening?

# mkfs.xfs -f -i size=1024,attr=2 -l version=2,size=128m,lazy-count=1 /dev/mapper/360a9800050334c59543455596d625a77
meta-data=/dev/mapper/360a9800050334c59543455596d625a77 isize=1024   
agcount=32, agsize=8388744 blks
        =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=268439808, imaxpct=25
        =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=32768, version=2
        =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# mount -t xfs -o noatime,nodiratime,nobarrier 
/dev/mapper/360a9800050334c59543455596d625a77 /mnt/new-homes/

# xfs_info /mnt/new-homes/
meta-data=/dev/mapper/360a9800050334c59543455596d625a77 isize=1024   
agcount=32, agsize=8388744 blks
        =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=268439808, imaxpct=25
        =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=32768, version=2
        =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

_______________________________________________
xfs mailing list
<a class="moz-txt-link-abbreviated" href="mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a>
<a class="moz-txt-link-freetext" href="http://oss.sgi.com/mailman/listinfo/xfs">http://oss.sgi.com/mailman/listinfo/xfs</a>


  </pre>
</blockquote>
</body>
</html>

--------------080700030001050308060402--


--===============6460985537507714969==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6460985537507714969==--
