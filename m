Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oANLBOuW008972 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 15:11:24 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F9711C6BA58
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 13:13:00 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	VLg6dJha2sTZc1Ni for <xfs@oss.sgi.com>;
	Tue, 23 Nov 2010 13:13:00 -0800 (PST)
Date: Wed, 24 Nov 2010 08:12:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS reclaim lock order bug
Message-ID: <20101123211258.GY22876@dastard>
References: <20101123121802.GA4785@amd>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101123121802.GA4785@amd>
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
To: Nick Piggin <npiggin@kernel.dk>
Cc: xfs@oss.sgi.com

On Tue, Nov 23, 2010 at 11:18:02PM +1100, Nick Piggin wrote:
> Hi,
> 
> IIRC I've reported this before. Perhaps it is a false positive, but even
> so it is still annoying that it triggers and turns off lockdep for
> subsequent debugging.
> 
> Any chance it can get fixed or properly annotated?

It is supposed to be handled by the re-initialisation of the
ip->i_iolock in ->evict_inode (xfs_fs_evict_inode). An inode found
in the reclaim state must have passed through this reinitialisation,
so from a lockdep perspective the iolock in the vfs path is a
different context to the iolock in the reclaim path. That fixed all
the non-reclaim state related lockdep false positives, so Perhaps
there is an issue with the lockdep reclaim state checking that does
not interact well with re-initialised lock contexts?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
