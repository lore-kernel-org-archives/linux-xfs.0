Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1A5B97F90
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 16:56:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ECA17304067
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 14:56:31 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	4IhTUhAKQsneTFB7 for <xfs@oss.sgi.com>;
	Tue, 01 Jul 2014 14:56:29 -0700 (PDT)
Date: Wed, 2 Jul 2014 07:56:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_growfs_data_private memory leak
Message-ID: <20140701215626.GE9508@dastard>
References: <20131226230018.GJ20579@dastard>
	<A0A556BD24EC45CEADAA07870B3E6205@alyakaslap>
	<20140113030230.GF3469@dastard>
	<CAOcd+r0B-4SPjzim=68w3L8Y9FxwBD-C5HkkeO58C6t9nfgbhw@mail.gmail.com>
	<20140113204314.GJ3469@dastard>
	<CAOcd+r22FirPMHjdxQyTmXOAM72ND-t0=njK9nEmesSV5=Ec=Q@mail.gmail.com>
	<20140115014503.GQ3469@dastard>
	<CAOcd+r0R6KxmgEJNPUZ0Q5cQhsStGb=cehYE0+wKgDNU1negsA@mail.gmail.com>
	<20140119231745.GF18112@dastard>
	<4B2A412C75324EE9880358513C069476@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B2A412C75324EE9880358513C069476@alyakaslap>
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

On Tue, Jul 01, 2014 at 06:06:38PM +0300, Alex Lyakas wrote:
> Greetings,
> 
> It appears that if xfs_growfs_data_private fails during the "new AG
> headers" loop, it does not free all the per-AG structures for the
> new AGs. When XFS is unmounted later, they are not freed as well,
> because xfs_growfs_data_private did not update the "sb_agcount"
> field, so xfs_free_perag will not free them. This happens on 3.8.13,
> but looking at the latest master branch, it seems to have the same
> issue.
> 
> Code like [1] in xfs_growfs_data, seems to fix the issue.

Why not just do this in the appropriate error stack, like is
done inside xfs_initialize_perag() on error?

        for (i = oagcount; i < nagcount; i++) {
                pag = radix_tree_delete(&mp->m_perag_tree, index);
                kmem_free(pag);
        }

(though it might need RCU freeing)

When you have a fix, can you send a proper patch with a sign-off on
it?

> A follow-up question: if xfs_grows_data_private fails during the
> loop that updates all the secondary superblocks, what is the
> consequence? (I am aware that in the latest master branch, the loop
> is not broken on first error, but attempts to initialize whatever
> possible). When these secondary superblocks will get updated? Is
> there a way to force-update them? Otherwise, what can be the
> consequence of leaving them not updated?

The consequence is documented in mainline tree - if we don't update
them all, then repair will do the wrong thing.  Repair requires a
majority iof identical secondaries to determine if the primary is
correct or out of date. The old behaviour of not updating after the
first error meant that the majority were old superblocks and so at
some time in the future repair could decide your filesystem is
smaller than it really is and hence truncate away the grown section
of the filesystem. i.e. trigger catastrophic, unrecoverable data
loss.

Hence it's far better to write every seconday we can than to leave
a majority in a bad state....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
