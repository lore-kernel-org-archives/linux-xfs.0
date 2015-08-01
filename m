Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2B1977F77
	for <xfs@oss.sgi.com>; Sat,  1 Aug 2015 08:01:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C7E08AC001
	for <xfs@oss.sgi.com>; Sat,  1 Aug 2015 06:01:31 -0700 (PDT)
Received: from josefsipek.net (josefsipek.net [71.174.113.7]) by cuda.sgi.com
	with ESMTP id HrvPLCqYspxaqt6H for <xfs@oss.sgi.com>;
	Sat, 01 Aug 2015 06:01:30 -0700 (PDT)
Date: Sat, 1 Aug 2015 09:01:31 -0400
From: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Subject: Re: [RFC v2 00/24] xfs: add reflink and dedupe support
Message-ID: <20150801130131.GD101746@meili.valhalla.31bits.net>
References: <20150729223258.17414.91354.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150729223258.17414.91354.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 29, 2015 at 03:32:59PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This is the second revision of an RFC for adding to XFS kernel support
> for mapping multiple file logical blocks to the same physical block,
> more commonly known as reflinking.  The implementation a single [block
> range, refcount] tree to track the reference counts of extents of
> physical blocks.  There's also support code to provide the desired
> copy-on-write behavior and the userland interfaces to reflink, query
> the status of, and un-reflink files.

This is cool work.  I have a random thought to share... IIRC, you keep a
per-inode flag to avoid expensive ops on files that have no refcounted
blocks.  ZFS keeps a bit in each block pointer to indicate that the target
is dedup'd.  I'd have to check if xfs has a spare bit in its block pointer,
but if it does that's one way to minimize the refcount btree overhead.

Jeff.

-- 
mainframe, n.:
  An obsolete device still used by thousands of obsolete companies serving
  billions of obsolete customers and making huge obsolete profits for their
  obsolete shareholders. And this year's run twice as fast as last year's.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
