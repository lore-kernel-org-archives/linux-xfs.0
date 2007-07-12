Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jul 2007 01:26:54 -0700 (PDT)
Received: from e4.ny.us.ibm.com (e4.ny.us.ibm.com [32.97.182.144])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6C8Qjbm008493
	for <xfs@oss.sgi.com>; Thu, 12 Jul 2007 01:26:48 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6C8QlWO012806
	for <xfs@oss.sgi.com>; Thu, 12 Jul 2007 04:26:47 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6C8QmfL421530
	for <xfs@oss.sgi.com>; Thu, 12 Jul 2007 04:26:48 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6C8QlMw025171
	for <xfs@oss.sgi.com>; Thu, 12 Jul 2007 04:26:47 -0400
Date: Thu, 12 Jul 2007 13:56:50 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070712082650.GB12817@amitarora.in.ibm.com>
References: <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626103247.GA19870@amitarora.in.ibm.com> <20070630102111.GB23568@infradead.org> <20070630165246.GA5159@schatzie.adilger.int> <20070703100848.GA14936@amitarora.in.ibm.com> <20070703103107.GA29763@infradead.org> <20070703114650.GB14936@amitarora.in.ibm.com> <20070711090312.GA18301@infradead.org> <20070712072813.GA31260@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712072813.GA31260@in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, adilger@clusterfs.com, David Chinner <dgc@sgi.com>, cmm@us.ibm.com, xfs@oss.sgi.com

On Thu, Jul 12, 2007 at 12:58:13PM +0530, Suparna Bhattacharya wrote:
> On Wed, Jul 11, 2007 at 10:03:12AM +0100, Christoph Hellwig wrote:
> > On Tue, Jul 03, 2007 at 05:16:50PM +0530, Amit K. Arora wrote:
> > > Well, if you see the modes proposed using above flags :
> > > 
> > > #define FA_ALLOCATE	0
> > > #define FA_DEALLOCATE	FA_FL_DEALLOC
> > > #define FA_RESV_SPACE	FA_FL_KEEP_SIZE
> > > #define FA_UNRESV_SPACE	(FA_FL_DEALLOC | FA_FL_KEEP_SIZE | FA_FL_DEL_DATA)
> > > 
> > > FA_FL_DEL_DATA is _not_ being used for preallocation. We have two modes
> > > for preallocation FA_ALLOCATE and FA_RESV_SPACE, which do not use this
> > > flag. Hence prealloction will never delete data.
> > > This mode is required only for FA_UNRESV_SPACE, which is a deallocation
> > > mode, to support any existing XFS aware applications/usage-scenarios.
> > 
> > Sorry, but this doesn't make any sense.  There is no need to put every
> > feature in the XFS ioctls in the syscalls.  The XFS ioctls will need to
> > be supported forever anyway - as I suggested before they really should
> > be moved to generic code.
> > 
> > What needs to be supported is what makes sense as an interface.
> > A punch a hole interface does make sense, but trying to hack this into
> > a preallocation system call is just madness.  We're not IRIX or windows
> > that fit things into random subcall just because there was some space
> > left to squeeze them in.
> > 
> > > > > > FA_FL_NO_MTIME	0x10 /* keep same mtime (default change on size, data change) */
> > > > > > FA_FL_NO_CTIME	0x20 /* keep same ctime (default change on size, data change) */
> > > > 
> > > > NACK to these aswell.  If i_size changes c/mtime need updates, if the size
> > > > doesn't chamge they don't.  No need to add more flags for this.
> > > 
> > > This requirement was from the point of view of HSM applications. Hope
> > > you saw Andreas previous post and are keeping that in mind.
> > 
> > HSMs needs this basically for every system call, which screams for an
> > open flag like O_INVISIBLE anyway.  Adding this in a generic way is
> > a good idea, but hacking bits and pieces that won't fit into the global
> > design is completely wrong.
> 
> Why don't we just merge the interface for preallocation (essentially
> enough to satisfy posix_fallocate() and the simple XFS requirement for 
> space reservation without changing file size), which there is clear agreement
> on (I hope :)).  After all, this was all that we set out to do when we
> started.

As you suggest, let us just have two modes for the time being:

#define FALLOC_ALLOCATE			0x1
#define FALLOC_ALLOCATE_KEEP_SIZE	0x2

As the name suggests, when FALLOC_ALLOCATE_KEEP_SIZE mode is passed it
will result in file size not being changed even if the preallocation is
beyond EOF.

> And leave all the dealloc/punch/hsm type features for separate future patches/
> debates, those really shouldn't hold up the basic fallocate interface.

I agree.

> I agree with Christoph that we are just diverging too much in trying to
> club those decisions here.
> 
> Dave, Andreas, Ted ?
> 
> Regards
> Suparna

--
Regards,
Amit Arora
