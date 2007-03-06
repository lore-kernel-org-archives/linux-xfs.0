Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Mar 2007 15:59:45 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l26Nxc6p004839
	for <linux-xfs@oss.sgi.com>; Tue, 6 Mar 2007 15:59:39 -0800
Message-Id: <200703062348.KAA13317@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: xfs_repair and extents size
Date: Wed, 7 Mar 2007 10:54:24 +1100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <5d96567b0703060214n45838ceh9375545613a1557c@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "'Raz Ben-Jehuda(caro)'" <raziebe@gmail.com>, linux-xfs@oss.sgi.com

Hi Raz,

It's quite possible xfs_repair hasn't been updated to handle extent 
hints on directories and files. I will investigate this.

Regards,
Barry.

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Raz Ben-Jehuda(caro)
> Sent: Tuesday, 6 March 2007 9:15 PM
> To: linux-xfs@oss.sgi.com
> Subject: xfs_repair and extents size
> 
> Hello.
> I am having some problems with extents sizes and xfs_repair.
> Problem is that my files and directories are not real time files
> and i am setting the extent size to 1MB. I have managed to
> set the extent size to 1M by setting parent directory extent
> to 1M and setting the inherit flag on.
> But if I am running xfs_repair all extents on all directories in
> the file system are being reset to zero.
> I am using last xfsprogs 2.8.18 downloaded from sgi web
> site.
> 
> thank you
> -- 
> Raz
> 
> 
> [[HTML alternate version deleted]]
> 
> 
