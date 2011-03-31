Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2VEXxEb150125 for <xfs@oss.sgi.com>; Thu, 31 Mar 2011 09:34:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA5EF131EEC1
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2011 07:37:11 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id M0VhVxTfnH9mTmcz for
	<xfs@oss.sgi.com>; Thu, 31 Mar 2011 07:37:11 -0700 (PDT)
Date: Thu, 31 Mar 2011 10:37:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS stack overflow?
Message-ID: <20110331143710.GA12821@infradead.org>
References: <1301581135.748149.10230.nullmailer@thekelleys.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1301581135.748149.10230.nullmailer@thekelleys.org.uk>
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
To: simon@thekelleys.org.uk
Cc: xfs@oss.sgi.com

On Thu, Mar 31, 2011 at 03:18:55PM +0100, simon@thekelleys.org.uk wrote:
> x86_64
> Storage is fibrechannel attached and the filesystem is hosted on a 
> LVM block device that concatentates four partitions, so the block access
> is going via a stack of LVM, multipath and Q-logic drivers.
> Network is Intel 10G ethernet (gxbe driver)
> Kernel is 2.6.32 with Debian patches. (both kernels)

Yes, this very much looks like a stack overflow caused by direct
reclaim from a context with a lot of stack usage into a filesystem (XFS
in this case) with a deep storage stack underneath.

The fix for this is to disable direct reclaim, which the VM maintainers
refuse.  We finally gave in and added a hack similar to the other
modern filesystems to prevent this from inside XFS.

Try backporting commits:

	"xfs: skip writeback from reclaim context"

and

	"xfs: allow writeback from kswapd"

from current mainline to avoid these kinds of issues.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
