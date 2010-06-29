Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5TDWG71080360 for <xfs@oss.sgi.com>; Tue, 29 Jun 2010 08:32:17 -0500
Date: Tue, 29 Jun 2010 09:35:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/15] xfs: move DMAPI definitions out of "xfs_mount.h"
Message-ID: <20100629133500.GA11312@infradead.org>
References: <201006282204.o5SM4qbU018132@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201006282204.o5SM4qbU018132@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 28, 2010 at 05:04:52PM -0500, Alex Elder wrote:
> XFS defines a bunch of DMAPI cruft in xfs_mount.h.  There is no need
> for it to be there; move it instead into the xfs_dmapi.h file.  A
> side-effect of this is that "xfs_dmapi.h" now depends on and needs
> to be #included after "xfs_mount.h" and "xfs_inode.h" (the latter of
> which itself depends on a "xfs_bmap_btree.h").
> 
> On the other hand, "xfs_dmapi.h" is #included by a LOT more files
> than it needs to be, so eliminate those cases.
> 
> Finally, "xfs_inode.h" defines a type dm_attrs_t that is never
> referenced anywhere else, so kill it off.

Asserting copyright on removing single include lines seems rather
interesting..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
