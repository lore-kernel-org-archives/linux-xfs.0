Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4RKUIIq162287 for <xfs@oss.sgi.com>; Thu, 27 May 2010 15:30:18 -0500
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 686CA37E115
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 13:32:41 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13]) by cuda.sgi.com with ESMTP id
	aovAkAtEce8ukktD for <xfs@oss.sgi.com>;
	Thu, 27 May 2010 13:32:41 -0700 (PDT)
Date: Thu, 27 May 2010 13:32:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] inode: Make unused inode LRU per superblock
Message-Id: <20100527133230.780be6c7.akpm@linux-foundation.org>
In-Reply-To: <1274777588-21494-2-git-send-email-david@fromorbit.com>
References: <1274777588-21494-1-git-send-email-david@fromorbit.com>
	<1274777588-21494-2-git-send-email-david@fromorbit.com>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, 25 May 2010 18:53:04 +1000
Dave Chinner <david@fromorbit.com> wrote:

> From: Dave Chinner <dchinner@redhat.com>
> 
> The inode unused list is currently a global LRU. This does not match
> the other global filesystem cache - the dentry cache - which uses
> per-superblock LRU lists. Hence we have related filesystem object
> types using different LRU reclaimatin schemes.
> 
> To enable a per-superblock filesystem cache shrinker, both of these
> caches need to have per-sb unused object LRU lists. Hence this patch
> converts the global inode LRU to per-sb LRUs.
> 
> The patch only does rudimentary per-sb propotioning in the shrinker
> infrastructure, as this gets removed when the per-sb shrinker
> callouts are introduced later on.
> 
> ...
>
> +			list_move(&inode->i_list, &inode->i_sb->s_inode_lru);

It's a shape that s_inode_lru is still protected by inode_lock.  One
day we're going to get in trouble over that lock.  Migrating to a
per-sb lock would be logical and might help.

Did you look into this?  I expect we'd end up taking both inode_lock
and the new sb->lru_lock in several places, which wouldn't be of any
help, at least in the interim.  Long-term, the locking for
fs-writeback.c should move to the per-superblock one also, at which
time this problem largely goes away I think.  Unfortunately the
writeback inode lists got moved into the backing_dev_info, whcih messes
things up a bit.

>  	inodes_stat.nr_unused--;
> +	inode->i_sb->s_nr_inodes_unused--;

It's regrettable to be counting the same thing twice.  Did you look
into removing (or no longer using) inodes_stat.nr_unused?


> +		/* Now, we reclaim unused dentrins with fairness.

May as well fix the typo while we're there.

Please review all these comments to ensure that they are still accurate
and complete.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
