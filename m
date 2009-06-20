Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5KHxQqf129391 for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 12:59:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8ACFF12A843A
	for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 10:59:53 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lnGYq0Sn8Py7KtRH for
	<xfs@oss.sgi.com>; Sat, 20 Jun 2009 10:59:53 -0700 (PDT)
Date: Sat, 20 Jun 2009 13:59:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfstests: fallocate + read/write tests, ext4
	regression tests
Message-ID: <20090620175953.GC3984@infradead.org>
References: <4A370DD2.6080204@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A370DD2.6080204@sandeen.net>
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
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jun 15, 2009 at 10:13:22PM -0500, Eric Sandeen wrote:
> New test to test basic mixed fallocate + read & write,
> includes a couple regression tests for bugs that ext4
> hit.  Uses xfs_io to generate fallocate calls, so requires
> git xfsprogs and very recent glibc at this point.

Looks good to me, and again does the correct notrun for my 32-bit
VM.  Guess I need to do the raw syscall wireup i xfsprogs eventually..


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
