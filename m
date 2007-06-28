Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 13:34:35 -0700 (PDT)
Received: from mail.clusterfs.com (mail.clusterfs.com [206.168.112.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5SKYPtL017922
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 13:34:26 -0700
Date: Thu, 28 Jun 2007 16:34:25 -0400
From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 0/6][TAKE5] fallocate system call
Message-ID: <20070628203425.GB5789@schatzie.adilger.int>
References: <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070628025543.9467216f.akpm@linux-foundation.org> <20070628175757.GA1674@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070628175757.GA1674@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Jun 28, 2007  23:27 +0530, Amit K. Arora wrote:
> On Thu, Jun 28, 2007 at 02:55:43AM -0700, Andrew Morton wrote:
> > Are we all supposed to re-review the entire patchset (or at least #4 and
> > #7) again?
> 
> As I mentioned in the note above, only patches #4 and #7 were new and
> thus these needed to be reviewed. Other patches are _not_ replacements
> of any of the patches which are already part of -mm and/or in Ted's
> patch queue. They were posted again as just "placeholders" so that the
> two new patches (#4 & #7) could be reviewed. Sorry for any confusion.

The new patches are definitely a big improvement over the previous API,
and need to go in before fallocate() goes into mainline.  This last set
of changes allows the behaviour of these syscalls to accomodate the various
different semantics desired by XFS in a sensible manner instead of tying
all of the individual behaviours (time update, size update, alloc/free, etc)
into monolithic modes that will never make everyone happy.

My understanding is that you only need to grab #4 and #7 to get your tree
into get fallocate in sync with the ext4 patch queue (i.e. they are
incremental over the previous set).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
