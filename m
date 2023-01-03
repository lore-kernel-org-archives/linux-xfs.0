Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C760C3DA7D
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Jan 2023 18:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjACSad (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Jan 2023 13:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbjACSac (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jan 2023 13:30:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD9BA8
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jan 2023 10:30:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6226B81058
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jan 2023 18:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7315BC433EF;
        Tue,  3 Jan 2023 18:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672770629;
        bh=qzYXxcRqXTFri65Jyv2HHpR9TASkImY1Tx6tArIuLQ4=;
        h=Date:From:To:Cc:Subject:From;
        b=AyA574J+sOEq7LRafQfLzL+YSBCPwW0VV+a48GdhNXSXP4zk0cLvtTXDbu3wF3jfu
         qv8Jg34yO9HOd7QPTY8+Y0kGYJ2WqH7OLPfOKi1YKp70S40NtIWbzEmo379K3NyNsE
         pdRsRVTdnpG8MSdzc3qTb96OIqXvY8ghrLjud706lZhwQmDXlwpW+F/Yu4fBhUuH1O
         DC+buOTVMAFYCAeib1LFaYnxPvT87NiC7HhgdG9BnvECgMrxFr/DGdlaeaHFH9PlSL
         aEoSg7qwQt4VJrIE5BG7QrXa8d0ORMqdEI/w/0n+awtE21ic/RGpcTPGsUxtr9KMNk
         VkNUEc0CoPa1Q==
Date:   Tue, 3 Jan 2023 10:30:29 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     david@fromorbit.com, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, shiina.hironori@fujitsu.com,
        wuguanghao3@huawei.com, zeming@nfschina.com
Subject: [ANNOUNCE] xfs-linux: for-next updated to e195605ed28b
Message-ID: <167277043338.2757622.9329696766206812287.stg-ugh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

e195605ed28b xfs: xfs_qm: remove unnecessary ‘0’ values from error

6 new commits:

Darrick J. Wong (3):
[26870c3f5b15] xfs: don't assert if cmap covers imap after cycling lock
[d4542f314507] xfs: make xfs_iomap_page_ops static
[c0f399ff5149] xfs: fix off-by-one error in xfs_btree_space_to_height

Hironori Shiina (1):
[817644fa4525] xfs: get root inode correctly at bulkstat

Li zeming (1):
[e195605ed28b] xfs: xfs_qm: remove unnecessary ‘0’ values from error

Wu Guanghao (1):
[4da112513c01] xfs: Fix deadlock on xfs_inodegc_worker

Code Diffstat:

fs/xfs/libxfs/xfs_btree.c |  7 ++++++-
fs/xfs/xfs_icache.c       | 10 ++++++++++
fs/xfs/xfs_ioctl.c        |  4 ++--
fs/xfs/xfs_iomap.c        |  2 +-
fs/xfs/xfs_qm.c           |  2 +-
fs/xfs/xfs_reflink.c      |  2 --
6 files changed, 20 insertions(+), 7 deletions(-)

