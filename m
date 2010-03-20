Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2KGfBJv061823 for <xfs@oss.sgi.com>; Sat, 20 Mar 2010 11:41:11 -0500
Date: Sat, 20 Mar 2010 12:42:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/7] xfs: fix min bufsize bugs in two places
Message-ID: <20100320164249.GB31444@infradead.org>
References: <201003182253.o2IMrp54001850@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201003182253.o2IMrp54001850@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

> +/* Number of basic blocks in a log sector */
> +#define xlog_sectbb(log) (1 << (log)->l_sectbb_log)

Looking at all uses of (log)->l_sectbb_log I wonder if we should
bother storing this in the log structure in this form, or rather
as the multipler of the basic block size, ala l_sectsize.  All the

	if (log->l_sectbb_log) {

checks would just become

	if (log->l_sectsize > 1) {

and the xlog_find_verify_cycle/xlog_write_log_records checks
would also be a natural

	if (bufblks < log->l_sectsize)

The comments added are defintively useful, btw.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
