Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BFD4C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 20:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C9E5204EA
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 20:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgHXUhs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 16:37:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:42344 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHXUhr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Aug 2020 16:37:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CACF6AC8B;
        Mon, 24 Aug 2020 20:38:16 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/6] xfsprogs: blockdev dax detection and warnings
Date:   Mon, 24 Aug 2020 22:37:18 +0200
Message-Id: <20200824203724.13477-1-ailiop@suse.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This short series adds blockdev dax capability detection via libblkid,
and subsequently uses this bit to warn on a couple of incompatible
configurations during mkfs.

The first patch adds the detection capability to libtopology, and the
following two patches add mkfs warnings that are issued when the fs
block size is not matching the page size, and when reflink is being
enabled in conjunction with dax.

The next patch adds a new cli option that can be used to override
warnings, and converts all warnings that can be forced to this option
instead the overloaded -f option. This avoids cases where forcing a
warning may also be implicitly forcing overwriting an existing
partition.

The last two patches are small cleanups that remove redundant code.

Anthony Iliopoulos (6):
  libfrog: add dax capability detection in topology probing
  mkfs: warn if blocksize doesn't match pagesize on dax devices
  mkfs: warn if reflink option is enabled on dax-capable devices
  mkfs: introduce -x option to force incompat config combinations
  mkfs: remove redundant assignment of cli sb options on failure
  mkfs: remove a couple of unused function parameters

 include/builddefs.in |  1 +
 libfrog/Makefile     |  4 ++++
 libfrog/topology.c   | 21 +++++++++++------
 libfrog/topology.h   |  1 +
 m4/package_blkid.m4  |  5 ++++
 man/man8/mkfs.xfs.8  |  6 +++++
 mkfs/xfs_mkfs.c      | 55 +++++++++++++++++++++++++++++---------------
 7 files changed, 68 insertions(+), 25 deletions(-)

--
2.28.0
