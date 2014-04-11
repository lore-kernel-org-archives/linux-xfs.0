Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6F75D7F3F
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 15:43:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E4FACAC002
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 13:43:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id b5MPooVFe1nLm3wf for
	<xfs@oss.sgi.com>; Fri, 11 Apr 2014 13:43:43 -0700 (PDT)
Date: Fri, 11 Apr 2014 16:43:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Strange hole creation behavior
Message-ID: <20140411204338.GA38024@bfoster.bfoster>
References: <534822D7.7090803@draigBrady.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <534822D7.7090803@draigBrady.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: =?utf-8?B?T25kxZllaiBWYcWhw61r?= <ovasik@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Apr 11, 2014 at 06:13:59PM +0100, P=E1draig Brady wrote:
> So this coreutils test is failing on XFS:
> http://git.sv.gnu.org/gitweb/?p=3Dcoreutils.git;a=3Dblob;f=3Dtests/dd/spa=
rse.sh;h=3D06efc7017
> Specifically the last hole check on line 66.
> =

> In summary what's happening is that a write(1MiB), lseek(1MiB), write(1Mi=
B)
> creates only a 64KiB hole. Is that expected?
> =


This is expected behavior due to speculative preallocation. An FAQ with
regard to this behavior is pending, but see here for reference:

http://oss.sgi.com/archives/xfs/2014-04/msg00083.html

In that particular write(1MB), lseek(+1MB), write(1MB) workload, each
write is preallocating some extra space beyond the current EOF. The seek
then moves past that space, but the space doesn't go away. The
subsequent writes will extend EOF. The previously preallocated space now
resides in the middle of the file and can't be trimmed away when the
file is closed.

> Now a 1MiB hole is supported using truncate:
>   dd if=3D/dev/urandom of=3Dfile.in bs=3D1M count=3D1 iflag=3Dfullblock
>   truncate -s+1M file.in
>   dd if=3D/dev/urandom of=3Dfile.in bs=3D1M count=3D1 iflag=3Dfullblock c=
onv=3Dnotrunc oflag=3Dappend
>   $ du -k file.in
>   2048  file.in
> =


This works simply because it is broken into multiple commands. When the
first dd exits, the excess space is trimmed off (the file descriptor is
closed). The subsequent truncate extends the file size without any
extra space getting caught between the old and new EOF.

You can confirm this by using the 'allocsize=3D4k' mount option to the XFS
mount. If you wanted something more generic for the purpose of testing
the coreutils functionality, you could also set the size of file.out in
advance. E.g., with preallocation in effect:

# dd if=3Dfile.in of=3Dfile.out bs=3D1M conv=3Dsparse
# xfs_bmap -v file.out =

file.out:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..3967]:       9773944..9777911  1 (9080..13047)     3968
   1: [3968..4095]:    hole                                   128
   2: [4096..6143]:    9778040..9780087  1 (13176..15223)    2048

... and then prevent preallocation by ensuring writes do not extend the
file:

# rm -f file.out =

# truncate --size=3D3M file.out
# dd if=3Dfile.in of=3Dfile.out bs=3D1M conv=3Dsparse,notrunc
# xfs_bmap -v file.out =

file.out:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..2047]:       9773944..9775991  1 (9080..11127)     2048
   1: [2048..4095]:    hole                                  2048
   2: [4096..6143]:    9778040..9780087  1 (13176..15223)    2048

Hope that helps.

Brian

> But when trying to create the 1MiB hole with dd (lseek) it fails?
> =

>   # Create 3MiB input file file
>   $ dd if=3D/dev/urandom of=3Dfile.in bs=3D1M count=3D3 iflag=3Dfullblock
>   $ dd if=3D/dev/zero    of=3Dfile.in bs=3D1M count=3D1 seek=3D1 conv=3Dn=
otrunc
>   $ du -k file.in
>   3072  file.in
> =

>   # Convert to 1MiB hole doesn't work :(
>   $ dd if=3Dfile.in of=3Dfile.out bs=3D1M conv=3Dsparse
>   $ du -k file.out
>   3008  file.out
> =

>   # Again with syscall details:
>   $ strace -e write,lseek dd if=3Dfile.in of=3Dfile.out bs=3D1M conv=3Dsp=
arse
>   write(1, "...", 1048576) =3D 1048576
>   lseek(1, 1048576, SEEK_CUR)             =3D 2097152
>   write(1, "...", 1048576) =3D 1048576
> =

> So it seems that the lseeks are treated differently to the truncate
> that was done in the first example, which is surprising.
> If we look at the file layout we can see the hole is
> only at the last 64KiB of the middle 1MiB of zeros,
> rather than for the whole middle 1MiB as in the first example??
> =

>   $ filefrag -v file.out
>   Filesystem type is: 58465342
>   File size of file.out is 3145728 (768 blocks of 4096 bytes)
>    ext:     logical_offset:        physical_offset: length:   expected: f=
lags:
>      0:        0..     495:      31271..     31766:    496:
>      1:      512..     767:      31783..     32038:    256:      31767: e=
of
> =

> thanks,
> P=E1draig.
> =

> Versions etc. in case useful
> =

> $ uname -a
> Linux tp2 3.12.6-300.fc20.x86_64 #1 SMP Mon Dec 23 16:44:31 UTC 2013 x86_=
64 x86_64 x86_64 GNU/Linux
> =

> $ xfs_info .
> meta-data=3D/dev/loop2             isize=3D256    agcount=3D4, agsize=3D6=
5536 blks
>          =3D                       sectsz=3D512   attr=3D2
> data     =3D                       bsize=3D4096   blocks=3D262144, imaxpc=
t=3D25
>          =3D                       sunit=3D0      swidth=3D0 blks
> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
> log      =3Dinternal               bsize=3D4096   blocks=3D2560, version=
=3D2
>          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-co=
unt=3D1
> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
