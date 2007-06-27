Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Jun 2007 20:49:23 -0700 (PDT)
Received: from mail.clusterfs.com (mail.clusterfs.com [206.168.112.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5R3nGtL029177
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 20:49:17 -0700
Date: Tue, 26 Jun 2007 23:49:15 -0400
From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070627034915.GR6652@schatzie.adilger.int>
References: <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626231431.GO31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626231431.GO31489@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Jun 27, 2007  09:14 +1000, David Chinner wrote:
> Someone on the XFs list had an interesting request - preallocated
> swap files. You can't use unwritten extents for this because
> of sys_swapon()s use of bmap() (XFS returns holes for reading
> unwritten extents), so we need a method of preallocating that does
> not zero or mark the extent unread. i.e. FA_MKSWAP.

Is there a reason why unwritten extents return 0 to bmap()?  This
would seem to be the only impediment from using fallocated files
for swap files.  Maybe if FIEMAP was used by mkswap to get an
"UNWRITTEN" flag back instead of "HOLE" it wouldn't be a problem.

> That way we can allocate large swap files that don't need zeroing
> in a single, fast operation, and hence potentially bring new
> swap space online without needed very much memory at all (i.e.
> should succeed in most near-OOM conditions).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
