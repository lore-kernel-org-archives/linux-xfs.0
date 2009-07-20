Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6KKE9xv106505
	for <linux-xfs@oss.sgi.com>; Mon, 20 Jul 2009 15:14:09 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 644851B0C8AA
	for <linux-xfs@oss.sgi.com>; Mon, 20 Jul 2009 13:14:51 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id JLKp21bmKS2CWYsd for
	<linux-xfs@oss.sgi.com>; Mon, 20 Jul 2009 13:14:51 -0700 (PDT)
Date: Mon, 20 Jul 2009 16:14:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.30 panic - xfs_fs_destroy_inode
Message-ID: <20090720201449.GA1646@infradead.org>
References: <4A408316.2070903@news-service.com>
	<1587994907.388291245745033392.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<20090623171305.GB23971@infradead.org>
	<4A4A7205.6010101@news-service.com>
	<20090630204256.GA1891@infradead.org>
	<4A64C34F.80807@news-service.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A64C34F.80807@news-service.com>
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

On Mon, Jul 20, 2009 at 09:19:43PM +0200, Patrick Schreurs wrote:
> Hi Christoph,
>
> I saw some patches from your hand on this list ("fixes for memory  
> allocator recursions into the filesystem"). Are these patches related to  
> this issue?

I don't think they are, but if you have sparse testing cycles it would
be great if you could test it.  I'm a bit overloaded right now and can't
do as much debugging of these problems as I'd wish to.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
