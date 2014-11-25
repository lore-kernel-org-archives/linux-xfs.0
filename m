Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 197167F3F
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 11:57:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D165E30404E
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 09:57:26 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id bbpUZzZJbSTMyb5C (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2014 09:57:24 -0800 (PST)
Date: Tue, 25 Nov 2014 12:57:16 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] vfs: add support for a lazytime mount option
Message-ID: <20141125175716.GC11648@thunk.org>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-3-git-send-email-tytso@mit.edu>
	<20141125015239.GD27262@dastard> <20141125043335.GF31339@thunk.org>
	<20141125171927.GC3228@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141125171927.GC3228@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Nov 25, 2014 at 06:19:27PM +0100, Jan Kara wrote:
>   Actually, I'd also prefer to do the writing from iput_final(). My main
> reason is that shrinker starts behaving very differently when you put
> inodes with I_DIRTY_TIME to the LRU. See inode_lru_isolate() and in
> particular:
>         /*
>          * Referenced or dirty inodes are still in use. Give them another
>          * pass
>          * through the LRU as we canot reclaim them now.
>          */
>         if (atomic_read(&inode->i_count) ||
>             (inode->i_state & ~I_REFERENCED)) {
>                 list_del_init(&inode->i_lru);
>                 spin_unlock(&inode->i_lock);
>                 this_cpu_dec(nr_unused);
>                 return LRU_REMOVED;
>         }

I must be missing something; how would the shirnker behave
differently?  I_DIRTY_TIME shouldn't have any effect on the shrinker;
note that I_DIRTY_TIME is *not* part of I_DIRTY, and this was quite
deliberate, because I didn't want I_DIRTY_TIME to have any affect on
any of the other parts of the writeback or inode management parts.

> Regarding your concern that we'd write the inode when file is closed -
> that's not true. We'll write the inode only after corresponding dentry is
> evicted and thus drops inode reference. That doesn't seem too bad to me.

True, fair enough.  It's not quite so lazy, but it should be close
enough.

I'm still not seeing the benefit in waiting until the last possible
minute to write out the timestamps; evict() can block as it is if
there are any writeback that needs to be completed, and if the
writeback happens to pages subject to delalloc, the timestamp update
could happen for free at that point.

      						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
