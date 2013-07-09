Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 76EE57F78
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 19:24:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 607D9304064
	for <xfs@oss.sgi.com>; Mon,  8 Jul 2013 17:24:53 -0700 (PDT)
Received: from mail-pd0-f180.google.com (mail-pd0-f180.google.com
	[209.85.192.180]) by cuda.sgi.com with ESMTP id
	N9YD4HBV2Q1eiVFz (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 08 Jul 2013 17:24:52 -0700 (PDT)
Received: by mail-pd0-f180.google.com with SMTP id 10so4600592pdi.25
	for <xfs@oss.sgi.com>; Mon, 08 Jul 2013 17:24:51 -0700 (PDT)
Date: Tue, 9 Jul 2013 08:43:32 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Some baseline tests on new hardware (was Re: [PATCH] xfs:
	optimise CIL insertion during transaction commit [RFC])
Message-ID: <20130709004332.GB23174@gmail.com>
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

Hi Dave,

On Mon, Jul 08, 2013 at 10:44:53PM +1000, Dave Chinner wrote:
[...]
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
> 
> ext4 create rate is limited by the extent cache LRU locking:

I have a patch to fix this problem and the patch has been applied into
3.11-rc1.  The patch is (d3922a77):
  ext4: improve extent cache shrink mechanism to avoid to burn CPU time

I do really appreicate that if you could try your testing again against
this patch.  I just want to make sure that this problem has been fixed.
At least in my own testing it looks fine.

Thanks,
                                                - Zheng

> 
> -  41.81%  [kernel]  [k] __ticket_spin_trylock
>    - __ticket_spin_trylock
>       - 60.67% _raw_spin_lock
>          - 99.60% ext4_es_lru_add
>             + 99.63% ext4_es_lookup_extent
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
> 
> 
> btrfs create has tree lock problems:
> 
> -  21.68%  [kernel]  [k] __write_lock_failed
>    - __write_lock_failed
>       - 99.93% do_raw_write_lock
>          - _raw_write_lock
>             - 79.04% btrfs_try_tree_write_lock
>                - btrfs_search_slot
>                   - 97.48% btrfs_insert_empty_items
>                        99.82% btrfs_new_inode
>                   + 2.52% btrfs_lookup_inode
>             - 20.37% btrfs_tree_lock
>                - 99.38% btrfs_search_slot
>                     99.92% btrfs_insert_empty_items
>                  0.52% btrfs_lock_root_node
>                     btrfs_search_slot
>                     btrfs_insert_empty_items
> -  21.24%  [kernel]  [k] _raw_spin_unlock_irqrestore
>    - _raw_spin_unlock_irqrestore
>       - 61.22% prepare_to_wait
>          + 61.52% btrfs_tree_lock
>          + 32.31% btrfs_tree_read_lock
>            6.17% reserve_metadata_bytes
>               btrfs_block_rsv_add
> 
> btrfs walk phase hammers the inode_hash_lock:
> 
> -  18.45%  [kernel]  [k] __ticket_spin_trylock
>    - __ticket_spin_trylock
>       - 47.38% _raw_spin_lock
>          + 42.99% iget5_locked
>          + 15.17% __remove_inode_hash
>          + 13.77% btrfs_get_delayed_node
>          + 11.27% inode_tree_add
>          + 9.32% btrfs_destroy_inode
> .....
>       - 46.77% do_raw_spin_lock
>          - _raw_spin_lock
>             + 30.51% iget5_locked
>             + 11.40% __remove_inode_hash
>             + 11.38% btrfs_get_delayed_node
>             + 9.45% inode_tree_add
>             + 7.28% btrfs_destroy_inode
> .....
> 
> I have a RCU inode hash lookup patch floating around somewhere if
> someone wants it...
> 
> And, well, the less said about btrfs unlinks the better:
> 
> +  37.14%  [kernel]  [k] _raw_spin_unlock_irqrestore
> +  33.18%  [kernel]  [k] __write_lock_failed
> +  17.96%  [kernel]  [k] __read_lock_failed
> +   1.35%  [kernel]  [k] _raw_spin_unlock_irq
> +   0.82%  [kernel]  [k] __do_softirq
> +   0.53%  [kernel]  [k] btrfs_tree_lock
> +   0.41%  [kernel]  [k] btrfs_tree_read_lock
> +   0.41%  [kernel]  [k] do_raw_read_lock
> +   0.39%  [kernel]  [k] do_raw_write_lock
> +   0.38%  [kernel]  [k] btrfs_clear_lock_blocking_rw
> +   0.37%  [kernel]  [k] free_extent_buffer
> +   0.36%  [kernel]  [k] btrfs_tree_read_unlock
> +   0.32%  [kernel]  [k] do_raw_write_unlock
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
