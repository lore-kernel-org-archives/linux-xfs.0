Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o26FihPD099071 for <xfs@oss.sgi.com>; Sat, 6 Mar 2010 09:44:44 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 169F9220137
	for <xfs@oss.sgi.com>; Sat,  6 Mar 2010 07:46:12 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id fnQ80HjQiVVwphcA for
	<xfs@oss.sgi.com>; Sat, 06 Mar 2010 07:46:12 -0800 (PST)
Date: Sat, 6 Mar 2010 10:46:10 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/9] xfs: introduce new internal log vector structure
Message-ID: <20100306154610.GA29590@infradead.org>
References: <1267840284-4652-1-git-send-email-david@fromorbit.com>
	<1267840284-4652-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1267840284-4652-9-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sat, Mar 06, 2010 at 12:51:23PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The current log IO vector structure is a flat array and not
> extensible. To make it possible to keep separate log IO vectors for
> individual log items, we need a method of chaining log IO vectors
> together.
> 
> Introduce a new log vector type that can be used to wrap the
> existing log IO vectors on use that internally to the log. This
> means that the existing external interface (xfs_log_write) does not
> change and hence no changes to the transaction commit code are
> required.
> 
> This initial use of the new log vectors does not use the chaining
> capability of the new log vector structure - it is not needed to
> implement the flat vector array the current transaction commit path
> creates.

Looks good to me,


Reviewed-by: Christoph Hellwig <hch@lst.de>

A few comments below:

> +			/* the data section must be 32 bit size aligned */
> +			struct {
> +			    __uint16_t magic;
> +			    __uint16_t pad1;
> +			    __uint32_t pad2; /* may as well make it 64 bits */
> +			} magic = {
> +				.magic = XLOG_UNMOUNT_TYPE,
> +			};
> +			struct xfs_log_iovec reg = {
> +				.i_addr = (void *)&magic,
> +				.i_len = sizeof(magic),
> +				.i_type = XLOG_REG_TYPE_UNMOUNT,
> +			};
> +			struct xfs_log_vec vec = {
> +				.lv_niovecs = 1,
> +			};
> +			/* sigh. c99 initialisers don't work on anon unions */
> +			vec.lv_iovecp = &reg;

I can't see an anonymous union involved anywhere here, and initializing
these normally works just fine (see patch below).

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2010-03-06 16:40:35.817021839 +0100
+++ xfs/fs/xfs/xfs_log.c	2010-03-06 16:41:49.873004518 +0100
@@ -557,9 +557,8 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 			};
 			struct xfs_log_vec vec = {
 				.lv_niovecs = 1,
+				.lv_iovecp = &reg,
 			};
-			/* sigh. c99 initialisers don't work on anon unions */
-			vec.lv_iovecp = &reg;
 
 			/* remove inited flag */
 			tic->t_flags = 0;
@@ -686,9 +685,8 @@ xfs_log_write(
 	int			error;
 	struct xfs_log_vec	vec = {
 		.lv_niovecs = nentries,
+		.lv_iovecp = reg,
 	};
-	/* sigh. c99 initialisers don't work on anon unions */
-	vec.lv_iovecp = reg;
 
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return XFS_ERROR(EIO);
@@ -1201,9 +1199,8 @@ xlog_commit_record(
 	};
 	struct xfs_log_vec vec = {
 		.lv_niovecs = 1,
+		.lv_iovecp = &reg,
 	};
-	/* sigh. c99 initialisers don't work on anon unions */
-	vec.lv_iovecp = &reg;
 
 	ASSERT_ALWAYS(iclog);
 	error = xlog_write(log, &vec, ticket, commitlsnp, iclog,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
