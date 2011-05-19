Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4J026ps004412 for <xfs@oss.sgi.com>; Wed, 18 May 2011 19:02:06 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D26E1129E0A4
	for <xfs@oss.sgi.com>; Wed, 18 May 2011 17:02:05 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	stGR0AOGJxCYzjHS for <xfs@oss.sgi.com>;
	Wed, 18 May 2011 17:02:05 -0700 (PDT)
Date: Thu, 19 May 2011 10:02:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests - SCRATCH_DIR mounted/unmounted twice when testing nfs
Message-ID: <20110519000202.GC32466@dastard>
References: <1305722498.25226.110.camel@dhcp-31-190.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1305722498.25226.110.camel@dhcp-31-190.brq.redhat.com>
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
To: Boris Ranto <branto@redhat.com>
Cc: xfs <xfs@oss.sgi.com>

On Wed, May 18, 2011 at 12:41:38PM +0000, Boris Ranto wrote:
> Tests 124, 127 and 128 unmount their SCRATCH_DEV manually while using _cleanup_testdir in trapped cleanup function.
> This can lead to test fails due to double unmount on nfs where _cleanup_testdir unmounts SCRATCH_DEV.
> 
> Tests 129 and 130 use _setup_testdir and _scratch_mount that can lead to double mount on nfs where _setup_testdir mounts SCRATCH_DEV.
> 
> The least invasive patch (only nfs shall be affected by this patch) I could come up with that fixed this issue used conditional umounts in _cleanup_testdir and conditional mount/remount in _scratch_mount (remount was used so that mount flags do not get lost).
> 
>From the code:

#
# Warning for UDF and NFS:
# this function calls _setup_udf_scratchdir and _setup_udf_scratchdir
# which actually uses the scratch dir for the test dir.
#
# This was done because testdir was intended to be a persistent
# XFS only partition.  This should eventually change, and treat
# at least local filesystems all the same.
#

I think that this means that the way _setup_testdir uses the scratch
device was a nasty hack and was intended to be fixed at some point.
Perhaps we should actually understand the issue that lead to this
hack first, and then determine what is needed to fix it rather than
just layering more hacks on top of it?

> Alternatively, _setup_testdir could stop mounting SCRATCH_DEV but
> that would be probably too invasive.

I don't really care about how invasive fixing the problem
properly is if it's the better long term solution....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
