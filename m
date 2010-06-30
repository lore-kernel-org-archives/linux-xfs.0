Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5UIMcXw140231 for <xfs@oss.sgi.com>; Wed, 30 Jun 2010 13:22:39 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4249C15AC0F7
	for <xfs@oss.sgi.com>; Wed, 30 Jun 2010 11:30:18 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id ln8mCjJFzGsvnzhZ for
	<xfs@oss.sgi.com>; Wed, 30 Jun 2010 11:30:18 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 37B65705
	for <xfs@oss.sgi.com>; Wed, 30 Jun 2010 20:25:21 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 1466083C821
	for <xfs@oss.sgi.com>; Wed, 30 Jun 2010 20:24:50 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs file system in process of becoming corrupt;
	though xfs_repair thinks it's fine! ; -/ (was xfs_dump problem...)
Date: Wed, 30 Jun 2010 20:25:20 +0200
References: <4C26A51F.8020909@tlinx.org> <20100628022744.GX6590@dastard>
	<4C2A749E.4060006@tlinx.org>
In-Reply-To: <4C2A749E.4060006@tlinx.org>
MIME-Version: 1.0
Message-Id: <201006302025.20289@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6176154278541472994=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6176154278541472994==
Content-Type: multipart/signed;
  boundary="nextPart4264842.0mvYMLhAeJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4264842.0mvYMLhAeJ
Content-Type: multipart/mixed;
  boundary="Boundary-01=_Qw4KMswcb0uhpR9"
Content-Transfer-Encoding: 7bit


--Boundary-01=_Qw4KMswcb0uhpR9
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Mittwoch, 30. Juni 2010 Linda Walsh wrote:
> But have another XFS problem that is much more reliably persistent.
> I don't know if they are at all related, but since I have this
>  problem that's a bit "stuck", it's easier to "reproduce".
=20
I think my problem is similar. I have a Linux ("orion") running Samba.=20
A Win7 client uses it to store it's "Windows Backup". That's OK.

=46rom another Linux ("saturn"), I do an rsync via an rsync-module,=20
and have already 4 Versions where the ".vhd" file of that Windows Backup=20
is destroyed on "saturn". So the corruption happens when starting=20
rsync @saturn, copying orion->saturn, both having XFS.

As I cannot delete the broken files, I moved the whole dir away,=20
and did an rsync again. The same file destroyed again on saturn.
Some days later, again 2 versions which are destroyed.

The difference to Linda is, I get:
drwx------+ 2 zmi  users     4096 Jun 12 03:15 ./
drwxr-xr-x  7 root root       154 Jun 30 04:00 ../
=2Drwx------+ 1 zmi  users 56640000 Jun 12 03:05 852c268f-cf1a-11de-b09b-80=
6e6f6e6963.vhd*
??????????? ? ?    ?            ?            ? 852c2690-cf1a-11de-b09b-806e=
6f6e6963.vhd=20

and on dmesg:
[125903.343714] Filesystem "dm-0": corrupt inode 649642 ((a)extents =3D 5).=
  Unmount and run xfs_repair.                                              =
                                                        =20
[125903.343735] ffff88011e34ca00: 49 4e 81 c0 02 02 00 00 00 00 03 e8 00 00=
 00 64  IN.............d                                                   =
                                                      =20
[125903.343756] Filesystem "dm-0": XFS internal error xfs_iformat_extents(1=
) at line 558 of file /usr/src/packages/BUILD/kernel-desktop-2.6.31.12/linu=
x-2.6.31/fs/xfs/xfs_inode.c.  Caller 0xffffffffa032c0ad
[125903.343763]                                                            =
                                                                           =
                                                      =20
[125903.343791] Pid: 17696, comm: ls Not tainted 2.6.31.12-0.2-desktop #1  =
                                                                           =
                                                      =20
[125903.343803] Call Trace:                                                =
                                                                           =
                                                      =20
[125903.343821]  [<ffffffff81011a19>] try_stack_unwind+0x189/0x1b0         =
                                                                           =
                                                      =20
[125903.343840]  [<ffffffff8101025d>] dump_trace+0xad/0x3a0                =
                                                                           =
                                                      =20
[125903.343858]  [<ffffffff81011524>] show_trace_log_lvl+0x64/0x90         =
                                                                           =
                                                      =20
[125903.343876]  [<ffffffff81011573>] show_trace+0x23/0x40                 =
                                                                           =
                                                      =20
[125903.343894]  [<ffffffff81552b46>] dump_stack+0x81/0x9e                 =
                                                                           =
                                                      =20
[125903.343947]  [<ffffffffa0321b4a>] xfs_error_report+0x5a/0x70 [xfs]     =
                                                                           =
                                                      =20
[125903.344085]  [<ffffffffa0321bcc>] xfs_corruption_error+0x6c/0x90 [xfs] =
                                                                           =
                                                      =20
[125903.344248]  [<ffffffffa032bb84>] xfs_iformat_extents+0x234/0x280 [xfs]=
                                                                           =
                                                      =20
[125903.344409]  [<ffffffffa032c0ad>] xfs_iformat+0x28d/0x5a0 [xfs]        =
                                                                           =
                                                      =20
[125903.344569]  [<ffffffffa032c542>] xfs_iread+0x182/0x1c0 [xfs]          =
                                                                           =
                                                      =20
[125903.344729]  [<ffffffffa0327938>] xfs_iget_cache_miss+0x78/0x250 [xfs] =
                                                                           =
                                                      =20
[125903.344882]  [<ffffffffa0327c3c>] xfs_iget+0x12c/0x1b0 [xfs]           =
                                                                           =
                                                      =20
[125903.345036]  [<ffffffffa0347b8e>] xfs_lookup+0xce/0x100 [xfs]          =
                                                                           =
                                                      =20
[125903.345256]  [<ffffffffa0354e6c>] xfs_vn_lookup+0x6c/0xc0 [xfs]        =
                                                                           =
                                                      =20
[125903.345453]  [<ffffffff81157782>] real_lookup+0x102/0x180              =
                                                                           =
                                                      =20
[125903.345473]  [<ffffffff811598c0>] do_lookup+0xd0/0x100                 =
                                                                           =
                                                      =20
[125903.345491]  [<ffffffff81159e12>] __link_path_walk+0x522/0x880         =
                                                                           =
                                                      =20
[125903.345510]  [<ffffffff8115a6f6>] path_walk+0x66/0xd0                  =
                                                                           =
                                                      =20
[125903.345528]  [<ffffffff8115a7cb>] do_path_lookup+0x6b/0xb0             =
                                                                           =
                                                      =20
[125903.345546]  [<ffffffff8115a9d1>] user_path_at+0x61/0xc0               =
                                                                           =
                                                      =20
[125903.345565]  [<ffffffff811514d1>] vfs_fstatat+0x41/0x90                =
                                                                           =
                                                      =20
[125903.345584]  [<ffffffff811515ac>] vfs_lstat+0x2c/0x50                  =
                                                                           =
                                                      =20
[125903.345602]  [<ffffffff811515fe>] sys_newlstat+0x2e/0x70               =
                                                                           =
                                                      =20
[125903.345621]  [<ffffffff8100c682>] system_call_fastpath+0x16/0x1b       =
                                                                           =
                                                      =20
[125903.345645]  [<00007f72dc451e65>] 0x7f72dc451e65

Trying to "xfs_repair -n" seems to find errors, see attachment "repair1.log"
Trying to "xfs_repair" crashes, see attachment "repair2.log"

Saturns kernel is 2.6.31.12-0.2-desktop from openSUSE 11.2,=20
xfs_repair is 3.1.2 (I tried down several versions down to 3.0.1, all witho=
ut success).

Even after xfs_metadump and xfs_mdrestore the error exists, and cannot be=20
repaired with xfs_repair, because that crashes.

I've put a new metadump containing only the broken stuff for public review:
http://zmi.at/saturn_bigdata.metadump.only_broken.bz2 (197 MB)

What should I do, apart of ripping the whole filesystem and copying new?=20
The problem is, would be destroyed again, just like it did 4 times now.

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--Boundary-01=_Qw4KMswcb0uhpR9
Content-Type: text/x-log;
  charset="UTF-8";
  name="repair1.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="repair1.log"

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
would have corrected attribute entry count in inode 649642 from 40 to 0
local inode 649790 attr too small (size = 1, min size = 4)
bad attribute fork in inode 649790, would clear attr fork
would have cleared inode 649790
        - agno = 1
local inode 2195133988 attr too small (size = 3, min size = 4)
bad attribute fork in inode 2195133988, would clear attr fork
would have cleared inode 2195133988
would have corrected attribute entry count in inode 2902971474 from 163 to 0
would have corrected attribute totsize in inode 2902971474 from 6 to 4
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
local inode 2195133988 attr too small (size = 3, min size = 4)
bad attribute fork in inode 2195133988, would clear attr fork
would have cleared inode 2195133988
local inode 649790 attr too small (size = 1, min size = 4)
bad attribute fork in inode 649790, would clear attr fork
would have cleared inode 649790
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.

--Boundary-01=_Qw4KMswcb0uhpR9
Content-Type: text/x-log;
  charset="UTF-8";
  name="repair2.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="repair2.log"

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
corrected attribute entry count in inode 649642, was 40, now 0
problem with attribute contents in inode 649642
local inode 649790 attr too small (size = 1, min size = 4)
bad attribute fork in inode 649790, clearing attr fork
clearing inode 649790 attributes
cleared inode 649790
        - agno = 1
local inode 2195133988 attr too small (size = 3, min size = 4)
bad attribute fork in inode 2195133988, clearing attr fork
clearing inode 2195133988 attributes
cleared inode 2195133988
corrected attribute entry count in inode 2902971474, was 163, now 0
corrected attribute entry totsize in inode 2902971474, was 6, now 4
problem with attribute contents in inode 2902971474
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
data fork in inode 2195133988 claims metadata block 537122652
xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err == 0' failed.

--Boundary-01=_Qw4KMswcb0uhpR9--

--nextPart4264842.0mvYMLhAeJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwrjBAACgkQzhSR9xwSCbQD4wCg1Sb8U2bXbSKLpL1nbnD2+fnl
z3AAn0fNE4ZB5Wf8ssSMrxj1zGTnGsEj
=vT9G
-----END PGP SIGNATURE-----

--nextPart4264842.0mvYMLhAeJ--


--===============6176154278541472994==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6176154278541472994==--
