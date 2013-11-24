Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E62D77F54
	for <xfs@oss.sgi.com>; Sun, 24 Nov 2013 09:28:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C6E84304059
	for <xfs@oss.sgi.com>; Sun, 24 Nov 2013 07:28:02 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id hFPg0LR6hczG5ahS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 24 Nov 2013 07:28:01 -0800 (PST)
Date: Sun, 24 Nov 2013 15:27:58 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: inode_permission NULL pointer dereference in 3.13-rc1
Message-ID: <20131124152758.GL10323@ZenIV.linux.org.uk>
References: <20131124140413.GA19271@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131124140413.GA19271@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Sun, Nov 24, 2013 at 06:04:13AM -0800, Christoph Hellwig wrote:
> Seems I can reproduce this by doing a full xfstests run and then
> shutting down the VM.  Doesn't seem to happen with the XFS tree
> which is still based on 3.12-rc1.

may_lookup() with LOOKUP_RCU in nd->flags and NULL nd->inode, by
the look of it...  Interesting.

AFAICS, path_init() initializes nd->inode on all success exits.
As for the places where we reassign nd->inode, we have the following:
fs/namei.c:681: nd->inode = nd->path.dentry->d_inode;
	nd_jump_link(), we would've already left RCU mode
fs/namei.c:856:         nd->inode = nd->path.dentry->d_inode;
	follow_link() - ditto.
fs/namei.c:1160:        nd->inode = nd->path.dentry->d_inode;
	follow_dotdot_rcu()
fs/namei.c:1257:        nd->inode = nd->path.dentry->d_inode;
	follow_dotdot() - not in RCU mode
fs/namei.c:1547:        nd->inode = inode;
	walk_component() - inode can't be NULL here, variable has
been explicitly compared with NULL a few lines prior
fs/namei.c:1825:                nd->inode = inode;
	path_init() with LOOKUP_ROOT; not from stat(2) and it would've
already oopsed with NULL inode anyway.
fs/namei.c:1892:        nd->inode = nd->path.dentry->d_inode;
	path_init()
fs/namei.c:3006:        nd->inode = inode;
	do_last(), not from stat(2) and no may_lookup() done past that
point anyway.
fs/namei.c:3077:        nd->inode = dir->d_inode;
	do_last(), not from stat(2)

which seems to leave two candidates - follow_dotdot_rcu() and path_init(),
both setting nd->inode to nd->path.dentry->d_inode...

Could you try to reproduce it with something like
	if (read_seqretry(&mount_lock, nd->m_seq))
		goto failed;
slapped before the success exit in follow_dotdot_rcu(), just to see if
we are hitting some races with umount here?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
