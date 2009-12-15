Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBF5EMDm205538 for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 23:14:23 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8DAC9F654C
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 21:14:59 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	s4saWssALTajc4Zv for <xfs@oss.sgi.com>;
	Mon, 14 Dec 2009 21:14:59 -0800 (PST)
Received: from discord (unverified [121.44.201.81])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	10076375-1927428
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 15:44:57 +1030 (CDT)
Received: from dave by discord with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>) id 1NKPkN-0001hM-Ls
	for xfs@oss.sgi.com; Tue, 15 Dec 2009 16:14:55 +1100
Date: Tue, 15 Dec 2009 16:14:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/6] XFS: Fix growfs deadlocks and per-AG use after free V2
Message-ID: <20091215051455.GB4850@discord.disaster>
References: <1260832270-14762-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1260832270-14762-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On Tue, Dec 15, 2009 at 10:11:04AM +1100, Dave Chinner wrote:
> The use of an array for the xfs_perag structures results in growfs having
> to realocate the array. This requires exclusion to prevent use-after-free
> situations. The current locking is prone to deadlocks when growing under
> load, and the xfssyncd currently has no protection against the array being
> reallocated that can lead to panics.
> 
> This series abstracts the per-ag structure access and then removes the array
> to replace it with individual xfs_perag structures indexed by a radix tree.
> The only locking required is for the radix tree, hence the deadlocks go away
> as the tree lock is always the innermost lock. The use after frees go away
> as well as growfs does not need to reallocate structures fo pre-existing
> allocation groups - it only needs to allocate the structures for the new
> AGs and insert them into the tree.
> 
> This series also adds reference counting to the xfs-perag structure to
> ensure that we balance get/put accesses to the structures and provide the
> infrastructure to determine if the structure is in use or not.
> 
> Version 2: Fix review comments from Christoph.

This series needs updating after the trace patches were merged. I'll
post it again soon...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
