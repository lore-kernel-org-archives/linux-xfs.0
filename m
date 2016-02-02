Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 68FB47CB1
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 09:26:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 46197304039
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 07:26:25 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fGaY0svOnQHZoZDX (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Feb 2016 07:26:24 -0800 (PST)
Date: Tue, 2 Feb 2016 10:26:21 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: stop using ioends for direct write completions
Message-ID: <20160202152620.GA1853@bfoster.bfoster>
References: <1452766237-2314-1-git-send-email-hch@lst.de>
	<20160128131656.GB14876@infradead.org>
	<20160129141232.GA43184@bfoster.bfoster>
	<20160201215407.GI20038@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160201215407.GI20038@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Feb 01, 2016 at 01:54:07PM -0800, Darrick J. Wong wrote:
> On Fri, Jan 29, 2016 at 09:12:33AM -0500, Brian Foster wrote:
> > On Thu, Jan 28, 2016 at 05:16:56AM -0800, Christoph Hellwig wrote:
> > > Any chance to get a review for this?  It should really help
> > > with sorting out the buffered I/O COW code.
> > > 
> > 
> > I haven't taken a closer look at the patch yet. I was kind of waiting
> > for Dave to chime in because I'm a little confused over the back and
> > forth nature of dio/ioend completion lately.
> > 
> > My understanding is that the original requirement for ioends here was to
> > track the state necessary in order to defer (to wq) completions that had
> > to allocate transactions. Eventually, the deferred buffer state was
> > implemented and we no longer required an ioend for that, so we removed
> > the ioends here:
> > 
> >   2ba6623 xfs: don't allocate an ioend for direct I/O completions
> > 
> > Then just a couple months later, we merged the following to re-add the
> > ioend into the dio path:
> > 
> >   d5cc2e3f xfs: DIO needs an ioend for writes
> > 
> > I recall reviewing that one, but looking back afaict the ioend was used
> > simply to enable reuse of the ioend completion code. Now we have this
> > patch which presumably removes much of that code to eliminate the ioend
> > allocation overhead.
> > 
> > Neither this patch nor the previous has any technical reasoning for one
> > approach over the other in the commit logs, so afaics this appears to be
> > a matter of preference. Can we get some agreement (or discussion) on
> > what the right interface is to transfer information to dio completion?
> > E.g., is this allocation overhead noticeable? Is ioend usage problematic
> > for other reasons (such as copy-on-write)? Going back to the previous
> > patch, were there explicit reasons for using ioends aside from code
> > reuse? Note that the subsequent commit 6dfa1b67 ("xfs: handle DIO
> > overwrite EOF update completion correctly") does refer to some problems
> > not running dio completions in the right context... Dave?
> 
> I don't know the reason /for/ using ioends, but I'll share an argument in favor
> of Christoph's patch to remove them:
> 

The only thing I can gather from the historical information is that they
are used to facilitate reuse of the completion path code responsible for
unwritten conversion, inode size updates, etc. (i.e., convenience).

> Each ioend has a type code which determines what we do at the end of the IO.
> For buffered writes, we can create as many ioends as necessary to handle all
> the different dispositions of all the blocks in the range of dirty pages.
> 
> For directio, however, the requirements are a little different -- we want to be
> able to say "change all the extents in this part of the file from unwritten to
> written", and to be able to change i_size after a write.  We can reuse the
> ioend structure to encode these desires until CoW came along.  Now we also want
> to be able to say "remap all extents in this part of a file if the write
> succeeds".  Since we can only have one type code per ioend, either we have to
> hide extra offset/size fields in the ioend for this purpose, add a flags field,
> revise the code to create a bunch of ioends for each disposition type,
> unconditionally try to remap blocks for any reflink'd inode, or do what
> Christoph proposes, which is to stop (ab)using ioends and simply encode status
> flags into dio->private.
> 
> Christoph's approach seems like the easiest, since we're already provided
> with the offset and size, and both the unwritten extent conversion and the
> CoW remap code know how to iterate the data fork to look for the extents
> they want to alter.
> 
> The overhead probably goes down once we get rid of the memory allocation,
> but the primary purpose is to make life easier for CoW to avoid unnecessary
> overhead.
> 

That sounds reasonable to me, though I'd probably have to see the cow
bits to grok/appreciate the complexity avoided by killing off ioends
here. I wonder if then perhaps the right thing to do is package this
change with the associated cow bits (as a dependency) wherever/once they
are available..?

> Also: I've noticed that if I write 8MB file to a file backed by a failing
> device, xfs_end_io_direct_write() gets called with size == 8MB even if the
> writes failed.  If the write was to an unwritten extent, the extent will be
> converted to a regular extent even though the blocks contain old file contents
> and other garbage, which can subsequently be read off the disk.
> 
> For CoW I'd only want to remap the blocks if the write totally succeeds.  If a
> disk error happens, the EIO code gets passed back to userspace, and it seems
> logical to me that the file contents should remain unchanged.
> 
> To that end, I'm changing dio_iodone_t to pass an error code, and I think I
> want to change XFS to avoid doing unwritten extent conversions when the write
> fails.  Does that make sense?
> 

Yep, sounds like a fail to me.

Brian

> --D
> 
> > 
> > Brian
> > 
> > > _______________________________________________
> > > xfs mailing list
> > > xfs@oss.sgi.com
> > > http://oss.sgi.com/mailman/listinfo/xfs
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
