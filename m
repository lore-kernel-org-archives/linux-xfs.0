Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6084F7F37
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 18:11:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E2573AC006
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 16:11:04 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	UIaTNd60UYT7cSSs for <xfs@oss.sgi.com>;
	Wed, 23 Sep 2015 16:11:01 -0700 (PDT)
Date: Thu, 24 Sep 2015 09:10:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_io: Implement inodes64 command - bug in
	XFS_IOC_FSINUMBERS?
Message-ID: <20150923231040.GS19114@dastard>
References: <1442825768-5793-1-git-send-email-cmaiolino@redhat.com>
	<20150921220832.GB19114@dastard>
	<20150922075432.GC26699@redhat.com>
	<20150922122238.GA46026@bfoster.bfoster>
	<20150922220054.GL19114@dastard> <20150923102834.GA4490@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150923102834.GA4490@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Wed, Sep 23, 2015 at 12:28:34PM +0200, Carlos Maiolino wrote:
> Howdy folks,
> 
> I was working in implementing the suggested feature in my patch, about getting
> the next inode used after one is provided, and I hit something that I'm not really
> sure if this might be considered a bug, or just a work form.
> 
> XFS_IOC_FSINUMBERS, is supposed to be called with a zeroed
> xfs_fsop_bulkreq.lastip, so at each call, kernel will update this number to the
> last inode returned, and, the next call will return in xfs_inogrp.xi_startino,
> the next existing inode after .lastip.
> 
> So, I was expecting that, passing a non-zero .lastip at the first call, I would
> be able to get the next inode right after the one I passed through .lastip, but,
> after some tests and reading the code, I noticed that this is not the case.

XFS_IOC_FSNUMBERS is not a "does this inode exist" query API - you
use the bulkstat interface for that. XFS_IOC_FSNUMBERS is for
iterating the "inode table", and it's API returns records, not
individual inodes.

Those records contain information about a chunk of inodes, not
individual inodes. The "lastino" cookie it uses always points to the
last inode in the last chunk it returns - the next iteration will
start at the chunk *after* the one that contains lastino.

Hence it is behaving as intended...

> I'm not sure if this is the desired behavior or not, but, I'd say that, if the
> inode passed in .lastip, is not the first in the chunk, the output should start
> for its own chunk, instead of the next one, but, I prefer to see you folks POV
> before starting to fix something that I'm not sure if it's actually broken :-)

It doesn't matter if it is "desired behaviour" or not, we can't
change it. If we change it we risk breaking userspace applications
that relies on it working the way it currently does. Most likely
that application will be xfsdump, and the breakage will be silent
and very hard to detect....

Perhaps reading the recent history fs/xfs/xfs_itable.c would be
instructive. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
