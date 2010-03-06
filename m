Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o26AgTMw079118 for <xfs@oss.sgi.com>; Sat, 6 Mar 2010 04:42:29 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 32B231D1B07F
	for <xfs@oss.sgi.com>; Sat,  6 Mar 2010 02:43:58 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id a0uHlKribBz68F1T for
	<xfs@oss.sgi.com>; Sat, 06 Mar 2010 02:43:58 -0800 (PST)
Date: Sat, 6 Mar 2010 05:43:57 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [RFC] xfs_fsr: Improve handling of attribute forks
Message-ID: <20100306104357.GA22520@infradead.org>
References: <1267764049-30650-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1267764049-30650-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Mar 05, 2010 at 03:40:49PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If the file being defragmented has attributes, then fsr puts a dummy
> attribute on the temporary file to try to ensure that the inode
> attribute fork offset is set correctly. This works perfectly well
> for the old style of attributes that use a fixed fork offset - the
> presence of any attribute of any size or shape will result in fsr
> doing the correct thing.
> 
> However, for attr2 filesystems, the attribute fork offset is
> dependent on the size and shape of both the data and attribute
> forks. Hence setting a small attribute on the file does not
> guarantee that the two inodes have the same fork offset and
> therefore compatible for a data fork swap.
> 
> This patch improves the attribute fork handling of fsr. It checks
> the filesystem version to see if the old style attributes are in
> use, and if so uses the current method.
> 
> If attr2 is in use, fsr uses bulkstat output to determine what the
> fork offset is. If the attribute fork offsets differ then fsr will
> try to create attributes that will result in the correct offset. If
> that fails, or the attribute fork is too large, it will give up and just
> attempt the swap.
> 
> This fork offset value in bulkstat new functionality in the kernel,
> so if there are attributes and a zero fork offset, then the kernel
> does not support this feature and we simply fall back to the existing,
> less effective code.

Looks reasonable.  It would be good to have a testcase for this in
xfsqa to verify this works.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
