Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6PH7SMA015905 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 12:07:28 -0500
Subject: Re: [PATCH 02/12 v3] xfs: Remove the macro XFS_BUF_ZEROFLAGS
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110725162718.GC2434@infradead.org>
References: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722233945.14612.1955.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110724113959.GD26332@infradead.org> <1311609452.2914.23.camel@doink>
	<20110725162718.GC2434@infradead.org>
Date: Mon, 25 Jul 2011 12:07:22 -0500
Message-ID: <1311613642.2914.40.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfs@oss.sgi.com

On Mon, 2011-07-25 at 12:27 -0400, Christoph Hellwig wrote:
> On Mon, Jul 25, 2011 at 10:57:32AM -0500, Alex Elder wrote:
> > Christoph, are you suggesting that this one hunk just
> > be excluded from the series?  Or the entire patch?
> 
> There's not much more in this patch, so I would suggest dropping it
> entirely.
> 

OK.  I think the later patches may need a little massage
but I will be happy to work through that.

Chandra, here is how I plan to proceed with your series:
- Change that (void *) to a (char *) in patch [8/12]
- Drop patch [2/12] from the series, and adjust all
  of its successors in the series accordingly.
- Run the result through some test cycles
- Commit it and publish it on oss.sgi.com

I will not commit the above until I get your OK
on it, so please let me know if you have any
objection, or affirm that you have none by
responding to this message.

Separately, out of all this came a few other
suggestions, which would be great for you to
handle (or reject) if you're open to it:
- Get rid of the definition and use of xfs_buf_target_name(),
  by verifying that comparable information is already provided
  everywhere it's used.
- Eliminate all references to __psint_t and __psunsigned_t
  in the XFS code, using uintptr_t in place where it
  is absolutely necessary.
- Look into having xfs_qm_dqalloc() return ENOMEM when
  it is unable to allocate a buffer, and fix all the
  callers up the chain so they handle such a situation
  appropriately.  Right now such errors get reset.

Thanks.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
