Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 901127F3F
	for <xfs@oss.sgi.com>; Thu, 26 Dec 2013 17:00:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 11944AC003
	for <xfs@oss.sgi.com>; Thu, 26 Dec 2013 15:00:27 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	4I3BV1Au3h2P4edr for <xfs@oss.sgi.com>;
	Thu, 26 Dec 2013 15:00:26 -0800 (PST)
Date: Fri, 27 Dec 2013 10:00:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Questions about XFS discard and xfs_free_extent() code (newbie)
Message-ID: <20131226230018.GJ20579@dastard>
References: <AD612A564BB84E75B010AE37687DFC8E@alyakaslap>
	<20131218230615.GQ31386@dastard>
	<78FC295EC7FF48C987266DC48B183930@alyakaslap>
	<20131219105513.GZ31386@dastard>
	<8155F3F9D6094F40B4DA71BD561D2DE8@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8155F3F9D6094F40B4DA71BD561D2DE8@alyakaslap>
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

On Tue, Dec 24, 2013 at 08:21:50PM +0200, Alex Lyakas wrote:
> Hi Dave,
> Reading through the code some more, I see that the extent that is
> freed through xfs_free_extent() can be an XFS metadata extent as
> well.
> For example, xfs_inobt_free_block() frees a block of the AG's
> free-inode btree. Also, xfs_bmbt_free_block() frees a generic btree
> block by putting it onto the cursor's "to-be-freed" list, which will
> be dropped into the free-space btree (by xfs_free_extent) in
> xfs_bmap_finish(). If we discard such metadata block before the
> transaction is committed to the log and we crash, we might not be
> able to properly mount after reboot, is that right?

Yes. The log stores a delta of the transactional changes, and so
requires th eprevious version of the block to be intact for revoery
to take place.

> I mean it's not
> that some file's data block will show 0s to the user instead of
> before-delete data, but some XFS btree node (for example) will be
> wiped in such case. Can this happen?

Yes, it could. That's what I meant by:

[snip]

> > IOWs, issuing the discard before the transaction that frees the
> > extent is on stable storage means we are discarding user data or
                                                                  ^^
> > metadata before we've guaranteed that the extent free transaction
    ^^^^^^^^
> > is permanent and that means we violate certain guarantees with
> > respect to crash recovery...

The "or metadata" part of the above sentence.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
