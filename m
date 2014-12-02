Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 114EC7F57
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 19:24:56 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C83413040AA
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 17:24:52 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xUdA8pNJKJV0skgS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Dec 2014 17:24:51 -0800 (PST)
Date: Mon, 1 Dec 2014 17:24:46 -0800 (PST)
From: Sage Weil <sweil@redhat.com>
Subject: Re: file journal fadvise
In-Reply-To: <20141202003239.GP16151@dastard>
Message-ID: <alpine.DEB.2.00.1412011719070.3471@cobra.newdream.net>
References: <alpine.DEB.2.00.1411301013490.352@cobra.newdream.net>
	<CALurOm2tEV=RqN21eFJvfU1zTtJkbz2gHDCk_Ntsy4oz9iwHoA@mail.gmail.com>
	<alpine.DEB.2.00.1411301922220.352@cobra.newdream.net>
	<547CBEFA.3000204@redhat.com>
	<alpine.DEB.2.00.1412011122020.3471@cobra.newdream.net>
	<547CEC36.6070309@redhat.com> <20141201225100.GO16151@dastard>
	<alpine.DEB.2.00.1412011559200.3471@cobra.newdream.net>
	<20141202003239.GP16151@dastard>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>, =?GB2312?B?wu29qMXz?= <majianpeng@gmail.com>, mnelson@redhat.com, xfs@oss.sgi.com

On Tue, 2 Dec 2014, Dave Chinner wrote:
> On Mon, Dec 01, 2014 at 04:12:03PM -0800, Sage Weil wrote:
> > On Tue, 2 Dec 2014, Dave Chinner wrote:
> > > What behaviour are you wanting for a journal file? it sounds like
> > > you want it to behave like a wandering log: automatically allocating
> > > it's next block where-ever the previous write of any kind occurred?
> > 
> > Precisely.  Well, as long as it is adjacent to *some* other scheduled 
> > write, it would save us a seek.  The real question, I guess, is whether 
> > there is an XFS allocation mode that makes no attempt to avoid 
> > fragmentation for the file and that chooses something adjacent to other 
> > small, newly-written data during delayed allocation.
> 
> Ok, so what is the most common underlying storage you need to
> optimise for? Is it raid5/6 where a small write will trigger a
> larger RMW cycle and so proximity rather than exact adjacency
> matters, or is it raid 0/1/jbod where exact adjacency is the only
> way to avoid a seek?

The common case is a single raw disk.

> I suspect that we can play certain tricks to trigger unaligned,
> discontiguous allocation (i.e. no target allocation block), but the
> question is whether we can get determine sufficient
> allocation/writeback context to enable delayed allocation to make
> sensible "next written block" decisions.

Yeah.

> > It's a circular file, usually a few GB in site, written sequentially with 
> > a range of small to large (block-aligned) write sizes, and (for all 
> > intents and purposes) is never read.  We periodically overwrite the first 
> > block with recent start and end pointers and other metadata.
> 
> Ok, so it's just another typical WAL file. ;)

Nothing to lose sleep over if this mode doesn't already exist, but I 
expect a fair number of applications could make use of this.

FWIW, while I am already distracting you from useful things, I suspect 
(batched) aio_fsync would be a bigger win for us and probably a smaller 
investment of effort.  :)

sage

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
