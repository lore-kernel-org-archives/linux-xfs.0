Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3DEa14T239447 for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 09:36:03 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8CFCCFF8B4A
	for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 07:37:55 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id wiN0ScdkSOBTbLLj for
	<xfs@oss.sgi.com>; Tue, 13 Apr 2010 07:37:55 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1O1hFT-0007aB-4P
	for xfs@oss.sgi.com; Tue, 13 Apr 2010 14:37:55 +0000
Date: Tue, 13 Apr 2010 10:37:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: wait for direct I/O to complete in fsync and
	write_inode
Message-ID: <20100413143755.GA28998@infradead.org>
References: <20100306132018.GA31360@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100306132018.GA31360@infradead.org>
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
To: xfs@oss.sgi.com

On Sat, Mar 06, 2010 at 08:20:18AM -0500, Christoph Hellwig wrote:
> 
> We need to wait for all pending direct I/O requests before taking care of
> metadata in fsync and write_inode.

ping?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
