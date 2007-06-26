Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Jun 2007 08:42:57 -0700 (PDT)
Received: from mail.clusterfs.com (mail.clusterfs.com [206.168.112.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5QFgotL022535
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 08:42:52 -0700
Date: Tue, 26 Jun 2007 11:42:50 -0400
From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070626154250.GD6652@schatzie.adilger.int>
References: <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625215239.GK5181@schatzie.adilger.int> <20070626104546.GB19870@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626104546.GB19870@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Jun 26, 2007  16:15 +0530, Amit K. Arora wrote:
> On Mon, Jun 25, 2007 at 03:52:39PM -0600, Andreas Dilger wrote:
> > In XFS one of the (many) ALLOC modes is to zero existing data on allocate.
> > For ext4 all this would mean is calling ext4_ext_mark_uninitialized() on
> > each extent.  For some workloads this would be much faster than truncate
> > and reallocate of all the blocks in a file.
> 
> In ext4, we already mark each extent having preallocated blocks as
> uninitialized. This is done as part of following code (which is part of
> patch 5/7) in ext4_ext_get_blocks() :  

What I meant is that with XFS_IOC_ALLOCSP the previously-written data
is ZEROED OUT, unlike with fallocate() which leaves previously-written
data alone and only allocates in holes.

So, if you had a sparse file with some data in it:

     AAAAA         BBBBBB

fallocate() would allocate the holes:

00000AAAAA000000000BBBBBB00000000

XFS_IOC_ALLOCSP would overwrite everything:

000000000000000000000000000000000

In order to specify this for allocation, FA_FL_DEL_DATA would need to make
sense for allocations (as well as the deallocation).  This is farily easy
to do - just mark all of the existing extents as unallocated, and their
data disappears.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
