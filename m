Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5NHCfag038772
	for <linux-xfs@oss.sgi.com>; Tue, 23 Jun 2009 12:12:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B0F001D43A8D
	for <linux-xfs@oss.sgi.com>; Tue, 23 Jun 2009 10:13:09 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id A7UETzcJBzN7Ae1A for
	<linux-xfs@oss.sgi.com>; Tue, 23 Jun 2009 10:13:09 -0700 (PDT)
Date: Tue, 23 Jun 2009 13:13:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.30 panic - xfs_fs_destroy_inode
Message-ID: <20090623171305.GB23971@infradead.org>
References: <4A408316.2070903@news-service.com>
	<1587994907.388291245745033392.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1587994907.388291245745033392.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
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
To: Lachlan McIlroy <lmcilroy@redhat.com>
Cc: Patrick Schreurs <patrick@news-service.com>, linux-xfs@oss.sgi.com, Tommy van Leeuwen <tommy@news-service.com>, Eric Sandeen <sandeen@sandeen.net>

On Tue, Jun 23, 2009 at 04:17:13AM -0400, Lachlan McIlroy wrote:
> It looks to me like xfs_reclaim_inode() has returned EAGAIN because the
> XFS_RECLAIM flag was set on the xfs inode.  This implies we are trying
> to reclaim an inode that is already in the process of being reclaimed.
> I'm not sure how this happened but it could be a simple case of ignoring
> this error since the reclaim is already in progress.

Well, having the reclaim already in progress means we're racing here.
And I suspect this fits into the other bugs with possibly duplicat
inodes we see after the inode+xfs_inode unification.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
