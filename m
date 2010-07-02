Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o62Jm9SG256428 for <xfs@oss.sgi.com>; Fri, 2 Jul 2010 14:48:09 -0500
Subject: Re: [PATCH 03/15] xfs: move DMAPI definitions out of "xfs_mount.h"
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100629133500.GA11312@infradead.org>
References: <201006282204.o5SM4qbU018132@stout.americas.sgi.com>
	<20100629133500.GA11312@infradead.org>
Date: Fri, 02 Jul 2010 14:50:02 -0500
Message-ID: <1278100202.1876.120.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: xfs@oss.sgi.com

On Tue, 2010-06-29 at 09:35 -0400, Christoph Hellwig wrote:
> On Mon, Jun 28, 2010 at 05:04:52PM -0500, Alex Elder wrote:
> > XFS defines a bunch of DMAPI cruft in xfs_mount.h.  There is no need
> > for it to be there; move it instead into the xfs_dmapi.h file.  A
> > side-effect of this is that "xfs_dmapi.h" now depends on and needs
> > to be #included after "xfs_mount.h" and "xfs_inode.h" (the latter of
> > which itself depends on a "xfs_bmap_btree.h").
> > 
> > On the other hand, "xfs_dmapi.h" is #included by a LOT more files
> > than it needs to be, so eliminate those cases.
> > 
> > Finally, "xfs_inode.h" defines a type dm_attrs_t that is never
> > referenced anywhere else, so kill it off.
> 
> Asserting copyright on removing single include lines seems rather
> interesting..

I simply updated the copyright on every file I touched.
We've been advised that "SGI" is the new description
of the company in copyright statements, so I was just
doing a blanket update.

I'll keep those changes, but will drop the ones where I
actually added a copyright that wasn't there before.
Looks like only one of the 64 files changed fits that
description ("linux-2.6/xfs_quotaops.c").

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
