Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 May 2007 04:56:27 -0700 (PDT)
Received: from e1.ny.us.ibm.com (e1.ny.us.ibm.com [32.97.182.141])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4ABuKfB026834
	for <xfs@oss.sgi.com>; Thu, 10 May 2007 04:56:21 -0700
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4ABuGoC001834
	for <xfs@oss.sgi.com>; Thu, 10 May 2007 07:56:16 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4ABuGkY522062
	for <xfs@oss.sgi.com>; Thu, 10 May 2007 07:56:16 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4ABuFsC021127
	for <xfs@oss.sgi.com>; Thu, 10 May 2007 07:56:16 -0400
Date: Thu, 10 May 2007 17:26:20 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Message-ID: <20070510115620.GB21400@amitarora.in.ibm.com>
References: <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426180332.GA7209@amitarora.in.ibm.com> <20070509160102.GA30745@amitarora.in.ibm.com> <20070510005926.GT85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510005926.GT85884050@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Thu, May 10, 2007 at 10:59:26AM +1000, David Chinner wrote:
> On Wed, May 09, 2007 at 09:31:02PM +0530, Amit K. Arora wrote:
> > I have the updated patches ready which take care of Andrew's comments.
> > Will run some tests and post them soon.
> > 
> > But, before submitting these patches, I think it will be better to finalize
> > on certain things which might be worth some discussion here:
> > 
> > 1) Should the file size change when preallocation is done beyond EOF ?
> >    - Andreas and Chris Wedgwood are in favor of not changing the
> >      file size in this case. I also tend to agree with them. Does anyone
> >      has an argument in favor of changing the filesize ?
> >      If not, I will remove the code which changes the filesize, before I
> >      resubmit the concerned ext4 patch.
> 
> I think there needs to be both. If we don't have a mechanism to
> atomically change the file size with the preallocation, then
> applications that use stat() to work out if they need to preallocate
> more space will end up racing.

By "both" above, do you mean we should give user the flexibility if it
wants the filesize changed or not ? It can be done by having *two* modes
for preallocation in the system call - say FA_PREALLOCATE and
FA_ALLOCATE. If we use FA_PREALLOCATE mode, fallocate() will allocate
blocks, but will not change the filesize and [cm]time. If FA_ALLOCATE
mode is used, fallocate() will change the filesize if required (i.e.
when allocation is beyond EOF) and also update [cm]time.
This way, the application can decide what it wants.

This will be helpfull for the partial allocation scenario also. Think of
the case when we do not change the filesize in fallocate() and expect
applications/posix_fallocate() to do ftruncate() after fallocate() for
this. Now if fallocate() results in a partial allocation with -ENOSPC
error returned, applications/posix_fallocate() will not know for what
length ftruncate() has to be called.  :(

Hence it may be a good idea to give user the flexibility if it wants to
atomically change the file size with preallocation or not. But, with
more flexibility there comes inconsistency in behavior, which is worth
considering.

> 
> > 2) For FA_UNALLOCATE mode, should the file system allow unallocation
> >    of normal (non-preallocated) blocks (blocks allocated via
> >    regular write/truncate operations) also (i.e. work as punch()) ?
> 
> Yes. That is the current XFS implementation for XFS_IOC_UNRESVSP, and
> what i did for FA_UNALLOCATE as well.

Ok. But, some people may not expect/like this. I think, we can keep it
on the backburner for a while, till other issues are sorted out.
 
> >    - Though FA_UNALLOCATE mode is yet to be implemented on ext4, still
> >      we need to finalize on the convention here as a general guideline
> >      to all the filesystems that implement fallocate.
> > 
> > 3) If above is true, the file size will need to be changed
> >    for "unallocation" when block holding the EOF gets unallocated.
> 
> No - we punch a hole. If you want the filesize to change, then
> you use ftruncate() to remove the blocks at EOF and change the
> file size atomically.

Ok.
> 
> > 4) Should we update mtime & ctime on a successfull allocation/
> >    unallocation ?
> >    - David Chinner raised this question in following post:
> >      http://lkml.org/lkml/2007/4/29/407
> >      I think it makes sense to update the [mc]time for a successfull
> >      preallocation/unallocation. Does anyone feel otherwise ?
> >      It will be interesting to know how XFS behaves currently. Does XFS
> >      update [mc]time for preallocation ?
> 
> No, XFS does *not* update a/m/ctime on prealloc/punch unless the file size
> changes. If the filesize changes, it behaves exactly the same way that
> ftruncate() behaves.

Having additional mode (of FA_PREALLOCATE) might help here too. Please
see above.

--
Regards,
Amit Arora
