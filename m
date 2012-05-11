Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4BNkkIu133233
	for <linux-xfs@oss.sgi.com>; Fri, 11 May 2012 18:46:46 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id oLeEbKJ3sM96QYQF for <linux-xfs@oss.sgi.com>;
	Fri, 11 May 2012 16:46:44 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id B6F3F4963295
	for <linux-xfs@oss.sgi.com>; Fri, 11 May 2012 18:46:43 -0500 (CDT)
Message-ID: <4FADA4E3.4060805@sandeen.net>
Date: Fri, 11 May 2012 18:46:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS (dm-5): xfs_swap_extents: inode 0x35dbd267 format is
	incompatible for exchanging.
References: <20120511195958.GA7387@sli.dy.fi>
In-Reply-To: <20120511195958.GA7387@sli.dy.fi>
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
To: linux-xfs@oss.sgi.com

On 5/11/12 2:59 PM, Sami Liedes wrote:
> Hi,
> 
> I got this warning in dmesg, presumably while running xfs_fsr on the
> filesystem, on kernel 3.3.5:
> 
> XFS (dm-5): xfs_swap_extents: inode 0x35dbd267 format is incompatible for exchanging.
> 
> The filesystem is new, created this week. find -xdev -inum 903598695
> doesn't find any file with such an inode number.
> 
> 	Sami

I've fixed a couple of these recently, still need to get them merged I guess; see the list for these xfsprogs patches:

[PATCH 1/2] xfs_fsr: extra debugging info
[PATCH 2/2] xfs_fsr: create extent-based attr to grow forkoff

and these kernel patches:

[PATCH] xfs: check on-disk (not incore) btree root size in dfrag.c
[PATCH 2/1] xfs: use XFS_BMAP_BMDR_SPACE vs. XFS_BROOT_SIZE_ADJ

if those don't solve it, a metadump of the filesystem should help us investigate further.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
