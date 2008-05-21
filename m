Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 May 2008 01:10:40 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4L8AbPL000380
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 01:10:37 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: TAKE streamline init/exit path
References: <20080518130511.GA28501@lst.de> <nccprrg32vr.fsf@sgi.com>
	<20080521060103.GA25003@lst.de> <nccej7w2l9c.fsf@sgi.com>
	<20080521072425.GA29889@lst.de>
Date: Wed, 21 May 2008 18:11:23 +1000
In-Reply-To: <20080521072425.GA29889@lst.de> (Christoph Hellwig's message of
	"Wed, 21 May 2008 09:24:25 +0200")
Message-ID: <ncc7ido2i1g.fsf_-_@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com


Christoph Hellwig <hch@lst.de> writes:

> Updated patch below.  There's now split out function to create/destroy
> the kmem zones and alloc/free the trace buffers.  I've also changed the
> ktrace allocations to KM_MAYFAIL and handled errors resulting from that.
>
> And yes, we really should replace the XFS_*_TRACE ifdefs with a single
> XFS_TRACE..

Thanks, 

it's in, forgot to send the TAKE message to oss, here it comes:

Subject: TAKE 976035 -  streamline init/exit path

Date:  Wed, 21 May 2008 18:02:18 +1000
Workarea:  chook.melbourne.sgi.com:/build/xaiki/isms/mangrove-1.3
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31210a

streamline init/exit path

Currently the xfs module init/exit code is a mess.  It's farmed out
over a lot of function with very little error checking.  This patch
makes sure we propagate all initialization failures properly and clean
up after them.  Various runtime initializations are replaced with
compile-time initializations where possible to make this easier.  The
exit path is similarly consolidated.

There's now split out function to create/destroy the kmem zones and
alloc/free the trace buffers.  I've also changed the ktrace
allocations to KM_MAYFAIL and handled errors resulting from that.

And yes, we really should replace the XFS_*_TRACE ifdefs with a single
XFS_TRACE..

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Niv Sardi <xaiki@sgi.com>

fs/xfs/linux-2.6/xfs_stats.c - 1.24 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_stats.c.diff?r1=text&tr1=1.24&r2=text&tr2=1.23&f=h
fs/xfs/linux-2.6/xfs_stats.h - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_stats.h.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.429 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.429&r2=text&tr2=1.428&f=h
fs/xfs/linux-2.6/xfs_sysctl.c - 1.44 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sysctl.c.diff?r1=text&tr1=1.44&r2=text&tr2=1.43&f=h
fs/xfs/linux-2.6/xfs_sysctl.h - 1.29 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sysctl.h.diff?r1=text&tr1=1.29&r2=text&tr2=1.28&f=h
fs/xfs/support/uuid.c - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/uuid.c.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
fs/xfs/support/uuid.h - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/uuid.h.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
fs/xfs/xfs_da_btree.c - 1.180 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_da_btree.c.diff?r1=text&tr1=1.180&r2=text&tr2=1.179&f=h
fs/xfs/xfs_error.c - 1.61 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_error.c.diff?r1=text&tr1=1.61&r2=text&tr2=1.60&f=h
fs/xfs/xfs_error.h - 1.50 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_error.h.diff?r1=text&tr1=1.50&r2=text&tr2=1.49&f=h
fs/xfs/xfs_filestream.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_filestream.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
fs/xfs/xfs_mount.h - 1.270 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.270&r2=text&tr2=1.269&f=h
fs/xfs/xfs_mru_cache.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mru_cache.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
fs/xfs/xfs_vfsops.c - 1.568 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.568&r2=text&tr2=1.567&f=h

-- 
Niv Sardi
