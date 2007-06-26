Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Jun 2007 03:32:48 -0700 (PDT)
Received: from e1.ny.us.ibm.com (e1.ny.us.ibm.com [32.97.182.141])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5QAWftL011981
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 03:32:42 -0700
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5QAWdsi006655
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 06:32:39 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5QAWdJW481796
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 06:32:39 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5QAWdiu016574
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 06:32:39 -0400
Date: Tue, 26 Jun 2007 16:02:47 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070626103247.GA19870@amitarora.in.ibm.com>
References: <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625214626.GJ5181@schatzie.adilger.int>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andreas Dilger <adilger@clusterfs.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Mon, Jun 25, 2007 at 03:46:26PM -0600, Andreas Dilger wrote:
> On Jun 25, 2007  20:33 +0530, Amit K. Arora wrote:
> > I have not implemented FA_FL_FREE_ENOSPC and FA_ZERO_SPACE flags yet, as
> > *suggested* by Andreas in http://lkml.org/lkml/2007/6/14/323  post.
> > If it is decided that these flags are also needed, I will update this
> > patch. Thanks!
> 
> Can you clarify - what is the current behaviour when ENOSPC (or some other
> error) is hit?  Does it keep the current fallocate() or does it free it?

Currently it is left on the file system implementation. In ext4, we do
not undo preallocation if some error (say, ENOSPC) is hit. Hence it may
end up with partial (pre)allocation. This is inline with dd and
posix_fallocate, which also do not free the partially allocated space.
 
> For FA_ZERO_SPACE - I'd think this would (IMHO) be the default - we
> don't want to expose uninitialized disk blocks to userspace.  I'm not
> sure if this makes sense at all.

I don't think we need to make it default - atleast for filesystems which
have a mechanism to distinguish preallocated blocks from "regular" ones.
In ext4, for example, we will have a way to mark uninitialized extents.
All the preallocated blocks will be part of these uninitialized extents.
And any read on these extents will treat them as a hole, returning
zeroes to user land. Thus any existing data on uninitialized blocks will
not be exposed to the userspace.

--
Regards,
Amit Arora 
