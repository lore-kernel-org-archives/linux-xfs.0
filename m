Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5D9207F3F
	for <xfs@oss.sgi.com>; Thu, 19 Dec 2013 04:55:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3CA7C304075
	for <xfs@oss.sgi.com>; Thu, 19 Dec 2013 02:55:19 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	hye3D8APnzTGVsSj for <xfs@oss.sgi.com>;
	Thu, 19 Dec 2013 02:55:17 -0800 (PST)
Date: Thu, 19 Dec 2013 21:55:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Questions about XFS discard and xfs_free_extent() code (newbie)
Message-ID: <20131219105513.GZ31386@dastard>
References: <AD612A564BB84E75B010AE37687DFC8E@alyakaslap>
	<20131218230615.GQ31386@dastard>
	<78FC295EC7FF48C987266DC48B183930@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <78FC295EC7FF48C987266DC48B183930@alyakaslap>
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
To: Alex Lyakas <alex@zadarastorage.com>
Cc: xfs@oss.sgi.com

On Thu, Dec 19, 2013 at 11:24:15AM +0200, Alex Lyakas wrote:
> Hi Dave,
> Thank you for your comments.
> I realize now that what I proposed cannot be done; I need to
> understand deeper how XFS transactions work (unfortunately, the
> awesome "XFS Filesystem Structure" doc has a TODO in the "Journaling
> Log" section).
> 
> Can you please comment on one more question:
> Let's say we had such fully asynchronous "fire-and-forget" discard
> operation (I can implement one myself for my block-device via a
> custom IOCTL). What is wrong if we trigger such operation in
> xfs_free_ag_extent(), right after we have merged the freed extent
> into a bigger one? I understand that the extent-free-intent is not
> yet committed to the log at this point. But from the user's point of
> view, the extent has been deleted, no? So if the underlying block
> device discards the merged extent right away, before committing to
> the log, what issues this can cause?

Think of what happens when a crash occurs immediately after the
discard completes. The freeing of the extent never made it to th
elog, so after recovery, the file still exists and the user can
access it. Except that it's contents are now all different to
before the crash occurred.

IOWs, issuing the discard before the transaction that frees the
extent is on stable storage means we are discarding user data or
metadata before we've guaranteed that the extent free transaction
is permanent and that means we violate certain guarantees with
respect to crash recovery...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
