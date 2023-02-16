Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 592A9C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjBPU1G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBPU1F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:27:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357894DE23
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:26:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAC21B82992
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01E0C433D2;
        Thu, 16 Feb 2023 20:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579216;
        bh=A4RRNpIeZbXfWmDdIgKgFfh9SX2Hr++KyJ6C3pQ2yNw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=H3CHhImroVNuXJ0AmzlMNOwsvlK6bXEhrRJLeV1u0hG0oApXZ0nuBs0DON6zvIpfK
         Axi/FaTtEkx7lglVNM5ZjRPhKmeyQmIObMIC1eQly5MPa+Ltqb6d78HZn/utwWV1ym
         iP5W3iIksgaZBeD1dWnTOk0WeBJdzB7mn0U9bzLdkhHCHgOCOlIXz8Ynk0JzDgacvh
         WI7QfAm9AWQA+tUJbrfsCyhOqKsiBQedGrpdsnoTgx90PuHg8aKUsVL6xx9eGSqB83
         T4Dv7logm1eEfNXY4Dd3Z3mHrMUHX2w2nDqYA4xelxAl1cGHyxGGiBVNV9jLt8Xjg3
         BNkTPydp0Qp7A==
Date:   Thu, 16 Feb 2023 12:26:56 -0800
Subject: [PATCHSET v9r2d1 0/4] xfs: rework the GETPARENTS ioctl
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657873432.3474196.15004300376430244372.stgit@magnolia>
In-Reply-To: <Y+6MxEgswrJMUNOI@magnolia>
References: <Y+6MxEgswrJMUNOI@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series fixes a few bugs that I found in the XFS_IOC_GETPARENTS
implementation.  It also reworks the xfs_attr_list implementations to
provide an xattr value pointer when available, and finally it reworks
the whole implementation to take advantage of this and use less memory.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-ioctl
---
 fs/xfs/libxfs/xfs_attr.h    |    5 +
 fs/xfs/libxfs/xfs_attr_sf.h |    1 
 fs/xfs/libxfs/xfs_parent.c  |   40 +++++++--
 fs/xfs/libxfs/xfs_parent.h  |   21 ++++-
 fs/xfs/scrub/attr.c         |    8 ++
 fs/xfs/xfs_attr_list.c      |    8 ++
 fs/xfs/xfs_ioctl.c          |   40 ++++++---
 fs/xfs/xfs_parent_utils.c   |  184 ++++++++++++++++++++++++-------------------
 fs/xfs/xfs_parent_utils.h   |    4 -
 fs/xfs/xfs_trace.c          |    1 
 fs/xfs/xfs_trace.h          |   73 +++++++++++++++++
 fs/xfs/xfs_xattr.c          |    1 
 12 files changed, 272 insertions(+), 114 deletions(-)

