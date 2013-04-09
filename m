Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 980527FBF
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 10:19:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2603BAC003
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 08:18:59 -0700 (PDT)
Received: from mail-ie0-f177.google.com (mail-ie0-f177.google.com
	[209.85.223.177]) by cuda.sgi.com with ESMTP id
	atx6zKqcJ3zwVaji (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Apr 2013 08:18:56 -0700 (PDT)
Received: by mail-ie0-f177.google.com with SMTP id tp5so8330705ieb.8
	for <xfs@oss.sgi.com>; Tue, 09 Apr 2013 08:18:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51642E5E.3040403@sandeen.net>
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<51642E5E.3040403@sandeen.net>
Date: Tue, 9 Apr 2013 23:18:56 +0800
Message-ID: <CADFMGuL7968v6L-3=j3FY3YYjeA_XH1CyuLgnL88u-abxiwHvg@mail.gmail.com>
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
From: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3216925519987356353=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

--===============3216925519987356353==
Content-Type: multipart/alternative; boundary=089e0111e0746d28cd04d9ef12a1

--089e0111e0746d28cd04d9ef12a1
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

The servers are back to service now and It's hard to run xfs_repair. It
always happen bellow is the xfs_repair log when it happens on another
server several days ago.
 -sh-4.1$ sudo xfs_repair -n /dev/glustervg/glusterlv
Phase 1 - find and verify superblock=A1=AD
Phase 2 - using internal log
        - scan filesystem freespace and inode maps=A1=AD
agi unlinked bucket 0 is 4046848 in ag 0 (inode=3D4046848)
agi unlinked bucket 5 is 2340485 in ag 0 (inode=3D2340485)
agi unlinked bucket 6 is 2326854 in ag 0 (inode=3D2326854)
agi unlinked bucket 8 is 1802120 in ag 0 (inode=3D1802120)
agi unlinked bucket 14 is 495566 in ag 0 (inode=3D495566)
agi unlinked bucket 16 is 5899536 in ag 0 (inode=3D5899536)
agi unlinked bucket 19 is 4008211 in ag 0 (inode=3D4008211)
agi unlinked bucket 21 is 4906965 in ag 0 (inode=3D4906965)
agi unlinked bucket 23 is 2022231 in ag 0 (inode=3D2022231)
agi unlinked bucket 24 is 1626200 in ag 0 (inode=3D1626200)
agi unlinked bucket 25 is 938585 in ag 0 (inode=3D938585)
agi unlinked bucket 30 is 4226526 in ag 0 (inode=3D4226526)
agi unlinked bucket 34 is 4108962 in ag 0 (inode=3D4108962)
agi unlinked bucket 37 is 1740389 in ag 0 (inode=3D1740389)
agi unlinked bucket 39 is 247399 in ag 0 (inode=3D247399)
agi unlinked bucket 40 is 6237864 in ag 0 (inode=3D6237864)
agi unlinked bucket 43 is 3404331 in ag 0 (inode=3D3404331)
agi unlinked bucket 45 is 2092717 in ag 0 (inode=3D2092717)
agi unlinked bucket 48 is 4041008 in ag 0 (inode=3D4041008)
agi unlinked bucket 50 is 1459762 in ag 0 (inode=3D1459762)
agi unlinked bucket 56 is 852024 in ag 0 (inode=3D852024)
        - found root in ode chunk
Phase 3 - for each AG=A1=AD
        - scan (but don't clear) agi unlinked lists=A1=AD
        - process known inodes and perform inode discovery=A1=AD
        - agno =3D 0
7f084d34e700: Badness in key lookup (length)
bp=3D(bno 123696, len 16384 bytes) key=3D(bno 123696, len 8192 bytes)
7f084d34e700: Badness in key lookup (length)
bp=3D(bno 247776, len 16384 bytes) key=3D(bno 247776, len 8192 bytes)
7f084d34e700: Badness in key lookup (length)
bp=3D(bno 425984, len 16384 bytes) key=3D(bno 425984, len 8192 bytes)
7f084d34e700: Badness in key lookup (length)
bp=3D(bno 469280, len 16384 bytes) key=3D(bno 469280, len 8192 bytes)
7f084d34e700: Badness in key lookup (length)
bp=3D(bno 729856, len 16384 bytes) key=3D(bno 729856, len 8192 bytes)
7f084d34e700: Badness in key lookup (length)
bp=3D(bno 813072, len 16384 bytes) key=3D(bno 813072, len 8192 bytes)
7f084d34e700: Badness in key lookup (length)
bp=3D(bno 870176, len 16384 bytes) key=3D(bno 870176, len 8192 bytes)
7f084d34e700: Badness in key lookup (length)
bp=3D(bno 901056, len 16384 bytes) key=3D(bno 901056, len 8192 bytes)
7f084d34e700: Badness in key lookup (length)
bp=3D(bno 1011104, len 16384 bytes) key=3D(bno 1011104, len 8192 bytes)
7f084d34e700: Badness in key lookup (length)
bp=3D(bno 1046336, len 16384 bytes) key=3D(bno 1046336, len 8192 bytes)
7f084d34e700: Badness in key lookup (length)
bp=3D(bno 1163424, len 16384 bytes) key=3D(bno 1163424, len 8192 bytes)
7f084d34e700: Badness in key lookup (length)
bp=3D(bno 1170240, len 16384 bytes) key=3D(bno 1170240, len 8192 bytes)
7f084d34e700: Badness in key lookup (length)
bp=3D(bno 1702160, len 16384 bytes) key=3D(bno 1702160, len 8192 bytes)
7f084d34e700: Badness in key lookup (length)
bp=3D(bno 2004096, len 16384 bytes) key=3D(bno 2004096, len 8192 bytes)
7f084d34e700: Badness in key lookup (length)
bp=3D(bno 2020496, len 16384 bytes) key=3D(bno 2020496, len 8192 bytes)
7f084d34e700: Badness in key lookup (length)
bp=3D(bno 2023408, len 16384 bytes) key=3D(bno 2023408, len 8192 bytes)
7f084d34e700: Badness in key lookup (length)
bp=3D(bno 2054464, len 16384 bytes) key=3D(bno 2054464, len 8192 bytes)
7f084d34e700: Badness in key lookup (length)
bp=3D(bno 2113232, len 16384 bytes) key=3D(bno 2113232, len 8192 bytes)
7f084d34e700: Badness in key lookup (length)
bp=3D(bno 2453472, len 16384 bytes) key=3D(bno 2453472, len 8192 bytes)
7f084d34e700: Badness in key lookup (length)
bp=3D(bno 2949760, len 16384 bytes) key=3D(bno 2949760, len 8192 bytes)
7f084d34e700: Badness in key lookup (length)
bp=3D(bno 3118912, len 16384 bytes) key=3D(bno 3118912, len 8192 bytes)
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - agno =3D 8
        - agno =3D 9
        - agno =3D 10
        - agno =3D 11
        - agno =3D 12
        - agno =3D 13
        - agno =3D 14
        - agno =3D 15
        - agno =3D 16
        - agno =3D 17
        - agno =3D 18
        - agno =3D 19
        - agno =3D 20
        - agno =3D 21
        - agno =3D 22
        - agno =3D 23
        - agno =3D 24
        - agno =3D 25
        - agno =3D 26
        - agno =3D 27
        - agno =3D 28
        - agno =3D 29
        - agno =3D 30
        - process newly discovered in odes..
Phase 4 - check for duplicate blocks=A1=AD
        - setting up duplicate extent list=A1=AD
        - check for inodes claiming duplicate blocks=A1=AD
        - agno =3D 0
        - agno =3D 1
        - agno =3D 3
        - agno =3D 9
        - agno =3D 12
        - agno =3D 14
        - agno =3D 5
        - agno =3D 19
        - agno =3D 23
        - agno =3D 24
        - agno =3D 25
        - agno =3D 26
        - agno =3D 27
        - agno =3D 28
        - agno =3D 29
        - agno =3D 30
        - agno =3D 4
        - agno =3D 2
        - agno =3D 17
        - agno =3D 6
        - agno =3D 8
        - agno =3D 16
        - agno =3D 11
        - agno =3D 10
        - agno =3D 18
        - agno =3D 13
        - agno =3D 15
        - agno =3D 20
        - agno =3D 22
        - agno =3D 21
        - agno =3D 7
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity=A1=AD
        - traversing filesystem =A1=AD
        - traversal finished =A1=AD
        - moving disconnected inodes to lost+found =A1=AD
disconnected inode 6235944, would move to lost+found
Phase 7 - verify link counts=A1=AD
would have reset inode 6235944 nlinks from 0 to 1
No modify flag set, skipping filesystem flush and exiting..



=B5=DA=B6=FE=B2=BD
repair=B5=C4log

sh-4.1$ sudo xfs_repair /dev/glustervg/glusterlv
Phase 1 - find and verify superblock=A1=AD
Phase 2 - using internal log
        - zero log=A1=AD
        - scan filesystem freespace and inode maps=A1=AD
agi unlinked bucket 0 is 4046848 in ag 0 (inode=3D4046848)
agi unlinked bucket 5 is 2340485 in ag 0 (inode=3D2340485)
agi unlinked bucket 6 is 2326854 in ag 0 (inode=3D2326854)
agi unlinked bucket 8 is 1802120 in ag 0 (inode=3D1802120)
agi unlinked bucket 14 is 495566 in ag 0 (inode=3D495566)
agi unlinked bucket 16 is 5899536 in ag 0 (inode=3D5899536)
agi unlinked bucket 19 is 4008211 in ag 0 (inode=3D4008211)
agi unlinked bucket 21 is 4906965 in ag 0 (inode=3D4906965)
agi unlinked bucket 23 is 2022231 in ag 0 (inode=3D2022231)
agi unlinked bucket 24 is 1626200 in ag 0 (inode=3D1626200)
agi unlinked bucket 25 is 938585 in ag 0 (inode=3D938585)
agi unlinked bucket 30 is 4226526 in ag 0 (inode=3D4226526)
agi unlinked bucket 34 is 4108962 in ag 0 (inode=3D4108962)
agi unlinked bucket 37 is 1740389 in ag 0 (inode=3D1740389)
agi unlinked bucket 39 is 247399 in ag 0 (inode=3D247399)
agi unlinked bucket 40 is 6237864 in ag 0 (inode=3D6237864)
agi unlinked bucket 43 is 3404331 in ag 0 (inode=3D3404331)
agi unlinked bucket 45 is 2092717 in ag 0 (inode=3D2092717)
agi unlinked bucket 48 is 4041008 in ag 0 (inode=3D4041008)
agi unlinked bucket 50 is 1459762 in ag 0 (inode=3D1459762)
agi unlinked bucket 56 is 852024 in ag 0 (inode=3D852024)
        - found root in ode chunk
Phase 3 - for each AG=A1=AD
        - scan and clear agi unlinked lists=A1=AD
        - process known inodes and perform inode discovery=A1=AD
        - agno =3D 0
7f8220be6700: Badness in key lookup (length)
bp=3D(bno 123696, len 16384 bytes) key=3D(bno 123696, len 8192 bytes)
7f8220be6700: Badness in key lookup (length)
bp=3D(bno 247776, len 16384 bytes) key=3D(bno 247776, len 8192 bytes)
7f8220be6700: Badness in key lookup (length)
bp=3D(bno 425984, len 16384 bytes) key=3D(bno 425984, len 8192 bytes)
7f8220be6700: Badness in key lookup (length)
bp=3D(bno 469280, len 16384 bytes) key=3D(bno 469280, len 8192 bytes)
7f8220be6700: Badness in key lookup (length)
bp=3D(bno 729856, len 16384 bytes) key=3D(bno 729856, len 8192 bytes)
7f8220be6700: Badness in key lookup (length)
bp=3D(bno 813072, len 16384 bytes) key=3D(bno 813072, len 8192 bytes)
7f8220be6700: Badness in key lookup (length)
bp=3D(bno 870176, len 16384 bytes) key=3D(bno 870176, len 8192 bytes)
7f8220be6700: Badness in key lookup (length)
bp=3D(bno 901056, len 16384 bytes) key=3D(bno 901056, len 8192 bytes)
7f8220be6700: Badness in key lookup (length)
bp=3D(bno 1011104, len 16384 bytes) key=3D(bno 1011104, len 8192 bytes)
7f8220be6700: Badness in key lookup (length)
bp=3D(bno 1046336, len 16384 bytes) key=3D(bno 1046336, len 8192 bytes)
7f8220be6700: Badness in key lookup (length)
bp=3D(bno 1163424, len 16384 bytes) key=3D(bno 1163424, len 8192 bytes)
7f8220be6700: Badness in key lookup (length)
bp=3D(bno 1170240, len 16384 bytes) key=3D(bno 1170240, len 8192 bytes)
7f8220be6700: Badness in key lookup (length)
bp=3D(bno 1702160, len 16384 bytes) key=3D(bno 1702160, len 8192 bytes)
7f8220be6700: Badness in key lookup (length)
bp=3D(bno 2004096, len 16384 bytes) key=3D(bno 2004096, len 8192 bytes)
7f8220be6700: Badness in key lookup (length)
bp=3D(bno 2020496, len 16384 bytes) key=3D(bno 2020496, len 8192 bytes)
7f8220be6700: Badness in key lookup (length)
bp=3D(bno 2023408, len 16384 bytes) key=3D(bno 2023408, len 8192 bytes)
7f8220be6700: Badness in key lookup (length)
bp=3D(bno 2054464, len 16384 bytes) key=3D(bno 2054464, len 8192 bytes)
7f8220be6700: Badness in key lookup (length)
bp=3D(bno 2113232, len 16384 bytes) key=3D(bno 2113232, len 8192 bytes)
7f8220be6700: Badness in key lookup (length)
bp=3D(bno 2453472, len 16384 bytes) key=3D(bno 2453472, len 8192 bytes)
7f8220be6700: Badness in key lookup (length)
bp=3D(bno 2949760, len 16384 bytes) key=3D(bno 2949760, len 8192 bytes)
7f8220be6700: Badness in key lookup (length)
bp=3D(bno 3118912, len 16384 bytes) key=3D(bno 3118912, len 8192 bytes)
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - agno =3D 8
        - agno =3D 9
        - agno =3D 10
        - agno =3D 11
        - agno =3D 12
        - agno =3D 13
        - agno =3D 14
        - agno =3D 15
        - agno =3D 16
        - agno =3D 17
        - agno =3D 18
        - agno =3D 19
        - agno =3D 20
        - agno =3D 21
        - agno =3D 22
        - agno =3D 23
        - agno =3D 24
        - agno =3D 25
        - agno =3D 26
        - agno =3D 27
        - agno =3D 28
        - agno =3D 29
        - agno =3D 30
        - process newly discovered in odes..
Phase 4 - check for duplicate blocks=A1=AD
        - setting up duplicate extent list=A1=AD
        - check for inodes claiming duplicate blocks=A1=AD
        - agno =3D 0
        - agno =3D 4
        - agno =3D 2
        - agno =3D 3
        - agno =3D 7
        - agno =3D 18
        - agno =3D 28
        - agno =3D 6
        - agno =3D 5
        - agno =3D 1
        - agno =3D 26
        - agno =3D 8
        - agno =3D 14
        - agno =3D 17
        - agno =3D 16
        - agno =3D 10
        - agno =3D 20
        - agno =3D 13
        - agno =3D 15
        - agno =3D 11
        - agno =3D 19
        - agno =3D 22
        - agno =3D 21
        - agno =3D 23
        - agno =3D 9
        - agno =3D 12
        - agno =3D 24
        - agno =3D 27
        - agno =3D 25
        - agno =3D 29
        - agno =3D 30
Phase 5 - rebuild AG headers and trees=A1=AD
        - reset superblock=A1=AD
Phase 6 - check inode connectivity=A1=AD
        - resetting contents of realtime bitmap and summary in odes
        - traversing filesystem =A1=AD
        - traversal finished =A1=AD
        - moving disconnected inodes to lost+found =A1=AD
disconnected inode 6235944, moving to lost+found
Phase 7 - verify and correct link counts=A1=AD
done
sh-4.1$ .


2013/4/9 Eric Sandeen <sandeen@sandeen.net>

> On 4/9/13 7:53 AM, =B7=FB=D3=C0=CC=CE wrote:
> > Dear xfs experts,
> > I really need your help sincerely!!! In our production enviroment we
> > run glusterfs over top of xfs on Dell x720D(Raid 6). And the xfs file
> > system crash on some of the server frequently about every two weeks.
> > Can you help to give me a direction about how to debug this issue and
> > how to avoid it? Thank you very very much!
>
> So this happens reliably, but infrequently? (only every 2 weeks or so?)
>
> Can you provoke it any more often?
>
> > uname -a
> > Linux cqdx.miaoyan.cluster1.node11.qiyi.domain 2.6.32-279.el6.x86_64
> > #1 SMP Wed Jun 13 18:24:36 EDT 2012 x86_64 x86_64 x86_64 GNU/Linux
>
> That's a RHEL6 kernel; I'm assuming that this is a RHEL clone w/o RH
> support?
>
> I agree with Ben that I'd like to see xfs_repair output.
>
> Since the fs has shut down, you should unmount, remount, and unmount
> again to replay the dirty log.  Then do xfs_repair -n, and provide the
> output
> if it discovers any errors.
>
> Thanks,
> -Eric
>
> > Every time the crash log is same, as following
> >
> > 038 Apr  9 09:41:36 cqdx kernel: XFS (sdb): xfs_iunlink_remove:
> > xfs_inotobp() returned error 22.
> > 1039 Apr  9 09:41:36 cqdx kernel: XFS (sdb): xfs_inactive: xfs_ifree
> > returned error 22
> > 1040 Apr  9 09:41:36 cqdx kernel: XFS (sdb):
> > xfs_do_force_shutdown(0x1) called from line 1184 of file
> > fs/xfs/xfs_vnodeops.c.  Return address =3D 0xffffffffa02ee20a
> > 1041 Apr  9 09:41:36 cqdx kernel: XFS (sdb): I/O Error Detected.
> > Shutting down filesystem
> > 1042 Apr  9 09:41:36 cqdx kernel: XFS (sdb): Please umount the
> > filesystem and rectify the problem(s)
> > 1043 Apr  9 09:41:53 cqdx kernel: XFS (sdb): xfs_log_force: error 5
> returned.
> > 1044 Apr  9 09:42:23 cqdx kernel: XFS (sdb): xfs_log_force: error 5
> returned.
> > 1045 Apr  9 09:42:53 cqdx kernel: XFS (sdb): xfs_log_force: error 5
> returned.
> > 1046 Apr  9 09:43:23 cqdx kernel: XFS (sdb): xfs_log_force: error 5
> returned.
> >
>
>


--=20
=B7=FB=D3=C0=CC=CE

--089e0111e0746d28cd04d9ef12a1
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">The servers are back to service now and It&#39;s hard to r=
un xfs_repair. It always happen bellow is the xfs_repair log when it happen=
s on another server several days ago. <br>&nbsp;-sh-4.1$ sudo xfs_repair -n=
 /dev/glustervg/glusterlv<br>
Phase 1 - find and verify superblock&hellip;<br>Phase 2 - using internal lo=
g<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - scan filesystem freespace=
 and inode maps&hellip;<br>agi unlinked bucket 0 is 4046848 in ag 0 (inode=
=3D4046848)<br>agi unlinked bucket 5 is 2340485 in ag 0 (inode=3D2340485)<b=
r>
agi unlinked bucket 6 is 2326854 in ag 0 (inode=3D2326854)<br>agi unlinked =
bucket 8 is 1802120 in ag 0 (inode=3D1802120)<br>agi unlinked bucket 14 is =
495566 in ag 0 (inode=3D495566)<br>agi unlinked bucket 16 is 5899536 in ag =
0 (inode=3D5899536)<br>
agi unlinked bucket 19 is 4008211 in ag 0 (inode=3D4008211)<br>agi unlinked=
 bucket 21 is 4906965 in ag 0 (inode=3D4906965)<br>agi unlinked bucket 23 i=
s 2022231 in ag 0 (inode=3D2022231)<br>agi unlinked bucket 24 is 1626200 in=
 ag 0 (inode=3D1626200)<br>
agi unlinked bucket 25 is 938585 in ag 0 (inode=3D938585)<br>agi unlinked b=
ucket 30 is 4226526 in ag 0 (inode=3D4226526)<br>agi unlinked bucket 34 is =
4108962 in ag 0 (inode=3D4108962)<br>agi unlinked bucket 37 is 1740389 in a=
g 0 (inode=3D1740389)<br>
agi unlinked bucket 39 is 247399 in ag 0 (inode=3D247399)<br>agi unlinked b=
ucket 40 is 6237864 in ag 0 (inode=3D6237864)<br>agi unlinked bucket 43 is =
3404331 in ag 0 (inode=3D3404331)<br>agi unlinked bucket 45 is 2092717 in a=
g 0 (inode=3D2092717)<br>
agi unlinked bucket 48 is 4041008 in ag 0 (inode=3D4041008)<br>agi unlinked=
 bucket 50 is 1459762 in ag 0 (inode=3D1459762)<br>agi unlinked bucket 56 i=
s 852024 in ag 0 (inode=3D852024)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; - found root in ode chunk<br>Phase 3 - for each AG&hellip;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - scan (but don&#39;t clear) agi=
 unlinked lists&hellip;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - pro=
cess known inodes and perform inode discovery&hellip;<br>&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 0<br>7f084d34e700: Badness in key looku=
p (length)<br>bp=3D(bno 123696, len 16384 bytes) key=3D(bno 123696, len 819=
2 bytes)<br>
7f084d34e700: Badness in key lookup (length)<br>bp=3D(bno 247776, len 16384=
 bytes) key=3D(bno 247776, len 8192 bytes)<br>7f084d34e700: Badness in key =
lookup (length)<br>bp=3D(bno 425984, len 16384 bytes) key=3D(bno 425984, le=
n 8192 bytes)<br>
7f084d34e700: Badness in key lookup (length)<br>bp=3D(bno 469280, len 16384=
 bytes) key=3D(bno 469280, len 8192 bytes)<br>7f084d34e700: Badness in key =
lookup (length)<br>bp=3D(bno 729856, len 16384 bytes) key=3D(bno 729856, le=
n 8192 bytes)<br>
7f084d34e700: Badness in key lookup (length)<br>bp=3D(bno 813072, len 16384=
 bytes) key=3D(bno 813072, len 8192 bytes)<br>7f084d34e700: Badness in key =
lookup (length)<br>bp=3D(bno 870176, len 16384 bytes) key=3D(bno 870176, le=
n 8192 bytes)<br>
7f084d34e700: Badness in key lookup (length)<br>bp=3D(bno 901056, len 16384=
 bytes) key=3D(bno 901056, len 8192 bytes)<br>7f084d34e700: Badness in key =
lookup (length)<br>bp=3D(bno 1011104, len 16384 bytes) key=3D(bno 1011104, =
len 8192 bytes)<br>
7f084d34e700: Badness in key lookup (length)<br>bp=3D(bno 1046336, len 1638=
4 bytes) key=3D(bno 1046336, len 8192 bytes)<br>7f084d34e700: Badness in ke=
y lookup (length)<br>bp=3D(bno 1163424, len 16384 bytes) key=3D(bno 1163424=
, len 8192 bytes)<br>
7f084d34e700: Badness in key lookup (length)<br>bp=3D(bno 1170240, len 1638=
4 bytes) key=3D(bno 1170240, len 8192 bytes)<br>7f084d34e700: Badness in ke=
y lookup (length)<br>bp=3D(bno 1702160, len 16384 bytes) key=3D(bno 1702160=
, len 8192 bytes)<br>
7f084d34e700: Badness in key lookup (length)<br>bp=3D(bno 2004096, len 1638=
4 bytes) key=3D(bno 2004096, len 8192 bytes)<br>7f084d34e700: Badness in ke=
y lookup (length)<br>bp=3D(bno 2020496, len 16384 bytes) key=3D(bno 2020496=
, len 8192 bytes)<br>
7f084d34e700: Badness in key lookup (length)<br>bp=3D(bno 2023408, len 1638=
4 bytes) key=3D(bno 2023408, len 8192 bytes)<br>7f084d34e700: Badness in ke=
y lookup (length)<br>bp=3D(bno 2054464, len 16384 bytes) key=3D(bno 2054464=
, len 8192 bytes)<br>
7f084d34e700: Badness in key lookup (length)<br>bp=3D(bno 2113232, len 1638=
4 bytes) key=3D(bno 2113232, len 8192 bytes)<br>7f084d34e700: Badness in ke=
y lookup (length)<br>bp=3D(bno 2453472, len 16384 bytes) key=3D(bno 2453472=
, len 8192 bytes)<br>
7f084d34e700: Badness in key lookup (length)<br>bp=3D(bno 2949760, len 1638=
4 bytes) key=3D(bno 2949760, len 8192 bytes)<br>7f084d34e700: Badness in ke=
y lookup (length)<br>bp=3D(bno 3118912, len 16384 bytes) key=3D(bno 3118912=
, len 8192 bytes)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 1<br>&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 2<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; - agno =3D 3<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agn=
o =3D 4<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 5<br>&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 6<br>&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; - agno =3D 7<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; - agno =3D 8<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D=
 9<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 10<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 11<br>&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 12<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; - agno =3D 13<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - =
agno =3D 14<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 15<br>=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 16<br>&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 17<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; - agno =3D 18<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - =
agno =3D 19<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 20<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 21<br>&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 22<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; - agno =3D 23<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - =
agno =3D 24<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 25<br>=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 26<br>&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 27<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; - agno =3D 28<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - =
agno =3D 29<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 30<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - process newly discovered in od=
es..<br>Phase 4 - check for duplicate blocks&hellip;<br>&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; - setting up duplicate extent list&hellip;<br>&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - check for inodes claiming duplicate=
 blocks&hellip;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 0<=
br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 1<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 3<br>&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 9<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; - agno =3D 12<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - ag=
no =3D 14<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 5<br>&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 19<br>&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 23<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; - agno =3D 24<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agn=
o =3D 25<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 26<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 27<br>&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 28<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; - agno =3D 29<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - =
agno =3D 30<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 4<br>&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 2<br>&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 17<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; - agno =3D 6<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agn=
o =3D 8<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 16<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 11<br>&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 10<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; - agno =3D 18<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - =
agno =3D 13<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 15<br>=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 20<br>&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 22<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; - agno =3D 21<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - =
agno =3D 7<br>No modify flag set, skipping phase 5<br>
Phase 6 - check inode connectivity&hellip;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; - traversing filesystem &hellip;<br>&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; - traversal finished &hellip;<br>&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; - moving disconnected inodes to lost+found &hellip;<br>d=
isconnected inode 6235944, would move to lost+found<br>
Phase 7 - verify link counts&hellip;<br>would have reset inode 6235944 nlin=
ks from 0 to 1<br>No modify flag set, skipping filesystem flush and exiting=
..<br><br><br><br>=B5=DA=B6=FE=B2=BD<br>repair=B5=C4log<br><br>sh-4.1$ sudo=
 xfs_repair /dev/glustervg/glusterlv<br>
Phase 1 - find and verify superblock&hellip;<br>Phase 2 - using internal lo=
g<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - zero log&hellip;<br>&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - scan filesystem freespace and inode=
 maps&hellip;<br>agi unlinked bucket 0 is 4046848 in ag 0 (inode=3D4046848)=
<br>agi unlinked bucket 5 is 2340485 in ag 0 (inode=3D2340485)<br>
agi unlinked bucket 6 is 2326854 in ag 0 (inode=3D2326854)<br>agi unlinked =
bucket 8 is 1802120 in ag 0 (inode=3D1802120)<br>agi unlinked bucket 14 is =
495566 in ag 0 (inode=3D495566)<br>agi unlinked bucket 16 is 5899536 in ag =
0 (inode=3D5899536)<br>
agi unlinked bucket 19 is 4008211 in ag 0 (inode=3D4008211)<br>agi unlinked=
 bucket 21 is 4906965 in ag 0 (inode=3D4906965)<br>agi unlinked bucket 23 i=
s 2022231 in ag 0 (inode=3D2022231)<br>agi unlinked bucket 24 is 1626200 in=
 ag 0 (inode=3D1626200)<br>
agi unlinked bucket 25 is 938585 in ag 0 (inode=3D938585)<br>agi unlinked b=
ucket 30 is 4226526 in ag 0 (inode=3D4226526)<br>agi unlinked bucket 34 is =
4108962 in ag 0 (inode=3D4108962)<br>agi unlinked bucket 37 is 1740389 in a=
g 0 (inode=3D1740389)<br>
agi unlinked bucket 39 is 247399 in ag 0 (inode=3D247399)<br>agi unlinked b=
ucket 40 is 6237864 in ag 0 (inode=3D6237864)<br>agi unlinked bucket 43 is =
3404331 in ag 0 (inode=3D3404331)<br>agi unlinked bucket 45 is 2092717 in a=
g 0 (inode=3D2092717)<br>
agi unlinked bucket 48 is 4041008 in ag 0 (inode=3D4041008)<br>agi unlinked=
 bucket 50 is 1459762 in ag 0 (inode=3D1459762)<br>agi unlinked bucket 56 i=
s 852024 in ag 0 (inode=3D852024)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; - found root in ode chunk<br>Phase 3 - for each AG&hellip;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - scan and clear agi unlinked li=
sts&hellip;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - process known i=
nodes and perform inode discovery&hellip;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; - agno =3D 0<br>7f8220be6700: Badness in key lookup (length)<b=
r>bp=3D(bno 123696, len 16384 bytes) key=3D(bno 123696, len 8192 bytes)<br>
7f8220be6700: Badness in key lookup (length)<br>bp=3D(bno 247776, len 16384=
 bytes) key=3D(bno 247776, len 8192 bytes)<br>7f8220be6700: Badness in key =
lookup (length)<br>bp=3D(bno 425984, len 16384 bytes) key=3D(bno 425984, le=
n 8192 bytes)<br>
7f8220be6700: Badness in key lookup (length)<br>bp=3D(bno 469280, len 16384=
 bytes) key=3D(bno 469280, len 8192 bytes)<br>7f8220be6700: Badness in key =
lookup (length)<br>bp=3D(bno 729856, len 16384 bytes) key=3D(bno 729856, le=
n 8192 bytes)<br>
7f8220be6700: Badness in key lookup (length)<br>bp=3D(bno 813072, len 16384=
 bytes) key=3D(bno 813072, len 8192 bytes)<br>7f8220be6700: Badness in key =
lookup (length)<br>bp=3D(bno 870176, len 16384 bytes) key=3D(bno 870176, le=
n 8192 bytes)<br>
7f8220be6700: Badness in key lookup (length)<br>bp=3D(bno 901056, len 16384=
 bytes) key=3D(bno 901056, len 8192 bytes)<br>7f8220be6700: Badness in key =
lookup (length)<br>bp=3D(bno 1011104, len 16384 bytes) key=3D(bno 1011104, =
len 8192 bytes)<br>
7f8220be6700: Badness in key lookup (length)<br>bp=3D(bno 1046336, len 1638=
4 bytes) key=3D(bno 1046336, len 8192 bytes)<br>7f8220be6700: Badness in ke=
y lookup (length)<br>bp=3D(bno 1163424, len 16384 bytes) key=3D(bno 1163424=
, len 8192 bytes)<br>
7f8220be6700: Badness in key lookup (length)<br>bp=3D(bno 1170240, len 1638=
4 bytes) key=3D(bno 1170240, len 8192 bytes)<br>7f8220be6700: Badness in ke=
y lookup (length)<br>bp=3D(bno 1702160, len 16384 bytes) key=3D(bno 1702160=
, len 8192 bytes)<br>
7f8220be6700: Badness in key lookup (length)<br>bp=3D(bno 2004096, len 1638=
4 bytes) key=3D(bno 2004096, len 8192 bytes)<br>7f8220be6700: Badness in ke=
y lookup (length)<br>bp=3D(bno 2020496, len 16384 bytes) key=3D(bno 2020496=
, len 8192 bytes)<br>
7f8220be6700: Badness in key lookup (length)<br>bp=3D(bno 2023408, len 1638=
4 bytes) key=3D(bno 2023408, len 8192 bytes)<br>7f8220be6700: Badness in ke=
y lookup (length)<br>bp=3D(bno 2054464, len 16384 bytes) key=3D(bno 2054464=
, len 8192 bytes)<br>
7f8220be6700: Badness in key lookup (length)<br>bp=3D(bno 2113232, len 1638=
4 bytes) key=3D(bno 2113232, len 8192 bytes)<br>7f8220be6700: Badness in ke=
y lookup (length)<br>bp=3D(bno 2453472, len 16384 bytes) key=3D(bno 2453472=
, len 8192 bytes)<br>
7f8220be6700: Badness in key lookup (length)<br>bp=3D(bno 2949760, len 1638=
4 bytes) key=3D(bno 2949760, len 8192 bytes)<br>7f8220be6700: Badness in ke=
y lookup (length)<br>bp=3D(bno 3118912, len 16384 bytes) key=3D(bno 3118912=
, len 8192 bytes)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 1<br>&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 2<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; - agno =3D 3<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agn=
o =3D 4<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 5<br>&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 6<br>&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; - agno =3D 7<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; - agno =3D 8<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D=
 9<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 10<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 11<br>&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 12<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; - agno =3D 13<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - =
agno =3D 14<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 15<br>=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 16<br>&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 17<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; - agno =3D 18<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - =
agno =3D 19<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 20<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 21<br>&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 22<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; - agno =3D 23<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - =
agno =3D 24<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 25<br>=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 26<br>&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 27<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; - agno =3D 28<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - =
agno =3D 29<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 30<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - process newly discovered in od=
es..<br>Phase 4 - check for duplicate blocks&hellip;<br>&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; - setting up duplicate extent list&hellip;<br>&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - check for inodes claiming duplicate=
 blocks&hellip;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 0<=
br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 4<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 2<br>&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 3<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; - agno =3D 7<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agn=
o =3D 18<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 28<br>&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 6<br>&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 5<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; - agno =3D 1<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =
=3D 26<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 8<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 14<br>&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 17<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; - agno =3D 16<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - =
agno =3D 10<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 20<br>=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 13<br>&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 15<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; - agno =3D 11<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - =
agno =3D 19<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 22<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 21<br>&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 23<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; - agno =3D 9<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - a=
gno =3D 12<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 24<br>&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 27<br>&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; - agno =3D 25<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; - agno =3D 29<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - a=
gno =3D 30<br>Phase 5 - rebuild AG headers and trees&hellip;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - reset superblock&hellip;<br>Ph=
ase 6 - check inode connectivity&hellip;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; - resetting contents of realtime bitmap and summary in odes<br>=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - traversing filesystem &hellip;=
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - traversal finished &hellip=
;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - moving disconnected inode=
s to lost+found &hellip;<br>
disconnected inode 6235944, moving to lost+found<br>Phase 7 - verify and co=
rrect link counts&hellip;<br>done<br>sh-4.1$ .<br></div><div class=3D"gmail=
_extra"><br><br><div class=3D"gmail_quote">2013/4/9 Eric Sandeen <span dir=
=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sande=
en@sandeen.net</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On 4/9/13 7:53 AM, =B7=FB=
=D3=C0=CC=CE wrote:<br>
&gt; Dear xfs experts,<br>
&gt; I really need your help sincerely!!! In our production enviroment we<b=
r>
&gt; run glusterfs over top of xfs on Dell x720D(Raid 6). And the xfs file<=
br>
&gt; system crash on some of the server frequently about every two weeks.<b=
r>
&gt; Can you help to give me a direction about how to debug this issue and<=
br>
&gt; how to avoid it? Thank you very very much!<br>
<br>
</div>So this happens reliably, but infrequently? (only every 2 weeks or so=
?)<br>
<br>
Can you provoke it any more often?<br>
<div class=3D"im"><br>
&gt; uname -a<br>
&gt; Linux cqdx.miaoyan.cluster1.node11.qiyi.domain 2.6.32-279.el6.x86_64<b=
r>
&gt; #1 SMP Wed Jun 13 18:24:36 EDT 2012 x86_64 x86_64 x86_64 GNU/Linux<br>
<br>
</div>That&#39;s a RHEL6 kernel; I&#39;m assuming that this is a RHEL clone=
 w/o RH support?<br>
<br>
I agree with Ben that I&#39;d like to see xfs_repair output.<br>
<br>
Since the fs has shut down, you should unmount, remount, and unmount<br>
again to replay the dirty log. &nbsp;Then do xfs_repair -n, and provide the=
 output<br>
if it discovers any errors.<br>
<br>
Thanks,<br>
-Eric<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; Every time the crash log is same, as following<br>
&gt;<br>
&gt; 038 Apr &nbsp;9 09:41:36 cqdx kernel: XFS (sdb): xfs_iunlink_remove:<b=
r>
&gt; xfs_inotobp() returned error 22.<br>
&gt; 1039 Apr &nbsp;9 09:41:36 cqdx kernel: XFS (sdb): xfs_inactive: xfs_if=
ree<br>
&gt; returned error 22<br>
&gt; 1040 Apr &nbsp;9 09:41:36 cqdx kernel: XFS (sdb):<br>
&gt; xfs_do_force_shutdown(0x1) called from line 1184 of file<br>
&gt; fs/xfs/xfs_vnodeops.c. &nbsp;Return address =3D 0xffffffffa02ee20a<br>
&gt; 1041 Apr &nbsp;9 09:41:36 cqdx kernel: XFS (sdb): I/O Error Detected.<=
br>
&gt; Shutting down filesystem<br>
&gt; 1042 Apr &nbsp;9 09:41:36 cqdx kernel: XFS (sdb): Please umount the<br=
>
&gt; filesystem and rectify the problem(s)<br>
&gt; 1043 Apr &nbsp;9 09:41:53 cqdx kernel: XFS (sdb): xfs_log_force: error=
 5 returned.<br>
&gt; 1044 Apr &nbsp;9 09:42:23 cqdx kernel: XFS (sdb): xfs_log_force: error=
 5 returned.<br>
&gt; 1045 Apr &nbsp;9 09:42:53 cqdx kernel: XFS (sdb): xfs_log_force: error=
 5 returned.<br>
&gt; 1046 Apr &nbsp;9 09:43:23 cqdx kernel: XFS (sdb): xfs_log_force: error=
 5 returned.<br>
&gt;<br>
<br>
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=
=C0=CC=CE
</div>

--089e0111e0746d28cd04d9ef12a1--


--===============3216925519987356353==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3216925519987356353==--
