Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4SLm0ZG012909 for <xfs@oss.sgi.com>; Thu, 28 May 2009 16:48:01 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E718B170C196
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 14:48:13 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id wv60HPFWQ16WA5YF for <xfs@oss.sgi.com>;
	Thu, 28 May 2009 14:48:13 -0700 (PDT)
Message-ID: <4A1F0691.7060302@sandeen.net>
Date: Thu, 28 May 2009 16:48:01 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfsprogs: add xfs_loggen
References: <20090528154338.GA20712@infradead.org>
In-Reply-To: <20090528154338.GA20712@infradead.org>
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
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> The loggen utility in xfstests is the only remaining reason why
> something outside libxfs would need libxfs, libxlog and their headers.
> 
> So just move it to xfsprogs but only install it with a special
> make install-qa-tools so that it does not get installed by default.
> Still easier to provide an xfsprogs-qa subpackage for those that want
> to run xfsqa.

Ok, and the xfsqa tests can then skip loggen tests if it's not found.

TBH I'd be pretty unlikely to bother with an xfsprogs-qa package for
Fedora, consisting of exactly one binary... hardly seems worth it.

But I guess I don't see a better way :)  At least this way we can build
it w/o the cross-package deps.

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Maybe we should also drop the current install-qa rule at the same time
> and just make install-qa-tools install-qa?
>
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfsprogs-dev/Makefile
> ===================================================================
> --- xfsprogs-dev.orig/Makefile	2009-05-28 15:22:48.000000000 +0000
> +++ xfsprogs-dev/Makefile	2009-05-28 15:37:39.000000000 +0000
> @@ -20,7 +20,7 @@
>  
>  LIB_SUBDIRS = libxfs libxlog libxcmd libhandle libdisk
>  TOOL_SUBDIRS = copy db estimate fsck fsr growfs io logprint mkfs quota \
> -		mdrestore repair rtcp reno m4 man doc po debian build
> +		mdrestore repair rtcp reno loggen m4 man doc po debian build
>  
>  SUBDIRS = include $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
>  
> @@ -89,6 +89,8 @@
>  
>  install-qa: install $(addsuffix -install-qa,$(SUBDIRS))
>  
> +install-qa-tools: default $(addsuffix -install-qa-tools,$(SUBDIRS))
> +
>  %-install:
>  	$(MAKE) -C $* install
>  
> @@ -98,6 +100,9 @@
>  %-install-qa:
>  	$(MAKE) -C $* install-qa
>  
> +%-install-qa-tools:
> +	$(MAKE) -C $* install-qa-tools
> +
>  distclean: clean
>  	rm -f $(LDIRT)
>  
> Index: xfsprogs-dev/loggen/Makefile
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfsprogs-dev/loggen/Makefile	2009-05-28 15:33:06.000000000 +0000
> @@ -0,0 +1,22 @@
> +
> +TOPDIR = ..
> +include $(TOPDIR)/include/builddefs
> +
> +LTCOMMAND = xfs_loggen
> +CFILES = loggen.c
> +
> +LLDLIBS	= $(LIBXLOG)
> +LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
> +LLDFLAGS = -static
> +
> +default: $(LTCOMMAND)
> +
> +include $(BUILDRULES)
> +
> +install:
> +
> +install-qa-tools: default
> +	$(INSTALL) -m 755 -d $(PKG_BIN_DIR)
> +	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_BIN_DIR)
> +
> +install-dev:
> Index: xfsprogs-dev/loggen/loggen.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfsprogs-dev/loggen/loggen.c	2009-05-28 15:29:44.000000000 +0000
> @@ -0,0 +1,320 @@
> +/*
> + * Copyright (c) 2000-2003 Silicon Graphics, Inc.
> + * All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +
> +/*
> + *
> + * loggen: Generate log entries. Very much incomplete. The empty log
> + *         record is a bit of a misnomer since we need to jump through
> + *         hoops to get a log record that parses ok yet does nothing.
> + *
> + *                                                  - dxm 29/09/00
> + */
> +
> +#include <xfs/libxfs.h>
> +#include <xfs/xfs_log.h>
> +#include <xfs/xfs_log_priv.h>
> +
> +
> +char *progname;
> +
> +static void usage(void)
> +{
> +	fprintf(stderr, "Usage: %s\n"
> +"           set up parameters before writing record(s):\n"
> +"               -f f     - set format\n"
> +"               -u u     - set uuid\n"
> +"               -c c     - set cycle\n"
> +"               -b b     - set block\n"
> +"               -C c     - set tail cycle\n"
> +"               -B b     - set tail block\n"
> +"           write log record(s):\n"
> +"               -z n     - write n zero block(s)     (1BB)\n"
> +"               -e n     - write n empty record(s)   (2BB)\n"
> +"               -m n     - write n unmount record(s) (2BB)\n"
> +"\n"
> +"            redirect stdout to external log partition, or pipe to\n"
> +"            dd with appropriate parameters to stuff into internal log.\n",
> +		progname);
> +	exit(1);
> +}
> +
> +int bufblocks = 0;
> +void *buf = NULL;
> +int param_cycle = 1;
> +int param_block = 0;
> +int param_tail_cycle = 1;
> +int param_tail_block = 0;
> +int param_fmt = XLOG_FMT;
> +uuid_t param_uuid = { 0 };
> +
> +void loggen_alloc(int blocks)
> +{
> +	if (!(buf = realloc(buf, blocks * BBSIZE))) {
> +		fprintf(stderr, "failed to allocate %d block(s)\n", blocks);
> +		exit(1);
> +	}
> +	memset(buf, 0, blocks * BBSIZE);
> +	bufblocks = blocks;
> +}
> +
> +void loggen_write(void)
> +{
> +	if (!buf) {
> +		fprintf(stderr, "no buffer allocated\n");
> +		exit(1);
> +	}
> +
> +	if (fwrite(buf, BBSIZE, bufblocks, stdout) != bufblocks) {
> +		perror("fwrite");
> +		exit(1);
> +	}
> +
> +}
> +
> +void loggen_zero(int count)
> +{
> +	if (!count)
> +		count = 1;
> +
> +	fprintf(stderr, "   *** zero block (1BB) x %d\n", count);
> +	loggen_alloc(1);
> +	while (count--)
> +		loggen_write();
> +}
> +
> +void loggen_unmount(int count)
> +{
> +	xlog_rec_header_t *head;
> +	xlog_op_header_t *op;
> +	/* the data section must be 32 bit size aligned */
> +	struct {
> +		__uint16_t magic;
> +		__uint16_t pad1;
> +		__uint32_t pad2;	/* may as well make it 64 bits */
> +	} magic = {
> +	XLOG_UNMOUNT_TYPE, 0, 0};
> +
> +	if (!count)
> +		count = 1;
> +
> +	fprintf(stderr, "   *** unmount record (2BB) x %d\n", count);
> +	loggen_alloc(2);
> +
> +	head = (xlog_rec_header_t *) buf;
> +	op = (xlog_op_header_t *) (((char *)buf) + BBSIZE);
> +
> +	/* note that oh_tid actually contains the cycle number
> +	 * and the tid is stored in h_cycle_data[0] - that's the
> +	 * way things end up on disk.
> +	 */
> +
> +	head->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
> +	head->h_cycle = cpu_to_be32(param_cycle);
> +	head->h_version = cpu_to_be32(1);
> +	head->h_len = cpu_to_be32(20);
> +	head->h_chksum = cpu_to_be32(0);
> +	head->h_prev_block = cpu_to_be32(-1);
> +	head->h_num_logops = cpu_to_be32(1);
> +	head->h_cycle_data[0] = cpu_to_be32(0xb0c0d0d0);
> +	head->h_fmt = cpu_to_be32(param_fmt);
> +
> +	head->h_tail_lsn = cpu_to_be64(xlog_assign_lsn(param_tail_cycle,
> +						       param_tail_block));
> +
> +	memcpy(head->h_fs_uuid, param_uuid, sizeof(uuid_t));
> +
> +	/* now a log unmount op */
> +	op->oh_tid = cpu_to_be32(param_cycle);
> +	op->oh_len = cpu_to_be32(sizeof(magic));
> +	op->oh_clientid = XFS_LOG;
> +	op->oh_flags = XLOG_UNMOUNT_TRANS;
> +	op->oh_res2 = cpu_to_be16(0);
> +
> +	/* and the data for this op */
> +
> +	memcpy(op + 1, &magic, sizeof(magic));
> +
> +	while (count--) {
> +		head->h_lsn =
> +		    cpu_to_be64(xlog_assign_lsn(param_cycle, param_block++));
> +
> +		loggen_write();
> +	}
> +}
> +
> +void loggen_empty(int count)
> +{
> +	xlog_rec_header_t *head;
> +	xlog_op_header_t *op1, *op2, *op3, *op4, *op5;
> +	xfs_trans_header_t *trans;
> +	xfs_buf_log_format_t blfs;
> +	xfs_buf_log_format_t *blf;
> +	int *data;
> +	char *p;
> +
> +	if (!count)
> +		count = 1;
> +
> +	fprintf(stderr, "   *** empty record (2BB) x %d\n", count);
> +	loggen_alloc(2);
> +
> +	p = (char *)buf;
> +	head = (xlog_rec_header_t *) p;
> +	p += BBSIZE;
> +	op1 = (xlog_op_header_t *) p;
> +	p += sizeof(xlog_op_header_t);
> +	op2 = (xlog_op_header_t *) p;
> +	p += sizeof(xlog_op_header_t);
> +	trans = (xfs_trans_header_t *) p;
> +	p += sizeof(xfs_trans_header_t);
> +	op3 = (xlog_op_header_t *) p;
> +	p += sizeof(xlog_op_header_t);
> +	blf = (xfs_buf_log_format_t *) p;
> +	p += sizeof(xfs_buf_log_format_t);
> +	op4 = (xlog_op_header_t *) p;
> +	p += sizeof(xlog_op_header_t);
> +	data = (int *)p;
> +	p += sizeof(int);
> +	op5 = (xlog_op_header_t *) p;
> +	p += sizeof(xlog_op_header_t);
> +
> +	/* note that oh_tid actually contains the cycle number
> +	 * and the tid is stored in h_cycle_data[0] - that's the
> +	 * way things end up on disk.
> +	 */
> +
> +	head->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
> +	head->h_cycle = cpu_to_be32(param_cycle);
> +	head->h_version = cpu_to_be32(1);
> +	head->h_len = cpu_to_be32(5 * sizeof(xlog_op_header_t) +
> +				  sizeof(xfs_trans_header_t) +
> +				  sizeof(xfs_buf_log_format_t) + sizeof(int));
> +	head->h_chksum = cpu_to_be32(0);
> +	head->h_prev_block = cpu_to_be32(-1);
> +	head->h_num_logops = cpu_to_be32(5);
> +	head->h_cycle_data[0] = cpu_to_be32(0xb0c0d0d0);
> +	head->h_fmt = cpu_to_be32(param_fmt);
> +
> +	head->h_tail_lsn = cpu_to_be64(xlog_assign_lsn(param_tail_cycle,
> +						       param_tail_block));
> +
> +	memcpy(head->h_fs_uuid, param_uuid, sizeof(uuid_t));
> +
> +	/* start */
> +	op1->oh_tid = cpu_to_be32(1);
> +	op1->oh_len = cpu_to_be32(0);
> +	op1->oh_clientid = XFS_TRANSACTION;
> +	op1->oh_flags = XLOG_START_TRANS;
> +	op1->oh_res2 = cpu_to_be16(0);
> +	/* dummy */
> +	op2->oh_tid = cpu_to_be32(0xb0c0d0d0);
> +	op2->oh_len = cpu_to_be32(sizeof(xfs_trans_header_t));
> +	op2->oh_clientid = XFS_TRANSACTION;
> +	op2->oh_flags = 0;
> +	op2->oh_res2 = cpu_to_be16(0);
> +	/* dummy transaction - this stuff doesn't get endian converted */
> +	trans->th_magic = XFS_TRANS_MAGIC;
> +	trans->th_type = XFS_TRANS_DUMMY1;
> +	trans->th_tid = 0;
> +	trans->th_num_items = 1;
> +	/* buffer */
> +	op3->oh_tid = cpu_to_be32(0xb0c0d0d0);
> +	op3->oh_len = cpu_to_be32(sizeof(xfs_buf_log_format_t));
> +	op3->oh_clientid = XFS_TRANSACTION;
> +	op3->oh_flags = 0;
> +	op3->oh_res2 = cpu_to_be16(0);
> +	/* an empty buffer too */
> +	blfs.blf_type = XFS_LI_BUF;
> +	blfs.blf_size = 2;
> +	blfs.blf_flags = XFS_BLI_CANCEL;
> +	blfs.blf_blkno = 1;
> +	blfs.blf_map_size = 1;
> +	blfs.blf_data_map[0] = 0;
> +	memcpy(blf, &blfs, sizeof(blfs));
> +	/* commit */
> +	op4->oh_tid = cpu_to_be32(0xb0c0d0d0);
> +	op4->oh_len = cpu_to_be32(sizeof(int));
> +	op4->oh_clientid = XFS_TRANSACTION;
> +	op4->oh_flags = 0;
> +	op4->oh_res2 = cpu_to_be16(0);
> +	/* and the data */
> +	*data = *(int *)(char *)"FISH";	/* this won't get written (I hope) */
> +	/* commit */
> +	op5->oh_tid = cpu_to_be32(0xb0c0d0d0);
> +	op5->oh_len = cpu_to_be32(0);
> +	op5->oh_clientid = XFS_TRANSACTION;
> +	op5->oh_flags = XLOG_COMMIT_TRANS;
> +	op5->oh_res2 = cpu_to_be16(0);
> +
> +	while (count--) {
> +		head->h_lsn =
> +		    cpu_to_be64(xlog_assign_lsn(param_cycle, param_block++));
> +
> +		loggen_write();
> +	}
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	int c;
> +
> +	progname = basename(argv[0]);
> +
> +	fprintf(stderr, "*** loggen\n");
> +
> +	if (argc < 2)
> +		usage();
> +
> +	while ((c = getopt(argc, argv, "f:u:c:b:C:B:z:e:m:")) != -1) {
> +		switch (c) {
> +		case 'f':
> +			param_fmt = atoi(optarg);
> +			break;
> +		case 'u':
> +			memset(param_uuid, atoi(optarg), sizeof(param_uuid));
> +			break;
> +		case 'c':
> +			param_cycle = atoi(optarg);
> +			break;
> +		case 'b':
> +			param_block = atoi(optarg);
> +			break;
> +		case 'C':
> +			param_tail_cycle = atoi(optarg);
> +			break;
> +		case 'B':
> +			param_tail_block = atoi(optarg);
> +			break;
> +
> +		case 'z':
> +			loggen_zero(atoi(optarg));
> +			break;
> +		case 'e':
> +			loggen_empty(atoi(optarg));
> +			break;
> +		case 'm':
> +			loggen_unmount(atoi(optarg));
> +			break;
> +
> +		default:
> +			fprintf(stderr, "unknown option\n");
> +			usage();
> +		}
> +	}
> +	return 0;
> +}
> Index: xfsprogs-dev/include/buildrules
> ===================================================================
> --- xfsprogs-dev.orig/include/buildrules	2009-05-28 15:37:24.000000000 +0000
> +++ xfsprogs-dev/include/buildrules	2009-05-28 15:37:30.000000000 +0000
> @@ -69,7 +69,7 @@
>  
>  $(_FORCE):
>  
> -.PHONY : depend install-qa
> +.PHONY : depend install-qa install-qa-tools
>  
>  DEPENDSCRIPT := $(MAKEDEPEND) $(DEPENDFLAGS) -f - -- $(CFLAGS) -- $(CFILES) | \
>  	$(SED) \
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
