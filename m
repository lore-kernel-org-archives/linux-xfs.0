Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Jul 2006 07:20:33 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [66.45.37.187])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6SEKFDW016849
	for <xfs@oss.sgi.com>; Fri, 28 Jul 2006 07:20:15 -0700
Date: Fri, 28 Jul 2006 10:19:48 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Problem with xfs_repair
In-Reply-To: <20060728064505.GA14714@charite.de>
Message-ID: <Pine.LNX.4.64.0607281019400.30325@p34.internal.lan>
References: <20060728064505.GA14714@charite.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1170971333-1154096388=:30325"
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
Cc: xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1170971333-1154096388=:30325
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 28 Jul 2006, Ralf Hildebrandt wrote:

> xfs_repair gave me this when repairing my / fs using a knoppix boot cd:
>
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>        - zero log...
>        - scan filesystem freespace and inode maps...
>        - found root inode chunk
> Phase 3 - for each AG...
>        - scan and clear agi unlinked lists...
>        - process known inodes and perform inode discovery...
>        - agno =3D 0
>        - agno =3D 1
>        - agno =3D 2
>        - agno =3D 3
>        - agno =3D 4
>        - agno =3D 5
>        - agno =3D 6
>        - agno =3D 7
>        - agno =3D 8
>        - agno =3D 9
>        - agno =3D 10
>        - agno =3D 11
>        - agno =3D 12
>        - agno =3D 13
>        - agno =3D 14
>        - agno =3D 15
>        - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>        - setting up duplicate extent list...
>        - clear lost+found (if it exists) ...
>        - clearing existing "lost+found" inode
>        - marking entry "lost+found" to be deleted
>        - check for inodes claiming duplicate blocks...
>        - agno =3D 0
>        - agno =3D 1
>        - agno =3D 2
>        - agno =3D 3
>        - agno =3D 4
>        - agno =3D 5
>        - agno =3D 6
>        - agno =3D 7
>        - agno =3D 8
>        - agno =3D 9
>        - agno =3D 10
>        - agno =3D 11
>        - agno =3D 12
>        - agno =3D 13
>        - agno =3D 14
>        - agno =3D 15
> Phase 5 - rebuild AG headers and trees...
>        - reset superblock...
> Phase 6 - check inode connectivity...
>        - resetting contents of realtime bitmap and summary inodes
>        - ensuring existence of lost+found directory
>        - traversing filesystem starting at / ...
> rebuilding directory inode 128
>
> fatal error -- can't read block 16777216 for directory inode 167785633
>
> a) How can I find out which file/directory this inode belongs to?
> b) Can I mark the block defektiv somehow?
>
> --=20
> Ralf Hildebrandt (i.A. des IT-Zentrums)         Ralf.Hildebrandt@charite.=
de
> Charite - Universit=E4tsmedizin Berlin            Tel.  +49 (0)30-450 570=
-155
> Gemeinsame Einrichtung von FU- und HU-Berlin    Fax.  +49 (0)30-450 570-9=
62
> IT-Zentrum Standort CBF                 send no mail to spamtrap@charite.=
de
>
>

Is your knoppix boot cd 5.0.1 =3D=3D 2.6.17 =3D=3D bugged kernel? ;P
---1463747160-1170971333-1154096388=:30325--
