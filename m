Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40222 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751559AbdCVFaD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Mar 2017 01:30:03 -0400
Date: Wed, 22 Mar 2017 01:28:27 -0400
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH RFC 2/2] xfs_io: hook up statx
Message-ID: <20170322052827.GE5722@birch.djwong.org>
References: <0bc83cf4-a927-e78e-9bfb-7f3fa91303eb@redhat.com>
 <0e724f22-4fd2-1904-6476-189fc22eea6d@redhat.com>
 <20170321214928.GC5722@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170321214928.GC5722@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, David Howells <dhowells@redhat.com>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>

On Tue, Mar 21, 2017 at 05:49:28PM -0400, Darrick J. Wong wrote:
> On Tue, Mar 21, 2017 at 03:03:29PM -0400, Eric Sandeen wrote:
> > Wire up the statx syscall to xfs_io.
> > 
> > xfs_io> help statx
> > statx [-O | -m mask][-FDLAP] -- extended information about the currently open file
> > 
> >  Display extended file status.
> > 
> >  Options:
> >  -m mask -- Specify the field mask for the statx call (default STATX_ALL)
> >  -A -- Suppress terminal automount traversal
> >  -D -- Don't sync attributes with the server
> >  -F -- Force the attributes to be sync'd with the server
> >  -L -- Follow symlinks (statx link target)
> >  -O -- Remove basic stats (STATX_BASIC_STATS) from default mask
> >  -P -- pretty-print results similar to stat(1)
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> > 
> > diff --git a/io/init.c b/io/init.c
> > index 06002e6..c15a1e1 100644
> > --- a/io/init.c
> > +++ b/io/init.c
> > @@ -86,6 +86,7 @@ init_commands(void)
> >  	seek_init();
> >  	sendfile_init();
> >  	shutdown_init();
> > +	stat_init();
> >  	sync_init();
> >  	sync_range_init();
> >  	truncate_init();
> > diff --git a/io/io.h b/io/io.h
> > index 7e95bd5..952bdb8 100644
> > --- a/io/io.h
> > +++ b/io/io.h
> > @@ -112,6 +112,7 @@ extern void		pwrite_init(void);
> >  extern void		quit_init(void);
> >  extern void		seek_init(void);
> >  extern void		shutdown_init(void);
> > +extern void		stat_init(void);
> >  extern void		sync_init(void);
> >  extern void		truncate_init(void);
> >  extern void		utimes_init(void);
> > diff --git a/io/stat.c b/io/stat.c
> > index 3ae9903..3b3d21d 100644
> > --- a/io/stat.c
> > +++ b/io/stat.c
> > @@ -2,6 +2,9 @@
> >   * Copyright (c) 2003-2005 Silicon Graphics, Inc.
> >   * All Rights Reserved.
> >   *
> > + * Copyright (C) 2015, 2017 Red Hat, Inc.
> > + * Portions of statx support written by David Howells (dhowells@redhat.com)
> > + *
> >   * This program is free software; you can redistribute it and/or
> >   * modify it under the terms of the GNU General Public License as
> >   * published by the Free Software Foundation.
> > @@ -20,10 +23,14 @@
> >  #include "input.h"
> >  #include "init.h"
> >  #include "io.h"
> > +#include "statx.h"
> >  #include "libxfs.h"
> >  
> > +#include <fcntl.h>
> > +
> >  static cmdinfo_t stat_cmd;
> >  static cmdinfo_t statfs_cmd;
> > +static cmdinfo_t statx_cmd;
> >  
> >  off64_t
> >  filesize(void)
> > @@ -167,6 +174,289 @@ statfs_f(
> >  	return 0;
> >  }
> >  
> > +#ifndef AT_STATX_SYNC_TYPE
> > +#define AT_STATX_SYNC_TYPE      0x6000  /* Type of synchronisation required from statx() */
> > +#define AT_STATX_SYNC_AS_STAT   0x0000  /* - Do whatever stat() does */
> > +#define AT_STATX_FORCE_SYNC     0x2000  /* - Force the attributes to be sync'd with the server */
> > +#define AT_STATX_DONT_SYNC      0x4000  /* - Don't sync attributes with the server */
> > +#endif
> > +
> > +#ifndef AT_NO_AUTOMOUNT
> > +#define AT_NO_AUTOMOUNT		0x800	/* Suppress terminal automount traversal */
> > +#endif
> > +
> > +/* XXX ERS fixme */
> > +#define __NR_statx 332
> 
> fixit? :)
> 
> > +
> > +static ssize_t
> > +statx(int dfd, const char *filename, unsigned flags,
> > +      unsigned int mask, struct statx *buffer)
> > +{
> > +	return syscall(__NR_statx, dfd, filename, flags, mask, buffer);
> > +}
> > +
> > +static void
> > +statx_help(void)
> > +{
> > +        printf(_(
> > +"\n"
> > +" Display extended file status.\n"
> > +"\n"
> > +" Options:\n"
> > +" -m mask -- Specify the field mask for the statx call (default STATX_ALL)\n"
> > +" -A -- Suppress terminal automount traversal\n"
> > +" -D -- Don't sync attributes with the server\n"
> > +" -F -- Force the attributes to be sync'd with the server\n"
> > +" -L -- Follow symlinks (statx link target)\n"
> > +" -O -- Remove basic stats (STATX_BASIC_STATS) from default mask\n"
> > +" -P -- pretty-print results similar to stat(1)\n"
> > +"\n"));
> > +}
> > +
> > +/* statx helper */
> > +static void
> > +raw_statx(struct statx *stx)
> > +{
> > +	printf("stx_mask: 0x%x\n", stx->stx_mask);
> > +	printf("stx_blksize: %u\n", stx->stx_blksize);
> > +	printf("stx_attributes: 0x%llx\n", stx->stx_attributes);
> > +	printf("stx_nlink: %u\n", stx->stx_nlink);
> > +	printf("stx_uid: %u\n", stx->stx_uid);
> > +	printf("stx_gid: %u\n", stx->stx_gid);
> > +	printf("stx_mode: 0%o\n", stx->stx_mode);
> > +	printf("stx_ino: %llu\n", stx->stx_ino);
> > +	printf("stx_size: %llu\n", stx->stx_size);
> > +	printf("stx_blocks: %llu\n", stx->stx_blocks);
> > +	printf("stx_atime.tv_sec: %lld\n", stx->stx_atime.tv_sec);
> > +	printf("stx_atime.tv_nsec: %d\n", stx->stx_atime.tv_nsec);
> > +	printf("stx_btime.tv_sec: %lld\n", stx->stx_btime.tv_sec);
> > +	printf("stx_btime.tv_nsec: %d\n", stx->stx_btime.tv_nsec);

Also I forgot to mention that we shouldn't print btime unless
STATX_BTIME is set.

Put another way, the mask filtering you do in the pretty print function
ought to be repeated here too, right?

--D

> > +	printf("stx_ctime.tv_sec: %lld\n", stx->stx_ctime.tv_sec);
> > +	printf("stx_ctime.tv_nsec: %d\n", stx->stx_ctime.tv_nsec);
> > +	printf("stx_mtime.tv_sec: %lld\n", stx->stx_mtime.tv_sec);
> > +	printf("stx_mtime.tv_nsec: %d\n", stx->stx_mtime.tv_nsec);
> > +	printf("stx_rdev_major: %u\n", stx->stx_rdev_major);
> > +	printf("stx_rdev_minor: %u\n", stx->stx_rdev_minor);
> > +	printf("stx_dev_major: %u\n", stx->stx_dev_major);
> > +	printf("stx_dev_minor: %u\n", stx->stx_dev_minor);
> > +}
> > +
> > +/* statx helper */
> > +static void
> > +print_time(const char *field, struct statx_timestamp *ts)
> > +{
> > +	struct tm tm;
> > +	time_t tim;
> > +	char buffer[100];
> > +	int len;
> > +
> > +	tim = ts->tv_sec;
> > +	if (!localtime_r(&tim, &tm)) {
> > +		perror("localtime_r");
> > +		exit(1);
> > +	}
> > +	len = strftime(buffer, 100, "%F %T", &tm);
> > +	if (len == 0) {
> > +		perror("strftime");
> > +		exit(1);
> > +	}
> > +	printf("%s", field);
> > +	fwrite(buffer, 1, len, stdout);
> > +	printf(".%09u", ts->tv_nsec);
> > +	len = strftime(buffer, 100, "%z", &tm);
> > +	if (len == 0) {
> > +		perror("strftime2");
> > +		exit(1);
> > +	}
> > +	fwrite(buffer, 1, len, stdout);
> > +	printf("\n");
> > +}
> > +
> > +/* statx helper */
> > +static void
> > +pretty_statx(struct statx *stx)
> > +{
> > +	char buffer[256], ft;
> > +
> > +	printf(" ");
> > +	if (stx->stx_mask & STATX_SIZE)
> > +		printf(" Size: %-15llu", (unsigned long long)stx->stx_size);
> > +	if (stx->stx_mask & STATX_BLOCKS)
> > +		printf(" Blocks: %-10llu", (unsigned long long)stx->stx_blocks);
> > +	printf(" IO Block: %-6llu", (unsigned long long)stx->stx_blksize);
> > +
> > +	ft = '?';
> > +	if (stx->stx_mask & STATX_TYPE) {
> > +		switch (stx->stx_mode & S_IFMT) {
> > +		case S_IFIFO:	printf("  FIFO\n");			ft = 'p'; break;
> > +		case S_IFCHR:	printf("  character special file\n");	ft = 'c'; break;
> > +		case S_IFDIR:	printf("  directory\n");		ft = 'd'; break;
> > +		case S_IFBLK:	printf("  block special file\n");	ft = 'b'; break;
> > +		case S_IFREG:	printf("  regular file\n");		ft = '-'; break;
> > +		case S_IFLNK:	printf("  symbolic link\n");		ft = 'l'; break;
> > +		case S_IFSOCK:	printf("  socket\n");			ft = 's'; break;
> > +		default:
> > +			printf(" unknown type (%o)\n", stx->stx_mode & S_IFMT);
> > +			break;
> > +		}
> > +	} else {
> > +		printf(" no type\n");
> > +	}
> > +
> > +	sprintf(buffer, "%02x:%02x", stx->stx_dev_major, stx->stx_dev_minor);
> > +	printf("Device: %-15s", buffer);
> > +	if (stx->stx_mask & STATX_INO)
> > +		printf(" Inode: %-11llu", (unsigned long long) stx->stx_ino);
> > +	if (stx->stx_mask & STATX_NLINK)
> > +		printf(" Links: %-5u", stx->stx_nlink);
> > +	if (stx->stx_mask & STATX_TYPE) {
> > +		switch (stx->stx_mode & S_IFMT) {
> > +		case S_IFBLK:
> > +		case S_IFCHR:
> > +			printf(" Device type: %u,%u",
> > +			       stx->stx_rdev_major, stx->stx_rdev_minor);
> > +			break;
> > +		}
> > +	}
> > +	printf("\n");
> > +
> > +	if (stx->stx_mask & STATX_MODE)
> > +		printf("Access: (%04o/%c%c%c%c%c%c%c%c%c%c)  ",
> > +		       stx->stx_mode & 07777,
> > +		       ft,
> > +		       stx->stx_mode & S_IRUSR ? 'r' : '-',
> > +		       stx->stx_mode & S_IWUSR ? 'w' : '-',
> > +		       stx->stx_mode & S_IXUSR ? 'x' : '-',
> > +		       stx->stx_mode & S_IRGRP ? 'r' : '-',
> > +		       stx->stx_mode & S_IWGRP ? 'w' : '-',
> > +		       stx->stx_mode & S_IXGRP ? 'x' : '-',
> > +		       stx->stx_mode & S_IROTH ? 'r' : '-',
> > +		       stx->stx_mode & S_IWOTH ? 'w' : '-',
> > +		       stx->stx_mode & S_IXOTH ? 'x' : '-');
> > +	if (stx->stx_mask & STATX_UID)
> > +		printf("Uid: %5d   ", stx->stx_uid);
> > +	if (stx->stx_mask & STATX_GID)
> > +		printf("Gid: %5d\n", stx->stx_gid);
> > +
> > +	if (stx->stx_mask & STATX_ATIME)
> > +		print_time("Access: ", &stx->stx_atime);
> > +	if (stx->stx_mask & STATX_MTIME)
> > +		print_time("Modify: ", &stx->stx_mtime);
> > +	if (stx->stx_mask & STATX_CTIME)
> > +		print_time("Change: ", &stx->stx_ctime);
> > +	if (stx->stx_mask & STATX_BTIME)
> > +		print_time(" Birth: ", &stx->stx_btime);
> > +
> > +	if (stx->stx_attributes) {
> > +		unsigned char bits;
> > +		int loop, byte;
> > +
> > +		static char attr_representation[64 + 1] =
> > +			/* STATX_ATTR_ flags: */
> > +			"????????"	/* 63-56 */
> > +			"????????"	/* 55-48 */
> > +			"????????"	/* 47-40 */
> > +			"????????"	/* 39-32 */
> > +			"????????"	/* 31-24	0x00000000-ff000000 */
> > +			"????????"	/* 23-16	0x00000000-00ff0000 */
> > +			"???mE???"	/* 15- 8	0x00000000-0000ff00 */
> > +			"?dai?c??"	/*  7- 0	0x00000000-000000ff */
> > +			;
> > +
> > +		printf("Attributes: %016llx\n", stx->stx_attributes);
> > +		printf("(");
> > +		for (byte = 64 - 8; byte >= 0; byte -= 8) {
> > +			bits = stx->stx_attributes >> byte;
> > +			for (loop = 7; loop >= 0; loop--) {
> > +				int bit = byte + loop;
> > +
> > +				if (bits & 0x80)
> > +					putchar(attr_representation[63 - bit]);
> > +				else
> > +					putchar('-');
> > +				bits <<= 1;
> > +			}
> > +			if (byte)
> > +				putchar(' ');
> > +		}
> > +		printf(")\n");
> > +	}
> > +}
> > +
> > +/*
> > + * options:
> > + * 	- input flags - query type
> > + * 	- output style for flags (and all else?) (chars vs. hex?)
> > + * 	- output - mask out incidental flag or not?
> > + */
> > +int
> > +statx_f(
> > +	int		argc,
> > +	char		**argv)
> > +{
> > +	int		c;
> > +	int		pretty = 0;
> > +	struct statx	stx;
> > +	int		atflag = AT_SYMLINK_NOFOLLOW;
> > +	unsigned int	m_mask = 0;	/* mask requested with -m */
> > +	int		Oflag = 0, mflag = 0;	/* -O or -m was used */
> > +	unsigned int	 mask = STATX_ALL;
> 
> Whitespace, bleh....
> 
> > +
> > +	while ((c = getopt(argc, argv, "m:FDLOAP")) != EOF) {
> > +		switch (c) {
> > +		case 'm':
> > +			m_mask = atoi(optarg);
> > +			mflag = 1;
> > +			break;
> > +		case 'F':
> > +			atflag &= ~AT_STATX_SYNC_TYPE;
> > +			atflag |= AT_STATX_FORCE_SYNC;
> > +			break;
> > +		case 'D':
> > +			atflag &= ~AT_STATX_SYNC_TYPE;
> > +			atflag |= AT_STATX_DONT_SYNC;
> > +			break;
> > +		case 'L':
> > +			atflag &= ~AT_SYMLINK_NOFOLLOW;
> > +			break;
> > +		case 'O':
> > +			mask &= ~STATX_BASIC_STATS;
> > +			Oflag = 1;
> > +			break;
> > +		case 'A':
> > +			atflag |= AT_NO_AUTOMOUNT;
> > +			break;
> > +		case 'P':
> > +			pretty = 1;
> > +			break;
> > +		default:
> > +			printf("errror\n");
> 
> command_usage(...)?
> 
> > +		}
> > +	}
> > +
> > +	if (Oflag && mflag) {
> > +		printf("Cannot specify both -m mask and -O\n");
> > +		return 0;
> > +	}
> > +
> > +	/* -m overrides any other mask options */
> > +	if (mflag)
> > +		mask = m_mask;
> > +
> > +	memset(&stx, 0xbf, sizeof(stx));
> > +	if (statx(AT_FDCWD, file->name, atflag, mask, &stx) < 0) {
> > +		perror("statx");
> > +		return 0;
> > +	}
> > +
> > +	if (pretty)
> > +		pretty_statx(&stx);
> > +	else
> > +		raw_statx(&stx);
> > +
> > +	return 0;
> > +}
> > +
> >  void
> >  stat_init(void)
> >  {
> > @@ -176,14 +466,25 @@ stat_init(void)
> >  	stat_cmd.argmax = 1;
> >  	stat_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> >  	stat_cmd.args = _("[-v]");
> > -	stat_cmd.oneline = _("statistics on the currently open file");
> > +	stat_cmd.oneline = _("imformation about the currently open file");
> 
> "information..."
> 
> >  
> >  	statfs_cmd.name = "statfs";
> >  	statfs_cmd.cfunc = statfs_f;
> >  	statfs_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> >  	statfs_cmd.oneline =
> > -		_("statistics on the filesystem of the currently open file");
> > + _("information about the filesystem of the currently open file");
> > +
> > +	statx_cmd.name = "statx";
> > +	statx_cmd.cfunc = statx_f;
> > +	statx_cmd.argmin = 0;
> > +	statx_cmd.argmax = -1;
> > +	statx_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> > +	statx_cmd.args = _("[-O | -m mask][-FDLAP]");
> > +	statx_cmd.oneline =
> > + _("extended information about the currently open file");
> > +	statx_cmd.help = statx_help;
> >  
> >  	add_command(&stat_cmd);
> >  	add_command(&statfs_cmd);
> > +	add_command(&statx_cmd);
> >  }
> > diff --git a/io/statx.h b/io/statx.h
> > new file mode 100644
> > index 0000000..7e024d1
> > --- /dev/null
> > +++ b/io/statx.h
> > @@ -0,0 +1,137 @@
> > +#ifndef XFS_IO_STATX_H
> > +#define XFS_IO_STATX_H
> > +
> > +#ifndef STATX_TYPE
> > +
> > +/*
> > + * Timestamp structure for the timestamps in struct statx.
> > + *
> > + * tv_sec holds the number of seconds before (negative) or after (positive)
> > + * 00:00:00 1st January 1970 UTC.
> > + *
> > + * tv_nsec holds a number of nanoseconds before (0..-999,999,999 if tv_sec is
> > + * negative) or after (0..999,999,999 if tv_sec is positive) the tv_sec time.
> > + *
> > + * Note that if both tv_sec and tv_nsec are non-zero, then the two values must
> > + * either be both positive or both negative.
> > + *
> > + * __reserved is held in case we need a yet finer resolution.
> > + */
> > +struct statx_timestamp {
> > +	__s64	tv_sec;
> > +	__s32	tv_nsec;
> > +	__s32	__reserved;
> > +};
> > +
> > +/*
> > + * Structures for the extended file attribute retrieval system call
> > + * (statx()).
> > + *
> > + * The caller passes a mask of what they're specifically interested in as a
> > + * parameter to statx().  What statx() actually got will be indicated in
> > + * st_mask upon return.
> > + *
> > + * For each bit in the mask argument:
> > + *
> > + * - if the datum is not supported:
> > + *
> > + *   - the bit will be cleared, and
> > + *
> > + *   - the datum will be set to an appropriate fabricated value if one is
> > + *     available (eg. CIFS can take a default uid and gid), otherwise
> > + *
> > + *   - the field will be cleared;
> > + *
> > + * - otherwise, if explicitly requested:
> > + *
> > + *   - the datum will be synchronised to the server if AT_STATX_FORCE_SYNC is
> > + *     set or if the datum is considered out of date, and
> > + *
> > + *   - the field will be filled in and the bit will be set;
> > + *
> > + * - otherwise, if not requested, but available in approximate form without any
> > + *   effort, it will be filled in anyway, and the bit will be set upon return
> > + *   (it might not be up to date, however, and no attempt will be made to
> > + *   synchronise the internal state first);
> > + *
> > + * - otherwise the field and the bit will be cleared before returning.
> > + *
> > + * Items in STATX_BASIC_STATS may be marked unavailable on return, but they
> > + * will have values installed for compatibility purposes so that stat() and
> > + * co. can be emulated in userspace.
> > + */
> > +struct statx {
> > +	/* 0x00 */
> > +	__u32	stx_mask;	/* What results were written [uncond] */
> > +	__u32	stx_blksize;	/* Preferred general I/O size [uncond] */
> > +	__u64	stx_attributes;	/* Flags conveying information about the file [uncond] */
> > +	/* 0x10 */
> > +	__u32	stx_nlink;	/* Number of hard links */
> > +	__u32	stx_uid;	/* User ID of owner */
> > +	__u32	stx_gid;	/* Group ID of owner */
> > +	__u16	stx_mode;	/* File mode */
> > +	__u16	__spare0[1];
> > +	/* 0x20 */
> > +	__u64	stx_ino;	/* Inode number */
> > +	__u64	stx_size;	/* File size */
> > +	__u64	stx_blocks;	/* Number of 512-byte blocks allocated */
> > +	__u64	__spare1[1];
> > +	/* 0x40 */
> > +	struct statx_timestamp	stx_atime;	/* Last access time */
> > +	struct statx_timestamp	stx_btime;	/* File creation time */
> > +	struct statx_timestamp	stx_ctime;	/* Last attribute change time */
> > +	struct statx_timestamp	stx_mtime;	/* Last data modification time */
> > +	/* 0x80 */
> > +	__u32	stx_rdev_major;	/* Device ID of special file [if bdev/cdev] */
> > +	__u32	stx_rdev_minor;
> > +	__u32	stx_dev_major;	/* ID of device containing file [uncond] */
> > +	__u32	stx_dev_minor;
> > +	/* 0x90 */
> > +	__u64	__spare2[14];	/* Spare space for future expansion */
> > +	/* 0x100 */
> > +};
> > +
> > +/*
> > + * Flags to be stx_mask
> > + *
> > + * Query request/result mask for statx() and struct statx::stx_mask.
> > + *
> > + * These bits should be set in the mask argument of statx() to request
> > + * particular items when calling statx().
> > + */
> > +#define STATX_TYPE		0x00000001U	/* Want/got stx_mode & S_IFMT */
> > +#define STATX_MODE		0x00000002U	/* Want/got stx_mode & ~S_IFMT */
> > +#define STATX_NLINK		0x00000004U	/* Want/got stx_nlink */
> > +#define STATX_UID		0x00000008U	/* Want/got stx_uid */
> > +#define STATX_GID		0x00000010U	/* Want/got stx_gid */
> > +#define STATX_ATIME		0x00000020U	/* Want/got stx_atime */
> > +#define STATX_MTIME		0x00000040U	/* Want/got stx_mtime */
> > +#define STATX_CTIME		0x00000080U	/* Want/got stx_ctime */
> > +#define STATX_INO		0x00000100U	/* Want/got stx_ino */
> > +#define STATX_SIZE		0x00000200U	/* Want/got stx_size */
> > +#define STATX_BLOCKS		0x00000400U	/* Want/got stx_blocks */
> > +#define STATX_BASIC_STATS	0x000007ffU	/* The stuff in the normal stat struct */
> > +#define STATX_BTIME		0x00000800U	/* Want/got stx_btime */
> > +#define STATX_ALL		0x00000fffU	/* All currently supported flags */
> > +
> > +/*
> > + * Attributes to be found in stx_attributes
> > + *
> > + * These give information about the features or the state of a file that might
> > + * be of use to ordinary userspace programs such as GUIs or ls rather than
> > + * specialised tools.
> > + *
> > + * Note that the flags marked [I] correspond to generic FS_IOC_FLAGS
> > + * semantically.  Where possible, the numerical value is picked to correspond
> > + * also.
> > + */
> > +#define STATX_ATTR_COMPRESSED		0x00000004 /* [I] File is compressed by the fs */
> > +#define STATX_ATTR_IMMUTABLE		0x00000010 /* [I] File is marked immutable */
> > +#define STATX_ATTR_APPEND		0x00000020 /* [I] File is append-only */
> > +#define STATX_ATTR_NODUMP		0x00000040 /* [I] File is not to be dumped */
> > +#define STATX_ATTR_ENCRYPTED		0x00000800 /* [I] File requires key to decrypt in fs */
> > +
> > +#define STATX_ATTR_AUTOMOUNT		0x00001000 /* Dir: Automount trigger */
> > +
> > +#endif /* STATX_TYPE */
> > +#endif /* XFS_IO_STATX_H */
> > diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> > index 19e1ae4..48b4496 100644
> > --- a/man/man8/xfs_io.8
> > +++ b/man/man8/xfs_io.8
> > @@ -880,6 +880,35 @@ and the XFS_IOC_GETXATTR system call on the current file. If the
> >  option is specified, the atime (last access), mtime
> >  (last modify), and ctime (last change) timestamps are also displayed.
> >  .TP
> > +.BR statx " [ " \-O " | " "\-m mask" " ][ \-" FDLAP " ]"
> > +Extended information from the statx syscall.
> > +.RS 1.0i
> > +.PD 0
> > +.TP 0.4i
> > +.B \-m mask
> > +Specify the field mask for the statx call (default STATX_ALL)
> > +.TP
> > +.B \-O
> > +Remove basic stats (STATX_BASIC_STATS) from default mask
> > +.TP
> > +.B \-F
> > +Force the attributes to be sync'd with the server
> > +.TP
> > +.B \-D
> > +Don't sync attributes with the server
> > +.TP
> > +.B \-L
> > +Follow symlinks (statx link target)
> > +.TP
> > +.B \-A
> > +Suppress terminal automount traversal
> > +.TP
> > +.B \-P
> > +pretty-print results similar to stat(1)
> > +.TP
> > +.RE
> > +.IP
> > +.TP
> >  .B statfs
> >  Selected statistics from
> >  .BR statfs (2)
> > 
> 
> Eh, looks ok for a start.
> 
> --D
> 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
