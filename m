Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A2B3429DF5
	for <xfs@oss.sgi.com>; Sun,  9 Aug 2015 20:38:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5B24C304043
	for <xfs@oss.sgi.com>; Sun,  9 Aug 2015 18:38:05 -0700 (PDT)
Received: from mail02.lsn.net (mail02.lsn.net [66.90.130.128]) by cuda.sgi.com
	with ESMTP id SKnFGEL4LTtwT1IM for <xfs@oss.sgi.com>;
	Sun, 09 Aug 2015 18:37:58 -0700 (PDT)
Message-ID: <55C8006C.8070807@mygrande.net>
Date: Sun, 09 Aug 2015 20:37:48 -0500
From: Leslie Rhorer <lrhorer@mygrande.net>
MIME-Version: 1.0
Subject: Re: XFS File system in trouble
References: <03864DDC681E664EBF5D47682BE7D7CF0D358740@USADCWVEMBX07.corp.global.level3.com>
	<CAN3tLtJuk3LKHtxvbXATBR7bjr2e=GTX-fgs-jQniuxqRXjeoA@mail.gmail.com>
	<55AAF73A.4040903@mygrande.net>
	<20150720111747.GA53450@bfoster.bfoster>
	<55B73365.1050908@mygrande.net>
	<20150728123307.GC38784@bfoster.bfoster>
	<55B79BFD.6020509@mygrande.net>
	<20150728221150.GA26604@bfoster.bfoster>
	<55BE7C75.4060604@mygrande.net> <55C06F41.4030502@mygrande.net>
	<20150804224240.GU16638@dastard>
In-Reply-To: <20150804224240.GU16638@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "Rhorer, Leslie" <Leslie.Rhorer@level3.com>, Brian Foster <bfoster@redhat.com>, Kris Rusocki <kszysiu@braxis.org>, Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Well, nice try, but it doesn't wash for several reasons:

1. Power supply issues would be highly unlikely to be the cause of such 
a highly specific failure at always a very specific point in a process. 
  Problems would crop up all over the place, not just with one, very 
specific failure.  While I am thinking of it, I also ran memtest86+ 
again on the new memory.  It passed all tests with flying colors.

2. The system has not been under a heavy load when this happens.  In 
fact, it's piddling.  Rsync and tar are single threaded, eating up at 
most 1 CPU core at a time.  I have processes that can regularly bang all 
8 cores right to the wall with no errors.  The I/O stream is even more 
piddling.  Rsync is transferring nearly 120 MBps (it's a 1G link) during 
the process, and some portions of the tar process can bang out well over 
2Gbps.  Creating a directory is nothing.

3.  All the power supply rails are nominal - I checked.

4. Most damning of all, I am able to reproduce the issue, now, on 
another machine.  I'm not entirely sure why creating the image on one 
partition and then copying it to the root or across the LAN stopped it 
from failing, but I took the 1.5T drive and moved it to the backup 
machine, which as I related earlier is nearly identical in hardware and 
highly similar in software to the primary system.  It's failing there 
repeatedly and consistently:

RR274x/Driver/Freebsd/rr274x_3x-bsd-8.0-v1.0.10.0712.tgz
RR274x/Driver/Linux/
RR274x/Driver/Linux/Debian/
tar: RR274x/Driver/Linux/Debian: Cannot mkdir: Structure needs cleaning
RR274x/Driver/Linux/Debian/rr274x_3x-debian-5.0.1-i386/
tar: RR274x/Driver/Linux/Debian: Cannot mkdir: Input/output error
tar: RR274x/Driver/Linux/Debian/rr274x_3x-debian-5.0.1-i386: Cannot 
mkdir: No such file or directory
RR274x/Driver/Linux/Debian/rr274x_3x-debian-5.0.1-i386/boot/
tar: RR274x/Driver/Linux/Debian: Cannot mkdir: Input/output error
tar: RR274x/Driver/Linux/Debian/rr274x_3x-debian-5.0.1-i386/boot: Cannot 
mkdir: No such file or directory
RR274x/Driver/Linux/Debian/rr274x_3x-debian-5.0.1-i386/boot/rr274x_3x2.6.26-2-486i386.ko.gz
tar: RR274x/Driver/Linux/Debian: Cannot mkdir: Input/output error

gzip: stdin: Input/output error
tar: Unexpected EOF in archive
tar: RR274x/Driver/Linux: Cannot utime: Input/output error
tar: RR274x/Driver/Linux: Cannot change ownership to uid 0, gid 1000: 
Input/output error
tar: RR274x/Driver/Linux: Cannot change mode to rwxr-xr-x: Input/output 
error
tar: RR274x/Driver: Cannot utime: Input/output error
tar: RR274x/Driver: Cannot change ownership to uid 0, gid 1000: 
Input/output error
tar: RR274x/Driver: Cannot change mode to rwxr-xr-x: Input/output error
tar: RR274x: Cannot utime: Input/output error
tar: RR274x: Cannot change ownership to uid 0, gid 1000: Input/output error
tar: RR274x: Cannot change mode to rwxr-xr-x: Input/output error
tar: Error is not recoverable: exiting now


dmesg:
[26743.775522] XFS (sdk): Mounting V4 Filesystem
[26743.904281] XFS (sdk): Ending clean mount
[26743.912614] Loading kernel module for a network device with 
CAP_SYS_MODULE (deprecated).  Use CAP_NET_ADMIN and alias netdev- instead.

<repeats>

[26772.528827] loop: module loaded
[26772.601043] XFS (loop0): Mounting V4 Filesystem
[26772.764360] XFS (loop0): Ending clean mount
[26772.770627] Loading kernel module for a network device with 
CAP_SYS_MODULE (deprecated).  Use CAP_NET_ADMIN and alias netdev- instead.

<repeats>

[26899.019942] XFS (loop0): xfs_iread: validation failed for inode 
124656869424 failed
[26899.019952] ffff8800b473e000: 49 4e 00 00 03 02 00 00 00 30 00 70 00 
00 03 e8  IN.......0.p....
[26899.019957] ffff8800b473e010: 00 00 00 00 06 20 b0 6f 01 2e 00 00 00 
00 00 16  ..... .o........
[26899.019960] ffff8800b473e020: 01 57 37 fd 2b 5d 22 9e 1e 0a 61 8c 00 
00 00 20  .W7.+]"...a....
[26899.019964] ffff8800b473e030: ff ff 00 d2 1b f6 27 90 00 00 00 00 00 
00 00 00  ......'.........
[26899.019993] XFS (loop0): Internal error xfs_iread at line 392 of file 
/build/linux-u5KAtC/linux-3.16.7-ckt11/fs/xfs/xfs_inode_buf.c.  Caller 
xfs_iget+0x24b/0x690 [xfs]
[26899.020000] CPU: 6 PID: 3756 Comm: tar Not tainted 3.16.0-4-amd64 #1 
Debian 3.16.7-ckt11-1+deb8u2
[26899.020004] Hardware name: To be filled by O.E.M. To be filled by 
O.E.M./SABERTOOTH 990FX R2.0, BIOS 0803 08/15/2012
[26899.020007]  0000000000000001 ffffffff8150b3d5 ffff8800065b9800 
ffffffffa06bd5cb
[26899.020014]  0000018800000010 ffffffffa06c2f6b ffff88000a680400 
ffff8800065b9800
[26899.020019]  0000000000000075 ffff88000527f140 ffffffffa0708b3a 
ffffffffa06c2f6b
[26899.020024] Call Trace:
[26899.020034]  [<ffffffff8150b3d5>] ? dump_stack+0x41/0x51
[26899.020052]  [<ffffffffa06bd5cb>] ? xfs_corruption_error+0x5b/0x80 [xfs]
[26899.020069]  [<ffffffffa06c2f6b>] ? xfs_iget+0x24b/0x690 [xfs]
[26899.020090]  [<ffffffffa0708b3a>] ? xfs_iread+0xea/0x400 [xfs]
[26899.020106]  [<ffffffffa06c2f6b>] ? xfs_iget+0x24b/0x690 [xfs]
[26899.020124]  [<ffffffffa06c2f6b>] ? xfs_iget+0x24b/0x690 [xfs]
[26899.020146]  [<ffffffffa0702de6>] ? xfs_ialloc+0xa6/0x500 [xfs]
[26899.020192]  [<ffffffffa06d258e>] ? kmem_zone_alloc+0x6e/0xe0 [xfs]
[26899.020215]  [<ffffffffa07032a2>] ? xfs_dir_ialloc+0x62/0x2a0 [xfs]
[26899.020237]  [<ffffffffa06d11e5>] ? xfs_trans_reserve+0x1f5/0x200 [xfs]
[26899.020261]  [<ffffffffa07039a9>] ? xfs_create+0x489/0x700 [xfs]
[26899.020267]  [<ffffffff811b40ea>] ? kern_path_create+0xaa/0x190
[26899.020286]  [<ffffffffa06c85ea>] ? xfs_generic_create+0xca/0x250 [xfs]
[26899.020292]  [<ffffffff811b7ad0>] ? vfs_mkdir+0xb0/0x160
[26899.020296]  [<ffffffff811b868b>] ? SyS_mkdirat+0xab/0xe0
[26899.020303]  [<ffffffff8151158d>] ? 
system_call_fast_compare_end+0x10/0x15
[26899.020307] XFS (loop0): Corruption detected. Unmount and run xfs_repair
[26899.020337] XFS (loop0): Internal error xfs_trans_cancel at line 959 
of file /build/linux-u5KAtC/linux-3.16.7-ckt11/fs/xfs/xfs_trans.c. 
Caller xfs_create+0x2b2/0x700 [xfs]
[26899.020342] CPU: 6 PID: 3756 Comm: tar Not tainted 3.16.0-4-amd64 #1 
Debian 3.16.7-ckt11-1+deb8u2
[26899.020345] Hardware name: To be filled by O.E.M. To be filled by 
O.E.M./SABERTOOTH 990FX R2.0, BIOS 0803 08/15/2012
[26899.020347]  000000000000000c ffffffff8150b3d5 ffff88000527f140 
ffffffffa06d1e07
[26899.020354]  ffff88000a729800 ffff8800066e3ec8 ffff8800065b9800 
ffffffffa07037d2
[26899.020359]  0000000000000001 ffff8800066e3e20 ffff8800066e3e1c 
ffff8800066e3eb0
[26899.020364] Call Trace:
[26899.020370]  [<ffffffff8150b3d5>] ? dump_stack+0x41/0x51
[26899.020388]  [<ffffffffa06d1e07>] ? xfs_trans_cancel+0xc7/0xf0 [xfs]
[26899.020409]  [<ffffffffa07037d2>] ? xfs_create+0x2b2/0x700 [xfs]
[26899.020414]  [<ffffffff811b40ea>] ? kern_path_create+0xaa/0x190
[26899.020432]  [<ffffffffa06c85ea>] ? xfs_generic_create+0xca/0x250 [xfs]
[26899.020437]  [<ffffffff811b7ad0>] ? vfs_mkdir+0xb0/0x160
[26899.020442]  [<ffffffff811b868b>] ? SyS_mkdirat+0xab/0xe0
[26899.020447]  [<ffffffff8151158d>] ? 
system_call_fast_compare_end+0x10/0x15
[26899.020454] XFS (loop0): xfs_do_force_shutdown(0x8) called from line 
960 of file /build/linux-u5KAtC/linux-3.16.7-ckt11/fs/xfs/xfs_trans.c. 
Return address = 0xffffffffa06d1e20
[26899.407181] XFS (loop0): Corruption of in-memory data detected. 
Shutting down filesystem
[26899.407190] XFS (loop0): Please umount the filesystem and rectify the 
problem(s)
[26923.319559] XFS (loop0): xfs_log_force: error 5 returned.

<repeats>

Xfs_repair still reports no faults.  I'm compressing the dump file and 
image file right now to be posted on http:/flethergeek.com/images when 
it is done, but it is taking a very long time.  I'll also try 
decompresssing the image to the other array to see if it still fails 
before I upload the file.  'No point in uploading if putting it through 
the compression process results in an image that does not fail.

On 8/4/2015 5:42 PM, Dave Chinner wrote:
> On Tue, Aug 04, 2015 at 02:52:33AM -0500, Leslie Rhorer wrote:
>> 	It's failing, again.  The rsync job failed and when I attempt to
>> untar the file in the image mount, it fails there, as well.  See
>> below.  I formatted a 1.5T drive as xfs and mounted it under /media.
>> I then dumped the failing FS to a file on /media using xfs_metadump
>> and used xfs_mdrestore to create an image of the FS.  I then mounted
>> the image, copied over the tarball to its location, and ran tar to
>> extract the files:
>>
>> [131874.545344] loop: module loaded
>> [131874.549914] XFS (loop0): Mounting V4 Filesystem
>                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
>> [131874.555540] XFS (loop0): Ending clean mount
>> [132020.964431] XFS (loop0): xfs_iread: validation failed for inode 124656869424 failed
>> [132020.964435] ffff88028b078000: 49 4e 00 00 03 02 00 00 00 30 00 70 00 00 03 e8  IN.......0.p....
>> [132020.964437] ffff88028b078010: 00 00 00 00 06 20 b0 6f 01 2e 00 00 00 00 00 16  ..... .o........
>> [132020.964438] ffff88028b078020: 01 57 37 fd 2b 5d 22 9e 1e 0a 61 8c 00 00 00 20  .W7.+]"...a....
>> [132020.964440] ffff88028b078030: ff ff 00 d2 1b f6 27 90 00 00 00 00 00 00 00 00  ......'.........
>> [132020.964454] XFS (loop0): Internal error xfs_iread at line 392 of
>> file /build/linux-QZaPpC/linux-3.16.7-ckt11/fs/xfs/xfs_inode_buf.c.
>> Caller xfs_iget+0x24b/0x690 [xfs]
>
> That's a different error to all the ones you've previously posted.
> This is an inode allocation that has found a bad inode on disk.
>
> Decoding the 64 bytes above:
>
> 	di_magic = 0x494e
> 	di_mode = 0
> 	di_version = 3			<<< That's *wrong*
> 	di_format = 2
> 	di_onlink = 0
> 	di_uid = 0x300070		<<< Looks unlikely
> 	di_gid = 0x3e8
> ----
> 	di_nlink = 0
> 	di_projlo = 0x620		<<< should be zero
> 	di_projhi = 0xb06f		<<< should be zero
> 	di_pad[6] = 0x1 0x2e 0 0 0 0	<<< should be zero
> 	di_flushiter = 0x16		<<< should be zero for v3 inode
> ---
> 	di_atime	<random>
> 	di_mtime	<random, should be similar to atime>
> 	di_ctime	<random, should be similar/same as mtime>
> 	di_size = 0x20ffff00d2		<<< should be zero
> ----
> 	di_nblocks = 0x1bf6279000000000 <<< should be zero
> 	di_extsize = 0
> ----
>
> You've just created and mounted a v4 filesystem, which means it is
> using v2 inodes. This inode read back as a v3 inode, with lots of
> crap in places where there should be zeros for either v2 or v3 inodes.
>
> This does not look like a filesystem problem - it's clear that what
> has come from disk (or a cached memory buffer) is full of garbage
> and contains invalid configuration, and the filesystem has quite
> correctly detected the corruption and shut down. The filesystem
> would give the same errors if it tried to *write* such a corrupt
> block, so we know what was just been detected has not come from the
> filesytem code...
>
> FWIW, I've occasionally seen this sort of thing happen when a power
> supply had gone bad - it wasn't bad enough to make things fail, it
> ust caused transient issues under load that manifest as corruptions
> and crashes. Given that you've already found one set of hardware
> problems and the corruption patterns are unlike any
> filesystem/storage problem I've ever seen, I'd suggest that you
> still have some kind of hardware issue...
>
> Cheers,
>
> Dave.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
