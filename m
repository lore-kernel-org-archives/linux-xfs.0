Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6278m9N072588
	for <linux-xfs@oss.sgi.com>; Thu, 2 Jul 2009 02:08:48 -0500
Received: from mail-fx0-f209.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C4C5933A611
	for <linux-xfs@oss.sgi.com>; Thu,  2 Jul 2009 00:09:20 -0700 (PDT)
Received: from mail-fx0-f209.google.com (mail-fx0-f209.google.com
	[209.85.220.209]) by cuda.sgi.com with ESMTP id
	SstTVStLS0iLpYPV for <linux-xfs@oss.sgi.com>;
	Thu, 02 Jul 2009 00:09:20 -0700 (PDT)
Received: by fxm5 with SMTP id 5so1222425fxm.20
	for <linux-xfs@oss.sgi.com>; Thu, 02 Jul 2009 00:09:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090701124441.GA12844@infradead.org>
References: <4A408316.2070903@news-service.com>
	<1587994907.388291245745033392.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<20090623171305.GB23971@infradead.org>
	<4A4A7205.6010101@news-service.com>
	<20090701124441.GA12844@infradead.org>
Date: Thu, 2 Jul 2009 09:09:19 +0200
Message-ID: <89c4f90c0907020009n3b321c71s49a54501b146e0cb@mail.gmail.com>
Subject: Re: 2.6.30 panic - xfs_fs_destroy_inode
From: Tommy van Leeuwen <tommy@news-service.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Patrick Schreurs <patrick@news-service.com>, linux-xfs@oss.sgi.com, Lachlan McIlroy <lmcilroy@redhat.com>, Eric Sandeen <sandeen@sandeen.net>

On Wed, Jul 1, 2009 at 2:44 PM, Christoph Hellwig<hch@infradead.org> wrote:
> Actually you might want to give this patch a try which fixes a race
> affecting the reclaim tag in iget:

Thanks Christoph, we'll try this out in the next couple of days and
let you know.

Tommy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
