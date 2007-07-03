Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Jul 2007 03:49:59 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l63AnstL014866
	for <xfs@oss.sgi.com>; Tue, 3 Jul 2007 03:49:55 -0700
Date: Tue, 3 Jul 2007 11:31:07 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070703103107.GA29763@infradead.org>
References: <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626103247.GA19870@amitarora.in.ibm.com> <20070630102111.GB23568@infradead.org> <20070630165246.GA5159@schatzie.adilger.int> <20070703100848.GA14936@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070703100848.GA14936@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, adilger@clusterfs.com, David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>

On Tue, Jul 03, 2007 at 03:38:48PM +0530, Amit K. Arora wrote:
> > FA_FL_DEALLOC		0x01 /* deallocate unwritten extent (default allocate) */
> > FA_FL_KEEP_SIZE	0x02 /* keep size for EOF {pre,de}alloc (default change size) */
> > FA_FL_DEL_DATA	0x04 /* delete existing data in alloc range (default keep) */
> 
> We now have two sets of flags - 
> 1) the above three with which I think no one has any issues with, and

Yes, I do.  FA_FL_DEL_DATA is plain stupid, a preallocation call should
never delete data.  FA_FL_DEALLOC should probably be a separate syscall
because it's very different functionality.

While we're at it I also dislike the FA_ prefix becuase it doesn't say
anything and is far too generic.  FALLOC_ is much better.

> > FA_FL_ERR_FREE	0x08 /* free preallocation on error (default keep prealloc) */

NACK on this one.  We should have just one behaviour, and from the thread
that not freeing the allocation on error.

> > FA_FL_NO_MTIME	0x10 /* keep same mtime (default change on size, data change) */
> > FA_FL_NO_CTIME	0x20 /* keep same ctime (default change on size, data change) */

NACK to these aswell.  If i_size changes c/mtime need updates, if the size
doesn't chamge they don't.  No need to add more flags for this.
