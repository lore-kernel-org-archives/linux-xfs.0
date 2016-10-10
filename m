Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37334 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752047AbcJJNiK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 09:38:10 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: optimize the COW I/O path
Date: Mon, 10 Oct 2016 15:37:56 +0200
Message-Id: <1476106685-29048-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

This series contains a couple optimizations for the COW I/O path:

 - avoid any overhead for reads from COW files
 - streamline the COW handling in write_begin
 - reduce the number of extent lookups during COW I/O completion

It does not touch the direct I/O path (yet), I still have a few
unsolved problems there.

