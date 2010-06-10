Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5A05oAI040652 for <xfs@oss.sgi.com>; Wed, 9 Jun 2010 19:05:51 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D600B3B86CC
	for <xfs@oss.sgi.com>; Wed,  9 Jun 2010 17:08:21 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	NIh2uifdLeN1oujS for <xfs@oss.sgi.com>;
	Wed, 09 Jun 2010 17:08:21 -0700 (PDT)
Date: Thu, 10 Jun 2010 10:08:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] writeback: pay attention to wbc->nr_to_write in
	write_cache_pages
Message-ID: <20100610000811.GL7869@dastard>
References: <1276043840-1946-1-git-send-email-david@fromorbit.com>
	<1276043840-1946-2-git-send-email-david@fromorbit.com>
	<20100609140942.6799c84a.akpm@linux-foundation.org>
	<20100609225804.GK7869@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100609225804.GK7869@dastard>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, stable@kernel.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jun 10, 2010 at 08:58:04AM +1000, Dave Chinner wrote:
> On Wed, Jun 09, 2010 at 02:09:42PM -0700, Andrew Morton wrote:
> > On Wed,  9 Jun 2010 10:37:18 +1000
> > Dave Chinner <david@fromorbit.com> wrote:
> > 
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > If a filesystem writes more than one page in ->writepage, write_cache_pages
> > > fails to notice this and continues to attempt writeback when wbc->nr_to_write
> > > has gone negative - this trace was captured from XFS:
> > > 
> > > 
> > >     wbc_writeback_start: towrt=1024
> > >     wbc_writepage: towrt=1024
> > >     wbc_writepage: towrt=0
> > >     wbc_writepage: towrt=-1
> > >     wbc_writepage: towrt=-5
> > >     wbc_writepage: towrt=-21
> > >     wbc_writepage: towrt=-85
> > > 
> > > This has adverse effects on filesystem writeback behaviour. write_cache_pages()
> > > needs to terminate after a certain number of pages are written, not after a
> > > certain number of calls to ->writepage are made.  This is a regression
> > > introduced by 17bc6c30cf6bfffd816bdc53682dd46fc34a2cf4 ("vfs: Add
> > > no_nrwrite_index_update writeback control flag"), but cannot be reverted
> > > directly due to subsequent bug fixes that have gone in on top of it.
> > 
> > Might be needed in -stable.  Unfortunately the most important piece of
> > information which is needed to make that decision was cunningly hidden
> > from us behind the vague-to-the-point-of-uselessness term "adverse
> > effects".
> > 
> > _what_ "adverse effects"??
> 
> Depends on how the specific filesystem handles a negative
> nr_to_write, doesn't it? I can't speak for the exact effect on
> anything other than XFS except to say that most ->write_page
> implemetnations don't handle the wbc->nr_to_write < 0 specifically...
> 
> For XFS, it results in increased CPU usage because it triggers
> page-at-a-time allocation (i.e no clustering), which increases
> overhead in the elveator due to merging requirements of single page
> bios and increased fragmentation due to small interleaved
> allocations on concurrent writeback workloads. Effectively it causes
> accelerated aging of XFS filesystems...

Sorry, forgot to address the -stable part of the question.

This series is dependent on the ext4 change to use it's own
writepage going into -stable first.  (i.e.
8e48dcfbd7c0892b4cfd064d682cc4c95a29df32 "ext4: Use our own
write_cache_pages()").

I'd suggest that all 4 patches (the ext4 patch and the three in this
series) should go back to 2.6.34-stable due to the long term affect
this writeback bug could have on XFS filesystems, and the sync
taking too long problem has been fairly widely reported since at
least .32...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
