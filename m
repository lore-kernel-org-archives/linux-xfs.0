Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 May 2007 23:06:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4M663Wt014354
	for <xfs@oss.sgi.com>; Mon, 21 May 2007 23:06:05 -0700
Date: Tue, 22 May 2007 16:05:59 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: ensure EOF writes into existing extents update filesize
Message-ID: <20070522060559.GI86004887@sgi.com>
References: <20070520233417.GA85884050@sgi.com> <738172E9F9634F7FC01B5B3C@timothy-shimmins-power-mac-g5.local> <20070522004414.GL85884050@sgi.com> <1179795779.6273.510.camel@edge> <20070522010326.GN85884050@sgi.com> <1179807014.6273.519.camel@edge>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179807014.6273.519.camel@edge>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nscott@aconex.com>
Cc: David Chinner <dgc@sgi.com>, Timothy Shimmin <tes@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, May 22, 2007 at 02:10:14PM +1000, Nathan Scott wrote:
> On Tue, 2007-05-22 at 11:03 +1000, David Chinner wrote:
> > On Tue, May 22, 2007 at 11:02:59AM +1000, Nathan Scott wrote:
> > > On Tue, 2007-05-22 at 10:44 +1000, David Chinner wrote:
> > > > On Mon, May 21, 2007 at 04:34:26PM +1000, Timothy Shimmin wrote:
> > > > I guess I need to ping Christoph and Nathan on this one....
> > > 
> > > Could you resend the patch to me please?  I lost the previous copy
> > > while ruthlessly ploughing through my mail backlog.  ;)
> > 
> > Below.
> 
> Looks pretty good to me - xfs_convert_page has been overlooked, I
> think - attached patch fixes that.

I thought about that, then tried to trip the problem and was not
successful. AFAICT, if we have multiple pages dirty and in the same
state (i.e. pwrite 0 32769 to dirty 3 pages, then sync, then pwrite
0 33000 to dirty and extend) we should hit the case where we cluster
the dirty pages and call xfs_convert_page() on the last two pages.

In that case, the entire range should be mapped via the one iomap
and so the last buffer (the one we extended) should be added to an
ioend with a type of 0 (IOMAP_READ) and hence we should see the bug. 
With the patch I posted, I can't get this to show the problem. It
should, but it doesn't....

I'll make the change anyway to be safe, but I'm still perplexed
as to why it doesn't seem necessary....

Ah - there it is - xfs_is_delayed_page():

    699                         if (buffer_unwritten(bh))
    700                                 acceptable = (type == IOMAP_UNWRITTEN);
    701                         else if (buffer_delay(bh))
    702                                 acceptable = (type == IOMAP_DELAY);
    703                         else if (buffer_dirty(bh) && buffer_mapped(bh))
    704     >>>>>>>>>>>                 acceptable = (type == 0);
    705                         else
    706                                 break;

The ioend we started with now has type = IOMAP_NEW = 0x40 which 
means xfs_convert_page() aborts clustering this case immediately.
IOWs, we are never getting to this xfs_convert_page() case and
we are only passing through xfs_page_state_convert for mapped
pages.

> You also initialise iomap_valid
> twice inside xfs_page_state_convert now ... I reverted that to just
> the once.

I'll fold these changes in and fixup xfs_is_delayed_page() to look
for type == IOMAP_NEW and send out a new patch. Thanks, Nathan.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
