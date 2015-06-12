Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 218CD7F51
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 07:21:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8DDD0AC002
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 05:21:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5tPTKVWC4bn3UHRk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 12 Jun 2015 05:21:11 -0700 (PDT)
Date: Fri, 12 Jun 2015 08:21:08 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: PROBLEM: XFS on ARM corruption 'Structure needs cleaning'
Message-ID: <20150612122108.GB60661@bfoster.bfoster>
References: <5579296A.8010208@skylable.com>
	<20150611151620.GB59168@bfoster.bfoster>
	<5579A904.3020204@skylable.com> <5579AE85.5080203@sandeen.net>
	<5579B034.4070503@sandeen.net> <5579B804.9050707@skylable.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5579B804.9050707@skylable.com>
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
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwin@skylable.com>
Cc: Christopher Squires <christopher.squires@hgst.com>, Wayne Burri <wayne.burri@hgst.com>, Eric Sandeen <sandeen@sandeen.net>, Luca Gibelli <luca@skylable.com>, xfs@oss.sgi.com

On Thu, Jun 11, 2015 at 07:32:04PM +0300, T=F6r=F6k Edwin wrote:
> On 06/11/2015 06:58 PM, Eric Sandeen wrote:
> > On 6/11/15 10:51 AM, Eric Sandeen wrote:
> >> On 6/11/15 10:28 AM, T=F6r=F6k Edwin wrote:
> >>> On 06/11/2015 06:16 PM, Brian Foster wrote:
> >>>> On Thu, Jun 11, 2015 at 09:23:38AM +0300, T=F6r=F6k Edwin wrote:
> >>>>> [1.] XFS on ARM corruption 'Structure needs cleaning'
> >>>>> [2.] Full description of the problem/report:
> >>>>>
> >>>>> I have been running XFS sucessfully on x86-64 for years, however I'=
m having trouble running it on ARM.
> >>>>>
> >>>>> Running the testcase below [7.] reliably reproduces the filesystem =
corruption starting from a freshly
> >>>>> created XFS filesystem: running ls after 'sxadm node --new --batch =
/export/dfs/a/b' shows a 'Structure needs cleaning' error,
> >>>>> and dmesg shows a corruption error [6.].
> >>>>> xfs_repair 3.1.9 is not able to repair the corruption: after mounti=
ng the repair filesystem
> >>>>> I still get the 'Structure needs cleaning' error.
> >>>>>
> >>>>> Note: using /export/dfs/a/b is important for reproducing the proble=
m: if I only use one level of directories in /export/dfs then the problem
> >>>>> doesn't reproduce. Also if I use a tuned version of sxadm that crea=
tes fewer database files then the problem doesn't reproduce either.
> >>>>>
> >>>>> [3.] Keywords: filesystems, XFS corruption, ARM
> >>>>> [4.] Kernel information
> >>>>> [4.1.] Kernel version (from /proc/version):
> >>>>> Linux hornet34 3.14.3-00088-g7651c68 #24 Thu Apr 9 16:13:46 MDT 201=
5 armv7l GNU/Linux
> >>>>>
> >>>> ...
> >>>>> [5.] Most recent kernel version which did not have the bug: Unknown=
, first kernel I try on ARM
> >>>>>
> >>>>> [6.] dmesg stacktrace
> >>>>>
> >>>>> [4627578.440000] XFS (sda4): Mounting Filesystem
> >>>>> [4627578.510000] XFS (sda4): Ending clean mount
> >>>>> [4627621.470000] dd6ee000: 58 46 53 42 00 00 10 00 00 00 00 00 37 4=
0 21 00  XFSB........7@!.
> >>>>> [4627621.480000] dd6ee010: 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00  ................
> >>>>> [4627621.490000] dd6ee020: 5b 08 7f 79 0e 3a 46 3d 9b ea 26 ad 9d 6=
2 17 8d  [..y.:F=3D..&..b..
> >>>>> [4627621.490000] dd6ee030: 00 00 00 00 20 00 00 04 00 00 00 00 00 0=
0 00 80  .... ...........
> >>>>
> >>>> Just a data point... the magic number here looks like a superblock m=
agic
> >>>> (XFSB) rather than one of the directory magic numbers. I'm wondering=
 if
> >>>> a buffer disk address has gone bad somehow or another.
> >>>>
> >>>> Does this happen to be a large block device? I don't see any partiti=
on
> >>>> or xfs_info data below. If so, it would be interesting to see if this
> >>>> reproduces on a smaller device. It does appear that the large block
> >>>> device option is enabled in the kernel config above, however, so may=
be
> >>>> that's unrelated.
> >>>
> >>> This is mkfs.xfs /dev/sda4:
> >>> meta-data=3D/dev/sda4              isize=3D256    agcount=3D4, agsize=
=3D231737408 blks
> >>>          =3D                       sectsz=3D512   attr=3D2, projid32b=
it=3D0
> >>> data     =3D                       bsize=3D4096   blocks=3D926949632,=
 imaxpct=3D5
> >>>          =3D                       sunit=3D0      swidth=3D0 blks
> >>> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
> >>> log      =3Dinternal log           bsize=3D4096   blocks=3D452612, ve=
rsion=3D2
> >>>          =3D                       sectsz=3D512   sunit=3D0 blks, laz=
y-count=3D1
> >>> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtexten=
ts=3D0
> >>>
> >>> But it also reproduces with this small loopback file:
> >>> meta-data=3D/tmp/xfs.test          isize=3D256    agcount=3D2, agsize=
=3D5120 blks
> >>>          =3D                       sectsz=3D512   attr=3D2, projid32b=
it=3D0
> >>> data     =3D                       bsize=3D4096   blocks=3D10240, ima=
xpct=3D25
> >>>          =3D                       sunit=3D0      swidth=3D0 blks
> >>> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
> >>> log      =3Dinternal log           bsize=3D4096   blocks=3D1200, vers=
ion=3D2
> >>>          =3D                       sectsz=3D512   sunit=3D0 blks, laz=
y-count=3D1
> >>> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtexten=
ts=3D0
> >>
> >> ok so not a block number overflow issue, thanks.
> >>
> >>> You can have a look at xfs.test here: http://vol-public.s3.indian.sky=
lable.com:8008/armel/testcase/xfs.test.gz
> >>>
> >>> If I loopback mount that on an x86-64 box it doesn't show the corrupt=
ion message though ...
> >>
> >> FWIW, this is the 2nd report we've had of something similar, both on A=
rmv7, both ok on x86_64.
> >>
> >> I'll take a look at your xfs.test; that's presumably copied after it r=
eported the error, and you unmounted it before uploading, correct?  And it =
was mkfs'd on armv7, never mounted or manipulated in any way on x86_64?
> =

> Thanks, yes it was mkfs.xfs on ARMv7 and unmounted.
> =

> > =

> > Oh, and what were the kernel messages when you produced the corruption =
with xfs.txt?
> =

> Takes only a couple of minutes to reproduce the issue so I've prepared a =
fresh set of xfs2.test and corresponding kernel messages to make sure its a=
ll consistent.
> Freshly created XFS by mkfs.xfs: http://vol-public.s3.indian.skylable.com=
:8008/armel/testcase/xfs2.test.orig.gz
> The corrupted XFS: http://vol-public.s3.indian.skylable.com:8008/armel/te=
stcase/xfs2.test.corrupted.gz
> =


I managed to get an updated kernel on a beaglebone I had sitting around,
but I don't reproduce any errors with the "corrupted" image (I think
we've established that the image is fine on-disk and something is going
awry at runtime):

root@beaglebone:~# uname -a
Linux beaglebone 3.14.1+ #5 SMP Thu Jun 11 20:58:02 EDT 2015 armv7l GNU/Lin=
ux
root@beaglebone:~# mount ./xfs2.test.corrupted /mnt/
root@beaglebone:~# ls -al /mnt/a/
total 12
drwxr-xr-x 3 root root   14 Jun 11 16:11 .
drwxr-xr-x 3 root root   14 Jun 11 16:11 ..
drwxr-x--- 2 root root 8192 Jun 11 16:11 b
root@beaglebone:~# ls -al /mnt/a/b/
total 17996
drwxr-x--- 2 root root    8192 Jun 11 16:11 .
drwxr-xr-x 3 root root      14 Jun 11 16:11 ..
-rw-r--r-- 1 root root   12288 Jun 11 16:11 events.db
-rw-r--r-- 1 root root   15360 Jun 11 16:11 f00000000.db
-rw-r--r-- 1 root root   15360 Jun 11 16:11 f00000001.db
-rw-r--r-- 1 root root   15360 Jun 11 16:11 f00000002.db
-rw-r--r-- 1 root root   15360 Jun 11 16:11 f00000003.db
...
root@beaglebone:~#

I echo Dave's suggestion down thread with regard to toolchain. This
kernel was compiled with the following cross-gcc (installed via Fedora
package):

	gcc version 4.9.2 20150212 (Red Hat Cross 4.9.2-5) (GCC) =


Are you using something different?

Brian

> All commands below were run on armv7, and unmounted, the files from /tmp =
copied over to x86-64, gzipped and uploaded, they were never mounted on x86=
-64:
> =

> # dd if=3D/dev/zero of=3D/tmp/xfs2.test bs=3D1M count=3D40
> 40+0 records in
> 40+0 records out
> 41943040 bytes (42 MB) copied, 0.419997 s, 99.9 MB/s
> # mkfs.xfs /tmp/xfs2.test
> meta-data=3D/tmp/xfs2.test         isize=3D256    agcount=3D2, agsize=3D5=
120 blks
>          =3D                       sectsz=3D512   attr=3D2, projid32bit=
=3D0
> data     =3D                       bsize=3D4096   blocks=3D10240, imaxpct=
=3D25
>          =3D                       sunit=3D0      swidth=3D0 blks
> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
> log      =3Dinternal log           bsize=3D4096   blocks=3D1200, version=
=3D2
>          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-co=
unt=3D1
> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
> # cp /tmp/xfs2.test /tmp/xfs2.test.orig
> # umount /export/dfs
> # mount -o loop -t xfs /tmp/xfs2.test /export/dfs
> # mkdir /export/dfs/a
> # sxadm node --new --batch /export/dfs/a/b
> # ls /export/dfs/a/b
> ls: reading directory /export/dfs/a/b: Structure needs cleaning
> # umount /export/dfs
> # cp /tmp/xfs2.test /tmp/xfs2.test.corrupted
> # dmesg >/tmp/dmesg
> # exit
> =

> the latest corruption message from dmesg:
> [4744604.870000] XFS (loop0): Mounting Filesystem
> [4744604.900000] XFS (loop0): Ending clean mount
> [4745016.610000] dc61e000: 58 46 53 42 00 00 10 00 00 00 00 00 00 00 28 0=
0  XFSB..........(.
> [4745016.620000] dc61e010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0  ................
> [4745016.630000] dc61e020: 64 23 d2 06 32 2e 4c 20 82 6e f0 36 a7 d9 54 f=
9  d#..2.L .n.6..T.
> [4745016.640000] dc61e030: 00 00 00 00 00 00 20 04 00 00 00 00 00 00 00 8=
0  ...... .........
> [4745016.640000] XFS (loop0): Internal error xfs_dir3_data_read_verify at=
 line 274 of file fs/xfs/xfs_dir2_data.c.  Caller 0xc01c1528
> [4745016.650000] CPU: 0 PID: 37 Comm: kworker/0:1H Not tainted 3.14.3-000=
88-g7651c68 #24
> [4745016.650000] Workqueue: xfslogd xfs_buf_iodone_work
> [4745016.650000] [<c0013948>] (unwind_backtrace) from [<c0011058>] (show_=
stack+0x10/0x14)
> [4745016.650000] [<c0011058>] (show_stack) from [<c01c3dc4>] (xfs_corrupt=
ion_error+0x54/0x70)
> [4745016.650000] [<c01c3dc4>] (xfs_corruption_error) from [<c01f7854>] (x=
fs_dir3_data_read_verify+0x60/0xd0)
> [4745016.650000] [<c01f7854>] (xfs_dir3_data_read_verify) from [<c01c1528=
>] (xfs_buf_iodone_work+0x7c/0x94)
> [4745016.650000] [<c01c1528>] (xfs_buf_iodone_work) from [<c00309f0>] (pr=
ocess_one_work+0xf4/0x32c)
> [4745016.650000] [<c00309f0>] (process_one_work) from [<c0030fb4>] (worke=
r_thread+0x10c/0x388)
> [4745016.650000] [<c0030fb4>] (worker_thread) from [<c0035e10>] (kthread+=
0xbc/0xd8)
> [4745016.650000] [<c0035e10>] (kthread) from [<c000e8f8>] (ret_from_fork+=
0x14/0x3c)
> [4745016.650000] XFS (loop0): Corruption detected. Unmount and run xfs_re=
pair
> [4745016.650000] XFS (loop0): metadata I/O error: block 0xa000 ("xfs_tran=
s_read_buf_map") error 117 numblks 8
> =

> Best regards,
> --Edwin
> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
