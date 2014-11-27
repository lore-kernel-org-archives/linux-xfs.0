Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 838617F4E
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 08:41:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 610358F8050
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 06:41:26 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id jhjnZHh7f7MpC3GL (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Nov 2014 06:41:23 -0800 (PST)
Date: Thu, 27 Nov 2014 09:41:16 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH-v4 1/7] vfs: split update_time() into update_time() and
	write_time()
Message-ID: <20141127144116.GA14091@thunk.org>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
	<1416997437-26092-2-git-send-email-tytso@mit.edu>
	<20141126192328.GA20436@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141126192328.GA20436@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>

On Wed, Nov 26, 2014 at 11:23:28AM -0800, Christoph Hellwig wrote:
> As mentioned last round please move the addition of the is_readonly
> operation to the first thing in the series, so that the ordering makes
> more sense.

OK, will fix.

> Second I think this patch is incorrect for XFS - XFS uses ->update_time
> to set the time stampst in the dinode.  These two need to be coherent
> as we can write out a dirty inode any time, so it needs to have the
> timestamp uptodate.
> 
> Third update_time now calls mark_inode_dirty unconditionally, while
> previously it wasn't called when ->update_time was set.  At least
> for XFS that's a major change in behavior as XFS never used VFS dirty
> tracking for metadata updates.

Thanks, I'll fix both of the above.

							- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
