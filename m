Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3486B7F37
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 08:59:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 20F2B8F8066
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 06:59:56 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id CQoxZtmI2lXPcEfN for <xfs@oss.sgi.com>;
	Mon, 08 Jul 2013 06:59:55 -0700 (PDT)
Date: Mon, 8 Jul 2013 15:59:53 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Some baseline tests on new hardware (was Re: [PATCH] xfs:
	optimise CIL insertion during transaction commit [RFC])
Message-ID: <20130708135953.GF5988@quack.suse.cz>
References: <1372657476-9241-1-git-send-email-david@fromorbit.com>
	<20130708124453.GC3438@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130708124453.GC3438@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Mon 08-07-13 22:44:53, Dave Chinner wrote:
<snipped some nice XFS results ;)>
> So, lets look at ext4 vs btrfs vs XFS at 16-way (this is on the
> 3.10-cil kernel I've been testing XFS on):
> 
> 	    create		 walk		unlink
> 	 time(s)   rate		time(s)		time(s)
> xfs	  222	266k+-32k	  170		  295
> ext4	  978	 54k+- 2k	  325		 2053
> btrfs	 1223	 47k+- 8k	  366		12000(*)
> 
> (*) Estimate based on a removal rate of 18.5 minutes for the first
> 4.8 million inodes.
> 
> Basically, neither btrfs or ext4 have any concurrency scaling to
> demonstrate, and unlinks on btrfs a just plain woeful.
  Thanks for posting the numbers. There isn't anyone seriously testing ext4
SMP scalability AFAIK so it's not surprising it sucks.
 
> ext4 create rate is limited by the extent cache LRU locking:
> 
> -  41.81%  [kernel]  [k] __ticket_spin_trylock
>    - __ticket_spin_trylock
>       - 60.67% _raw_spin_lock
>          - 99.60% ext4_es_lru_add
>             + 99.63% ext4_es_lookup_extent
  At least this should improve with the patches in 3.11-rc1.

>       - 39.15% do_raw_spin_lock
>          - _raw_spin_lock
>             + 95.38% ext4_es_lru_add
>               0.51% insert_inode_locked
>                  __ext4_new_inode
> -   16.20%  [kernel]  [k] native_read_tsc
>    - native_read_tsc
>       - 60.91% delay_tsc
>            __delay
>            do_raw_spin_lock
>          + _raw_spin_lock
>       - 39.09% __delay
>            do_raw_spin_lock
>          + _raw_spin_lock
> 
> Ext4 unlink is serialised on orphan list processing:
> 
> -  12.67%  [kernel]  [k] __mutex_unlock_slowpath
>    - __mutex_unlock_slowpath
>       - 99.95% mutex_unlock
>          + 54.37% ext4_orphan_del
>          + 43.26% ext4_orphan_add
> +   5.33%  [kernel]  [k] __mutex_lock_slowpath
  ext4 can do better here I'm sure. The current solution is pretty
simplistic. At least we could use spinlock for in-memory orphan list and
atomic ops for on disk one (as it's only singly linked list). But not sure
if I find time to look into this in forseeable future...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
