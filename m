Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Jun 2007 08:34:21 -0700 (PDT)
Received: from mail.clusterfs.com (mail.clusterfs.com [206.168.112.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5QFYEtL019761
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 08:34:15 -0700
Date: Tue, 26 Jun 2007 11:34:13 -0400
From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070626153413.GC6652@schatzie.adilger.int>
References: <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626103247.GA19870@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626103247.GA19870@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Jun 26, 2007  16:02 +0530, Amit K. Arora wrote:
> On Mon, Jun 25, 2007 at 03:46:26PM -0600, Andreas Dilger wrote:
> > Can you clarify - what is the current behaviour when ENOSPC (or some other
> > error) is hit?  Does it keep the current fallocate() or does it free it?
> 
> Currently it is left on the file system implementation. In ext4, we do
> not undo preallocation if some error (say, ENOSPC) is hit. Hence it may
> end up with partial (pre)allocation. This is inline with dd and
> posix_fallocate, which also do not free the partially allocated space.

Since I believe the XFS allocation ioctls do it the opposite way (free
preallocated space on error) this should be encoded into the flags.
Having it "filesystem dependent" just means that nobody will be happy.

> > For FA_ZERO_SPACE - I'd think this would (IMHO) be the default - we
> > don't want to expose uninitialized disk blocks to userspace.  I'm not
> > sure if this makes sense at all.
> 
> I don't think we need to make it default - atleast for filesystems which
> have a mechanism to distinguish preallocated blocks from "regular" ones.

What I mean is that any data read from the file should have the "appearance"
of being zeroed (whether zeroes are actually written to disk or not).  What
I _think_ David is proposing is to allow fallocate() to return without
marking the blocks even "uninitialized" and subsequent reads would return
the old data from the disk.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
