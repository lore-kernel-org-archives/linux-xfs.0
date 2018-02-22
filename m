Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44736 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932828AbeBVPaH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 10:30:07 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: lazytime for XFS
Date: Thu, 22 Feb 2018 07:29:55 -0800
Message-Id: <20180222152957.19624-1-hch@lst.de>
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
