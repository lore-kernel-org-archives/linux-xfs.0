Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6PMLbLm050532 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 17:21:37 -0500
Received: from e36.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C2069565E
	for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 15:21:36 -0700 (PDT)
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154]) by
	cuda.sgi.com with ESMTP id BqhwPdMlcGeN4dOO for
	<xfs@oss.sgi.com>; Mon, 25 Jul 2011 15:21:36 -0700 (PDT)
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by e36.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6PMFMG4002564
	for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 16:15:22 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6PMLa4v157276 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 16:21:36 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6PGL8GV021943
	for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 10:21:08 -0600
Subject: Re: [PATCH 02/12 v3] xfs: Remove the macro XFS_BUF_ZEROFLAGS
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1311613642.2914.40.camel@doink>
References: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722233945.14612.1955.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110724113959.GD26332@infradead.org> <1311609452.2914.23.camel@doink>
	<20110725162718.GC2434@infradead.org> <1311613642.2914.40.camel@doink>
Date: Mon, 25 Jul 2011 15:21:32 -0700
Message-ID: <1311632492.3210.988.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: aelder@sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, 2011-07-25 at 12:07 -0500, Alex Elder wrote:
> On Mon, 2011-07-25 at 12:27 -0400, Christoph Hellwig wrote:
> > On Mon, Jul 25, 2011 at 10:57:32AM -0500, Alex Elder wrote:
> > > Christoph, are you suggesting that this one hunk just
> > > be excluded from the series?  Or the entire patch?
> > 
> > There's not much more in this patch, so I would suggest dropping it
> > entirely.
> > 
> 
> OK.  I think the later patches may need a little massage
> but I will be happy to work through that.
> 
> Chandra, here is how I plan to proceed with your series:
> - Change that (void *) to a (char *) in patch [8/12]
> - Drop patch [2/12] from the series, and adjust all
>   of its successors in the series accordingly.
> - Run the result through some test cycles
> - Commit it and publish it on oss.sgi.com
> 
> I will not commit the above until I get your OK
> on it, so please let me know if you have any
> objection, or affirm that you have none by
> responding to this message.

I am fine with your direction.

chandra 
> 
> Separately, out of all this came a few other
> suggestions, which would be great for you to
> handle (or reject) if you're open to it:
> - Get rid of the definition and use of xfs_buf_target_name(),
>   by verifying that comparable information is already provided
>   everywhere it's used.
> - Eliminate all references to __psint_t and __psunsigned_t
>   in the XFS code, using uintptr_t in place where it
>   is absolutely necessary.
> - Look into having xfs_qm_dqalloc() return ENOMEM when
>   it is unable to allocate a buffer, and fix all the
>   callers up the chain so they handle such a situation
>   appropriately.  Right now such errors get reset.
> 
> Thanks.
> 
> 					-Alex
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
