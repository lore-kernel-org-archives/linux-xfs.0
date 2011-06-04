Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p541eSrd046000 for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 20:40:29 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 887E0B4B43E
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2011 18:40:26 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	wrvs5l6AEuJGowxi for <xfs@oss.sgi.com>;
	Fri, 03 Jun 2011 18:40:26 -0700 (PDT)
Date: Sat, 4 Jun 2011 11:40:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/12] inode: Make unused inode LRU per superblock
Message-ID: <20110604014013.GC561@dastard>
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
	<1306998067-27659-7-git-send-email-david@fromorbit.com>
	<20110604002552.GU11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110604002552.GU11521@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sat, Jun 04, 2011 at 01:25:52AM +0100, Al Viro wrote:
> On Thu, Jun 02, 2011 at 05:01:01PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The inode unused list is currently a global LRU. This does not match
> > the other global filesystem cache - the dentry cache - which uses
> > per-superblock LRU lists. Hence we have related filesystem object
> > types using different LRU reclaimation schemes.
> > 
> > To enable a per-superblock filesystem cache shrinker, both of these
> > caches need to have per-sb unused object LRU lists. Hence this patch
> > converts the global inode LRU to per-sb LRUs.
> > 
> > The patch only does rudimentary per-sb propotioning in the shrinker
> > infrastructure, as this gets removed when the per-sb shrinker
> > callouts are introduced later on.
> 
> What protects s_nr_inodes_unused?

For this patch, the modifications are protected by the
inode_lru_lock, but the reads are unprotected. That's the same
protection as the inode_stat.nr_unused field, and the same as the
existing dentry cache per-sb LRU accounting.  In the next patch
modifcations are moved under the sb->s_inode_lru_lock, but reads
still remain unprotected.

I can see how the multiple reads in shrink_icache_sb() could each
return a different value during the proportioning, but I don't think
that is a big problem. That proportioning code goes away in the next
patch and is replaced by different code in prune_super(), so if you
want the reads protected by locks or a single snapshot used for the
proportioning calculations I'll do it in the new code in
prune_super().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
