Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p540Q1dA043815 for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 19:26:01 -0500
Received: from ZenIV.linux.org.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 52C2F49D0D3
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2011 17:25:59 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id vZJpclwCSxtcvqJu for
	<xfs@oss.sgi.com>; Fri, 03 Jun 2011 17:25:59 -0700 (PDT)
Date: Sat, 4 Jun 2011 01:25:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 06/12] inode: Make unused inode LRU per superblock
Message-ID: <20110604002552.GU11521@ZenIV.linux.org.uk>
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
	<1306998067-27659-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1306998067-27659-7-git-send-email-david@fromorbit.com>
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

On Thu, Jun 02, 2011 at 05:01:01PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The inode unused list is currently a global LRU. This does not match
> the other global filesystem cache - the dentry cache - which uses
> per-superblock LRU lists. Hence we have related filesystem object
> types using different LRU reclaimation schemes.
> 
> To enable a per-superblock filesystem cache shrinker, both of these
> caches need to have per-sb unused object LRU lists. Hence this patch
> converts the global inode LRU to per-sb LRUs.
> 
> The patch only does rudimentary per-sb propotioning in the shrinker
> infrastructure, as this gets removed when the per-sb shrinker
> callouts are introduced later on.

What protects s_nr_inodes_unused?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
