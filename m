Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55058 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933180AbeB1R5n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Feb 2018 12:57:43 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: lazytime for XFS V2
Date: Wed, 28 Feb 2018 09:57:35 -0800
Message-Id: <20180228175737.317-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>

Hi all,

this series implements the lazytime feature for XFS.  Unlike ext4 we don't
bother supporting the file system parsed text option as MS_LAZYTIME has
been supported by util-linux for a long time now.  The first patch is
needed to make sure XFS actually sees that a dirty inode was dirtied due
to lazy time, which is important for XFS as we don't otherwise use the
VFS inode dirty tracking for metadata.

Changes since V1:
 - fix i_version logging in xfs_vn_update_time,
 - document the racy I_DIRTY_TIME check
