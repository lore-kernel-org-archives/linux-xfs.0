Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0D48E7F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 17:57:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DF34B304039
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 15:57:47 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	WIrTEEGBwSSu9Bv6 for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 15:57:45 -0700 (PDT)
Date: Tue, 25 Aug 2015 08:57:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150824225743.GE714@dastard>
References: <20150824011123.GA714@dastard>
	<20150824031816.GO17933@dhcp-13-216.nay.redhat.com>
	<20150824062425.GU3902@dastard>
	<20150824091959.GA2936@quack.suse.cz>
	<20150824145150.GA10029@mtj.duckdns.org>
	<20150824171144.GB27262@mtj.duckdns.org>
	<20150824190847.GA4234@quack.suse.cz>
	<20150824193242.GE28944@mtj.duckdns.org>
	<20150824210927.GA8823@quack.suse.cz>
	<20150824214535.GM28944@mtj.duckdns.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150824214535.GM28944@mtj.duckdns.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com

On Mon, Aug 24, 2015 at 05:45:35PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Mon, Aug 24, 2015 at 11:09:27PM +0200, Jan Kara wrote:
> > It is inefficient, yes. But note that 'writeback' and 'dirty' states are
> > completely independent. Page can be in any of the !dirty & !writeback,
> 
> That isn't true for pages being dirtied through set_page_dirty().
> It's guaranteed that a dirty inode remains on one of the b_* lists
> till there's no dirty page and writeback is complete.

IO submission calls clear_page_dirty_for_io(), so by the time that
all the pages have been submitted for IO, there are no dirty pages.
IO submission also calls set_page_writeback() once the filesystem
has decided to do IO on the page, and then IO completion calls
end_page_writeback() to clear that state.

IOWs, the page transitions from (dirty && !writeback) before
submission to (!dirty && writeback) after submission, and to (!dirty
&& !writeback) once IO completion occurs.

And you'll note that filemap_fdatawait() blocks on pages with the
PAGECACHE_TAG_WRITEBACK tag set in the mapping tree, not dirty
pages. Hence sync has to wait for all pages to transition out of
writeback before we can consider the inode to be clean.

> > dirty & !writeback, !dirty & writeback, dirty & writeback states. So mixing
> > tracking of writeback and dirty state of an inode just makes the code even
> > messier.
> 
> I'm curious where and why they would deviate.  Can you give me some
> examples?  AFAICS, anything which uses the usual set_page_dirty() path
> shouldn't do that.

mmaped files.

page_mkwrite dirties page		(dirty && !writeback)
writepage clear_page_dirty_for_io	(!dirty && !writeback)
writepage starts writeback		(!dirty && writeback)
page_mkwrite dirties page		(dirty && writeback)
io completes				(dirty && !writeback)

This is done so we don't lose dirty state from page faults whilst
the page is under IO and hence have sync miss the page next time
through....

Of course, this behaviour is different if you have a filesystem or
block device that requires stable pages (e.g. btrfs for data CRC
validity). In this case, the page fault will block until the
writeback state goes away...

> > > > a list to track inodes with pages under writeback but they clashed with
> > > > your patch series and they didn't get rebased yet AFAIR.
> > > 
> > > Wouldn't it make more sense to simply put them on one of the existing
> > > b_* lists?
> > 
> > Logically it just doesn't make sense because as I wrote above dirty and
> > writeback states are completely independent. Also you'd have to detect &
> > skip inodes that don't really have any dirty pages to write and all the
> > detection of "is there any data to write" would get more complicated. A
> > separate list for inodes under writeback as Josef did is IMO the cleanest
> > solution.
> 
> Given that the usual code path tracks dirty and writeback together, I
> don't think it's nonsensical; however, I'm more curious how common
> writeback w/o dirtying case is.

I suspect you've misunderstood the progression here. You can't get
writeback without first going through dirty. But the transition to
writeback clears the dirty page state so that we can capture page
state changes while writeback is in progress.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
