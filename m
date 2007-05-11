Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 May 2007 04:01:44 -0700 (PDT)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4BB1bfB020236
	for <xfs@oss.sgi.com>; Fri, 11 May 2007 04:01:39 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4BB1ak9030146
	for <xfs@oss.sgi.com>; Fri, 11 May 2007 07:01:36 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4BB1aIw544592
	for <xfs@oss.sgi.com>; Fri, 11 May 2007 07:01:36 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4BB1ZDE031697
	for <xfs@oss.sgi.com>; Fri, 11 May 2007 07:01:36 -0400
Date: Fri, 11 May 2007 16:33:01 +0530
From: Suparna Bhattacharya <suparna@in.ibm.com>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Message-ID: <20070511110301.GB28425@in.ibm.com>
Reply-To: suparna@in.ibm.com
References: <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426180332.GA7209@amitarora.in.ibm.com> <20070509160102.GA30745@amitarora.in.ibm.com> <20070510005926.GT85884050@sgi.com> <20070510115620.GB21400@amitarora.in.ibm.com> <20070510223950.GD86004887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510223950.GD86004887@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com

On Fri, May 11, 2007 at 08:39:50AM +1000, David Chinner wrote:
> On Thu, May 10, 2007 at 05:26:20PM +0530, Amit K. Arora wrote:
> > On Thu, May 10, 2007 at 10:59:26AM +1000, David Chinner wrote:
> > > On Wed, May 09, 2007 at 09:31:02PM +0530, Amit K. Arora wrote:
> > > > I have the updated patches ready which take care of Andrew's comments.
> > > > Will run some tests and post them soon.
> > > > 
> > > > But, before submitting these patches, I think it will be better to
> > > > finalize on certain things which might be worth some discussion here:
> > > > 
> > > > 1) Should the file size change when preallocation is done beyond EOF ?
> > > > - Andreas and Chris Wedgwood are in favor of not changing the file size
> > > > in this case. I also tend to agree with them. Does anyone has an
> > > > argument in favor of changing the filesize ?  If not, I will remove the
> > > > code which changes the filesize, before I resubmit the concerned ext4
> > > > patch.
> > > 
> > > I think there needs to be both. If we don't have a mechanism to atomically
> > > change the file size with the preallocation, then applications that use
> > > stat() to work out if they need to preallocate more space will end up
> > > racing.
> > 
> > By "both" above, do you mean we should give user the flexibility if it wants
> > the filesize changed or not ? It can be done by having *two* modes for
> > preallocation in the system call - say FA_PREALLOCATE and FA_ALLOCATE. If we
> > use FA_PREALLOCATE mode, fallocate() will allocate blocks, but will not
> > change the filesize and [cm]time. If FA_ALLOCATE mode is used, fallocate()
> > will change the filesize if required (i.e.  when allocation is beyond EOF)
> > and also update [cm]time.  This way, the application can decide what it
> > wants.
> 
> Yes, that's right.
> 
> > This will be helpfull for the partial allocation scenario also. Think of the
> > case when we do not change the filesize in fallocate() and expect
> > applications/posix_fallocate() to do ftruncate() after fallocate() for this.
> > Now if fallocate() results in a partial allocation with -ENOSPC error
> > returned, applications/posix_fallocate() will not know for what length
> > ftruncate() has to be called.  :(
> 
> Well, posix_fallocate() either gets all the space or it fails. If
> you truncate to extend the file size after an ENOSPC, then that is
> a buggy implementation.
> 
> The same could be said for any application, or even the fallocate()
> call itself if it changes the filesize without having completely
> preallocated the space asked....
> 
> > Hence it may be a good idea to give user the flexibility if it wants to
> > atomically change the file size with preallocation or not. But, with more
> > flexibility there comes inconsistency in behavior, which is worth
> > considering.
> 
> We've got different modes to specify different behaviour. That's
> what the mode field was put there for in the first place - the
> interface is *designed* to support different preallocation
> behaviours....
> 
> > > > 2) For FA_UNALLOCATE mode, should the file system allow unallocation of
> > > > normal (non-preallocated) blocks (blocks allocated via regular
> > > > write/truncate operations) also (i.e. work as punch()) ?
> > > 
> > > Yes. That is the current XFS implementation for XFS_IOC_UNRESVSP, and what
> > > i did for FA_UNALLOCATE as well.
> > 
> > Ok. But, some people may not expect/like this. I think, we can keep it on
> > the backburner for a while, till other issues are sorted out.
> 
> How can it be a "backburner" issue when it defines the
> implementation?  I've already implemented some thing in XFS that
> sort of does what I think that the interface is supposed to do, but
> I need that interface to be nailed down before proceeding any
> further.
> 
> All I'm really interested in right now is that the fallocate
> _interface_ can be used as a *complete replacement* for the
> pre-existing XFS-specific ioctls that are already used by
> applications.  What ext4 can or can't do right now is irrelevant to
> this discussion - the interface definition needs to take priority
> over implementation....

Would you like to write up an interface definition description (likely
man page) and post it for review, possibly with a mention of apps using
it today ?

One reason for introducing the mode parameter was to allow the interface to
evolve incrementally as more options / semantic questions are proposed, so
that we don't have to make all the decisions right now. 
So it would be good to start with a *minimal* definition, even just one mode.
The rest could follow as subsequent patches, each being reviewed and debated
separately. Otherwise this discussion can drag on for a long time.

Regards
Suparna

> 
> Cheers,
> 
> Dave,
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India
