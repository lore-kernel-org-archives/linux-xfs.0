Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 355A4C7619A
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 03:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjDLDpi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 23:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDLDph (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 23:45:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7206330E0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 20:45:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CA2262B68
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 03:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68154C433D2;
        Wed, 12 Apr 2023 03:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681271135;
        bh=p018O0KDIHVz9AJeo+cUyOMtd6FJdvqNJEhGw02Q2N4=;
        h=Date:Subject:From:To:Cc:From;
        b=eZ3MQUt3BNZ1hm8kOohYWIg1VBVzMUv+6i5S96HooKrxQxSGqP0vmYHA8TgZ1RZhB
         uEUGLfW6TOnvhjRGxSny6UYzh8VwOLExYVrDCdpAJvnsxksRhSVXsJTDTKNXaBqqRF
         98g6CDQm6S9ad3G8McE8BWgsofKQ/WwxXlk3RvmkAX7+KvDGenLkzZ7upKqVNv9GV0
         dQrm/iqjvLBVYmkW3cjVAn4ydYi2Gd+/H69uSJPVsw3UKvih+Lld6jR5TXIs0IM0tX
         P5Q+UiIdRj02EoBqe+Ffsr5ZGnZfjf1BxJOH+q3OjsSOtIGeTArdOhO2uxueIVVene
         eJr2tnbqB6WcQ==
Date:   Tue, 11 Apr 2023 20:45:34 -0700
Subject: [GIT PULL 3/22] xfs: pass perag references around when possible
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@fromorbit.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <168127093954.417736.329214140924049645.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Please pull this branch with changes for xfs.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 00e7b3bac1dc8961bd5aa9d39e79131c6bd81181:

xfs: give xfs_refcount_intent its own perag reference (2023-04-11 18:59:55 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/pass-perag-refs-6.4_2023-04-11

for you to fetch changes up to 9b2e5a234c89f097ec36f922763dfa1465dc06f8:

xfs: create traced helper to get extra perag references (2023-04-11 18:59:55 -0700)

----------------------------------------------------------------
xfs: pass perag references around when possible [v24.5]

Avoid the cost of perag radix tree lookups by passing around active perag
references when possible.

v24.2: rework some of the naming and whatnot so there's less opencoding

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
xfs: create traced helper to get extra perag references

fs/xfs/libxfs/xfs_ag.c             | 13 +++++++++++++
fs/xfs/libxfs/xfs_ag.h             |  1 +
fs/xfs/libxfs/xfs_alloc_btree.c    |  4 +---
fs/xfs/libxfs/xfs_ialloc_btree.c   |  4 +---
fs/xfs/libxfs/xfs_refcount_btree.c |  5 +----
fs/xfs/libxfs/xfs_rmap_btree.c     |  5 +----
fs/xfs/xfs_iunlink_item.c          |  4 +---
fs/xfs/xfs_iwalk.c                 |  5 ++---
fs/xfs/xfs_trace.h                 |  1 +
9 files changed, 22 insertions(+), 20 deletions(-)

