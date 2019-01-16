Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733118AbfAPNfk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Jan 2019 08:35:40 -0500
Date: Wed, 16 Jan 2019 13:35:38 +0000
From: Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 1/4] xfs: eof trim writeback mapping as soon as it is cached
In-Reply-To: <20190111123032.31538-2-bfoster@redhat.com>
References: <20190111123032.31538-2-bfoster@redhat.com>
Message-Id: <20190116133539.7BD5620675@mail.kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sasha Levin <sashal@kernel.org>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Cc: stable@vger.kernel.orgstable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 40214d128e07 xfs: trim writepage mapping to within eof.

The bot has tested the following trees: v4.20.2, v4.19.15, v4.14.93, v4.9.150.

v4.20.2: Build OK!
v4.19.15: Build OK!
v4.14.93: Failed to apply! Possible dependencies:
    2d5f4b5bebcc ("xfs: remove unused parameter from xfs_writepage_map")
    5c665e5b5af6 ("xfs: remove xfs_map_cow")
    70c57dcd606f ("xfs: skip CoW writes past EOF when writeback races with truncate")
    a7b28f72ab90 ("xfs: don't use XFS_BMAPI_IGSTATE in xfs_map_blocks")
    b4d8ad7fd3a1 ("xfs: fix s_maxbytes overflow problems")

v4.9.150: Failed to apply! Possible dependencies:
    08438b1e386b ("xfs: plumb in needed functions for range querying of the freespace btrees")
    092d5d9d5812 ("xfs: cleanup xfs_reflink_find_cow_mapping")
    11ef38afe98c ("xfs: make xfs btree stats less huge")
    2d5f4b5bebcc ("xfs: remove unused parameter from xfs_writepage_map")
    5c665e5b5af6 ("xfs: remove xfs_map_cow")
    70c57dcd606f ("xfs: skip CoW writes past EOF when writeback races with truncate")
    755c7bf5ddca ("libxfs: convert ushort to unsigned short")
    a7b28f72ab90 ("xfs: don't use XFS_BMAPI_IGSTATE in xfs_map_blocks")
    af7d20fd83d9 ("xfs: make xfs_btree_magic more generic")
    b4d8ad7fd3a1 ("xfs: fix s_maxbytes overflow problems")
    c8ce540db5f6 ("xfs: remove double-underscore integer types")
    cae028df5344 ("xfs: optimise CRC updates")


How should we proceed with this patch?

--
Thanks,
Sasha
