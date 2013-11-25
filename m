Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6B14E7F4E
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 10:07:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 58BF330407B
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 08:06:58 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 3aOzsbkuBWmeOz55 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Nov 2013 08:06:51 -0800 (PST)
Date: Mon, 25 Nov 2013 08:06:48 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: inode_permission NULL pointer dereference in 3.13-rc1
Message-ID: <20131125160648.GA4933@infradead.org>
References: <20131124140413.GA19271@infradead.org>
	<20131124152758.GL10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131124152758.GL10323@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Sun, Nov 24, 2013 at 03:27:58PM +0000, Al Viro wrote:
> which seems to leave two candidates - follow_dotdot_rcu() and path_init(),
> both setting nd->inode to nd->path.dentry->d_inode...
> 
> Could you try to reproduce it with something like
> 	if (read_seqretry(&mount_lock, nd->m_seq))
> 		goto failed;
> slapped before the success exit in follow_dotdot_rcu(), just to see if
> we are hitting some races with umount here?

Still reproducable with the diff below.  Fixed by reverting the RCU'd
vfsmounts.


diff --git a/fs/namei.c b/fs/namei.c
index 8f77a8c..856e4d5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1158,6 +1158,10 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 	}
 	follow_mount_rcu(nd);
 	nd->inode = nd->path.dentry->d_inode;
+
+	if (read_seqretry(&mount_lock, nd->m_seq))
+		goto failed;
+
 	return 0;
 
 failed:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
