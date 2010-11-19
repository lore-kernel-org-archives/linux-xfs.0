Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAJEpZ4f128874 for <xfs@oss.sgi.com>; Fri, 19 Nov 2010 08:51:35 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1B991C58C65
	for <xfs@oss.sgi.com>; Fri, 19 Nov 2010 06:53:08 -0800 (PST)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id iugxyHDcwvp8B5ye for
	<xfs@oss.sgi.com>; Fri, 19 Nov 2010 06:53:08 -0800 (PST)
Message-ID: <4CE68F51.9000207@sandeen.net>
Date: Fri, 19 Nov 2010 08:53:05 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: check block truncation after write failure
References: <20101109114923.GA29629@infradead.org>	<20101109223426.GO2715@dastard>
	<20101110125500.GA9828@infradead.org>
In-Reply-To: <20101110125500.GA9828@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Marius Tolzmann <tolzmann@molgen.mpg.de>, xfs@oss.sgi.com

On 11/10/10 6:55 AM, Christoph Hellwig wrote:
> Below is a version using od.  The output in case of failure is not
> quite as easily readable as the original, but in the end portability
> wins:
> 
> ---
> From: Christoph Hellwig <hch@lst.de>
> Subject: [PATCH] xfstests: check block truncation after write failure
> Cc: Marius Tolzmann <tolzmann@molgen.mpg.de>
> 
> Extraced from  https://bugzilla.kernel.org/show_bug.cgi?id=22452
> "data corruption after mmap()ing a file and writev() some data to another file"
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

On top of Dave's review of the original, the change to od looks fine:

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: xfstests-dev/246
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/246	2010-11-10 12:50:10.000000000 +0000
> @@ -0,0 +1,60 @@
> +#! /bin/bash
> +# FS QA Test No. 246
> +#
> +# Check that truncation after failed writes does not zero too much data.
> +#
> +# Based on a bug report and testcase from
> +# Marius Tolzmann <tolzmann@molgen.mpg.de>
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2010 Christoph Hellwig.  All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#
> +#-----------------------------------------------------------------------
> +#
> +# creator
> +owner=hch@lst.de
> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +
> +file=$TEST_DIR/mmap-writev
> +
> +_cleanup()
> +{
> +	rm -rf $file
> +	rm -rf $file.NEW
> +}
> +
> +trap "_cleanup ; exit \$status" 0 1 2 3 15
> +
> +echo -n "cccccccccc" > $file
> +$here/src/t_mmap_writev $file $file.NEW
> +od -t x2 $file.NEW
> +
> +status=0
> +exit $status
> Index: xfstests-dev/246.out
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/246.out	2010-11-10 12:50:30.000000000 +0000
> @@ -0,0 +1,4 @@
> +QA output created by 246
> +0000000 6161 6161 6161 6161 6161 6262 6262 6262
> +0000020 6262 6262 6363 6363 6363 6363 6363
> +0000036
> Index: xfstests-dev/group
> ===================================================================
> --- xfstests-dev.orig/group	2010-11-10 12:40:29.000000000 +0000
> +++ xfstests-dev/group	2010-11-10 12:40:40.000000000 +0000
> @@ -359,3 +359,4 @@ deprecated
>  243 auto quick prealloc
>  244 auto quota quick
>  245 auto quick dir
> +246 auto quick rw
> Index: xfstests-dev/src/Makefile
> ===================================================================
> --- xfstests-dev.orig/src/Makefile	2010-11-10 12:39:26.000000000 +0000
> +++ xfstests-dev/src/Makefile	2010-11-10 12:40:40.000000000 +0000
> @@ -10,7 +10,8 @@ TARGETS = dirstress fill fill2 getpagesi
>  	mmapcat append_reader append_writer dirperf metaperf \
>  	devzero feature alloc fault fstest t_access_root \
>  	godown resvtest writemod makeextents itrash rename \
> -	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes
> +	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes \
> +	t_mmap_writev
>  
>  LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
> Index: xfstests-dev/src/t_mmap_writev.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfstests-dev/src/t_mmap_writev.c	2010-11-10 12:40:40.000000000 +0000
> @@ -0,0 +1,70 @@
> +/*
> +    mmap() a file and writev() back to another file
> +         - kernel bug #22452 testcase
> +
> +    Copyright (C) 2010
> +         by D.Buczek - Max Planck Institute for Molecular Genetics Berlin
> +
> +    This program is free software; you can redistribute it and/or modify
> +    it under the terms of the GNU General Public License as published by
> +    the Free Software Foundation; either version 2 of the License, or
> +    (at your option) any later version.
> +
> +    This program is distributed in the hope that it will be useful,
> +    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +    GNU General Public License for more details.
> +
> +    You should have received a copy of the GNU General Public License along
> +    with this program; if not, write to the Free Software Foundation, Inc.,
> +    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> +*/
> +
> +#include <sys/types.h>
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +
> +#include <sys/mman.h>
> +#include <string.h>
> +#include <sys/uio.h>
> +#include <unistd.h>
> +
> +int main(int argc, char **argv)
> +{
> +	char *file = argv[1];
> +	char *new_file = argv[2];
> +	int fd;
> +	int fd_new;
> +	void *base;
> +
> +	struct iovec iovec[3]=
> +	{
> +		{ "aaaaaaaaaa" , 10 },
> +		{ "bbbbbbbbbb" , 10 },
> +	 	{ NULL , 10 }
> +	};
> +
> +	int i;
> +
> +	fd=open(file, O_RDONLY);
> +	if (fd==-1) {perror("open");exit(1);}
> +
> +	base = mmap(NULL,16384,PROT_READ,MAP_SHARED,fd,0);
> +	if  (base == (void *)-1) { perror("mmap");exit(1); }
> +
> +	unlink(new_file);
> +
> +	fd_new=open(new_file,O_RDWR|O_CREAT,0666);
> +	if (fd_new==-1) {perror("creat");exit(1);}
> +
> +	iovec[2].iov_base=(char *)base;
> +	i=writev(fd_new,iovec,sizeof(iovec)/sizeof(*iovec));
> +	if (i==-1) {perror("writev");exit(1);}
> +
> +	close(fd_new);
> +	munmap(base,16384);
> +	close(fd);
> +
> +	return 0;
> +}
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
