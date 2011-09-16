Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8G0QpZ0238346 for <xfs@oss.sgi.com>; Thu, 15 Sep 2011 19:26:52 -0500
Received: from e5.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 80F171C18C54
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2011 17:26:51 -0700 (PDT)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145]) by
	cuda.sgi.com with ESMTP id xmDDSiEtUKkUrH3n for
	<xfs@oss.sgi.com>; Thu, 15 Sep 2011 17:26:51 -0700 (PDT)
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p8FNuApg021062
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2011 19:56:10 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p8G0PxLv349990 for <xfs@oss.sgi.com>; Thu, 15 Sep 2011 20:26:07 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p8G0PwF5025388 for <xfs@oss.sgi.com>; Thu, 15 Sep 2011 20:25:58 -0400
Date: Thu, 15 Sep 2011 17:25:57 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Stalls during writeback for mmaped I/O on XFS in 3.0
Message-ID: <20110916002557.GN11984@tux1.beaverton.ibm.com>
References: <20110915144755.GB2235@BohrerMBP.rgmadvisors.com>
	<20110915145556.GA19902@infradead.org>
	<20110915154748.GC2235@BohrerMBP.rgmadvisors.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110915154748.GC2235@BohrerMBP.rgmadvisors.com>
Reply-To: djwong@us.ibm.com
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
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Sep 15, 2011 at 10:47:48AM -0500, Shawn Bohrer wrote:
> Thanks Christoph,
> 
> On Thu, Sep 15, 2011 at 10:55:57AM -0400, Christoph Hellwig wrote:
> > On Thu, Sep 15, 2011 at 09:47:55AM -0500, Shawn Bohrer wrote:
> > > I've got a workload that is latency sensitive that writes data to a
> > > memory mapped file on XFS.  With the 3.0 kernel I'm seeing stalls of
> > > up to 100ms that occur during writeback that we did not see with older
> > > kernels.  I've traced the stalls and it looks like they are blocking
> > > on wait_on_page_writeback() introduced in
> > > d76ee18a8551e33ad7dbd55cac38bc7b094f3abb "fs: block_page_mkwrite
> > > should wait for writeback to finish"
> > > 
> > > Reading the commit description doesn't really explain to me why this
> > > change was needed.
> > 
> > It it there to avoid pages beeing modified while they are under
> > writeback, which defeats various checksumming like DIF/DIX, the iscsi
> > CRCs, or even just the RAID parity calculations.  All of these either
> > failed before, or had to work around it by copying all data was
> > written.
> 
> I'm assuming you mean software RAID here?  We do have a hardware RAID

Yes.

> controller.  Also for anything that was working around this issue
> before by copying the data, are those workarounds still in place?

I suspect iscsi and md-raid5 are still making shadow copies of data blocks
before writing them out.  However, there was no previous workaround for DIF/DIX
errors -- this ("*_page_mkwrite should wait...") patch series _is_ the fix for
DIF/DIX.  I recall that we rejected the shadow buffer approach for DIF/DIX
because allocating new pages is expensive if we do it for each disk write in
anticipation of future page writes...

> > If you don't use any of these you can remove the call and things
> > will work like they did before.
> 
> I may do this for now.
> 
> In the longer term is there any chance this could be made better?  I'm
> not an expert here so my suggestions may be naive.  Could a mechanism
> be made to check if the page needs to be checksummed and only block in

...however, one could replace that wait_on_page_writeback with some sort of
call that would duplicate the page, update each program's page table to point
to the new page, and then somehow reap the page that's under IO when the IO
completes.  That might also be complicated to implement, I don't know.  If
there aren't any free pages, then this scheme (and the one I mentioned in the
previous paragraph) will block a thread while the system tries to reclaim some
pages.

I think we also talked about a block device flag to signal that the device
requires stable page writes, which would let us turn off the waits on devices
that don't care.  That at least could defer this discussion until you encounter
one of these devices that wants stable page writes.

I'm curious, is this program writing to the mmap region while another program
is trying to fsync/fdatasync/sync dirty pages to disk?  Is that how you noticed
the jittery latency?  We'd figured that not many programs would notice the
latency unless there was something that was causing a lot of dirty page writes
concurrent to something else dirtying a lot of pages.  Clearly we failed in
your case.  Sorry. :/

That said, imagine if we revert to the pre-3.0 mechanism (or add that flag): if
we start transferring page A to the disk for writing and your program comes in
and changes A to A' before that transfer completes, then the disk will see a
data blob that is partly A and partly A', and the proportions of A/A' are
ill-defined.  I agree that ~100ms latency is not good, however. :(

What are your program's mmap write latency requirements?

> that case?  Or perhaps some mount option, madvise() flag or other hint
> from user-mode to disable this, or hint that I'm going to be touching
> that page again soon?

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
