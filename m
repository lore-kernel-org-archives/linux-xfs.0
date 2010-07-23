Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6N8RqWp190688 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 03:27:52 -0500
Received: from ucsc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D5C3119FD7B
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 01:37:51 -0700 (PDT)
Received: from ucsc.edu (email-prod-out-1.ucsc.edu [128.114.129.85]) by
	cuda.sgi.com with ESMTP id XHDGHsk1ySfVCY7L for
	<xfs@oss.sgi.com>; Fri, 23 Jul 2010 01:37:51 -0700 (PDT)
Subject: Re: filesystem shrinks after using xfs_repair
Mime-Version: 1.0 (Apple Message framework v1081)
From: Eli Morris <ermorris@ucsc.edu>
In-Reply-To: <20100712134743.624249b2@harpe.intellique.com>
Date: Fri, 23 Jul 2010 01:30:40 -0700
Message-Id: <274A8D0C-4C31-4FB9-AB2D-BA3C31D497E0@ucsc.edu>
References: <DFB2DB04-A3BA-4272-A12A-4F28A7D51491@ucsc.edu>
	<20100712134743.624249b2@harpe.intellique.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Jul 12, 2010, at 4:47 AM, Emmanuel Florac wrote:

> Le Sun, 11 Jul 2010 18:10:41 -0700
> Eli Morris <ermorris@ucsc.edu> =E9crivait:
> =

>> Here are some of the log files from my XFS problem. Yes, I think this
>> all started with a hardware failure of some sort. My storage is RAID
>> 6, a an Astra SecureStor ES.
>> =

> =

> There are IO errors on sdc, sdd and sdg. Aren't these jbods connected
> through the same cable, for instance? You must correct the hardware
> problems before attempting any repair or it will do more harm than good.
> =

> -- =

> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                    |   Intellique
>                    |	<eflorac@intellique.com>
>                    |   +33 1 78 94 84 02
> ------------------------------------------------------------------------

Hi Emmanuel,

I think the raid tech support and me found and corrected the hardware probl=
ems associated with the RAID. I'm still having the same problem though. I e=
xpanded the filesystem to use the space of the now corrected RAID and that =
seems to work OK. I can write files to the new space OK. But then, if I run=
 xfs_repair on the volume, the newly added space disappears and there are t=
ons of error messages from xfs_repair (listed below)

thanks,

Eli

bad data fork in inode 2183564202
cleared inode 2183564202
inode 2183564204 - bad extent starting block number 18924700017, offset 0
.
.
.
entry "entries" in shortform directory 312244 references free inode 312298
junking entry "entries" in directory inode 312244
entry "README.txt" in shortform directory 312244 references free inode 3123=
96
junking entry "README.txt" in directory inode 312244
entry "format" in shortform directory 312244 references free inode 312399
junking entry "format" in directory inode 312244
entry "config.h.in.svn-base" at block 0 offset 48 in directory inode 312245=
 references free inode 312246
	clearing inode number in entry at offset 48...
entry "configure.svn-base" at block 0 offset 80 in directory inode 312245 r=
eferences free inode 312247
	clearing inode number in entry at offset 80...
entry "Makefile.in.svn-base" at block 0 offset 112 in directory inode 31224=
5 references free inode 312251
	clearing inode number in entry at offset 112...
entry "configure.in.svn-base" at block 0 offset 144 in directory inode 3122=
45 references free inode 312253
	clearing inode number in entry at offset 144...
entry "ChangeLog.svn-base" at block 0 offset 176 in directory inode 312245 =
references free inode 312254
	clearing inode number in entry at offset 176...
entry "0README.svn-base" at block 0 offset 208 in directory inode 312245 re=
ferences free inode 312263
	clearing inode number in entry at offset 208...
entry "DOMAIN.INFO" in shortform directory 312400 references free inode 312=
574
junking entry "DOMAIN.INFO" in directory inode 312400
entry "DOMAIN.CTL" in shortform directory 312400 references free inode 3125=
75
junking entry "DOMAIN.CTL" in directory inode 312400
entry "entries" in shortform directory 312562 references free inode 312570
junking entry "entries" in directory inode 312562
entry "README.txt" in shortform directory 312562 references free inode 3125=
72
junking entry "README.txt" in directory inode 312562
entry "format" in shortform directory 312562 references free inode 312573
junking entry "format" in directory inode 312562
entry "IC_P1993010100.ctl.svn-base" in shortform directory 312563 reference=
s free inode 312564
junking entry "IC_P1993010100.ctl.svn-base" in directory inode 312563
entry "SIGMAtoP.f.svn-base" in shortform directory 312563 references free i=
node 312565
junking entry "SIGMAtoP.f.svn-base" in directory inode 312563
entry "IC_P1994070100.ctl.svn-base" in shortform directory 312563 reference=
s free inode 312566
junking entry "IC_P1994070100.ctl.svn-base" in directory inode 312563
entry "entries" in shortform directory 312643 references free inode 312739
junking entry "entries" in directory inode 312643
entry "README.txt" in shortform directory 312643 references free inode 3127=
41
junking entry "README.txt" in directory inode 312643
entry "format" in shortform directory 312643 references free inode 312742
junking entry "format" in directory inode 312643
entry "cmap.param.svn-base" at block 0 offset 48 in directory inode 312644 =
references free inode 312645
	clearing inode number in entry at offset 48...
entry "cmap2000.param.svn-base" at block 0 offset 80 in directory inode 312=
644 references free inode 312646
	clearing inode number in entry at offset 80...
entry "cmap2001.param.svn-base" at block 0 offset 120 in directory inode 31=
2644 references free inode 312647
	clearing inode number in entry at offset 120...
entry "cruPGI3.x.svn-base" at block 0 offset 160 in directory inode 312644 =
references free inode 312648
	clearing inode number in entry at offset 160...
entry "cmap2002.param.svn-base" at block 0 offset 192 in directory inode 31=
2644 references free inode 312649
	clearing inode number in entry at offset 192...
entry "cruPGI5.x.svn-base" at block 0 offset 232 in directory inode 312644 =
references free inode 312650
	clearing inode number in entry at offset 232...
entry "CMAP2RCM.f.svn-base" at block 0 offset 264 in directory inode 312644=
 references free inode 312651
	clearing inode number in entry at offset 264...
entry "cmapIFC7.x.svn-base" at block 0 offset 296 in directory inode 312644=
 references free inode 312652
	clearing inode number in entry at offset 296...
 =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
