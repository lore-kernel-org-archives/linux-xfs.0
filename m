Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Jul 2007 11:41:25 -0700 (PDT)
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6DIfJbm001188
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 11:41:20 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6DIfJI3013607
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 14:41:19 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6DIfIDJ178076
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 12:41:18 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6DIfGTs019100
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 12:41:17 -0600
Date: Sat, 14 Jul 2007 00:11:25 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 0/5][TAKE8] fallocate system call
Message-ID: <20070713184125.GA12156@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: xfs@oss.sgi.com, tytso@mit.edu, cmm@us.ibm.com, suparna@in.ibm.com, adilger@clusterfs.com, dgc@sgi.com, michael.kerrisk@gmx.net

This is the latest fallocate patchset and is based on 2.6.22.

* Following are the changes from TAKE7:
1) Updated the man page.
2) Merged "revalidate write permissions" patch with the main falloc patch.
3) Added linux/falloc.h and moved FALLOC_FL_KEEP_SIZE flag to it.
   Also removed the two modes (FALLOC_ALLOCATE and FALLOC_RESV_SPACE).
4) Removed comment above sys_fallocate definition.
5) Updated the testcase below to use FALLOC_FL_KEEP_SIZE flag instead
   of previous two modes.

* Following are the changes from TAKE6:
1) We now just have two modes (and no deallocation modes).
2) Updated the man page
3) Added a new patch submitted by David P. Quigley  (Patch 3/6).
4) Used EXT_INIT_MAX_LEN instead of 0x8000 in Patch 6/6.
4) Included below in the end is a small testcase to test fallocate.


* Following are the changes from TAKE5 to TAKE6:
1) Rebased to 2.6.22
2) Added compat wrapper for x86_64
3) Dropped s390 and ia64 patches, since the platform maintaners can
   add the support for fallocate once it is in mainline.
4) Added a change suggested by Andreas for better extent-to-group
   alignment in ext4 (Patch 6/6). Please refer following post:
5) Renamed mode flags and values from "FA_" to "FALLOC_"
6) Added manpage (updated version of the one initially submitted by
   David Chinner).


Todos:
-----
1> Implementation on other architectures (other than i386, x86_64,
   and ppc64). s390(x) and ia64 patches are ready and will be pushed
   by platform maintaners when the fallocate is in mainline.
2> A generic file system operation to handle fallocate
   (generic_fallocate), for filesystems that do _not_ have the fallocate
   inode operation implemented.
3> Changes to glibc,
   a) to support fallocate() system call
   b) to make posix_fallocate() and posix_fallocate64() call fallocate()
4> Patch to e2fsprogs to recognize and display uninitialized extents.


Following patches follow:
Patch 1/5 : manpage for fallocate
Patch 2/5 : fallocate() implementation in i386, x86_64 and powerpc
Patch 3/5 : ext4: fallocate support in ext4
Patch 4/5 : ext4: write support for preallocated blocks
Patch 5/5 : ext4: change for better extent-to-group alignment

**
Attached below is a small testcase to test fallocate. The __NR_fallocate will
need to be changed depending on the system call number in the kernel (it may
get changed due to merge) and also depending on the architecture.

--
Regards,
Amit Arora



#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>

#include <linux/unistd.h>
#include <sys/vfs.h>
#include <sys/stat.h>

#define VERBOSE 0

#define __NR_fallocate                324

#define FALLOC_FL_KEEP_SIZE	0x01

int do_fallocate(int fd, int mode, loff_t offset, loff_t len)
{
  int ret;

  if (VERBOSE)
  	printf("Trying to preallocate blocks (offset=%llu, len=%llu)\n",
		offset, len);
  ret = syscall(__NR_fallocate, fd, mode, offset, len);

  if (ret <0) {
        printf("SYSCALL: received error %d, ret=%d\n", errno, ret);
        close(fd);
        return(1);
  }

  if (VERBOSE)
  	printf("fallocate system call succedded !  ret=%d\n", ret);

  return ret;
}

int test_fallocate(int fd, int mode, loff_t offset, loff_t len)
{
  int ret, blocks;
  struct stat statbuf1, statbuf2;

  fstat(fd, &statbuf1);

  ret = do_fallocate(fd, mode, offset, len);

  fstat(fd, &statbuf2);

  /* check file size after preallocation */
  if (!mode) {
  	if (!ret && statbuf1.st_size < (offset + len) &&
	    statbuf2.st_size != (offset + len)) {
		printf("Error: fallocate succeeded, but the file size did not "
			"change, where it should have!\n");
		ret = 1;
	}
  } else if (statbuf1.st_size != statbuf2.st_size) {
	printf("Error : File size changed, when it should not have!\n");
	ret = 1;
  }

  blocks = ((statbuf2.st_blocks - statbuf1.st_blocks) * 512)/ statbuf2.st_blksize;

  /* Print report */
  printf("# FALLOCATE TEST REPORT #\n");
  printf("\tNew blocks preallocated = %d.\n", blocks);
  printf("\tNumber of bytes preallocated = %d\n", blocks * statbuf2.st_blksize);
  printf("\tOld file size = %d, New file size %d.\n",
	  statbuf1.st_size, statbuf2.st_size);
  printf("\tOld num blocks = %d, New num blocks %d.\n",
	  (statbuf1.st_blocks * 512)/1024, (statbuf2.st_blocks * 512)/1024);

  return ret;
}


int do_write(int fd, loff_t offset, loff_t len)
{
  int ret;
  char *buf;

  buf = (char *)malloc(len);
  if (!buf) {
	printf("error: malloc failed.\n");
	return(-1);
  }

  if (VERBOSE)
  	printf("Trying to write to file (offset=%llu, len=%llu)\n", 
		offset, len);

  ret = lseek(fd, offset, SEEK_SET);
  if (ret != offset) {
     	printf("lseek() failed error=%d, ret=%d\n", errno, ret);
  	close(fd); 
       	return(-1);
  }

  ret = write(fd, buf, len);
  if (ret != len) {
       	 printf("write() failed error=%d, ret=%d\n", errno, ret);
  		close(fd); 
       		return(-1);
  }

  if (VERBOSE)
  	printf("Write succedded ! Written %llu bytes ret=%d\n", len, ret);

  return ret;
}


int test_write(int fd, loff_t offset, loff_t len)
{
  int ret;

  ret = do_write(fd, offset, len);
  printf("# WRITE TEST REPORT #\n");
  if (ret > 0) printf("\t written %d bytes.\n", ret);
  else printf("\t write operation failed!\n");

  if (ret > 0) return 0;
  else return 1;
}

void usage(char **argv)
{
  printf("\n%s <option> <filename-with-path> <offset> <length>\n", argv[0]);
  printf("option can be one of the following :\n");
  printf("\t-f\t: preallocate. This maps to default mode.\n");
  printf("\t-F\t: preallocate, but do not change the file size.\n");
  printf("\t\t    This maps to FALLOC_FL_KEEP_SIZE mode flag.\n");
  printf("\t-w\t: write some data to the range.\n");
  printf("\t-W\t: preallocate and write some data to the range.\n");
}

/*
 * Arguments:
 * argv[1] = option (-f/-F/-w/-W/-m)
 * argv[2] = fname	: the file name with path
 * argv[3] = offset	: in bytes
 * argv[4] = len	: in bytes
 */
int main(int argc, char **argv)
{
  int ret = 1, fd, mode;
  char *fname; 
  loff_t offset, len;

  if (argc!=5 || argv[1][0] != '-') {
	usage(argv);
	exit(1);
  }

  fname = argv[2];
  offset = (unsigned long long)atol(argv[3]);;
  len = (unsigned long long)atol(argv[4]);

  if (offset < 0 || len <= 0) {
        printf("%s: Invalid arguments.\n", argv[0]);
        exit(1);
  }

  fd = open(fname, O_CREAT|O_RDWR, 0666);
  if (fd < 0) {
        printf("Error opening file %s, error = %d.\n", fname, errno);
        exit(1);
  }

  /* -f */
  if (!strcmp(argv[1], "-f")) {
	mode = 0; /* default mode */
	ret = test_fallocate(fd, mode, offset, len);
  	if (ret) printf("test_fallocate: ERROR ! ret=%d\n", ret);
  /* -F */
  } else if (!strcmp(argv[1], "-F")) {
	mode = FALLOC_FL_KEEP_SIZE;
	ret = test_fallocate(fd, mode, offset, len);
  	if (ret) printf("test_fallocate: ERROR ! ret=%d\n", ret);
  /* -w */
  } else if (!strcmp(argv[1], "-w")) {
	ret = test_write(fd, offset, len);
  /* -W */
  } else if (!strcmp(argv[1], "-W")) {
	mode = 0; /* default mode */
	ret = test_fallocate(fd, mode, offset, len);
  	if (ret) {
		printf("test_fallocate: ERROR ! ret=%d\n", ret);
		goto out;
	}
	ret = test_write(fd, offset, len);
  	if (ret) printf("test_write: ERROR ! ret=%d\n", ret);
  } else {
        printf("%s: Invalid arguments.\n", argv[0]);
	usage(argv);
  }

out:

  if (!ret) printf("\n\n### TESTS PASSED ###\n");
  else printf("\n\n#!# TESTS FAILED #!#\n");

  close(fd);
  return ret;
}
