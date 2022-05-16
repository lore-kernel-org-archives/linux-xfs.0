Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16470C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 03:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239667AbiEPDcV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 May 2022 23:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239665AbiEPDcU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 May 2022 23:32:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9CF1FCC1
        for <linux-xfs@vger.kernel.org>; Sun, 15 May 2022 20:32:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79B2260ECC
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 03:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD429C385AA;
        Mon, 16 May 2022 03:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652671938;
        bh=Dq5TTP/uWneOkvd7NaAdWwP5VlD+uOinmw66BjIKFoI=;
        h=Subject:From:To:Cc:Date:From;
        b=Ca55WKhTi89+fgP77021j1i9CyGnyfCNxCRu7bk21zcFiinuqb5O6gkwfNEs8ttEn
         RSbCO47ZgltUSueKNqDDdJW2hp6Y9KWhaZ6ph9WOif3u61pO82gbTClSTr39GAndUV
         S9GrKGEr6RWqgzDpdX2ypZDXmEu+gTH/BgQepQbmME2NNBf7dmPDdDIl6+duorQ8kF
         D8lsQ9R33Ol1u6pguRfxvBJf113hEVo1YIlToDJvZO1Sxius6hLKOVV+Voq2l0nwiI
         6QrdsZ0R18vSRSdndstRDYB6nXlLeJ9s6n0ZZon1avbQuO9m5ya4Ox5YWhcmwkA/8x
         RR/OslQrsLQUw==
Subject: [PATCHSET 0/6] xfs: cleanups for logged xattr updates
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 15 May 2022 20:32:18 -0700
Message-ID: <165267193834.626272.10112290406449975166.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are a bunch of cleanups to the logged xattr code to use slab caches
for better memory efficiency, reduce the size of the attr intent
tracking structure, fix some wonkinessin the attri/attrd cache
constructors, and give things more appropriat enames.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D
---
 fs/xfs/libxfs/xfs_attr.c        |  165 +++++++++++++++++----------------------
 fs/xfs/libxfs/xfs_attr.h        |   54 +++++--------
 fs/xfs/libxfs/xfs_attr_remote.c |    6 +
 fs/xfs/libxfs/xfs_attr_remote.h |    6 +
 fs/xfs/libxfs/xfs_da_btree.c    |   11 +++
 fs/xfs/libxfs/xfs_da_btree.h    |    1 
 fs/xfs/libxfs/xfs_defer.c       |    8 --
 fs/xfs/libxfs/xfs_log_format.h  |    8 +-
 fs/xfs/xfs_attr_item.c          |   56 +++++++------
 fs/xfs/xfs_attr_item.h          |    9 +-
 fs/xfs/xfs_super.c              |   19 ++++
 11 files changed, 176 insertions(+), 167 deletions(-)

