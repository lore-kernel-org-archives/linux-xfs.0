Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nATEfsfS076413 for <xfs@oss.sgi.com>; Sun, 29 Nov 2009 08:41:54 -0600
Received: from BLADE3.ISTI.CNR.IT (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 04241BD4F8
	for <xfs@oss.sgi.com>; Sun, 29 Nov 2009 06:42:21 -0800 (PST)
Received: from BLADE3.ISTI.CNR.IT (blade3.isti.cnr.it [194.119.192.19]) by
	cuda.sgi.com with ESMTP id 78BkkqprCDFkvxDX for
	<xfs@oss.sgi.com>; Sun, 29 Nov 2009 06:42:21 -0800 (PST)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.4 #31773)
	id <01NGO4PBRIB490OL9W@mx.isti.cnr.it> for xfs@oss.sgi.com; Sun,
	29 Nov 2009 15:41:17 +0100
Date: Sun, 29 Nov 2009 15:41:31 +0100
From: Asdo <asdo@shiftmail.org>
Subject: Re: XFS & LVM: unexpected cp when issuing mv
In-reply-to: <200911291452.20646@zmi.at>
Message-id: <4B12881B.6080302@shiftmail.org>
MIME-version: 1.0
References: <200911291452.20646@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8165442846270854053=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.

--===============8165442846270854053==
Content-type: multipart/alternative;
 boundary="Boundary_(ID_k1E3RIcxtx1ZPGyuZzZ/Rg)"

This is a multi-part message in MIME format.

--Boundary_(ID_k1E3RIcxtx1ZPGyuZzZ/Rg)
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT

Please paste the output of the following 2 commands:

df  /disks/sharestore/upload/

df  /disks/sharestore/download/


Michael Monnerie wrote:
> I have an unexpected behaviour and I hope someone can explain me the 
> reasons:
>
> This is an openSUSE 11.2 virtual machine within XENserver. XENserver can 
> only create 2TB disks, but I needed more. So I create 2x 2TB disks for 
> that VM. These disks have no partitions, but are straight LVM:
> # pvscan
>   PV /dev/xvdb   VG sharestore   lvm2 [1,95 TB / 0    free]
>   PV /dev/xvdc   VG sharestore   lvm2 [1,95 TB / 0    free]
>   Total: 2 [3,91 TB] / in use: 2 [3,91 TB] / in no VG: 0 [0   ]
>
> I created one VG, and then one LV:
> # vgscan
>   Reading all physical volumes.  This may take a while...
>   Found volume group "sharestore" using metadata type lvm2
> # lvscan
>   ACTIVE            '/dev/sharestore/public' [3,91 TB] inherit
>
> On that LV, I created an XFS filesystem, mounted from /etc/fstab:
> /dev/sharestore/public /disks/sharestore  xfs        
> noatime,nodiratime,logbufs=8,logbsize=256k,attr2,nobarrier,largeio,swalloc,inode64,prjquota
>
> Now when I move from one dir to another, example
> mv /disks/sharestore/upload/* /disks/sharestore/download/
>
> within some dirs it's a simple mv where only metadata is moved, but with 
> some dirs it's a physical cp+rm of the files. You can easily see that by 
> the speed of the mv, plus with iostat:
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-
> sz avgqu-sz   await  svctm  %util
> xvdb              0,00     0,00    0,00  647,31     0,00 28424,75    
> 87,82    18,46   29,71   0,24  15,65
> xvdc              0,00     0,40  631,14    2,40 26928,54    76,65    
> 85,25     5,56    8,69   1,56  98,84
>
> Until now I believed that a mv within one filesystem is always just a 
> metadata mv. But it seems I found a case now where even within the same 
> filesystem a physical cp+rm is done. Can someone explain me
>
> 1) why this happens
> 2) how I can prevent this?
>
> We have files >5G there, often 20G or more, so a mv should just be a 
> metadata mv, everything else is inacceptable.
> Could it be the way I created the VG + LV, that there's a cp instead mv?
> How could I create all that to get a normal behaviour?
>
> Maybe like this?:
> 1) create VG only on one disk
> 2) create LV on that disk
> 3) create XFS
> 4) extend VG to 2nd disk
> 5) extend LV to 2nd disk
> 6) xfs_growfs to 2nd disk
>
> mfg zmi
>   
> ------------------------------------------------------------------------
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>   


--Boundary_(ID_k1E3RIcxtx1ZPGyuZzZ/Rg)
Content-type: text/html; charset=UTF-8
Content-transfer-encoding: 8BIT

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=UTF-8" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
Please paste the output of the following 2 commands:<br>
<br>
df  /disks/sharestore/upload/
<br>
<br>
df  /disks/sharestore/download/
<br>
<br>
<br>
Michael Monnerie wrote:
<blockquote cite="mid:200911291452.20646@zmi.at" type="cite">
  <pre wrap="">I have an unexpected behaviour and I hope someone can explain me the 
reasons:

This is an openSUSE 11.2 virtual machine within XENserver. XENserver can 
only create 2TB disks, but I needed more. So I create 2x 2TB disks for 
that VM. These disks have no partitions, but are straight LVM:
# pvscan
  PV /dev/xvdb   VG sharestore   lvm2 [1,95 TB / 0    free]
  PV /dev/xvdc   VG sharestore   lvm2 [1,95 TB / 0    free]
  Total: 2 [3,91 TB] / in use: 2 [3,91 TB] / in no VG: 0 [0   ]

I created one VG, and then one LV:
# vgscan
  Reading all physical volumes.  This may take a while...
  Found volume group "sharestore" using metadata type lvm2
# lvscan
  ACTIVE            '/dev/sharestore/public' [3,91 TB] inherit

On that LV, I created an XFS filesystem, mounted from /etc/fstab:
/dev/sharestore/public /disks/sharestore  xfs        
noatime,nodiratime,logbufs=8,logbsize=256k,attr2,nobarrier,largeio,swalloc,inode64,prjquota

Now when I move from one dir to another, example
mv /disks/sharestore/upload/* /disks/sharestore/download/

within some dirs it's a simple mv where only metadata is moved, but with 
some dirs it's a physical cp+rm of the files. You can easily see that by 
the speed of the mv, plus with iostat:
Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-
sz avgqu-sz   await  svctm  %util
xvdb              0,00     0,00    0,00  647,31     0,00 28424,75    
87,82    18,46   29,71   0,24  15,65
xvdc              0,00     0,40  631,14    2,40 26928,54    76,65    
85,25     5,56    8,69   1,56  98,84

Until now I believed that a mv within one filesystem is always just a 
metadata mv. But it seems I found a case now where even within the same 
filesystem a physical cp+rm is done. Can someone explain me

1) why this happens
2) how I can prevent this?

We have files &gt;5G there, often 20G or more, so a mv should just be a 
metadata mv, everything else is inacceptable.
Could it be the way I created the VG + LV, that there's a cp instead mv?
How could I create all that to get a normal behaviour?

Maybe like this?:
1) create VG only on one disk
2) create LV on that disk
3) create XFS
4) extend VG to 2nd disk
5) extend LV to 2nd disk
6) xfs_growfs to 2nd disk

mfg zmi
  </pre>
  <pre wrap="">
<hr size="4" width="90%">
_______________________________________________
xfs mailing list
<a class="moz-txt-link-abbreviated" href="mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a>
<a class="moz-txt-link-freetext" href="http://oss.sgi.com/mailman/listinfo/xfs">http://oss.sgi.com/mailman/listinfo/xfs</a>
  </pre>
</blockquote>
<br>
</body>
</html>

--Boundary_(ID_k1E3RIcxtx1ZPGyuZzZ/Rg)--


--===============8165442846270854053==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8165442846270854053==--
