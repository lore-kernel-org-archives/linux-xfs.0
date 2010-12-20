Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBKC4bZV120070 for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 06:04:37 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 969C61CDF3FD
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 04:06:34 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Tbr8U36TufuAD31v for
	<xfs@oss.sgi.com>; Mon, 20 Dec 2010 04:06:34 -0800 (PST)
Date: Mon, 20 Dec 2010 07:06:34 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/12] xfs: convert l_tail_lsn to an atomic variable.
Message-ID: <20101220120634.GA3582@infradead.org>
References: <1292215483-18224-1-git-send-email-david@fromorbit.com>
	<1292215483-18224-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292215483-18224-9-git-send-email-david@fromorbit.com>
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

On Mon, Dec 13, 2010 at 03:44:39PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> log->l_tail_lsn is currently protected by the log grant lock. The
> lock is only needed for serialising readers against writers, so we
> don't really need the lock if we make the l_tail_lsn variable an
> atomic. Converting the l_tail_lsn variable to an atomic64_t means we
> can start to peel back the grant lock from various operations.
> 
> Also, provide functions to safely crack an atomic LSN variable into
> it's component pieces and to recombined the components into an
> atomic variable. Use them where appropriate.
> 
> This also removes the need for explicitly holding a spinlock to read
> the l_tail_lsn on 32 bit platforms.

I know I suggested this, but I think the atomic read of l_tail_lsn
in xlog_space_left might be problemetic for the call from
xlog_grant_push_ail, where we read it twice now.  Maybe split
xlog_space_left into a __xlog_space_left that gets the already cracked
values, and xlog_space_left as a wrapper around it?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
