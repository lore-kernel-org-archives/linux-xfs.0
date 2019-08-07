Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46182 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbfHGKRw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Aug 2019 06:17:52 -0400
Received: by mail-pl1-f196.google.com with SMTP id c2so40077055plz.13
        for <linux-xfs@vger.kernel.org>; Wed, 07 Aug 2019 03:17:51 -0700 (PDT)
Date: Wed, 7 Aug 2019 18:17:42 +0800
From: Murphy Zhou <jencce.kernel@gmail.com>
Subject: Re: [LTP] [PATCH v7 3/3] syscalls/copy_file_range02: increase
 coverage and remove EXDEV test
Message-ID: <20190807101742.mt6tgowsh4xw5hyt@XZHOUW.usersys.redhat.com>
References: <20190730110555.GB7528@rei.lan>
 <1564569629-2358-1-git-send-email-xuyang2018.jy@cn.fujitsu.com>
 <1564569629-2358-3-git-send-email-xuyang2018.jy@cn.fujitsu.com>
 <20190805065832.ti6vpoviykfaxcj7@XZHOUW.usersys.redhat.com>
 <5D47D6B9.9090306@cn.fujitsu.com>
 <20190805102211.pvyufepn6xywi7vm@XZHOUW.usersys.redhat.com>
 <20190806162703.GA1333@dell5510>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cbjas7zntt62c4iw"
Content-Disposition: inline
In-Reply-To: <20190806162703.GA1333@dell5510>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Petr Vorel <pvorel@suse.cz>
Cc: Murphy Zhou <jencce.kernel@gmail.com>, Yang Xu <xuyang2018.jy@cn.fujitsu.com>, chrubis@suse.cz, ltp@lists.linux.it, linux-xfs@vger.kernel.org


--cbjas7zntt62c4iw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

ccing linux-xfs@vger.kernel.org

Hi,

Tracked down this to be a xfs specific issue:

If we call copy_file_range with a large offset like this:

	loff_t off = 9223372036854710270; // 2 ** 63
	ret = copy_file_range(fd_in, 0, fd_out, &off, 65537, 0);

(test programme cfrbig.c attached)

xfs has it done successfully, while ext4 returns EFBIG.

ccing xfs folks to check that if this is expected for xfs.

We are now expecting EFBIG in copy_file_range02.c test #12.

Thanks!

Other info:

[root@8u ~]# xfs_info /test1
meta-data=/dev/pmem0             isize=512    agcount=4, agsize=327680 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=1310720, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@8u ~]# mkfs.xfs -V
mkfs.xfs version 5.2.0-rc0
[root@8u ~]# mount | grep test
/dev/pmem0 on /test1 type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota)
[root@8u ~]# uname -r
5.3.0-rc3-v5.3-rc3-282-g33920f1
[root@8u ~]# cp a.out /test1
[root@8u ~]# cp 1t /test1
[root@8u ~]# cd /test1
[root@8u test1]# ./a.out 1t 2t
ret 40945
[root@8u test1]# ll 1t 2t
-rw-r--r--. 1 root root               40945 Aug  7 17:35 1t
-rw-r--r--. 1 root root 9223372036854751215 Aug  7 17:35 2t
[root@8u test1]# 

On Tue, Aug 06, 2019 at 06:27:03PM +0200, Petr Vorel wrote:
> Hi Murphy,
> 
> > On Mon, Aug 05, 2019 at 03:11:53PM +0800, Yang Xu wrote:
> > > on 2019/08/05 14:58, Murphy Zhou  wrote:
> 
> > > > > + * 13) Try to copy contents to a file with target file range
> > > > > >  + *     beyond maximum supported file size ->EFBIG
> > > > Test 13) fails on latest Linus tree. Is there any report or working on this?
> > > Hi Murphy
> 
> > >    Test 13)  passed on my system(64bit, 5.2.0+, ext4,vfat,btrfs,xfs ).
> > >    Do you provide more infomation(filesystem, 32bit or 64bit)?
> 
> > All of them, ext234 xfs and vfat. 64bit
> Hi, I can confirm that. Also fails on btrfs.
> 
> > copy_file_range02.c:127: FAIL: copy_file_range returned wrong value: 32
> I got this one as well. I tested it today again with 5.3.0-rc3+ 0eb0ce0 ("Merge
> tag 'spi-fix-v5.3-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi")
> and got this error:
> 
> copy_file_range02.c:130: FAIL: copy_file_range failed unexpectedly; expected EFBIG, but got: EINVAL
> 
> But that is caused by tmpfs used as TMPDIR, going to send a patch fixing it.

And I have a question about LTP itself.

If we run the testcase directly like:
	 ./testcases/kernel/syscalls/copy_file_range/copy_file_range02

to test all_filesystems, for every filesystem, we mkfs and mount it in
.mntpoint, but we do not chdir to .mntpoint. So we are running tests in 
the same tmpdir, fs type of which does not change while looping
all_filesystems.  Only the .mntpoint in tmpdir has different fs type in
each loop.

Now we are using this to test cross-device copy in copy_file_range01.c,
but in copy_file_range02.c, we are not using .mntpint at all, all the
tests in the all_filesystems loop are running in the same tmpdir. In other
words, we are NOT testing all filesystems.

Is this expected?

I commented out testcases in copy_file_range02.c other then #12, and add
some nasty debug info:

diff --git a/testcases/kernel/syscalls/copy_file_range/copy_file_range02.c b/testcases/kernel/syscalls/copy_file_range/copy_file_range02.c
index 56797f639..c74f1a7ec 100644
--- a/testcases/kernel/syscalls/copy_file_range/copy_file_range02.c
+++ b/testcases/kernel/syscalls/copy_file_range/copy_file_range02.c
@@ -62,6 +62,7 @@ static struct tcase {
 	loff_t     len;
 	const char *tname;
 } tcases[] = {
+#if 0
 	{&fd_rdonly,	0,   EBADF,      0,     CONTSIZE, "readonly file"},
 	{&fd_dir,	0,   EISDIR,     0,     CONTSIZE, "directory"},
 	{&fd_append,	0,   EBADF,      0,     CONTSIZE, "append to file"},
@@ -74,6 +75,7 @@ static struct tcase {
 	{&fd_chrdev,    0,   EINVAL,     0,     CONTSIZE, "charr device"},
 	{&fd_fifo,      0,   EINVAL,     0,     CONTSIZE, "fifo"},
 	{&fd_copy,      0,   EOVERFLOW,  MAX_OFF, ULLONG_MAX, "max length lenght"},
+#endif
 	{&fd_copy,      0,   EFBIG,      MAX_OFF, MIN_OFF, "max file size"},
 };
 
@@ -163,6 +165,9 @@ static void setup(void)
 	syscall_info();
 	char dev_path[1024];
 
+	system("pwd");
+	system("df -Th .");
+	system("mount | grep loop");
 	if (access(FILE_DIR_PATH, F_OK) == -1)
 		SAFE_MKDIR(FILE_DIR_PATH, 0777);
 	/*


Got this: (deleted some irrelevant lines of output)

All tests on / filesystem.


tst_test.c:1161: INFO: Testing on ext2
tst_mkfs.c:90: INFO: Formatting /dev/loop0 with ext2 opts='' extra opts=''
mke2fs 1.44.6 (5-Mar-2019)
tst_test.c:1100: INFO: Timeout per run is 0h 05m 00s
copy_file_range.h:44: INFO: Testing __NR_copy_file_range syscall
/tmp/koASqI
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/sda2      xfs   618G  432G  187G  70% /
/dev/loop0 on /tmp/koASqI/mnt_point type ext2 (rw,relatime,seclabel,errors=continue,user_xattr,acl)
tst_device.c:87: INFO: Found free device 1 '/dev/loop1'
Setting up swapspace version 1, size = 36 KiB (36864 bytes)
no label, UUID=faff58f0-a824-48b6-a103-bc6b1cc99a17
copy_file_range02.c:103: INFO: Test #0: max file size
copy_file_range02.c:132: FAIL: copy_file_range returned wrong value: 32

tst_test.c:1161: INFO: Testing on ext3
tst_mkfs.c:90: INFO: Formatting /dev/loop0 with ext3 opts='' extra opts=''
mke2fs 1.44.6 (5-Mar-2019)
tst_test.c:1100: INFO: Timeout per run is 0h 05m 00s
copy_file_range.h:44: INFO: Testing __NR_copy_file_range syscall
/tmp/koASqI
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/sda2      xfs   618G  432G  187G  70% /
/dev/loop0 on /tmp/koASqI/mnt_point type ext3 (rw,relatime,seclabel)
tst_device.c:87: INFO: Found free device 1 '/dev/loop1'
Setting up swapspace version 1, size = 36 KiB (36864 bytes)
no label, UUID=c9e759f6-866d-421d-8322-1a60e7e387ce
copy_file_range02.c:103: INFO: Test #0: max file size
copy_file_range02.c:132: FAIL: copy_file_range returned wrong value: 32

tst_test.c:1161: INFO: Testing on ext4
tst_mkfs.c:90: INFO: Formatting /dev/loop0 with ext4 opts='' extra opts=''
mke2fs 1.44.6 (5-Mar-2019)
tst_test.c:1100: INFO: Timeout per run is 0h 05m 00s
copy_file_range.h:44: INFO: Testing __NR_copy_file_range syscall
/tmp/koASqI
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/sda2      xfs   618G  432G  187G  70% /
/dev/loop0 on /tmp/koASqI/mnt_point type ext4 (rw,relatime,seclabel)
tst_device.c:87: INFO: Found free device 1 '/dev/loop1'
Setting up swapspace version 1, size = 36 KiB (36864 bytes)
no label, UUID=de87413e-3700-4928-9529-7968a6753dda
copy_file_range02.c:103: INFO: Test #0: max file size
copy_file_range02.c:132: FAIL: copy_file_range returned wrong value: 32

tst_test.c:1161: INFO: Testing on xfs
tst_mkfs.c:90: INFO: Formatting /dev/loop0 with xfs opts='' extra opts=''
tst_test.c:1100: INFO: Timeout per run is 0h 05m 00s
copy_file_range.h:44: INFO: Testing __NR_copy_file_range syscall
/tmp/koASqI
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/sda2      xfs   618G  432G  187G  70% /
/dev/loop0 on /tmp/koASqI/mnt_point type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota)
tst_device.c:87: INFO: Found free device 1 '/dev/loop1'
Setting up swapspace version 1, size = 36 KiB (36864 bytes)
no label, UUID=bd59eb67-2ca9-44c5-9f04-1a2bd85ef3cc
copy_file_range02.c:103: INFO: Test #0: max file size
copy_file_range02.c:132: FAIL: copy_file_range returned wrong value: 32

tst_test.c:1161: INFO: Testing on vfat
tst_mkfs.c:90: INFO: Formatting /dev/loop0 with vfat opts='' extra opts=''
tst_test.c:1100: INFO: Timeout per run is 0h 05m 00s
copy_file_range.h:44: INFO: Testing __NR_copy_file_range syscall
/tmp/koASqI
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/sda2      xfs   618G  432G  187G  70% /
/dev/loop0 on /tmp/koASqI/mnt_point type vfat (rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,errors=remount-ro)
tst_device.c:87: INFO: Found free device 1 '/dev/loop1'
Setting up swapspace version 1, size = 36 KiB (36864 bytes)
no label, UUID=e29211e3-175e-46de-b8bc-e6f021de585e
copy_file_range02.c:103: INFO: Test #0: max file size
copy_file_range02.c:132: FAIL: copy_file_range returned wrong value: 32



After adding chdir to .mntpoint in setup:


diff --git a/testcases/kernel/syscalls/copy_file_range/copy_file_range02.c b/testcases/kernel/syscalls/copy_file_range/copy_file_range02.c
index 56797f639..d7b0a7cfd 100644
--- a/testcases/kernel/syscalls/copy_file_range/copy_file_range02.c
+++ b/testcases/kernel/syscalls/copy_file_range/copy_file_range02.c
@@ -62,6 +62,7 @@ static struct tcase {
 	loff_t     len;
 	const char *tname;
 } tcases[] = {
+#if 0
 	{&fd_rdonly,	0,   EBADF,      0,     CONTSIZE, "readonly file"},
 	{&fd_dir,	0,   EISDIR,     0,     CONTSIZE, "directory"},
 	{&fd_append,	0,   EBADF,      0,     CONTSIZE, "append to file"},
@@ -74,6 +75,7 @@ static struct tcase {
 	{&fd_chrdev,    0,   EINVAL,     0,     CONTSIZE, "charr device"},
 	{&fd_fifo,      0,   EINVAL,     0,     CONTSIZE, "fifo"},
 	{&fd_copy,      0,   EOVERFLOW,  MAX_OFF, ULLONG_MAX, "max length lenght"},
+#endif
 	{&fd_copy,      0,   EFBIG,      MAX_OFF, MIN_OFF, "max file size"},
 };
 
@@ -156,6 +158,7 @@ static void cleanup(void)
 	if (fd_copy > 0)
 		SAFE_CLOSE(fd_copy);
 	SAFE_UNLINK(FILE_FIFO);
+	SAFE_CHDIR("..");
 }
 
 static void setup(void)
@@ -163,6 +166,11 @@ static void setup(void)
 	syscall_info();
 	char dev_path[1024];
 
+	SAFE_CHDIR(MNTPOINT);
+
+	system("pwd");
+	system("df -Th .");
+	system("mount | grep loop");
 	if (access(FILE_DIR_PATH, F_OK) == -1)
 		SAFE_MKDIR(FILE_DIR_PATH, 0777);
 	/*


Only xfs fails the test now:  (vfat brok)

tst_test.c:1161: INFO: Testing on ext2
tst_mkfs.c:90: INFO: Formatting /dev/loop0 with ext2 opts='' extra opts=''
mke2fs 1.44.6 (5-Mar-2019)
tst_test.c:1100: INFO: Timeout per run is 0h 05m 00s
copy_file_range.h:41: INFO: Testing libc copy_file_range()
/tmp/QtMvgB/mnt_point
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     ext2  248M  2.1M  234M   1% /tmp/QtMvgB/mnt_point
/dev/loop0 on /tmp/QtMvgB/mnt_point type ext2 (rw,relatime,seclabel,errors=continue,user_xattr,acl)
tst_device.c:87: INFO: Found free device 1 '/dev/loop1'
Setting up swapspace version 1, size = 36 KiB (36864 bytes)
no label, UUID=46d54fae-85fb-4836-ab69-2ebb23d8fa75
copy_file_range02.c:103: INFO: Test #0: max file size
copy_file_range02.c:123: PASS: copy_file_range failed as expected: EFBIG

tst_test.c:1161: INFO: Testing on ext3
tst_mkfs.c:90: INFO: Formatting /dev/loop0 with ext3 opts='' extra opts=''
mke2fs 1.44.6 (5-Mar-2019)
tst_test.c:1100: INFO: Timeout per run is 0h 05m 00s
copy_file_range.h:41: INFO: Testing libc copy_file_range()
/tmp/QtMvgB/mnt_point
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     ext3  240M  2.1M  226M   1% /tmp/QtMvgB/mnt_point
/dev/loop0 on /tmp/QtMvgB/mnt_point type ext3 (rw,relatime,seclabel)
tst_device.c:87: INFO: Found free device 1 '/dev/loop1'
Setting up swapspace version 1, size = 36 KiB (36864 bytes)
no label, UUID=9598e117-03cc-4bf3-9706-3f072303709b
copy_file_range02.c:103: INFO: Test #0: max file size
copy_file_range02.c:123: PASS: copy_file_range failed as expected: EFBIG

tst_test.c:1161: INFO: Testing on ext4
tst_mkfs.c:90: INFO: Formatting /dev/loop0 with ext4 opts='' extra opts=''
mke2fs 1.44.6 (5-Mar-2019)
tst_test.c:1100: INFO: Timeout per run is 0h 05m 00s
copy_file_range.h:41: INFO: Testing libc copy_file_range()
/tmp/QtMvgB/mnt_point
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     ext4  240M  2.1M  222M   1% /tmp/QtMvgB/mnt_point
/dev/loop0 on /tmp/QtMvgB/mnt_point type ext4 (rw,relatime,seclabel)
tst_device.c:87: INFO: Found free device 1 '/dev/loop1'
Setting up swapspace version 1, size = 36 KiB (36864 bytes)
no label, UUID=714961f8-dcda-451e-98df-091d2b670a97
copy_file_range02.c:103: INFO: Test #0: max file size
copy_file_range02.c:123: PASS: copy_file_range failed as expected: EFBIG

tst_test.c:1161: INFO: Testing on xfs
tst_mkfs.c:90: INFO: Formatting /dev/loop0 with xfs opts='' extra opts=''
tst_test.c:1100: INFO: Timeout per run is 0h 05m 00s
copy_file_range.h:41: INFO: Testing libc copy_file_range()
/tmp/QtMvgB/mnt_point
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     xfs   251M   15M  236M   6% /tmp/QtMvgB/mnt_point
/dev/loop0 on /tmp/QtMvgB/mnt_point type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota)
tst_device.c:87: INFO: Found free device 1 '/dev/loop1'
Setting up swapspace version 1, size = 36 KiB (36864 bytes)
no label, UUID=5a4b2adb-5b03-484c-a5b3-6e23ea3d80c8
copy_file_range02.c:103: INFO: Test #0: max file size
copy_file_range02.c:132: FAIL: copy_file_range returned wrong value: 32

tst_test.c:1161: INFO: Testing on vfat
tst_mkfs.c:90: INFO: Formatting /dev/loop0 with vfat opts='' extra opts=''
tst_test.c:1100: INFO: Timeout per run is 0h 05m 00s
copy_file_range.h:41: INFO: Testing libc copy_file_range()
/tmp/QtMvgB/mnt_point
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/loop0     vfat  256M     0  256M   0% /tmp/QtMvgB/mnt_point
/dev/loop0 on /tmp/QtMvgB/mnt_point type vfat (rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,errors=remount-ro)
tst_device.c:87: INFO: Found free device 1 '/dev/loop1'
safe_macros.c:1032: BROK: copy_file_range02.c:182: mknod() failed: EPERM
safe_macros.c:360: WARN: copy_file_range02.c:160: unlink(file_fifo) failed: ENOENT


Thanks!
M

> 
> Kind regards,
> Petr

--cbjas7zntt62c4iw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cfrbig.c"

#define _GNU_SOURCE
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <limits.h>

#if 0
static loff_t copy_file_range(int fd_in, loff_t *off_in, int fd_out,
		        loff_t *off_out, size_t len, unsigned int flags)
{
	return syscall(__NR_copy_file_range, fd_in, off_in, fd_out,
		           off_out, len, flags);
}
#endif

int main(int argc, char **argv)
{
	int fd_in, fd_out, ret;
	loff_t off = 9223372036854710270; // 2 ** 63

	if (argc != 3) {
		fprintf(stderr, "Usage: %s <source> <destination>\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	fd_in = open(argv[1], O_RDONLY);
	if (fd_in == -1) {
		perror("open (argv[1])");
		exit(EXIT_FAILURE);
	}

	fd_out = open(argv[2], O_CREAT | O_RDWR | O_TRUNC, 0644);
	if (fd_out == -1) {
		perror("open (argv[2])");
		exit(EXIT_FAILURE);
	}

	ret = copy_file_range(fd_in, 0, fd_out, &off, 65537, 0);
	if (ret == -1) {
		perror("copy_file_range");
		exit(EXIT_FAILURE);
	}
	printf("ret %d\n", ret);
	close(fd_in);
	close(fd_out);

	exit(EXIT_SUCCESS);
}

--cbjas7zntt62c4iw--
