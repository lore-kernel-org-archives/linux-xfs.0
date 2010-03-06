Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o26Fl6JO099206 for <xfs@oss.sgi.com>; Sat, 6 Mar 2010 09:47:06 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5932C220167
	for <xfs@oss.sgi.com>; Sat,  6 Mar 2010 07:48:36 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LyMMNolaaBTQmPHr for
	<xfs@oss.sgi.com>; Sat, 06 Mar 2010 07:48:36 -0800 (PST)
Date: Sat, 6 Mar 2010 10:48:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 9/9] xfs: factor xlog_write and make use of new log
	vector structure
Message-ID: <20100306154836.GB29590@infradead.org>
References: <1267840284-4652-1-git-send-email-david@fromorbit.com>
	<1267840284-4652-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1267840284-4652-10-git-send-email-david@fromorbit.com>
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

On Sat, Mar 06, 2010 at 12:51:24PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xlog_write is a mess that takes a lot of effort to understand. It is
> a mass of nested loops with 4 space indents to get it to fit in 80 columns
> and lots of funky variables that aren't obvious what they mean or do.
> 
> Break it down into understandable chunks, format them properly and propagate
> the new log vector structure into it to support chaining of log vectors.

This looks good to me, but I have a bit of a hard time to verify it.

As mention before I think this would be much better off as one
patch to split up xlog_write to go in before patch 8, and a separate
one to deal with the xfs_log_vecs, which could in fact be merged into
the existing patch 8, just to be reordered to be last - or even first
of the actual delayed logging series.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
