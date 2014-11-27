Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 079EF7F4E
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 09:25:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CD34930405F
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 07:25:35 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id kmVDoAZkb1Y3A8RJ (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Nov 2014 07:25:33 -0800 (PST)
Date: Thu, 27 Nov 2014 10:25:24 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH-v4 6/7] ext4: add support for a lazytime mount option
Message-ID: <20141127152524.GB14091@thunk.org>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
	<1416997437-26092-7-git-send-email-tytso@mit.edu>
	<20141126224843.GG9561@dastard>
	<1A106262-D64C-4493-856F-AAAFC3BE2647@dilger.ca>
	<20141126233537.GH9561@dastard>
	<20141127132752.GF30152@quack.suse.cz>
	<20141127133227.GA11872@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141127133227.GA11872@quack.suse.cz>
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
Cc: Andreas Dilger <adilger@dilger.ca>, XFS Developers <xfs@oss.sgi.com>, Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>

This is what I'm currently playing with which I believe fixes the iput()
problem.  In fs/ext4/inode.c:

struct other_inode {
	unsigned long		orig_ino;
	struct ext4_inode	*raw_inode;
};
static int other_inode_match(struct inode * inode, unsigned long ino,
			     void *data);

/*
 * Opportunistically update the other time fields for other inodes in
 * the same inode table block.
 */
static void ext4_update_other_inodes_time(struct super_block *sb,
					  unsigned long orig_ino, char *buf)
{
	struct other_inode oi;
	unsigned long ino;
	int i, inodes_per_block = EXT4_SB(sb)->s_inodes_per_block;
	int inode_size = EXT4_INODE_SIZE(sb);

	oi.orig_ino = orig_ino;
	ino = orig_ino & ~(inodes_per_block - 1);
	for (i = 0; i < inodes_per_block; i++, ino++, buf += inode_size) {
		if (ino == orig_ino)
			continue;
		oi.raw_inode = (struct ext4_inode *) buf;
		(void) find_inode_nowait(sb, ino, other_inode_match, &oi);
	}
}

static int other_inode_match(struct inode * inode, unsigned long ino,
			     void *data)
{
	struct other_inode *oi = (struct other_inode *) data;

	if ((inode->i_ino != ino) ||
	    (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) ||
	    ((inode->i_state & I_DIRTY_TIME) == 0))
		return 0;
	spin_lock(&inode->i_lock);
	if (((inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) == 0) &&
	    (inode->i_state & I_DIRTY_TIME)) {
		struct ext4_inode_info	*ei = EXT4_I(inode);

		inode->i_state &= ~I_DIRTY_TIME;
		inode->i_ts_dirty_day = 0;
		spin_unlock(&inode->i_lock);
		inode_requeue_dirtytime(inode);

		spin_lock(&ei->i_raw_lock);
		EXT4_INODE_SET_XTIME(i_ctime, inode, oi->raw_inode);
		EXT4_INODE_SET_XTIME(i_mtime, inode, oi->raw_inode);
		EXT4_INODE_SET_XTIME(i_atime, inode, oi->raw_inode);
		ext4_inode_csum_set(inode, oi->raw_inode, ei);
		spin_unlock(&ei->i_raw_lock);
		trace_ext4_other_inode_update_time(inode, oi->orig_ino);
		return -1;
	}
	spin_unlock(&inode->i_lock);
	return -1;
}

The above uses the following in fs/inode.c (which gets added instead of
find_active_inode_nowait):

/**
 * find_inode_nowait - find an inode in the inode cache
 * @sb:		super block of file system to search
 * @hashval:	hash value (usually inode number) to search for
 * @match:	callback used for comparisons between inodes
 * @data:	opaque data pointer to pass to @match
 *
 * Search for the inode specified by @hashval and @data in the inode
 * cache, where the helper function @match will return 0 if the inode
 * does not match, 1 if the inode does match, and -1 if the search
 * should be stopped.  The @match function must be responsible for
 * taking the i_lock spin_lock and checking i_state for an inode being
 * freed or being initialized, and incrementing the reference count
 * before returning 1.  It also must not sleep, since it is called with
 * the inode_hash_lock spinlock held.
 *
 * This is a even more generalized version of ilookup5() when the
 * function must never block --- find_inode() can block in
 * __wait_on_freeing_inode() --- or when the caller can not increment
 * the reference count because the resulting iput() might cause an
 * inode eviction().  The tradeoff is that the @match funtion must be
 * very carefully implemented.
 */
struct inode *find_inode_nowait(struct super_block *sb,
				unsigned long hashval,
				int (*match)(struct inode *, unsigned long,
					     void *),
				void *data)
{
	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
	struct inode *inode, *ret_inode = NULL;
	int mval;

	spin_lock(&inode_hash_lock);
	hlist_for_each_entry(inode, head, i_hash) {
		if (inode->i_sb != sb)
			continue;
		mval = match(inode, hashval, data);
		if (mval == 0)
			continue;
		if (mval == 1)
			ret_inode = inode;
		goto out;
	}
out:
	spin_unlock(&inode_hash_lock);
	return ret_inode;
}
EXPORT_SYMBOL(find_inode_nowait);

Comments?

							- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
