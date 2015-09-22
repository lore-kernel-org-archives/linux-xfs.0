Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1524929DF5
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 07:41:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E623B8F8033
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 05:41:11 -0700 (PDT)
Received: from mail.nomovok.com (mail.nomovok.com [83.150.122.238]) by
	cuda.sgi.com with ESMTP id lJwFEEkv6ctGj0m1 (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Sep 2015 05:41:09 -0700 (PDT)
Received: from [192.168.0.111]
	(host46-236-dynamic.8-87-r.retail.telecomitalia.it [87.8.236.46])
	by mail.nomovok.com (Postfix) with ESMTPSA id 49652AE17E
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 15:41:07 +0300 (EEST)
Message-ID: <56014C62.1070403@nomovok.com>
Date: Tue, 22 Sep 2015 14:41:06 +0200
From: Angelo Dureghello <angelo.dureghello@nomovok.com>
MIME-Version: 1.0
Subject: Re: xfstests, bad generic tests 009 and 308
References: <55FC3E0E.9060506@nomovok.com> <20150918224412.GE26895@dastard>
	<55FFE665.7040004@nomovok.com> <20150921225244.GD19114@dastard>
In-Reply-To: <20150921225244.GD19114@dastard>
Content-Type: multipart/mixed; boundary="------------090109000100090403070109"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------090109000100090403070109
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave,

still thanks for following.

>> I am using actually gcc-linaro-4.9-2015.05-x86_64_arm-linux-gnueabihf
> So gcc-4.9 patched with a bunch of stuff from linaro and built as a
> cross compiler from x86-64 to 32 bit arm? ISTR we had a bunch of
> different compiler problems at one point that only showed up in
> kernels build with a x86-64 to arm cross-compiler.  In case you
> haven't guessed, XFS has a history of being bitten by ARM compiler
> problems. There's been a lot more problems in the past couple of
> years than the historical trend, though.
>
> As it is, I highly recommend that you try a current 4.3 kernel, as
> there are several code fixes in the XFS kernel code that work around
> compiler issues we know about. AFAIA, the do_div() asm bug that
> trips recent gcc optimisations isn't in the upstream kernel yet, but
> that can be worked around by setting CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> in your build.

Well, i updated to this toolchain recently, but built the kernel also
with an i686 4.9 toolchain, and had exactly same tests errors.
Yes i am always cross compiling for armhf btw.
I am using a 4.1.5-rt from TI,
will try possibly some more recent version and let you know.

>> I have recent git version of xfstests, but generic/308 shows
>>
>> #! /bin/bash
>> # FS QA Test No. 308
>> #
>> # Regression test for commit:
>> # f17722f ext4: Fix max file size and logical block counting of
>> extent format file
> More that one filesystem had problems with maximum file sizes on 32
> bit systems. Compare the contents of the test; don't stop reading
> because the summary of the test makes you think the rest of the test
> is unrelated to the problem at hand.
>
>> I have a 16MB partition, and wondering why xfs allows from test 308
>> to create a 16TB file.
>>
>> -rw------- 1 root root  17592186044415 Sep 18 09:40 testfile.308
> https://en.wikipedia.org/wiki/Sparse_file
>
>> QA output created by 009
>> 	1. into a hole
>> 0: [0..39]: hole
>> daa100df6e6711906b61c9ab5aa16032
>> 	2. into allocated space
>> cc58a7417c2d7763adc45b6fcd3fa024
>> 	3. into unwritten space
>> daa100df6e6711906b61c9ab5aa16032
> I don't need to look any further to see that something is badly
> wrong here. This is telling me that no extents are being allocated
> at all, which indicates either fiemap is broken, awk/sed is
> broken or misbehaving (and hence mangling the output) or something
> deep in the filesystem code is fundamentally broken in some
> strange, silent way.
>
> Can you create an xfs filesystem on your scratch device, and
> manually run this command and post the output:
>
> # mkfs.xfs -V
> # mkfs.xfs <dev>
> # mount <dev> /mnt/xfs
> # xfs_io -f -c "pwrite 0 64k" -c sync \
> 	    -c "bmap -vp" -c "fiemap -v" \
> 	    -c "falloc 1024k 256k" -c sync \
> 	    -c "pwrite 1088k 64k" -c sync \
> 	    -c "bmap -vp" -c "fiemap -v" \
> 	    /mnt/xfs/testfile
>
> and attach the entire output?

I attached the output. I can be completely wrong, but file system
seems quite reliable for rootfs operations until now. At least,
never had any issue after installing and removing several and several
debian packages.
Only issues i had are created from test 308 that, if left running too long,
it damages the fs.

> It would also be good if you can run this command under trace-cmd
> and capture all the XFS events that occur during the test. See

Ok, about test 308, the 2 xfs_io operations passes, it stops on the rm 
exiting
the tests, while trying to erase the 16t file.

# Create a sparse file with an extent lays at one block before old 
s_maxbytes
offset=$(((2**32 - 2) * $block_size))
$XFS_IO_PROG -f -c "pwrite $offset $block_size" -c fsync $testfile 
 >$seqres.full 2>&1

rm can remove remove correctly this file (17592186040320)

# Write to the block after the extent just created
offset=$(((2**32 - 1) * $block_size))
$XFS_IO_PROG -f -c "pwrite $offset $block_size" -c fsync $testfile 
 >>$seqres.full 2>&1

while rm hangs on removing this file (17592186044415)

Magic sysrq l or t is not helping, nothing useful comes out.
But i collected the strace log. Since the issue is at unlinkat().



Many thanks
Best regards
Angelo


-- 
Best regards,
Angelo Dureghello


--------------090109000100090403070109
Content-Type: text/plain; charset=UTF-8;
 name="mkfs_output.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mkfs_output.txt"

root[249] ~
# mkfs.xfs -V
mkfs.xfs version 3.2.1
root[250] ~
# mkfs.xfs /dev/mmcblk0p6
mkfs.xfs: /dev/mmcblk0p6 appears to contain an existing filesystem (xfs).
mkfs.xfs: Use the -f option to force overwrite.
root[251] ~
# mkfs.xfs -f /dev/mmcblk0p6
meta-data=/dev/mmcblk0p6         isize=256    agcount=4, agsize=551008 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=2204032, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
root[252] ~
# mount /dev/mmcblk0p6 /media/p6                
[38946.599770] XFS (mmcblk0p6): Mounting V4 Filesystem
[38946.800708] XFS (mmcblk0p6): Ending clean mount

# xfs_io -f -c "pwrite 0 64k" -c sync \
                       -c "bmap -vp" -c "fiemap -v" \
                       -c "falloc 1024k 256k" -c sync \
                       -c "pwrite 1088k 64k" -c sync \
                       -c "bmap -vp" -c "fiemap -v" \
                       /media/p6/testfile
wrote 65536/65536 bytes at offset 0
64 KiB, 16 ops; 0.0000 sec (96.154 MiB/sec and 24615.3846 ops/sec)
command "sync" not found
/media/p6/testfile:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..127]:        96..223           0 (96..223)          128 00000
/media/p6/testfile:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..127]:        96..223            128   0x1
command "sync" not found
wrote 65536/65536 bytes at offset 1114112
64 KiB, 16 ops; 0.0000 sec (112.208 MiB/sec and 28725.3142 ops/sec)
command "sync" not found
/media/p6/testfile:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..127]:        96..223           0 (96..223)          128 00000
   1: [128..2047]:     hole                                  1920
   2: [2048..2559]:    2144..2655        0 (2144..2655)       512 10000
/media/p6/testfile:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..127]:        96..223            128   0x0
   1: [128..2047]:     hole              1920
   2: [2048..2175]:    2144..2271         128 0x800
   3: [2176..2303]:    2272..2399         128   0x0
   4: [2304..2559]:    2400..2655         256 0x801

Step by step xfs_io
-------------------

Due to the "sync" is missing, i tried also command by command with
shell "sync" after each command. Output is exactly the same.



--------------090109000100090403070109
Content-Type: text/plain; charset=UTF-8;
 name="strace_rm_308.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="strace_rm_308.txt"

-rw-------  1 root root 17592186040320 Sep 22 10:55 testfile.308


rm ok

-rw-------  1 root root 17592186044415 Sep 22 10:58 testfile.308

total 496
drwxr-xr-x 11 root root           4096 Sep 22 10:58 .
drwxr-xr-x  4 root root            101 Sep 22 08:40 ..
-rw-------  1 root root         131072 Sep 21 14:50 008.24410
-rw-------  1 root root         131072 Sep 21 14:52 008.2913
-rw-------  1 root root           4096 Sep 21 14:50 009.25001
-rw-------  1 root root           4096 Sep 21 14:52 009.3505
-rw-------  1 root root          81920 Sep 21 14:50 012.26531
-rw-------  1 root root          49152 Sep 21 14:52 012.5039
drwxr-xr-x  3 root root           4096 Sep 21 15:16 14536
drwxr-xr-x  3 root root             38 Sep 21 15:25 16802
drwxr-xr-x  3 root root           4096 Sep 21 15:26 18438
drwxr-xr-x  3 root root             38 Sep 21 15:27 21042
drwxr-xr-x  3 root root             38 Sep 21 14:50 27593
drwxr-xr-x  3 root root             70 Sep 21 15:08 8274
drwxr-xr-x  3 root root             15 Sep 21 14:53 fsstress.5653.1
drwxr-xr-x 22 root root           4096 Sep 21 14:53 fsstress.5653.2
-rw-------  1 root root 17592186044415 Sep 22 11:44 testfile.308
drwxr-xr-x  2 root root             20 Sep 21 15:12 tmp
root[252] vpc24 /media/p5
# rm testfile.308 

# strace rm testfile.308 
execve("/bin/rm", ["rm", "testfile.308"], [/* 16 vars */]) = 0
brk(0)                                  = 0x2a000
uname({sys="Linux", node="vpc24", ...}) = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap2(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb6f36000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=34089, ...}) = 0
mmap2(NULL, 34089, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb6f2d000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/arm-linux-gnueabihf/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\3\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0Mw\1\0004\0\0\0"..., 512) = 512
lseek(3, 899996, SEEK_SET)              = 899996
read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 2880) = 2880
lseek(3, 896548, SEEK_SET)              = 896548
read(3, "A4\0\0\0aeabi\0\1*\0\0\0\0057-A\0\6\n\7A\10\1\t\2\n\3\f"..., 53) = 53
fstat64(3, {st_mode=S_IFREG|0755, st_size=902876, ...}) = 0
mmap2(NULL, 972200, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb6e23000
mprotect(0xb6efc000, 61440, PROT_NONE)  = 0
mmap2(0xb6f0b000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xd8000) = 0xb6f0b000
mmap2(0xb6f0e000, 9640, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb6f0e000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb6f2c000
set_tls(0xb6f2c850, 0xb6f39050, 0xb6f2cf38, 0xb6f2c850, 0xb6f39050) = 0
mprotect(0xb6f0b000, 8192, PROT_READ)   = 0
mprotect(0x28000, 4096, PROT_READ)      = 0
mprotect(0xb6f38000, 4096, PROT_READ)   = 0
munmap(0xb6f2d000, 34089)               = 0
brk(0)                                  = 0x2a000
brk(0x4b000)                            = 0x4b000
ioctl(0, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, {B115200 opost isig icanon echo ...}) = 0
newfstatat(AT_FDCWD, "testfile.308", {st_mode=S_IFREG|0600, st_size=17592186044415, ...}, AT_SYMLINK_NOFOLLOW) = 0
geteuid32()                             = 0
unlinkat(AT_FDCWD, "testfile.308", 0

--------------090109000100090403070109
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------090109000100090403070109--
