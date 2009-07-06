Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n66IlNGB103947 for <xfs@oss.sgi.com>; Mon, 6 Jul 2009 13:47:25 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38282603586
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2009 11:54:47 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id F749aTZiNLQ6fATs for
	<xfs@oss.sgi.com>; Mon, 06 Jul 2009 11:54:47 -0700 (PDT)
Date: Mon, 6 Jul 2009 14:42:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] default to inode64 on 64-bit systems
Message-ID: <20090706184257.GA18107@infradead.org>
References: <4A52419E.5020301@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A52419E.5020301@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Mon, Jul 06, 2009 at 01:25:34PM -0500, Eric Sandeen wrote:
> I'm tiring of telling people to use the inode64 mount option
> when they are experiencing bad performance on large xfs 
> filesystems...
> 
> 32-bit userspace is still largely broken when it comes to still
> using 32-bit stat calls, but on 64-bit systems this should be
> safe.
> 
> The only problem here is moving the disk onto a 32-bit system, or using
> 32-bit apps.  But I think it's a small risk.
> 
> What do we think about the following?

Looks good to me, but it could use a comment in the code explaining why
we do this.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
