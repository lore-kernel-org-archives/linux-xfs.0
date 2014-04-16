Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 056C67F37
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 01:18:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C5A718F8039
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 23:18:38 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	LE1ExLfccMlWi5LA for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 23:18:35 -0700 (PDT)
Date: Wed, 16 Apr 2014 16:18:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 19/19] XFS: set PF_FSTRANS while ilock is held in
	xfs_free_eofblocks
Message-ID: <20140416061819.GF15995@dastard>
References: <20140416033623.10604.69237.stgit@notabene.brown>
	<20140416040337.10604.7488.stgit@notabene.brown>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140416040337.10604.7488.stgit@notabene.brown>
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
To: NeilBrown <neilb@suse.de>
Cc: linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Apr 16, 2014 at 02:03:37PM +1000, NeilBrown wrote:
> memory allocates can happen while the xfs ilock is held in
> xfs_free_eofblocks, particularly
> 
>   [<ffffffff813e6667>] kmem_zone_alloc+0x67/0xc0
>   [<ffffffff813e5945>] xfs_trans_add_item+0x25/0x50
>   [<ffffffff8143d64c>] xfs_trans_ijoin+0x2c/0x60
>   [<ffffffff8142275e>] xfs_itruncate_extents+0xbe/0x400
>   [<ffffffff813c72f4>] xfs_free_eofblocks+0x1c4/0x240
> 
> So set PF_FSTRANS to avoid this causing a deadlock.

Another "You broke KM_NOFS" moment. You win a Kit Kat. ;)

xfs_trans_add_item():

	lidp = kmem_zone_zalloc(xfs_log_item_desc_zone, KM_SLEEP | KM_NOFS);

KM_NOFS needs to work, otherwise XFS is just a huge steaming pile of
memory reclaim deadlocks regardless of whether you are using
loopback NFS or not.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
