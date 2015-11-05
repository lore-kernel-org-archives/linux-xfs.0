Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 42C547F86
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2015 17:48:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 321FA8F804B
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2015 15:48:30 -0800 (PST)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24]) by
	cuda.sgi.com with ESMTP id oqSjCadGPpgeZL19 for
	<xfs@oss.sgi.com>; Thu, 05 Nov 2015 15:48:28 -0800 (PST)
Date: Thu, 5 Nov 2015 16:48:27 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/6 V2] xfs: upfront block zeroing for DAX
Message-ID: <20151105234827.GA5771@linux.intel.com>
References: <1445225238-30413-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1445225238-30413-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: ross.zwisler@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Mon, Oct 19, 2015 at 02:27:12PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> This is an updated patch set that was first posted here:
> 
> http://oss.sgi.com/archives/xfs/2015-10/msg00006.html
> 
> I've dropped the DAX locking revert patch from it; that's on it's
> way to Linus via other channels and is essentially independent to
> this set of XFS changes.
> 
> The only real change in the XFS code between the two versions is the
> addition of XFS_TRANS_RESERVE in the DAX path in
> xfs_iomap_write_direct() to allow it to dip into the reserve block
> pool for unwritten extent conversion rather than reporting ENOSPC.
> 
> Patches are against 4.3-rc5 + XFS for-next branch.
> 
> -Dave.

Hey Dave,

I was going to start testing these, but I'm having trouble finding a baseline
where they apply cleanly.  It looks like xfs/for-next already contains v1 of
the series, and they don't seem to apply cleanly to the current
xfs/xfs-misc-fixes-for-4.4-2 nor to v4.3.  The xfs repo I'm looking at is
git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

What am I missing?

Thanks,
- Ross

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
