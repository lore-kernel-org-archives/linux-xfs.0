Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B2EAA7F4E
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 14:20:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A1985304048
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 12:20:05 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id SKaoD5FEOOW2ckwy (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Nov 2014 12:20:04 -0800 (PST)
Date: Thu, 27 Nov 2014 15:19:54 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH-v4 2/7] vfs: add support for a lazytime mount option
Message-ID: <20141127201954.GF14091@thunk.org>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
	<1416997437-26092-3-git-send-email-tytso@mit.edu>
	<20141127131421.GE30152@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141127131421.GE30152@quack.suse.cz>
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
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>

On Thu, Nov 27, 2014 at 02:14:21PM +0100, Jan Kara wrote:
> Looking into the code & your patch I'd prefer to do something like:
> * add support for I_DIRTY_TIME in __mark_inode_dirty() - update_time will
>   call __mark_inode_dirty() with this flag if any of the times was updated.
>   That way we can just remove your ->write_time() callback - filesystems
>   can just handle this in their ->dirty_inode() methods if they wish.
>   __mark_inode_dirty() will take care of moving inode into proper writeback
>   list (i_dirty / i_dirty_time), dirtied_when will be set to current time.

One of the tricky bits about this is that btrfs wants to be able to
return an error from write_time() which gets reflected up through
update_time() to the callers of file_update_time().  Currently
__mark_inode_dirty() and family return a void, and changing this is
going to be a bit of a mess, since doing this correctly would require
auditing all of the callers of mark_inode_dirty(),
mark_inode_dirty_sync(), __mark_inode_dirty(), etc.

Doing this would be a good thing, and eventually I think it would be
nice if we could allow the mark_inode_dirty() functions return an
error instead of void, but I wonder if that's a cleanup that's better
saved for later.  While we were at it, maybe we should rename
mark_inode_dirty() to inode_dirty(), since that way we can be sure
we've looked at all of the call site of mark_inode_dirty() and friends
--- and we have a number of file systems, including btrfs, ext3, and
ext4, where mark_inode_dirty() is doing a lot more than just marking
the inode is dirty, and the only reason why it's named that is mostly
historical.

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
