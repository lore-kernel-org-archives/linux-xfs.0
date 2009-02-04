Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n148TQYj132141 for <xfs@oss.sgi.com>; Wed, 4 Feb 2009 02:29:27 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E79618BB549
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 00:28:48 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id AR3J4OAzhfjL92kB for
	<xfs@oss.sgi.com>; Wed, 04 Feb 2009 00:28:48 -0800 (PST)
Date: Wed, 4 Feb 2009 03:28:17 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: A rescue tool: xfs_irecover
Message-ID: <20090204082816.GA9111@infradead.org>
References: <alpine.LSU.2.00.0812292059020.15355@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0812292059020.15355@fbirervta.pbzchgretzou.qr>
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
To: Jan Engelhardt <jengelh@medozas.de>
Cc: xfs@oss.sgi.com

I looked into importing this into xfsprogs, and from a quick look
it could be simplified a lot by using code from libxfs or maybe even
by merging it into xfs_db and using the infrastructure there.

But xfsprogs is licensed under GPLv2 and will stay that way as it shares
a lot of code with the kernel.  Are you willing to relicense the tool
under GPLv2 or later?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
