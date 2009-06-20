Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5KHvxag129266 for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 12:57:59 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD61A953680
	for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 11:06:30 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id aBcgDoo4OWCY1fJN for
	<xfs@oss.sgi.com>; Sat, 20 Jun 2009 11:06:30 -0700 (PDT)
Date: Sat, 20 Jun 2009 13:58:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfstests: basic fallocate boundary tests
Message-ID: <20090620175824.GA3984@infradead.org>
References: <4A370C2C.6030404@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A370C2C.6030404@sandeen.net>
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

On Mon, Jun 15, 2009 at 10:06:20PM -0500, Eric Sandeen wrote:
> This is just like test 072, but using fallocate instead
> of the xfs ioctl.  Just very basic fallocate tests.
> 
> Also adds a "prealloc" group (./check -g prealloc)

Looks good to me, and does the right thing on my 32 bit test VM (notrun)

> +echo $testio | grep -q "not found" && \
> +	_notrun "xfs_io fallocate support is missing"
> +echo $testio | grep -q "Operation not supported" && \
> +	_notrun "xfs_io fallocate command failed (old kernel? wrong fs?)"

Maybe add a _require_fallocate as you need the same check in the next
testcase?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
