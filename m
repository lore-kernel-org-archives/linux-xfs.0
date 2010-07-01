Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o618MN44179508 for <xfs@oss.sgi.com>; Thu, 1 Jul 2010 03:22:24 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F72514B4556
	for <xfs@oss.sgi.com>; Thu,  1 Jul 2010 01:30:05 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id reHZeNSRVUBJVIdn for
	<xfs@oss.sgi.com>; Thu, 01 Jul 2010 01:30:05 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: rsync and corrupt inodes (was xfs_dump problem)
Date: Thu, 1 Jul 2010 10:25:03 +0200
References: <4C26A51F.8020909@tlinx.org> <201006302025.20289@zmi.at>
	<20100630233029.GO24712@dastard>
In-Reply-To: <20100630233029.GO24712@dastard>
MIME-Version: 1.0
Message-Id: <201007011025.04391@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5187564055950639743=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5187564055950639743==
Content-Type: multipart/signed;
  boundary="nextPart49156877.RidFttURCt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart49156877.RidFttURCt
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 1. Juli 2010 Dave Chinner wrote:
> > From another Linux ("saturn"), I do an rsync via an rsync-module,
> > and have already 4 Versions where the ".vhd" file of that Windows
> > Backup is destroyed on "saturn". So the corruption happens when
> > starting rsync @saturn, copying orion->saturn, both having XFS.
>=20
> Are you running rsync locally on saturn (i.e. pulling data)? If so,
> can you get an strace of the rsync of that file so we can see what
> the order or operations being done on the file is. If you are
> pushing data to saturn, does the problem go away if you pull it (and
> vice versa)?

Oh dear, I made a mistake. It's a push @orion, doing
rsync -aPvHAXy / saturn::orionbackup/

The problem is: I cannot 100% replicate it. I found the problem once,=20
moved the dir with the broken file away and synced again. Again broken.=20
Then I reported here. Meanwhile, Windows has done a new backup, that=20
file doesn't seem to get broken. But with another fresh Windows backup,=20
it came again. I don't know if it depends on the file, it happened 4=20
times until now.

I rsynced today 3 times, twice with the openSUSE kernel and once with=20
2.6.34, no problem. Sorry (or maybe "lucky me"?).

> > 852c268f-cf1a-11de-b09b-806e6f6e6963.vhd* ??????????? ? ?    ?    =20
> >       ?            ? 852c2690-cf1a-11de-b09b-806e6f6e6963.vhd
>=20
> On the source machine, can you get a list of the xattrs on the
> inode?

How would I do that? "getfattr" on that file gives no return, does that=20
mean it doesn't have anything to say? I never do that things, so there=20
shouldn't be any attributes set.
=20
> > and on dmesg:
> > [125903.343714] Filesystem "dm-0": corrupt inode 649642 ((a)extents
> > =3D 5).  Unmount and run xfs_repair. [125903.343735]
> > ffff88011e34ca00: 49 4e 81 c0 02 02 00 00 00 00 03 e8 00 00 00 64=20
> > IN.............d [125903.343756] Filesystem "dm-0": XFS internal
> > error xfs_iformat_extents(1) at line 558 of file
> > /usr/src/packages/BUILD/kernel-desktop-2.6.31.12/linux-2.6.31/fs/xf
> >s/xfs_inode.c.  Caller 0xffffffffa032c0ad
>=20
> That seems like a different problem to what linda is seeing
> because this is on-disk corruption. can you dump the bad inode via:
>=20
> # xfs_db -x -r -c "inode 649642" -c p <dev>

Uh, that's a long output.

# xfs_db -x -r -c "inode 649642" -c p /dev/swraid0/backup=20
core.magic =3D 0x494e                                                      =
                                                  =20
core.mode =3D 0100700                                                      =
                                                  =20
core.version =3D 2                                                         =
                                                  =20
core.format =3D 2 (extents)                                                =
                                                  =20
core.nlinkv2 =3D 1                                                         =
                                                  =20
core.onlink =3D 0                                                          =
                                                  =20
core.projid =3D 0                                                          =
                                                  =20
core.uid =3D 1000                                                          =
                                                  =20
core.gid =3D 100                                                           =
                                                  =20
core.flushiter =3D 4                                                       =
                                                  =20
core.atime.sec =3D Mon Jun 14 10:53:41 2010                                =
                                                  =20
core.atime.nsec =3D 000000000                                              =
                                                  =20
core.mtime.sec =3D Sat Jun 12 03:15:57 2010                                =
                                                  =20
core.mtime.nsec =3D 000000000                                              =
                                                  =20
core.ctime.sec =3D Mon Jun 14 10:53:41 2010                                =
                                                  =20
core.ctime.nsec =3D 180152802                                              =
                                                  =20
core.size =3D 36569189376                                                  =
                                                  =20
core.nblocks =3D 8928025                                                   =
                                                  =20
core.extsize =3D 0                                                         =
                                                  =20
core.nextents =3D 5                                                        =
                                                  =20
core.naextents =3D 0                                                       =
                                                  =20
core.forkoff =3D 9                                                         =
                                                  =20
core.aformat =3D 1 (local)                                                 =
                                                  =20
core.dmevmask =3D 0                                                        =
                                                  =20
core.dmstate =3D 0                                                         =
                                                  =20
core.newrtbm =3D 0                                                         =
                                                  =20
core.prealloc =3D 0                                                        =
                                                  =20
core.realtime =3D 0                                                        =
                                                  =20
core.immutable =3D 0                                                       =
                                                  =20
core.append =3D 0                                                          =
                                                  =20
core.sync =3D 0                                                            =
                                                  =20
core.noatime =3D 0                                                         =
                                                  =20
core.nodump =3D 0                                                          =
                                                  =20
core.rtinherit =3D 0                                                       =
                                                  =20
core.projinherit =3D 0                                                     =
                                                  =20
core.nosymlinks =3D 0                                                      =
                                                  =20
core.extsz =3D 0                                                           =
                                                  =20
core.extszinherit =3D 0                                                    =
                                                  =20
core.nodefrag =3D 0                                                        =
                                                  =20
core.filestream =3D 0                                                      =
                                                  =20
core.gen =3D 112968465                                                     =
                                                  =20
next_unlinked =3D null                                                     =
                                                  =20
u.bmx[0-4] =3D [startoff,startblock,blockcount,extentflag] 0:
[0,549849376,2097151,0] 1:[2097151,551946527,2097151,0] 2:
[4194302,554043678,2097151,0] 3:[6291453,556140829,2097151,0] 4:
[8388604,558237980,539421,0]
a.sfattr.hdr.totsize =3D 4                                                 =
                                                                           =
                                                            =20
a.sfattr.hdr.count =3D 40                                                  =
                                                                           =
                                                            =20
a.sfattr.list[0].namelen =3D 35                                            =
                                                                           =
                                                            =20
a.sfattr.list[0].valuelen =3D 136                                          =
                                                                           =
                                                            =20
a.sfattr.list[0].root =3D 1                                                =
                                                                           =
                                                            =20
a.sfattr.list[0].secure =3D 0                                              =
                                                                           =
                                                            =20
a.sfattr.list[0].name =3D=20
"\035GI_ACL_FILE\000\000\000\005\000\000\000\001\377\377\377\377\000\a\000\=
000\000\000\000\002\000\000\004"                                           =
                                  =20
a.sfattr.list[0].value =3D=20
"\346\000\a\000\000\000\000\000\004\377\377\377\377\000\006\000\000\000\000=
\000\020\377\377\377\377\000\000\000\000\000\000\000=20
\377\377\377\377\000\000\000\000\000IN\201\377\002\002\000\000\000\000\003\=
350\000\000\000d\000\000\000\001\000\000\000\000\000\000\000\000\000\000\00=
0\002L\025\356\025\000\000\000\000L\022\337\316\000\000\000\000L\025\356\02=
5\024\'\314\214\000\000\000\000\000\000\004\242\000\000\000\000\000\000\000=
\001\000\000\000\000\000\000\000\001\000\000\c\001\000\000\000\000\000\000\=
000\000\006\273"                                                           =
                                                                           =
                             =20
a.sfattr.list[1].namelen =3D 195                                           =
                                                                           =
                                                                           =
            =20
a.sfattr.list[1].valuelen =3D 12                                           =
                                                                           =
                                                                           =
            =20
a.sfattr.list[1].root =3D 1                                                =
                                                                           =
                                                                           =
            =20
a.sfattr.list[1].secure =3D 1                                              =
                                                                           =
                                                                           =
            =20
a.sfattr.list[1].name =3D=20
"\377\377\377\000\000\000\000\000\000\000\000\000\006\000\000\373\340\000\0=
01\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\=
000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000=
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\00=
0\000S\001\000\f@\002SGI_ACL_FILE\000\000\000\005\000\000\000\001\377\377\3=
77\377\000\a\000\000\000\000\000\002\000\000\004\346\000\a\000\000\000\000\=
000\004\377\377\377\377\000\a\000\000\000\000\000\020\377\377\377\377\000\a=
\000\000\000\000\000=20
\377\377\377\377\000\a\000\000\000IN\201\377\002\002\000\000\000\000\003\35=
0\000\000\000d\000\000\000\001\000\000\000\000\000\000\000\000\000\000\000\=
002L\025\356\025"                                                          =
                                                                           =
                                                                         =20
a.sfattr.list[1].value =3D "\000\000\000\000L\022\337\316\000\000\000\000" =
                                                                           =
                                                                           =
            =20
a.sfattr.list[2].namelen =3D 76                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[2].valuelen =3D 21                                           =
                                                                           =
                                                                           =
            =20
a.sfattr.list[2].root =3D 1                                                =
                                                                           =
                                                                           =
            =20
a.sfattr.list[2].secure =3D 1                                              =
                                                                           =
                                                                           =
            =20
a.sfattr.list[2].name =3D=20
"\025\024\'\314\214\000\000\000\000\000\000\0046\000\000\000\000\000\000\00=
0\001\000\000\000\000\000\000\000\001\000\000\c\001\000\000\000\000\000\000=
\000\000\006\273\303\f\377\377\377\377\000\000\000\000\000\000\000\000\000\=
a\000\000u@\000\001\000\000\000\000\000\000\000\000\000\000\000"           =
                                                                           =
                                                                        =20
a.sfattr.list[2].value =3D=20
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\0=
00\000\000"                                                                =
                                                            =20
a.sfattr.list[3].namelen =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[3].valuelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[3].root =3D 0                                                =
                                                                           =
                                                                           =
            =20
a.sfattr.list[3].secure =3D 0                                              =
                                                                           =
                                                                           =
            =20
a.sfattr.list[4].namelen =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[4].valuelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[4].root =3D 0                                                =
                                                                           =
                                                                           =
            =20
a.sfattr.list[4].secure =3D 0                                              =
                                                                           =
                                                                           =
            =20
a.sfattr.list[5].namelen =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[5].valuelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[5].root =3D 0                                                =
                                                                           =
                                                                           =
            =20
a.sfattr.list[5].secure =3D 0                                              =
                                                                           =
                                                                           =
            =20
a.sfattr.list[6].namelen =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[6].valuelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[6].root =3D 0                                                =
                                                                           =
                                                                           =
            =20
a.sfattr.list[6].secure =3D 0                                              =
                                                                           =
                                                                           =
            =20
a.sfattr.list[7].namelen =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[7].valuelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[7].root =3D 0                                                =
                                                                           =
                                                                           =
            =20
a.sfattr.list[7].secure =3D 0                                              =
                                                                           =
                                                                           =
            =20
a.sfattr.list[8].namelen =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[8].valuelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[8].root =3D 0                                                =
                                                                           =
                                                                           =
            =20
a.sfattr.list[8].secure =3D 0                                              =
                                                                           =
                                                                           =
            =20
a.sfattr.list[9].namelen =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[9].valuelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[9].root =3D 0                                                =
                                                                           =
                                                                           =
            =20
a.sfattr.list[9].secure =3D 0                                              =
                                                                           =
                                                                           =
            =20
a.sfattr.list[10].namelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[10].valuelen =3D 0                                           =
                                                                           =
                                                                           =
            =20
a.sfattr.list[10].root =3D 0                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[10].secure =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[11].namelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[11].valuelen =3D 83                                          =
                                                                           =
                                                                           =
            =20
a.sfattr.list[11].root =3D 0                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[11].secure =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[11].value =3D=20
"\000\f@\002SGI_ACL_FILE\000\000\000\005\000\000\000\001\377\377\377\377\00=
0\a\000\000\000\000\000\002\000\000\004\346\000\a\000\000\000\000\000\004\3=
77\377\377\377\000\a\000\000\000\000\000\020\377\377\377\377\000\a\000\000\=
000\000\000=20
\377\377\377\377\000\a\000\000\000IN"                                      =
                                                                           =
                                                          =20
a.sfattr.list[12].namelen =3D 129                                          =
                                                                           =
                                                                           =
            =20
a.sfattr.list[12].valuelen =3D 255                                         =
                                                                           =
                                                                           =
            =20
a.sfattr.list[12].root =3D 1                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[12].secure =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[12].name =3D=20
"\002\000\000\000\000\003\350\000\000\000d\000\000\000\001\000\000\000\000\=
000\000\000\000\000\000\000\002L\025\356\025\000\000\000\000L\022\337\316\0=
00\000\000\000L\025\356\025\0247\017{\000\000\000\000\000\000$2\000\000\000=
\000\000\000\000\003\000\000\000\000\000\000\000\001\000\000\c\001\000\000\=
000\000\000\000\000\000\006\273\303\f\377\377\377\377\000\000\000\000\000\0=
00\000\000\000\001\003\350y\240\000\003\000\000\000\000\000\000\000\000\000=
\000\000\000\000\000\000\000\000\000"                                      =
                                                                           =
                                                                           =
       =20
a.sfattr.list[12].value =3D=20
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\0=
00\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\=
000\000S\001\000\f@\002SGI_ACL_FILE\000\000\000\005\000\000\000\001\377\377=
\377\377\000\a\000\000\000\000\000\002\000\000\004\346\000\a\000\000\000\00=
0\000\004\377\377\377\377\000\a\000\000\000\000\000\020\377\377\377\377\000=
\a\000\000\000\000\000=20
\377\377\377\377\000\a\000\000\000IN\201\377\002\002\000\000\000\000\003\35=
0\000\000\000d\000\000\000\001\000\000\000\000\000\000\000\000\000\000\000\=
002L\025\356\025\000\000\000\000L\022\337\316\000\000\000\000L\025\356\025\=
024FR\242\000\000\000\000\000\000\031\216\000\000\000\000\000\000\000\002\0=
00\000\000\000\000\000\000\001\000\000\c\001\000\000\000\000\000\000\000\00=
0\006\273\303\f\377\377\377\377\000\000\000\000\000\000\000\000\000\002\003;
\365\000\000\002\000\000\000\000\000\000\000\000\000\000\000\000\000\000\00=
0\000\000"                                                                 =
                                                                           =
                                                                           =
    =20
a.sfattr.list[13].namelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[13].valuelen =3D 0                                           =
                                                                           =
                                                                           =
            =20
a.sfattr.list[13].root =3D 0                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[13].secure =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[14].namelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[14].valuelen =3D 0                                           =
                                                                           =
                                                                           =
            =20
a.sfattr.list[14].root =3D 0                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[14].secure =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[15].namelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[15].valuelen =3D 0                                           =
                                                                           =
                                                                           =
            =20
a.sfattr.list[15].root =3D 0                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[15].secure =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[16].namelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[16].valuelen =3D 0                                           =
                                                                           =
                                                                           =
            =20
a.sfattr.list[16].root =3D 0                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[16].secure =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[17].namelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[17].valuelen =3D 0                                           =
                                                                           =
                                                                           =
            =20
a.sfattr.list[17].root =3D 0                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[17].secure =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[18].namelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[18].valuelen =3D 0                                           =
                                                                           =
                                                                           =
            =20
a.sfattr.list[18].root =3D 0                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[18].secure =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[19].namelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[19].valuelen =3D 0                                           =
                                                                           =
                                                                           =
            =20
a.sfattr.list[19].root =3D 0                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[19].secure =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[20].namelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[20].valuelen =3D 0                                           =
                                                                           =
                                                                           =
            =20
a.sfattr.list[20].root =3D 0                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[20].secure =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[21].namelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[21].valuelen =3D 0                                           =
                                                                           =
                                                                           =
            =20
a.sfattr.list[21].root =3D 0                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[21].secure =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[22].namelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[22].valuelen =3D 0                                           =
                                                                           =
                                                                           =
            =20
a.sfattr.list[22].root =3D 0                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[22].secure =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[23].namelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[23].valuelen =3D 0                                           =
                                                                           =
                                                                           =
            =20
a.sfattr.list[23].root =3D 0                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[23].secure =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[24].namelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[24].valuelen =3D 0                                           =
                                                                           =
                                                                           =
            =20
a.sfattr.list[24].root =3D 0                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[24].secure =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[25].namelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[25].valuelen =3D 0                                           =
                                                                           =
                                                                           =
            =20
a.sfattr.list[25].root =3D 0                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[25].secure =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[26].namelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[26].valuelen =3D 83                                          =
                                                                           =
                                                                           =
            =20
a.sfattr.list[26].root =3D 0                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[26].secure =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[26].value =3D=20
"\000\f@\002SGI_ACL_FILE\000\000\000\005\000\000\000\001\377\377\377\377\00=
0\a\000\000\000\000\000\002\000\000\004\346\000\a\000\000\000\000\000\004\3=
77\377\377\377\000\a\000\000\000\000\000\020\377\377\377\377\000\a\000\000\=
000\000\000=20
\377\377\377\377\000\a\000\000\000IN"                                      =
                                                                           =
                                                          =20
a.sfattr.list[27].namelen =3D 129                                          =
                                                                           =
                                                                           =
            =20
a.sfattr.list[27].valuelen =3D 255                                         =
                                                                           =
                                                                           =
            =20
a.sfattr.list[27].root =3D 1                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[27].secure =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[27].name =3D=20
"\002\000\000\000\000\003\350\000\000\000d\000\000\000\001\000\000\000\000\=
000\000\000\000\000\000\000\002L\025\356\025\000\000\000\000L\022\337\315\0=
00\000\000\000L\025\356\025\024FR\242\000\000\000\000\000\000\021\234\000\0=
00\000\000\000\000\000\002\000\000\000\000\000\000\000\001\000\000\c\001\00=
0\000\000\000\000\000\000\000\006\273\303\f\377\377\377\377\000\000\000\000=
\000\000\000\000\000\003\003P5\200\000\002\000\000\000\000\000\000\000\000\=
000\000\000\000\000\000\000\000\000\000"                                   =
                                                                           =
                                                                           =
       =20
a.sfattr.list[27].value =3D=20
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\0=
00\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\=
000\000S\001\000\f@\002SGI_ACL_FILE\000\000\000\005\000\000\000\001\377\377=
\377\377\000\a\000\000\000\000\000\002\000\000\004\346\000\a\000\000\000\00=
0\000\004\377\377\377\377\000\a\000\000\000\000\000\020\377\377\377\377\000=
\a\000\000\000\000\000=20
\377\377\377\377\000\a\000\000\000\000\000\000\000\000\000\000\000\361\017\=
000\000\000\000\000\000\020\360s\001\000\000\000\000\310t\251I\300\177\000\=
000\020\360s\001\000\000\000\000\2000t\001\000\000\000\000\000\000\000\000\=
000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000=
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\00=
0\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\0=
00\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\=
000\000\000\000\000\000"                                                   =
                                                                           =
                                                                           =
     =20
a.sfattr.list[28].namelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[28].valuelen =3D 0                                           =
                                                                           =
                                                                           =
            =20
a.sfattr.list[28].root =3D 0                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[28].secure =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[29].namelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[29].valuelen =3D 0                                           =
                                                                           =
                                                                           =
            =20
a.sfattr.list[29].root =3D 0                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[29].secure =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[30].namelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[30].valuelen =3D 0                                           =
                                                                           =
                                                                           =
            =20
a.sfattr.list[30].root =3D 0                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[30].secure =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[31].namelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[31].valuelen =3D 0                                           =
                                                                           =
                                                                           =
            =20
a.sfattr.list[31].root =3D 0                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[31].secure =3D 0                                             =
                                                                           =
                                                                           =
            =20
a.sfattr.list[32].namelen =3D 0                                            =
                                                                           =
                                                                           =
            =20
a.sfattr.list[32].valuelen =3D 0                                           =
                                                                           =
                                                                           =
            =20
a.sfattr.list[32].root =3D 0                                               =
                                                                           =
                                                                           =
            =20
a.sfattr.list[32].secure =3D 0
a.sfattr.list[33].namelen =3D 0
a.sfattr.list[33].valuelen =3D 0
a.sfattr.list[33].root =3D 0
a.sfattr.list[33].secure =3D 0
a.sfattr.list[34].namelen =3D 0
a.sfattr.list[34].valuelen =3D 0
a.sfattr.list[34].root =3D 0
a.sfattr.list[34].secure =3D 0
a.sfattr.list[35].namelen =3D 0
a.sfattr.list[35].valuelen =3D 0
a.sfattr.list[35].root =3D 0
a.sfattr.list[35].secure =3D 0
a.sfattr.list[36].namelen =3D 0
a.sfattr.list[36].valuelen =3D 0
a.sfattr.list[36].root =3D 0
a.sfattr.list[36].secure =3D 0
a.sfattr.list[37].namelen =3D 0
a.sfattr.list[37].valuelen =3D 0
a.sfattr.list[37].root =3D 0
a.sfattr.list[37].secure =3D 0
a.sfattr.list[38].namelen =3D 0
a.sfattr.list[38].valuelen =3D 0
a.sfattr.list[38].root =3D 0
a.sfattr.list[38].secure =3D 0
a.sfattr.list[39].namelen =3D 0
a.sfattr.list[39].valuelen =3D 0
a.sfattr.list[39].root =3D 0
a.sfattr.list[39].secure =3D 0
=20
> > [125903.343791] Pid: 17696, comm: ls Not tainted
> > 2.6.31.12-0.2-desktop #1
>=20
> That's getting a bit old now.

It's the most actual for openSUSE 11.2, which is the actual release.=20
Well, 11.3 should land on July 15...

> This kernel does not have any of the swap extent guards we added to
> avoid fsr corrupting inodes with attribute forks, and the above
> corruption report and the repair output look exactly like I saw when
> intentionally corrupting inodes with xfs_fsr.
>
> Hmmmm - do you run xfs_fsr? The errors reported and the corrutpion
> above are exactly what I'd expect from the swap extent bugs we fixed
> a while back....

Yes, xfs_fsdr was running. Disabled it now, and compiled and changed to=20
kernel 2.6.34 now. Hope that's OK ;-)
=20
> I'll take a look.

Thank you!

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart49156877.RidFttURCt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwsUOAACgkQzhSR9xwSCbTYpACgnk5SpQ6TpHuRqEtwQzkvwlHd
d+QAnjepGnjdF1dcdnkKfm7n7AMxmn3r
=el7s
-----END PGP SIGNATURE-----

--nextPart49156877.RidFttURCt--


--===============5187564055950639743==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5187564055950639743==--
