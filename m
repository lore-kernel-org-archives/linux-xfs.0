Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2PEM1AX130346 for <xfs@oss.sgi.com>; Thu, 25 Mar 2010 09:22:02 -0500
Subject: Re: [PATCH 2/7] xfs: fix min bufsize bugs in two places
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100320164249.GB31444@infradead.org>
References: <201003182253.o2IMrp54001850@stout.americas.sgi.com>
	<20100320164249.GB31444@infradead.org>
Date: Thu, 25 Mar 2010 09:23:34 -0500
Message-ID: <1269527014.2523.5.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Sat, 2010-03-20 at 12:42 -0400, Christoph Hellwig wrote:
> > +/* Number of basic blocks in a log sector */
> > +#define xlog_sectbb(log) (1 << (log)->l_sectbb_log)
> 
> Looking at all uses of (log)->l_sectbb_log I wonder if we should
> bother storing this in the log structure in this form, or rather
> as the multipler of the basic block size, ala l_sectsize.  All the

I agree, and I was sort of headed in that direction.  I have
more work in this file that eventually will lead to some larger
scale (algorithmic) simplification.  But for now I'm starting
small.

> 	if (log->l_sectbb_log) {
> 
> checks would just become
> 
> 	if (log->l_sectsize > 1) {
> 
> and the xlog_find_verify_cycle/xlog_write_log_records checks
> would also be a natural
> 
> 	if (bufblks < log->l_sectsize)

I'll attack this in a later patch.

> The comments added are defintively useful, btw.

Thanks, I felt they were necessary.  More to come.

I got "looks good" from you on all but this patch,
and numbers 5 and 7 in the series.  Is this one OK,
and do you plan to review those other two?

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
