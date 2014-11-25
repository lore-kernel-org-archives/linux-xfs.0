Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5DFD57F3F
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 11:19:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3D34E8F8052
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 09:19:33 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id er7euhl4r5zy7d4n (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2014 09:19:31 -0800 (PST)
Date: Tue, 25 Nov 2014 18:19:27 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/4] vfs: add support for a lazytime mount option
Message-ID: <20141125171927.GC3228@quack.suse.cz>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-3-git-send-email-tytso@mit.edu>
	<20141125015239.GD27262@dastard> <20141125043335.GF31339@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141125043335.GF31339@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon 24-11-14 23:33:35, Ted Tso wrote:
> On Tue, Nov 25, 2014 at 12:52:39PM +1100, Dave Chinner wrote:
> > Eviction is too late for this. I'm pretty sure that it won't get
> > this far as iput_final() should catch the I_DIRTY_TIME in the !drop
> > case via write_inode_now().
> 
> Actually, the tracepoint for fs_lazytime_evict() does get triggered
> from time to time; but only when the inode is evicted due to memory
> pressure, i.e., via the evict_inodes() path.
> 
> I thought about possibly doing this in iput_final(), but that would
> mean that whenever we closed the last fd on the file, we would push
> the inode out to disk.  For files that we are writing, that's not so
> bad; but if we enable strictatime with lazytime, then we would be
> updating the atime for inodes that had been only been read on every
> close --- which in the case of say, all of the files in the kernel
> tree, would be a little unfortunate.
  Actually, I'd also prefer to do the writing from iput_final(). My main
reason is that shrinker starts behaving very differently when you put
inodes with I_DIRTY_TIME to the LRU. See inode_lru_isolate() and in
particular:
        /*
         * Referenced or dirty inodes are still in use. Give them another
         * pass
         * through the LRU as we canot reclaim them now.
         */
        if (atomic_read(&inode->i_count) ||
            (inode->i_state & ~I_REFERENCED)) {
                list_del_init(&inode->i_lru);
                spin_unlock(&inode->i_lock);
                this_cpu_dec(nr_unused);
                return LRU_REMOVED;
        }

Regarding your concern that we'd write the inode when file is closed -
that's not true. We'll write the inode only after corresponding dentry is
evicted and thus drops inode reference. That doesn't seem too bad to me.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
