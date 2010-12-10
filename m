Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBADRnPJ257855 for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 07:27:50 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 418EA1CB11D7
	for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 05:29:39 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id YEPyLRg9sR2kSd2v for
	<xfs@oss.sgi.com>; Fri, 10 Dec 2010 05:29:39 -0800 (PST)
Date: Fri, 10 Dec 2010 08:29:35 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: prevent NMI timeouts in cmn_err
Message-ID: <20101210132935.GA24210@infradead.org>
References: <1291341315-31338-1-git-send-email-david@fromorbit.com>
	<20101203043846.GB23339@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101203043846.GB23339@dastard>
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

On Fri, Dec 03, 2010 at 03:38:46PM +1100, Dave Chinner wrote:
> FWIW, while these macros are the best way to make a simple backport
> is possible, I just discovered that mainline has a %pV format
> operator that allows an implementation like:
> 
> void
> xfs_fs_cmn_err(
> 	const char              *lvl,
> 	struct xfs_mount        *mp,
> 	const char              *fmt,
> 	...)
> {
> 	struct va_format        vaf;
> 	va_list                 args;
> 
> 	va_start(args, fmt);
> 	vaf.fmt = fmt;
> 	vaf.va = &args;
> 
> 	printk("%sFilesystem %s: %pV", lvl, mp->m_fsname, &vaf);
> 	va_end(args);
> 
> 	BUG_ON(strncmp(lvl, KERN_EMERG, strlen(KERN_EMERG)) == 0);
> }

With this we can also keep the existing integer-based CE_ values
and do trivial array lookup.  That also avoids having to do a strcmp for
every message printed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
