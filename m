Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5UKgQUC228876
	for <linux-xfs@oss.sgi.com>; Tue, 30 Jun 2009 15:42:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 13B35333CB3
	for <linux-xfs@oss.sgi.com>; Tue, 30 Jun 2009 13:42:57 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id RzXuFoXmpgTNjXGi for
	<linux-xfs@oss.sgi.com>; Tue, 30 Jun 2009 13:42:57 -0700 (PDT)
Date: Tue, 30 Jun 2009 16:42:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.30 panic - xfs_fs_destroy_inode
Message-ID: <20090630204256.GA1891@infradead.org>
References: <4A408316.2070903@news-service.com>
	<1587994907.388291245745033392.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<20090623171305.GB23971@infradead.org>
	<4A4A7205.6010101@news-service.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A4A7205.6010101@news-service.com>
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
To: Patrick Schreurs <patrick@news-service.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@oss.sgi.com, Tommy van Leeuwen <tommy@news-service.com>, Lachlan McIlroy <lmcilroy@redhat.com>, Eric Sandeen <sandeen@sandeen.net>

On Tue, Jun 30, 2009 at 10:13:57PM +0200, Patrick Schreurs wrote:
> Hi (again),
>
> Anyone has any advice to prevent this from happening? We've seen 10  
> crashes in the last 14 days. Would it be helpful to enable  
> CONFIG_XFS_DEBUG? Does this result in a big performance hit on busy xfs  
> filesystems? If we can help troubleshoot this problem, please advice.
>
> If i understand correctly this issue also exists in 2.6.29? Should i  
> downgrade to the latest 2.6.28 kernel to regain stability?

For now please downgrade to the latest 2.6.28, yes.  I hope I will have
time and machine ressources to dig deeper into the problem this week.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
