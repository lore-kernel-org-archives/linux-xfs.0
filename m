Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51086 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728055AbfGKOAS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jul 2019 10:00:18 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/3] xfs: Fix races between readahead and hole punching
Date: Thu, 11 Jul 2019 16:00:09 +0200
Message-Id: <20190711140012.1671-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-xfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, Boaz Harrosh <boaz@plexistor.com>, Jan Kara <jack@suse.cz>

Hello,

this is a patch series that addresses a possible race between readahead and
hole punching Amir has discovered [1]. The first patch makes madvise(2) to
handle readahead requests through fadvise infrastructure, the third patch
then adds necessary locking to XFS to protect against the race. Note that
other filesystems need similar protections but e.g. in case of ext4 it isn't
so simple without seriously regressing mixed rw workload performance so
I'm pushing just xfs fix at this moment which is simple.

								Honza

[1] https://lore.kernel.org/linux-fsdevel/CAOQ4uxjQNmxqmtA_VbYW0Su9rKRk2zobJmahcyeaEVOFKVQ5dw@mail.gmail.com/
