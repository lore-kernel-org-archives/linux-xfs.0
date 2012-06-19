Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5JCaSWf088618 for <xfs@oss.sgi.com>; Tue, 19 Jun 2012 07:36:28 -0500
Date: Tue, 19 Jun 2012 07:36:24 -0500
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: No space left on device
Message-ID: <20120619123624.GD16802@sgi.com>
References: <CA+UH363THQXhT8bH8Mb8Hpz9kvMnWxhq4ToVg6uiwDFLN91VmA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+UH363THQXhT8bH8Mb8Hpz9kvMnWxhq4ToVg6uiwDFLN91VmA@mail.gmail.com>
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
To: =?iso-8859-1?Q?Andr=E9_=D8ien?= Langvand <andre.oien.langvand@wimpmusic.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 19, 2012 at 02:05:34PM +0200, Andr=E9 =D8ien Langvand wrote:
| Hi,
| =

| I know there are quite a few posts regarding similar issues around, but I
| can't seem to find a solution or at least an answer to why this is
| happening in my case, so I thought I'd try the mailing list and I hope
| that's okay.
| =

| We have 2 file servers with identical hardware and identical configuration
| (Dell R610's, H800 controllers, MD1200 DAS, RAID-5) set up with rsync to
| mirror the contents. The content is music in several formats (from PCM WAV
| to 64kbit AAC previews), which means file sizes of about 1 - 40mb. Both
| systems running SLES 11 SP1. Same kernel (2.6.32.59-0.3-default), same
| xfsprogs version (xfsprogs-3.1.1-0.1.36).
| =

| My example partition on the source now has 9.9G (of 9.1T) available space
| and still doesn't report the drive as full. On the destination, however, =
it
| wont allow me to use any of the remaining 51G. This is obviously a problem
| when trying to do mirroring.
| =

| Both file systems have been mounted with inode64 option since first mount,
| there are plenty of inodes available and I've also verified that there are
| noe sparse files (find -type f -printf "%S\t%p\n" 2>/dev/null | gawk '{if
| ($1 < 1.0) print $1 $2}'), just in case.
| =

| I have tried repairing (xfs_repair), defragmenting (xfs_fsr) and alter
| imaxpct without any luck. Rsync is run like this: # ionice -c3 rsync -rv
| --size-only --progress --delete-before --inplace.
| =

| =

| More detailed information on source file system:
| =

| # df -k | grep sdg1
| /dev/sdg1            9762777052 9752457156  10319896 100% /content/raid31
| =

| # df -i | grep sdg1
| /dev/sdg1            7471884 2311914 5159970   31% /content/raid31
| =

| # xfs_info /dev/sdg1
| meta-data=3D/dev/sdg1              isize=3D2048   agcount=3D10, agsize=3D=
268435424
| blks
|          =3D                       sectsz=3D512   attr=3D2
| data     =3D                       bsize=3D4096   blocks=3D2441215991, im=
axpct=3D5
|          =3D                       sunit=3D16     swidth=3D80 blks
| naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
| log      =3Dinternal               bsize=3D4096   blocks=3D521728, versio=
n=3D2
|          =3D                       sectsz=3D512   sunit=3D16 blks, lazy-c=
ount=3D1
| realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
| =

| # xfs_db -r "-c freesp -s" /dev/sdg1
|    from      to extents  blocks    pct
|       1       1   69981   69981   2.99
|       2       3  246574  559149  23.86
|       4       7  315038 1707929  72.88
|       8      15     561    6374   0.27
| total free extents 632154
| total free blocks 2343433
| average free extent size 3.70706
| =

| =

| =

| More detailed information on destination file system:
| =

| # df -k | grep sdj1
| /dev/sdj1            9762777052 9710148076  52628976 100% /content/sg08/v=
d08
| =

| # df -i | grep sdj1
| /dev/sdj1            28622264 2307776 26314488    9% /content/sg08/vd08
| =

| # xfs_info /dev/sdj1
| meta-data=3D/dev/sdj1              isize=3D2048   agcount=3D10, agsize=3D=
268435424
| blks
|          =3D                       sectsz=3D512   attr=3D2
| data     =3D                       bsize=3D4096   blocks=3D2441215991, im=
axpct=3D5
|          =3D                       sunit=3D16     swidth=3D80 blks
| naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
| log      =3Dinternal               bsize=3D4096   blocks=3D521728, versio=
n=3D2
|          =3D                       sectsz=3D512   sunit=3D16 blks, lazy-c=
ount=3D1
| realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
| =

| # xfs_db -r "-c freesp -s" /dev/sdj1
|    from      to extents  blocks    pct
|       1       1   81761   81761   0.62
|       2       3  530258 1147719   8.73
|       4       7  675864 3551039  27.01
|       8      15  743089 8363043  63.62
|      16      31     102    1972   0.02
| total free extents 2031074
| total free blocks 13145534
| average free extent size 6.47221
| =

| =

| I would be grateful if anyone could shed some light on why this is
| happening or maybe even provide a solution.

You are using 2 KiB inodes, so an inode cluster (64 inodes) requires
128 KiB of contiguous space on disk.  The freesp output above shows that
the largest possible contiguous free space chunk available is 31 * 4 KiB
or 4 KiB short of 128 KiB.  You don't have enough contiguous space to
create a new inode cluster, and your existing inodes are likely all
used.  This can be verified using xfs_db: =

	xfs_db -r -c "sb" -c "p ifree" /dev/sdj1

xfs_fsr does not defragment free space, it only makes the problem worse.
A possible solution:
  1.  mount the filesystem with the ikeep mount option
  2.  delete a few large files to free up some contiguous space
  3.  create a few thousand files to "preallocate" inodes
  4.  delete the newly created files
The ikeep mount option will prevent the space for inodes from being
reused for other purposes.


-- =

Geoffrey Wehrman
SGI Building 10                             Office: (651)683-5496
2750 Blue Water Road                           Fax: (651)683-5098
Eagan, MN 55121                             E-mail: gwehrman@sgi.com
	  http://www.sgi.com/products/storage/software/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
