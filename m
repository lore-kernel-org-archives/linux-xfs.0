Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4RKUHt3162282 for <xfs@oss.sgi.com>; Thu, 27 May 2010 15:30:18 -0500
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DB35149D817
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 13:34:33 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13]) by cuda.sgi.com with ESMTP id
	5QZZSY7os4yNQlih for <xfs@oss.sgi.com>;
	Thu, 27 May 2010 13:34:33 -0700 (PDT)
Date: Thu, 27 May 2010 13:32:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/5] Per superblock shrinkers V2
Message-Id: <20100527133223.efa4740a.akpm@linux-foundation.org>
In-Reply-To: <1274777588-21494-1-git-send-email-david@fromorbit.com>
References: <1274777588-21494-1-git-send-email-david@fromorbit.com>
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

On Tue, 25 May 2010 18:53:03 +1000
Dave Chinner <david@fromorbit.com> wrote:

> This series reworks the filesystem shrinkers. We currently have a
> set of issues with the current filesystem shrinkers:
> 
>         1. There is an dependency between dentry and inode cache
>            shrinking that is only implicitly defined by the order of
>            shrinker registration.
>         2. The shrinkers need to walk the superblock list and pin
>            the superblock to avoid unmount races with the sb going
>            away.
>         3. The dentry cache uses per-superblock LRUs and proportions
>            reclaim between all the superblocks which means we are
>            doing breadth based reclaim. This means we touch every
>            superblock for every shrinker call, and may only reclaim
>            a single dentry at a time from a given superblock.
>         4. The inode cache has a global LRU, so it has different
>            reclaim patterns to the dentry cache, despite the fact
>            that the dentry cache is generally the only thing that
>            pins inodes in memory.
>         5. Filesystems need to register their own shrinkers for
>            caches and can't co-ordinate them with the dentry and
>            inode cache shrinkers.

Nice description, but...  it never actually told us what the benefit of
the changes are.  Presumably some undescribed workload had some
undescribed user-visible problem.  But what was that workload, and what
was the user-visible problem, and how does the patch affect all this?

Stuff like that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
