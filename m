Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0LBNPk7068668 for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 05:23:25 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F3DB91C6A5F6
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 03:24:26 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FATX9QUY27l3y5i6 for
	<xfs@oss.sgi.com>; Thu, 21 Jan 2010 03:24:26 -0800 (PST)
Date: Thu, 21 Jan 2010 06:24:26 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfstests: Automatic build dependency calculations
Message-ID: <20100121112426.GB27634@infradead.org>
References: <1264053773-6054-1-git-send-email-david@fromorbit.com>
	<1264053773-6054-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1264053773-6054-3-git-send-email-david@fromorbit.com>
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

>  LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize \
> -	preallo_rw_pattern_reader preallo_rw_pattern_writer ftrunc trunc \
> -	fs_perms testx looptest locktest unwritten_mmap \
> +	ftrunc trunc fs_perms testx looptest locktest unwritten_mmap \
>  	bulkstat_unlink_test bulkstat_unlink_test_modified t_dir_offset \
>  	t_futimens
>  
> +SUBDIRS =
> +
>  LLDLIBS = $(LIBATTR) $(LIBHANDLE) $(LIBACL)
>  
>  ifeq ($(HAVE_XLOG_ASSIGN_LSN), true)
> @@ -27,6 +28,7 @@ endif
>  IRIX_TARGETS = open_unlink
>  
>  ifeq ($(PKG_PLATFORM),linux)
> +PREALLO_TARGETS = preallo_rw_pattern_reader

What happens to the writer here?  Before introducing more special cases
for this duplicates let me post my patch to make the file compiled more
normal, will send it out ASAP.

Otherwise looks good to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
