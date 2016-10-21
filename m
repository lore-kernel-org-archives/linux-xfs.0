Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53435 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753520AbcJUQuL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2016 12:50:11 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: remove the XFS iolock, V2
Date: Fri, 21 Oct 2016 18:50:04 +0200
Message-Id: <1477068606-21936-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: peterz@infradead.org

Hi all,

this series remove the per-inode iolock in XFS which has historically
been used to serialize I/O.  But now that the VFS i_mutex has been
replaced with a rw_semaphore called i_rwsem there is no need to keep
the XFS lock - by relying on the VFS i_rwsem we unify the locking
constraints between difference file systems, reduce the XFS inode size
and reduce the amount of atomic instruction we do with every read
or write call.

Note that Dave asked to kill the XFS mrlock first the last time this
series was posted - while that seems desirable it's not easily possible
due to the way XFS may offload allocator work to a workqueues, and how
lockdep doesn't recognize that.  As removing mrlocks entirely would
be just a cleanup without an affect on locking hierchies or inode
size reduction (except for debug builds) I would prefer to get this
series to remove the iolock in first, and then see what we can do about
the two remaining mrlocks later.

