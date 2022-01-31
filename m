Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C4BC433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jan 2022 06:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357729AbiAaGnz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jan 2022 01:43:55 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36947 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1357759AbiAaGnz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jan 2022 01:43:55 -0500
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7F9CD10C46C9
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jan 2022 17:43:53 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nEQPo-006J3V-MM
        for linux-xfs@vger.kernel.org; Mon, 31 Jan 2022 17:43:52 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nEQPo-0036UO-Kv
        for linux-xfs@vger.kernel.org;
        Mon, 31 Jan 2022 17:43:52 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/5] xfs: fallocate() vs xfs_update_prealloc_flags()
Date:   Mon, 31 Jan 2022 17:43:45 +1100
Message-Id: <20220131064350.739863-1-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <164351876356.4177728.10148216594418485828.stgit@magnolia>
References: <164351876356.4177728.10148216594418485828.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=61f78529
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=DghFqjY3_ZEA:10 a=WrH18T77pny2e9YneIUA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

This is more along the lines of what I was thinking. Unfortunately,
xfs_fs_map_blocks() can't be made to use file based VFS helpers, so
the whole "open code the permissions stripping on data extent
allocation" thing needs to remain in that code. Otherwise, we can
significantly clean up xfs_file_fallocate() and completely remove
the entire transaction that sets the prealloc flag. And given that
xfs_ioc_space() no longer exists, most of the option functionality
that xfs_update_prealloc_flags() provides is no longer necessary...

This is only smoke tested so far, but I think it gets us the same
benefits but also makes the code a lot simpler at the same time.
Your thoughts?

-Dave.

