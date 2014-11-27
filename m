Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C6FED7F4E
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 14:13:26 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B5BAF8F8035
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 12:13:23 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id 4kB61SyW41GJDWe1 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Nov 2014 12:13:21 -0800 (PST)
Date: Thu, 27 Nov 2014 15:13:16 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH-v4 6/7] ext4: add support for a lazytime mount option
Message-ID: <20141127201316.GE14091@thunk.org>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
	<1416997437-26092-7-git-send-email-tytso@mit.edu>
	<20141126224843.GG9561@dastard>
	<1A106262-D64C-4493-856F-AAAFC3BE2647@dilger.ca>
	<20141126233537.GH9561@dastard>
	<20141127132752.GF30152@quack.suse.cz>
	<20141127133227.GA11872@quack.suse.cz>
	<20141127152524.GB14091@thunk.org>
	<20141127154159.GA11922@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141127154159.GA11922@quack.suse.cz>
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

On Thu, Nov 27, 2014 at 04:41:59PM +0100, Jan Kara wrote:
>   Hum, but this puts lots of stuff under inode_hash_lock, including
> writeback list lock. I don't like this too much. I understand that getting
> handle for each inode is rather more CPU intensive but it should still be a
> clear win over the current situation and avoids entangling locks like this.

Hmm, if we dropped the inode_requeue_dirtytime(), then we can avoid
taking the writeback list lock.  The net result is that we would have
some inodes still on the b_dirty_time list that were no longer
I_DIRTY_TIME, but since I_DIRTY_TIME wouldn't be set, it's mostly
harmless since when we do iterate over the b_dirty_time list, those
inodes can be quickly identified and skipped over.  (And if the inode
ever gets dirtied for real, then it will get moved onto the b_dirty
list and that will be that.)

The problem with getting a handle on the inode is not just that it is
more CPU intensive, but that can't let the iput_final() call happen
until after we have finished the transaction handle.  We could keep a
linked list of inodes attached to the handle, and then only call iput
on them once ext4_journal_stop(handle) gets called, but that's a
complication I'd like to avoid if at all possible.

Being able to opporunistically write the timestamps when we are
journalling an inode table block is a pretty big win, so if we end up
extending the hold time on inode_hash_lock (only when we come across a
I_DIRTY_TIME inode that we can clear) a tiny bit, there will be a lot
of workloads where I think it's a worthwhile tradeoff.  If we can
avoid entangling the writebakc list lock, does that make you happier
about this approach?

	     	      	       	     	 - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
