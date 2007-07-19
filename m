Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 22:11:45 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6J5Babm015872
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 22:11:40 -0700
Date: Thu, 19 Jul 2007 15:10:52 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/5][TAKE8] manpage for fallocate
Message-ID: <20070719051052.GE12413810@sgi.com>
References: <20070713184125.GA12156@amitarora.in.ibm.com> <20070713184625.GB12156@amitarora.in.ibm.com> <20070719034155.GE32734@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719034155.GE32734@ca-server1.us.oracle.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, tytso@mit.edu, cmm@us.ibm.com, suparna@in.ibm.com, adilger@clusterfs.com, dgc@sgi.com, michael.kerrisk@gmx.net

On Wed, Jul 18, 2007 at 08:41:55PM -0700, Mark Fasheh wrote:
> On Sat, Jul 14, 2007 at 12:16:25AM +0530, Amit K. Arora wrote:
> > After a successful call, subsequent writes are guaranteed not to fail because
> > of lack of disk space.
>   
> If a write to an unwritten region requires a node split, that could result
> in the allocation of new meta data which obviously could fail if the disk is
> truly full.

% git-log 84e1e99f112dead8f9ba036c02d24a9f5ce7f544 |head -10
commit 84e1e99f112dead8f9ba036c02d24a9f5ce7f544
Author: David Chinner <dgc@sgi.com>
Date:   Mon Jun 18 16:50:27 2007 +1000

    [XFS] Prevent ENOSPC from aborting transactions that need to succeed

    During delayed allocation extent conversion or unwritten extent
    conversion, we need to reserve some blocks for transactions reservations.
    We need to reserve these blocks in case a btree split occurs and we need
    to allocate some blocks.

------

IOWs, XFS didn't provide this guarantee until about a month ago....

> Granted that's unlikely to happen but maybe we should be conservative and
> say something like:
> 
> "After a successful call, subsequent writes are guaranteed to never require
> allocation of file data." ?

Well, the above phrasing is taken directly from the posix_fallocate() man
page, and it is intended that sys_fallocate() is used to implement
posix_fallocate(). In that case, the semantics we have to provide are
"writes are guaranteed not to fail due to lack of disk space".

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
