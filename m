Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0O7Grfa234832 for <xfs@oss.sgi.com>; Sun, 24 Jan 2010 01:16:54 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E86831C73DDA
	for <xfs@oss.sgi.com>; Sat, 23 Jan 2010 23:17:55 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	tfrpVYCMl4BMdh41 for <xfs@oss.sgi.com>;
	Sat, 23 Jan 2010 23:17:55 -0800 (PST)
Date: Sun, 24 Jan 2010 18:17:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfstests: Automatic build dependency calculations
Message-ID: <20100124071752.GI25842@discord.disaster>
References: <1264053773-6054-1-git-send-email-david@fromorbit.com>
	<1264053773-6054-3-git-send-email-david@fromorbit.com>
	<20100121112426.GB27634@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100121112426.GB27634@infradead.org>
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

On Thu, Jan 21, 2010 at 06:24:26AM -0500, Christoph Hellwig wrote:
> >  LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize \
> > -	preallo_rw_pattern_reader preallo_rw_pattern_writer ftrunc trunc \
> > -	fs_perms testx looptest locktest unwritten_mmap \
> > +	ftrunc trunc fs_perms testx looptest locktest unwritten_mmap \
> >  	bulkstat_unlink_test bulkstat_unlink_test_modified t_dir_offset \
> >  	t_futimens
> >  
> > +SUBDIRS =
> > +
> >  LLDLIBS = $(LIBATTR) $(LIBHANDLE) $(LIBACL)
> >  
> >  ifeq ($(HAVE_XLOG_ASSIGN_LSN), true)
> > @@ -27,6 +28,7 @@ endif
> >  IRIX_TARGETS = open_unlink
> >  
> >  ifeq ($(PKG_PLATFORM),linux)
> > +PREALLO_TARGETS = preallo_rw_pattern_reader
> 
> What happens to the writer here?

Oops, missed it.
>
> Before introducing more special cases
> for this duplicates let me post my patch to make the file compiled more
> normal, will send it out ASAP.

OK, I'll pull your patch into my series and rebase my change on it
before pushing the lot of them.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
