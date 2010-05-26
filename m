Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4QGFEKn086774 for <xfs@oss.sgi.com>; Wed, 26 May 2010 11:15:15 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47D84157A40B
	for <xfs@oss.sgi.com>; Wed, 26 May 2010 09:19:23 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id 9TzHo5CggZc2HnNZ for <xfs@oss.sgi.com>;
	Wed, 26 May 2010 09:19:23 -0700 (PDT)
Date: Thu, 27 May 2010 02:17:33 +1000
From: Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 1/5] inode: Make unused inode LRU per superblock
Message-ID: <20100526161732.GC22536@laptop>
References: <1274777588-21494-1-git-send-email-david@fromorbit.com>
	<1274777588-21494-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1274777588-21494-2-git-send-email-david@fromorbit.com>
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

On Tue, May 25, 2010 at 06:53:04PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The inode unused list is currently a global LRU. This does not match
> the other global filesystem cache - the dentry cache - which uses
> per-superblock LRU lists. Hence we have related filesystem object
> types using different LRU reclaimatin schemes.

Is this an improvement I wonder? The dcache is using per sb lists
because it specifically requires sb traversal.

What allocation/reclaim really wants (for good scalability and NUMA
characteristics) is per-zone lists for these things. It's easy to
convert a single list into per-zone lists.

It is much harder to convert per-sb lists into per-sb x per-zone lists.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
