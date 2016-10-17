Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41523 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758949AbcJQUWh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 16:22:37 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: discard improvements
Date: Mon, 17 Oct 2016 22:22:30 +0200
Message-Id: <1476735753-5861-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: michaelcallahan@fb.com

This series improves XFS discard support so that we don't stall the
log commit thread and improve performance for workloads with lots
of deletions.

The first patch is a fix for a long-standing allocator issue when we
have busy extents in the way of an allocation.  Without the async
discard support it was harder to hit, but it's basically been there
since we added busy extent tracking and non-synchronous delete
transactions.

The second patch is the main async discard support, and the third
one allows to batch up multiple extents into a single discard bio,
which is a common occurance.

