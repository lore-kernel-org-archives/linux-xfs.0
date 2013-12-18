Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 692FE7F51
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 12:37:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ED4E0AC005
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:37:28 -0800 (PST)
Received: from mail-ea0-f175.google.com (mail-ea0-f175.google.com
	[209.85.215.175]) by cuda.sgi.com with ESMTP id
	0zHBog8H0BkyCB5H (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Dec 2013 10:37:27 -0800 (PST)
Received: by mail-ea0-f175.google.com with SMTP id z10so15688ead.6
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 10:37:26 -0800 (PST)
Received: from alyakaslap ([212.143.144.103])
	by mx.google.com with ESMTPSA id m1sm2400227eeg.0.2013.12.18.10.37.25
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
	Wed, 18 Dec 2013 10:37:25 -0800 (PST)
Message-ID: <AD612A564BB84E75B010AE37687DFC8E@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
Subject: Questions about XFS discard and xfs_free_extent() code (newbie)
Date: Wed, 18 Dec 2013 20:37:29 +0200
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Greetings XFS developers & community,

I am studying the XFS code, primarily focusing now at the free-space
allocation and deallocation parts.

I learned that freeing an extent happens like this:
- xfs_free_extent() calls xfs_free_ag_extent(), which attempts to merge the
freed extents from left and from right in the by-bno btree. Then the by-size
btree is updated accordingly.
- xfs_free_extent marks the original (un-merged) extent as "busy" by
xfs_extent_busy_insert(). This prevents this original extent from being
allocated. (Except that for metadata allocations such extent or part of it
can be "unbusied", while it is still not marked for discard with
XFS_EXTENT_BUSY_DISCARDED).
- Once the appropriate part of the log is committed, xlog_cil_committed
calls xfs_discard_extents. This discards the extents using the synchronous
blkdev_issue_discard() API, and only them "unbusies" the extents. This makes
sense, because we cannot allow allocating these extents until discarding
completed.

WRT to this flow, I have some questions:

- xfs_free_extent first inserts the extent into the free-space btrees, and
only then marks it as busy. How come there is no race window here? Can
somebody allocate the freed extent before it is marked as busy? Or the
free-space btrees somehow are locked at this point? The code says "validate
the extent size is legal now we have the agf locked". I more or less see
that xfs_alloc_fix_freelist() locks *something*, but I don't see
xfs_free_extent() unlocking anything.

- If xfs_extent_busy_insert() fails to alloc a xfs_extent_busy structure,
such extent cannot be discarded, correct?

- xfs_discard_extents() doesn't check the discard granularity of the
underlying block device, like xfs_ioc_trim() does. So it may send a small
discard request, which cannot be handled. If it would have checked the
granularity, it could have avoided sending small requests. But the thing is
that the busy extent might have been merged in the free-space btree into a
larger extent, which is now suitable for discard.

I want to attempt the following logic in xfs_discard_extents():
# search the "by-bno" free-space btree for a larger extent that fully
encapsulates the busy extent (which we want to discard)
# if found, check whether some other part of the larger extent is still busy
(except for the current busy extent we want to discard)
# if no, send discard for the larger extent
Does this make send? And I think that we need to hold the larger extent 
locked somehow until the
discard completes, to prevent allocation from the discarded range.

Can anybody please comment on these questions?

Thanks!
Alex. 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
