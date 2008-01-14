Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jan 2008 05:23:39 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0EDNWcw031023
	for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 05:23:35 -0800
Received: from imo-m20.mx.aol.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 60CA7517774
	for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 05:23:47 -0800 (PST)
Received: from imo-m20.mx.aol.com (imo-m20.mx.aol.com [64.12.137.1]) by cuda.sgi.com with ESMTP id GNnzXCEHvkgUxIV8 for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 05:23:47 -0800 (PST)
Received: from AndrewL733@aol.com
	by imo-m20.mx.aol.com (mail_out_v38_r9.3.) id 4.c1d.2dedc8d5 (37120)
	 for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 08:23:44 -0500 (EST)
Subject: Optimal mkfs settings for md RAID0 over 2x3ware RAIDS
Date: Mon, 14 Jan 2008 08:23:44 -0500
MIME-Version: 1.0
From: andrewl733@aol.com
Message-Id: <8CA24C7D24953CD-93C-29C2@WEBMAIL-DG08.sysops.aol.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello XFS list,

I am trying to figure out the optimal mkfs settings for a large array (i.e.=
, 18 TB) consisting of 2 or 4 PHYSICAL 3ware RAID-5 arrays striped together=
 with Linux software RAID-0. As far as I can tell, this question about comb=
ining physical and software RAID has not been asked or answered on the list=
.=20

As I understand it, for a SINGLE 12-drive 3ware PHYSICAL Hardware RAID-5 cr=
eated with a 3-ware-defined "stripe size" of 64K, the optimal mkfs setting =
should be:=20

mkfs.xfs =E2=80=93d=C2=A0 su=3D64k,sw=3D11 /dev/sdX


The question is, what is optimal if I stripe together TWO of these Physical=
 Hardware RAID-5 arrays as a SOFTWARE RAID-0. Casual testing shows striping=
 together two PHYSICAL RAIDS as sucn can yield a gain in performance of app=
roximately 60 percent versus 12-drives. But in order to optimize the RAID-0=
 device, would the correct mkfs be:=20

mkfs.xfs -d su=3D64k,sw=3D22 /dev/mdX

There are now 24 drives minus two for parity. Is the logic correct here?=20

Regards,=20
Andrew

________________________________________________________________________
More new features than ever.  Check out the new AOL Mail ! - http://webmail=
.aol.com


[[HTML alternate version deleted]]
