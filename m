Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Jul 2007 04:46:54 -0700 (PDT)
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l63BkmtL001992
	for <xfs@oss.sgi.com>; Tue, 3 Jul 2007 04:46:49 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l63Bkmiw019193
	for <xfs@oss.sgi.com>; Tue, 3 Jul 2007 07:46:48 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l63BkkRQ240090
	for <xfs@oss.sgi.com>; Tue, 3 Jul 2007 05:46:48 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l63Bkk7j005778
	for <xfs@oss.sgi.com>; Tue, 3 Jul 2007 05:46:46 -0600
Date: Tue, 3 Jul 2007 17:16:50 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070703114650.GB14936@amitarora.in.ibm.com>
References: <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626103247.GA19870@amitarora.in.ibm.com> <20070630102111.GB23568@infradead.org> <20070630165246.GA5159@schatzie.adilger.int> <20070703100848.GA14936@amitarora.in.ibm.com> <20070703103107.GA29763@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070703103107.GA29763@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, adilger@clusterfs.com, David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Tue, Jul 03, 2007 at 11:31:07AM +0100, Christoph Hellwig wrote:
> On Tue, Jul 03, 2007 at 03:38:48PM +0530, Amit K. Arora wrote:
> > > FA_FL_DEALLOC		0x01 /* deallocate unwritten extent (default allocate) */
> > > FA_FL_KEEP_SIZE	0x02 /* keep size for EOF {pre,de}alloc (default change size) */
> > > FA_FL_DEL_DATA	0x04 /* delete existing data in alloc range (default keep) */
> > 
> > We now have two sets of flags - 
> > 1) the above three with which I think no one has any issues with, and
> 
> Yes, I do.  FA_FL_DEL_DATA is plain stupid, a preallocation call should
> never delete data.  FA_FL_DEALLOC should probably be a separate syscall
> because it's very different functionality.

Well, if you see the modes proposed using above flags :

#define FA_ALLOCATE	0
#define FA_DEALLOCATE	FA_FL_DEALLOC
#define FA_RESV_SPACE	FA_FL_KEEP_SIZE
#define FA_UNRESV_SPACE	(FA_FL_DEALLOC | FA_FL_KEEP_SIZE | FA_FL_DEL_DATA)

FA_FL_DEL_DATA is _not_ being used for preallocation. We have two modes
for preallocation FA_ALLOCATE and FA_RESV_SPACE, which do not use this
flag. Hence prealloction will never delete data.
This mode is required only for FA_UNRESV_SPACE, which is a deallocation
mode, to support any existing XFS aware applications/usage-scenarios.

And, regarding FA_FL_DEALLOC being a separate syscall - I think then the
very purpose of @mode argument is not justified. We have this mode so
that we can provide more features like this. That said, I don't say that
we should make things very complicated; but, atleast we should provide
some basic features which we expect most of the applications wanting
preallocation to use. To start with, we need to cater to already
existing applications/user base who use XFS preallocation feature.

And further advanced features, like goal based preallocation, can be
implemented as a separate syscall.

> While we're at it I also dislike the FA_ prefix becuase it doesn't say
> anything and is far too generic.  FALLOC_ is much better.

Ok. This can be changed in the next take.
 
> > > FA_FL_ERR_FREE	0x08 /* free preallocation on error (default keep prealloc) */
> 
> NACK on this one.  We should have just one behaviour, and from the thread
> that not freeing the allocation on error.

I agree on this one. 
 
> > > FA_FL_NO_MTIME	0x10 /* keep same mtime (default change on size, data change) */
> > > FA_FL_NO_CTIME	0x20 /* keep same ctime (default change on size, data change) */
> 
> NACK to these aswell.  If i_size changes c/mtime need updates, if the size
> doesn't chamge they don't.  No need to add more flags for this.

This requirement was from the point of view of HSM applications. Hope
you saw Andreas previous post and are keeping that in mind.

--
Regards,
Amit Arora
