Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Jul 2007 02:13:57 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6B9Dqbm000829
	for <xfs@oss.sgi.com>; Wed, 11 Jul 2007 02:13:53 -0700
Date: Wed, 11 Jul 2007 10:03:12 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070711090312.GA18301@infradead.org>
References: <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626103247.GA19870@amitarora.in.ibm.com> <20070630102111.GB23568@infradead.org> <20070630165246.GA5159@schatzie.adilger.int> <20070703100848.GA14936@amitarora.in.ibm.com> <20070703103107.GA29763@infradead.org> <20070703114650.GB14936@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070703114650.GB14936@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, adilger@clusterfs.com, David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Tue, Jul 03, 2007 at 05:16:50PM +0530, Amit K. Arora wrote:
> Well, if you see the modes proposed using above flags :
> 
> #define FA_ALLOCATE	0
> #define FA_DEALLOCATE	FA_FL_DEALLOC
> #define FA_RESV_SPACE	FA_FL_KEEP_SIZE
> #define FA_UNRESV_SPACE	(FA_FL_DEALLOC | FA_FL_KEEP_SIZE | FA_FL_DEL_DATA)
> 
> FA_FL_DEL_DATA is _not_ being used for preallocation. We have two modes
> for preallocation FA_ALLOCATE and FA_RESV_SPACE, which do not use this
> flag. Hence prealloction will never delete data.
> This mode is required only for FA_UNRESV_SPACE, which is a deallocation
> mode, to support any existing XFS aware applications/usage-scenarios.

Sorry, but this doesn't make any sense.  There is no need to put every
feature in the XFS ioctls in the syscalls.  The XFS ioctls will need to
be supported forever anyway - as I suggested before they really should
be moved to generic code.

What needs to be supported is what makes sense as an interface.
A punch a hole interface does make sense, but trying to hack this into
a preallocation system call is just madness.  We're not IRIX or windows
that fit things into random subcall just because there was some space
left to squeeze them in.

> > > > FA_FL_NO_MTIME	0x10 /* keep same mtime (default change on size, data change) */
> > > > FA_FL_NO_CTIME	0x20 /* keep same ctime (default change on size, data change) */
> > 
> > NACK to these aswell.  If i_size changes c/mtime need updates, if the size
> > doesn't chamge they don't.  No need to add more flags for this.
> 
> This requirement was from the point of view of HSM applications. Hope
> you saw Andreas previous post and are keeping that in mind.

HSMs needs this basically for every system call, which screams for an
open flag like O_INVISIBLE anyway.  Adding this in a generic way is
a good idea, but hacking bits and pieces that won't fit into the global
design is completely wrong.
