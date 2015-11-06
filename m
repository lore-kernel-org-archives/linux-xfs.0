Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9A7747F58
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2015 16:32:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 87E5E304039
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2015 14:32:43 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	srRk4THSzkHowi81 for <xfs@oss.sgi.com>;
	Fri, 06 Nov 2015 14:32:40 -0800 (PST)
Date: Sat, 7 Nov 2015 09:32:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/6 V2] xfs: upfront block zeroing for DAX
Message-ID: <20151106223238.GT10656@dastard>
References: <1445225238-30413-1-git-send-email-david@fromorbit.com>
	<20151105234827.GA5771@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151105234827.GA5771@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: jack@suse.cz, xfs@oss.sgi.com

On Thu, Nov 05, 2015 at 04:48:27PM -0700, Ross Zwisler wrote:
> On Mon, Oct 19, 2015 at 02:27:12PM +1100, Dave Chinner wrote:
> > Hi folks,
> > 
> > This is an updated patch set that was first posted here:
> > 
> > http://oss.sgi.com/archives/xfs/2015-10/msg00006.html
> > 
> > I've dropped the DAX locking revert patch from it; that's on it's
> > way to Linus via other channels and is essentially independent to
> > this set of XFS changes.
> > 
> > The only real change in the XFS code between the two versions is the
> > addition of XFS_TRANS_RESERVE in the DAX path in
> > xfs_iomap_write_direct() to allow it to dip into the reserve block
> > pool for unwritten extent conversion rather than reporting ENOSPC.
> > 
> > Patches are against 4.3-rc5 + XFS for-next branch.
> > 
> > -Dave.
> 
> Hey Dave,
> 
> I was going to start testing these, but I'm having trouble finding a baseline
> where they apply cleanly.  It looks like xfs/for-next already contains v1 of
> the series, and they don't seem to apply cleanly to the current
> xfs/xfs-misc-fixes-for-4.4-2 nor to v4.3.  The xfs repo I'm looking at is
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

The xfs-dax-updates branch of that kernel contains the v3 version of
the patches I posted a few days ago. i.e. just pull the for-next
branch of the XFS tree, because that already contains all the
patches integrated into the rest of the XFS for-next tree...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
