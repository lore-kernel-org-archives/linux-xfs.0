Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAH35E5x163880 for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 21:05:14 -0600
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 757701C4CACD
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 19:06:47 -0800 (PST)
Received: from thunker.thunk.org (THUNK.ORG [69.25.196.29]) by cuda.sgi.com
	with ESMTP id 39J70kKybhJIKECf for <xfs@oss.sgi.com>;
	Tue, 16 Nov 2010 19:06:47 -0800 (PST)
Date: Tue, 16 Nov 2010 22:06:40 -0500
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 4/6] Ext4: fail if we try to use hole punch
Message-ID: <20101117030640.GD3290@thunk.org>
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
	<1289840723-3056-5-git-send-email-josef@redhat.com>
	<4CE2783F.1020004@redhat.com>
	<20101116125016.GA31957@dhcp231-156.rdu.redhat.com>
	<4CE28211.6060204@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CE28211.6060204@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Avi Kivity <avi@redhat.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, cmm@us.ibm.com, Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

> >There is no simple way to test if a filesystem supports hole punching or not so
> >the check has to be done per fs.  Thanks,
> 
> Could put a flag word in superblock_operations.  Filesystems which
> support punching (or other features) can enable it there.

No, it couldn't be in super_operations.  It may vary on a per-inode
basis for some file systems, such as ext4 (depending on whether the
inode is extent-mapped or indirect-block mapped).

So at least for ext4 we'd need to call into fallocate() function
anyway, once we add support.  I suppose if other file systems really
want it, we could add a flag to the super block ops structure, so they
don't have do the "do we support the punch" operation.  I can go
either way on that; although if we think the majority of file systems
are going support punch in the long-term, then it might not be worth
it to add such a flag.

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
