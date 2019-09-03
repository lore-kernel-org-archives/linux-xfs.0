Return-Path: <SRS0=8CmW=W6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 243F1C3A5A2
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 22:26:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D75F022CF8
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 22:26:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="evy9KEJP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfICW0p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Sep 2019 18:26:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36716 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfICW0p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Sep 2019 18:26:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83MQLus152323;
        Tue, 3 Sep 2019 22:26:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=sqVy0qyBCHuTXF+U8DWNztpiFldVDRjCx5zWUugilik=;
 b=evy9KEJPYfI3q4it+lR0qMWf47OvXovNJTKWgGX8epp0BD0IYVtKoWGUUSlK9NhKWc1r
 8wRC09VOkwsLpE0NN8PBOgC6HRqAuRkhjhKMHBFOpjyYixD+RD9iimi/daIDDOeHP8IS
 iYWLa5iu3D3CfIRvPMCgYIbHEPk92w32i1TmJmbLruV0lVK3T3zuf1nuxZM9UcPI5W4J
 DQ6NOht6QK7F4lu8HO1+tO/YupvulDwdw8VknloctEicLAQvALHGfnx6KxjDnKysUC+2
 CrrVRK07ZvZbCS+1/HRKWWwEicnsO2zmd2aRYz6zwV81dQ+aixEtzmU7kUA9hgdxS+VJ Pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2ut0yag01p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 22:26:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83MNdfX087351;
        Tue, 3 Sep 2019 22:24:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2us5phcrt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 22:24:32 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x83MOW4x030678;
        Tue, 3 Sep 2019 22:24:32 GMT
Received: from localhost (/10.145.178.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 15:24:31 -0700
Date:   Tue, 3 Sep 2019 15:24:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs_io: support splice data between two files
Message-ID: <20190903222430.GA5354@magnolia>
References: <20190519150026.24626-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190519150026.24626-1-zlang@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909030223
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909030223
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 19, 2019 at 11:00:26PM +0800, Zorro Lang wrote:
> Add splice command into xfs_io, by calling splice(2) system call.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> Thanks the reviewing from Eric.
> 
> If 'length' or 'soffset' or 'length + soffset' out of source file
> range, splice hanging there. V2 fix this issue.
> 
> Thanks,
> Zorro
> 
>  io/Makefile       |   2 +-
>  io/init.c         |   1 +
>  io/io.h           |   1 +
>  io/splice.c       | 194 ++++++++++++++++++++++++++++++++++++++++++++++
>  man/man8/xfs_io.8 |  26 +++++++
>  5 files changed, 223 insertions(+), 1 deletion(-)
>  create mode 100644 io/splice.c
> 
> diff --git a/io/Makefile b/io/Makefile
> index 484e2b5a..06d21dd5 100644
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -12,7 +12,7 @@ CFILES = init.c \
>  	attr.c bmap.c crc32cselftest.c cowextsize.c encrypt.c file.c freeze.c \
>  	fsync.c getrusage.c imap.c inject.c label.c link.c mmap.c open.c \
>  	parent.c pread.c prealloc.c pwrite.c reflink.c resblks.c scrub.c \
> -	seek.c shutdown.c stat.c swapext.c sync.c truncate.c utimes.c
> +	seek.c shutdown.c splice.c stat.c swapext.c sync.c truncate.c utimes.c
>  
>  LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD)
>  LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
> diff --git a/io/init.c b/io/init.c
> index 83f08f2d..fc191aa7 100644
> --- a/io/init.c
> +++ b/io/init.c
> @@ -79,6 +79,7 @@ init_commands(void)
>  	seek_init();
>  	sendfile_init();
>  	shutdown_init();
> +	splice_init();
>  	stat_init();
>  	swapext_init();
>  	sync_init();
> diff --git a/io/io.h b/io/io.h
> index 6469179e..9a0b71f0 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -110,6 +110,7 @@ extern void		quit_init(void);
>  extern void		resblks_init(void);
>  extern void		seek_init(void);
>  extern void		shutdown_init(void);
> +extern void		splice_init(void);
>  extern void		stat_init(void);
>  extern void		swapext_init(void);
>  extern void		sync_init(void);
> diff --git a/io/splice.c b/io/splice.c
> new file mode 100644
> index 00000000..3c6f55e6
> --- /dev/null
> +++ b/io/splice.c
> @@ -0,0 +1,194 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2019 Red Hat, Inc.
> + * All Rights Reserved.
> + */
> +
> +#include "command.h"
> +#include "input.h"
> +#include <fcntl.h>
> +#include "init.h"
> +#include "io.h"
> +
> +static cmdinfo_t splice_cmd;
> +
> +static void
> +splice_help(void)
> +{
> +	printf(_(
> +"\n"
> +" Splice a range of bytes from the given offset between files through pipe\n"
> +"\n"
> +" Example:\n"
> +" 'splice filename 0 4096 32768' - splice 32768 bytes from filename at offset\n"
> +"                                  0 into the open file at position 4096\n"
> +" 'splice filename' - splice all bytes from filename into the open file at\n"
> +" '                   position 0\n"
> +"\n"
> +" Copies data between one file and another.  Because this copying is done\n"
> +" within the kernel, sendfile does not need to transfer data to and from user\n"

sendfile?  I thought this ^^^ was splice?

Otherwise looks ok to me, though it seems that callers could do a lot more
evil^Winteresting things with splice() if they had better control over
the pipe and buffer length between the two splice calls.

--D

> +" space.\n"
> +" -m -- SPLICE_F_MOVE flag, attempt to move pages instead of copying.\n"
> +" Offset and length in the source/destination file can be optionally specified.\n"
> +"\n"));
> +}
> +
> +static uint64_t
> +splice_file(
> +	int		fd,
> +	off64_t		soffset,
> +	off64_t		doffset,
> +	size_t		length,
> +	unsigned int	flag,
> +	int		*ops)
> +{
> +	off64_t		soff = soffset;
> +	off64_t		doff = doffset;
> +	ssize_t		rc = 0;
> +	size_t		len = length;
> +	uint64_t	total = 0;
> +	int		filedes[2];
> +
> +	if (pipe(filedes) < 0) {
> +		perror("pipe");
> +		return -1;
> +	}
> +
> +	*ops = 0;
> +	while (len > 0 || !*ops) {
> +		/* move to pipe buffer */
> +		rc = splice(fd, &soff, filedes[1], NULL, len, flag);
> +		if (rc < 0) {
> +			perror("splice to pipe");
> +			goto out_close;
> +		}
> +		/* move from pipe buffer to dst file */
> +		rc = splice(filedes[0], NULL, file->fd, &doff, len, flag);
> +		if (rc < 0) {
> +			perror("splice from pipe");
> +			goto out_close;
> +		}
> +		(*ops)++;
> +		len -= rc;
> +		total += rc;
> +	}
> +
> +out_close:
> +	close(filedes[0]);
> +	close(filedes[1]);
> +	return total;
> +}
> +
> +static int
> +splice_f(
> +	int		argc,
> +	char		**argv)
> +{
> +	off64_t		soffset, doffset;
> +	long long	count, total;
> +	size_t		blocksize, sectsize;
> +	struct timeval	t1, t2;
> +	char		*infile = NULL;
> +	int		Cflag, qflag;
> +	int		splice_flag = 0;
> +	int		c, fd = -1;
> +	int		ops = 0;
> +	struct stat	stat;
> +
> +	Cflag = qflag = 0;
> +	soffset = doffset=0;
> +	init_cvtnum(&blocksize, &sectsize);
> +
> +	while ((c = getopt(argc, argv, "Cqm")) != EOF) {
> +		switch (c) {
> +		case 'C':
> +			Cflag = 1;
> +			break;
> +		case 'q':
> +			qflag = 1;
> +			break;
> +		case 'm':
> +			splice_flag |= SPLICE_F_MOVE;
> +			break;
> +		default:
> +			return command_usage(&splice_cmd);
> +		}
> +	}
> +
> +	if (optind != argc - 4 && optind != argc - 1)
> +		return command_usage(&splice_cmd);
> +
> +	infile = argv[optind];
> +	if ((fd = openfile(infile, NULL, IO_READONLY, 0, NULL)) < 0)
> +		return 0;
> +	optind++;
> +
> +	if (fstat(fd, &stat) < 0) {
> +		perror("fstat");
> +		goto done;
> +	}
> +
> +	if (optind == argc - 3) {
> +		soffset = cvtnum(blocksize, sectsize, argv[optind]);
> +		if (soffset < 0 || soffset > stat.st_size) {
> +			printf(_("invalid src offset argument -- %s\n"), \
> +			       argv[optind]);
> +			return 0;
> +		}
> +		optind++;
> +		doffset = cvtnum(blocksize, sectsize, argv[optind]);
> +		if (doffset < 0) {
> +			printf(_("invalid dest offset argument -- %s\n"), \
> +			       argv[optind]);
> +			return 0;
> +		}
> +		optind++;
> +		count = cvtnum(blocksize, sectsize, argv[optind]);
> +		if (count < 0 || (soffset + count) > stat.st_size) {
> +			printf(_("invalid length argument -- %s\n"), \
> +			       argv[optind]);
> +			return 0;
> +		}
> +	} else {
> +		/*
> +		 * splice whole file to another, if doesn't specify src and dst
> +		 * offset and length
> +		 */
> +		count = stat.st_size;
> +		soffset = 0;
> +		doffset = 0;
> +	}
> +
> +	gettimeofday(&t1, NULL);
> +	total = splice_file(fd, soffset, doffset, count, splice_flag, &ops);
> +	if (ops == 0 || qflag)
> +		goto done;
> +	gettimeofday(&t2, NULL);
> +	t2 = tsub(t2, t1);
> +
> +	report_io_times("spliced", &t2, (long long)doffset, count, total, ops, \
> +	                Cflag);
> +
> +done:
> +	if (infile)
> +		close(fd);
> +	return 0;
> +}
> +
> +void
> +splice_init(void)
> +{
> +	splice_cmd.name = "splice";
> +	splice_cmd.altname = "spl";
> +	splice_cmd.cfunc = splice_f;
> +	splice_cmd.argmin = 1;
> +	splice_cmd.argmax = -1;
> +	splice_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;;
> +	splice_cmd.args =
> +		_("[-m] infile [src_off dst_off len]");
> +	splice_cmd.oneline =
> +		_("Splice an entire file, or a number of bytes at a specified offset");
> +	splice_cmd.help = splice_help;
> +
> +	add_command(&splice_cmd);
> +}
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 980dcfd3..066a72e7 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -830,6 +830,32 @@ verbose output will be printed.
>  .RE
>  .PD
>  .TP
> +.BI "splice  [ \-C ] [ \-q ] [\-m] infile [src_offset dst_offset length]"
> +On filesystems that support the
> +.BR splice (2)
> +system call, splice data from the
> +.I infile
> +into the open file. If
> +.IR src_offset ,
> +.IR dst_offset ,
> +and
> +.I length
> +are omitted the contents of infile will be copied to the beginning of the
> +open file, overwriting any data already there.
> +.RS 1.0i
> +.PD 0
> +.TP 0.4i
> +.B \-C
> +Print timing statistics in a condensed format.
> +.TP
> +.B \-q
> +Do not print timing statistics at all.
> +.TP
> +.B \-m
> +Enable SPLICE_F_MOVE flag, attempt to move pages instead of copying.
> +.RE
> +.PD
> +.TP
>  .BI utimes " atime_sec atime_nsec mtime_sec mtime_nsec"
>  The utimes command changes the atime and mtime of the current file.
>  sec uses UNIX timestamp notation and is the seconds elapsed since
> -- 
> 2.17.2
> 
