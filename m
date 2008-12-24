Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBOFXqPR022911 for <xfs@oss.sgi.com>; Wed, 24 Dec 2008 09:33:53 -0600
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B47F1787D09
	for <xfs@oss.sgi.com>; Wed, 24 Dec 2008 07:33:49 -0800 (PST)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com
	[208.42.117.202]) by cuda.sgi.com with ESMTP id
	On9kULd4lQBBbhHi for <xfs@oss.sgi.com>;
	Wed, 24 Dec 2008 07:33:49 -0800 (PST)
Message-ID: <49524FBD.4010304@thebarn.com>
Date: Wed, 24 Dec 2008 09:05:33 -0600
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: question ?
References: <49520C2D.5080601@euroimmun.de>
In-Reply-To: <49520C2D.5080601@euroimmun.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "M.Cypris" <m.cypris@euroimmun.de>
Cc: xfs-oss <xfs@oss.sgi.com>


A bit more info might be helpful.

Like the version of xfs_repair you are running.

Based on the message email address linux-xfs@oss.sgi.com
I'm guessing this is an older version of repair.

Please try a recent version of xfsprogs and see if the error still occurs.

-Russell




M.Cypris wrote:
> data fork in ino 4056744656 claims free block 521849722
> data fork in ino 4056744656 claims free block 521849723
> data fork in ino 4056744656 claims free block 521849724
> data fork in ino 4056744656 claims free block 521849725
> data fork in ino 4056744656 claims free block 521849726
> data fork in ino 4056744656 claims free block 521849727
> data fork in ino 4056744656 claims free block 521849729
> data fork in ino 4056744667 claims free block 319386679
>         - agno =3D 16
>         - agno =3D 17
>         - agno =3D 19
>         - agno =3D 20
>         - agno =3D 22
>         - agno =3D 23
>         - agno =3D 25
>         - agno =3D 26
>         - agno =3D 27
>         - agno =3D 29
>         - agno =3D 30
>         - agno =3D 31
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - clear lost+found (if it exists) ...
>         - clearing existing "lost+found" inode
>         - check for inodes claiming duplicate blocks...
>         - agno =3D 0
> entry "JSADM.exv" at block 0 offset 2616 in directory inode 39152 =

> references fre
> e inode 39742
>         clearing inode number in entry at offset 2616...
> entry "AdobeCMapFnt07.lst" at block 0 offset 2664 in directory inode =

> 39152 refer
>         clearing inode number in entry at offset 2664...
>         - agno =3D 1
> bad data fork in inode 268491301
> cleared inode 268491301
>         - agno =3D 2
> entry "calvar.ini" at block 0 offset 3136 in directory inode 536909609 =

> reference
> s free inode 536912996
>         clearing inode number in entry at offset 3136...
> entry "acad.mnr" at block 0 offset 3160 in directory inode 536909609 =

> references
>         clearing inode number in entry at offset 3160...
> entry "Thumbs.db" in shortform directory 536931591 references free =

> inode 5369316
> junking entry "Thumbs.db" in directory inode 536931591
>         - agno =3D 3
> data fork in ino 1073765375 claims dup extent, off - 0, start - =

> 404442312, cnt 1
> bad data fork in inode 1073765375
> cleared inode 1073765375
> entry "org.openoffice.Office.OptionsDialog.dat" at block 0 offset 3432 =

> in direct
> ory inode 1073771053 references free inode 1073772857
>         clearing inode number in entry at offset 3432...
> entry "files.MYI" at block 0 offset 2040 in directory inode 1073771423 =

> reference
> s free inode 1073758984
>         clearing inode number in entry at offset 2040...
> entry "favorites.frm" at block 0 offset 2136 in directory inode =

> 1073771423 refer
> ences free inode 1073782807
>         clearing inode number in entry at offset 2136...
> entry "files.MYD" at block 0 offset 2160 in directory inode 1073771423 =

> reference
> s free inode 1073795156
>         clearing inode number in entry at offset 2160...
> entry "Annotation_A0CCA60A-AB56-4EFD-83A5-8764BC08CDA8.atc" at block 0 =

> offset 52
> 0 in directory inode 1073782824 references free inode 1073800859
>         clearing inode number in entry at offset 520...
>         - agno =3D 5
> entry "btiryakioglu@online.metroturizm.com[2].txt" at block 20 offset =

> 2760 in di
> rectory inode 1342192000 references free inode 1342199976
>         clearing inode number in entry at offset 2760...
> data fork in regular inode 1342225423 claims used block 149306464
> correcting nblocks for inode 1342225423, was 3 - counted 0
>         - agno =3D 6
> entry "Color Settings.csf" at block 0 offset 72 in directory inode =

> 1610654999 re
> ferences free inode 1610668079
>         clearing inode number in entry at offset 72...
> entry "PluginCache.psp" at block 0 offset 2648 in directory inode =

> 1610654999 ref
> erences free inode 1610654496
>         - agno =3D 7
>         - agno =3D 8
>         - agno =3D 9
>         - agno =3D 10
> entry "KAgent.cfg" at block 0 offset 1896 in directory inode =

> 2699352171 referenc
>         clearing inode number in entry at offset 1896...
> entry "KTVR0.chl" at block 0 offset 1920 in directory inode 2699352171 =

> reference
> s free inode 2699400189
>         clearing inode number in entry at offset 1920...
>         - agno =3D 11
>         - agno =3D 12
>         - agno =3D 13
>         - agno =3D 14
>         - agno =3D 15
> entry "AdobeFnt00.lst" at block 0 offset 1400 in directory inode =

> 4052255567 refe
> rences free inode 4050601519
>         clearing inode number in entry at offset 1400...
> entry "AdobeFnt05.lst" at block 0 offset 2960 in directory inode =

> 4052255567 refe
> rences free inode 4048724573
>         clearing inode number in entry at offset 2960...
> entry "AdobeFnt04.lst" at block 0 offset 3072 in directory inode =

> 4052255567 refe
> rences free inode 4056487992
>         clearing inode number in entry at offset 3072...
>         - agno =3D 16
>         - agno =3D 17
>         - agno =3D 18
>         - agno =3D 19
>         - agno =3D 20
>         - agno =3D 21
>         - agno =3D 22
>         - agno =3D 23
>         - agno =3D 24
>         - agno =3D 25
>         - agno =3D 26
>         - agno =3D 27
>         - agno =3D 28
>         - agno =3D 29
>         - agno =3D 30
>         - agno =3D 31
> Phase 5 - rebuild AG headers and trees...
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - ensuring existence of lost+found directory
>         - traversing filesystem starting at / ...
> rebuilding directory inode 128
> rebuilding directory inode 536909609
> rebuilding directory inode 1073782824
> rebuilding directory inode 1073771053
> rebuilding directory inode 2699352171
> rebuilding directory inode 1610654999
> entry "settings.xml" in shortform directory inode 268470425 points to =

> free inode
>  268491301
> junking entry "settings.xml" in directory inode 268491301
> rebuilding directory inode 39152
> rebuilding directory inode 1073771423
> rebuilding directory inode 4052255567
> entry "settings.sol" in shortform directory inode 1073765024 points to =

> free inod
> e 1073765375
> junking entry "settings.sol" in directory inode 1073765375
> rebuilding directory inode 1342192000
>         - traversal finished ...
>         - traversing all unattached subtrees ...
>         - traversals finished ...
>         - moving disconnected inodes to lost+found ...
> disconnected inode 57710, moving to lost+found
> disconnected inode 57811, moving to lost+found
> disconnected inode 268483357, moving to lost+found
> disconnected inode 536909580, moving to lost+found
> disconnected inode 536911218, moving to lost+found
> disconnected inode 536931642, moving to lost+found
> disconnected inode 536931643, moving to lost+found
> disconnected inode 805320139, moving to lost+found
> disconnected inode 805321300, moving to lost+found
> disconnected inode 1073789249, moving to lost+found
> disconnected inode 1073794002, moving to lost+found
> disconnected inode 1073794734, moving to lost+found
> disconnected inode 1073800857, moving to lost+found
> disconnected inode 1073800862, moving to lost+found
> disconnected inode 1342188547, moving to lost+found
> disconnected inode 1342188653, moving to lost+found
> disconnected inode 1342200504, moving to lost+found
> disconnected inode 1342200509, moving to lost+found
> disconnected inode 1342209771, moving to lost+found
> disconnected inode 1342209840, moving to lost+found
> disconnected inode 1342209924, moving to lost+found
> disconnected inode 1342210023, moving to lost+found
> disconnected inode 1342210074, moving to lost+found
> disconnected inode 1342219122, moving to lost+found
> disconnected inode 1342219310, moving to lost+found
> disconnected inode 1342219363, moving to lost+found
> disconnected inode 1342219672, moving to lost+found
> disconnected inode 1342222775, moving to lost+found
> disconnected inode 1342222911, moving to lost+found
> disconnected inode 1342222942, moving to lost+found
> disconnected inode 1342225917, moving to lost+found
> disconnected inode 1342226754, moving to lost+found
> disconnected inode 1342227011, moving to lost+found
> disconnected inode 1342228292, moving to lost+found
> disconnected inode 1342228678, moving to lost+found
> disconnected inode 1342229022, moving to lost+found
> disconnected inode 1342229043, moving to lost+found
> disconnected inode 1342229161, moving to lost+found
> disconnected inode 1342229522, moving to lost+found
> disconnected inode 1342229554, moving to lost+found
> disconnected inode 1342230251, moving to lost+found
> disconnected inode 1342230257, moving to lost+found
> disconnected inode 1342230281, moving to lost+found
> disconnected inode 1342230303, moving to lost+found
> disconnected inode 1342230688, moving to lost+found
> disconnected inode 1342233033, moving to lost+found
> disconnected inode 1342233148, moving to lost+found
> disconnected inode 1342233194, moving to lost+found
> disconnected inode 1342233208, moving to lost+found
> disconnected inode 1342233234, moving to lost+found
> disconnected inode 1342233761, moving to lost+found
> disconnected inode 1342233778, moving to lost+found
> disconnected inode 1342234141, moving to lost+found
> disconnected inode 1342234258, moving to lost+found
> disconnected inode 1342234266, moving to lost+found
> disconnected inode 1610636053, moving to lost+found
> disconnected inode 1610654518, moving to lost+found
> disconnected inode 1610668967, moving to lost+found
> disconnected inode 2699400184, moving to lost+found
> disconnected inode 2699400185, moving to lost+found
> disconnected inode 4048724570, moving to lost+found
> disconnected inode 4050886573, moving to lost+found
> disconnected inode 4056744747, moving to lost+found
> Phase 7 - verify and correct link counts...
> resetting inode 268483470 nlinks from 1 to 2
> resetting inode 805320078 nlinks from 1 to 2
> resetting inode 805327953 nlinks from 1 to 2
> resetting inode 1073793449 nlinks from 1 to 2
> resetting inode 1342188688 nlinks from 1 to 2
> resetting inode 1342201396 nlinks from 1 to 2
> resetting inode 1342209294 nlinks from 1 to 2
> resetting inode 1342209618 nlinks from 1 to 2
> resetting inode 1342209654 nlinks from 1 to 2
> resetting inode 1342209917 nlinks from 1 to 2
> resetting inode 1342210104 nlinks from 1 to 2
> resetting inode 1342219214 nlinks from 1 to 2
> resetting inode 1342219224 nlinks from 1 to 2
> resetting inode 1342219346 nlinks from 1 to 2
> resetting inode 1342219390 nlinks from 1 to 2
> resetting inode 1342219706 nlinks from 1 to 2
> resetting inode 1342219793 nlinks from 1 to 2
> resetting inode 1342219978 nlinks from 1 to 2
> resetting inode 1342222896 nlinks from 1 to 2
> resetting inode 1342222946 nlinks from 1 to 2
> resetting inode 1342222955 nlinks from 1 to 2
> corrupt dinode 1342225423, extent total =3D 1, nblocks =3D 0.  This is a =
bug.
> Please report it to linux-xfs@oss.sgi.com.
>
> fatal error -- couldn't map inode 1342225423, err =3D 990
> linuxserver:/var/log # mount -a
>
>
> thanks
>
>
> -- =

> Matthias Cypris
> Head IT-Technik / IT-Einkauf
> EUROIMMUN AG
> Seekamp 31
> D-23560 L=FCbeck
> Phone:  +49 451 58 55-24351
> Fax:    +49 451 58 55-270
> m.cypris@euroimmun.de
> www.euroimmun.de
>
>
>
> ------------------------------------------------------------------------
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>   =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
