Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E9A6C433E6
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 17:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC8A423130
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 17:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbhAFRm5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Jan 2021 12:42:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51363 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727205AbhAFRm5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jan 2021 12:42:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609954891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=II1G2dGNYp5kbwIoBIkpJ/aLkaJfoH1OJdrkaPUSTWY=;
        b=Mi4PVa1zfQYBgSyr0xuoYNEtlborgom9PyKGpQYXW///p8B0Z5rnjsl25FV1hy+wc/cS9w
        7ji0zhd/z4p/LcnPDUZdOow/Rh+/Iie00YOU/PreC/5Eqy5UTqbJN9kUbpRobg70JVVaSJ
        9mWox57kP+Ffr3Iql6SOqbrYMntwP3c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-Rs4IStAKMf6UVpUOzMLONg-1; Wed, 06 Jan 2021 12:41:29 -0500
X-MC-Unique: Rs4IStAKMf6UVpUOzMLONg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E9BE9CDA2
        for <linux-xfs@vger.kernel.org>; Wed,  6 Jan 2021 17:41:28 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 223D118A9D
        for <linux-xfs@vger.kernel.org>; Wed,  6 Jan 2021 17:41:28 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/9] xfs: rework log quiesce to cover the log
Date:   Wed,  6 Jan 2021 12:41:18 -0500
Message-Id: <20210106174127.805660-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series modifies the log quiesce code path to cover the log instead
of mark it clean and separates the latter into a distinct step. This
allows existing users to determine whether to quiesce (i.e. cover) or
clean the log depending on the operation, and thus avoids the need for
contexts like freeze to have to redirty the log after a quiesce.

By covering the log on quiesce, we can also fold final superblock
updates (i.e., lazy superblock counters) into the quiesce sequence
because covering uses the same superblock transaction as the explicit
superblock updates. This same approach can accommodate (probably with
some additional tweaks) future final superblock updates, such as for log
feature compatibility bit management when the log is cleared of
incompatible items.

Patch 1 is a repost of a lazy sb accounting bug fix that was previously
sent (included here as a dependency). Patches 2-3 make some preliminary
cleanups. Patch 4 injects log covering into the log quiesce sequence.
Patches 5-6 fold the existing lazy superblock accounting update into
quiesce. Patches 7-8 make some final refactoring cleanups (these two
patches could probably be squashed now that I look at them again).
Finally, patch 9 updates fs freeze to cover the log instead of cleaning
and redirtying it.

Thoughts, reviews, flames appreciated.

Brian

Brian Foster (9):
  xfs: sync lazy sb accounting on quiesce of read-only mounts
  xfs: lift writable fs check up into log worker task
  xfs: separate log cleaning from log quiesce
  xfs: cover the log during log quiesce
  xfs: don't reset log idle state on covering checkpoints
  xfs: fold sbcount quiesce logging into log covering
  xfs: remove duplicate wq cancel and log force from attr quiesce
  xfs: remove xfs_quiesce_attr()
  xfs: cover the log on freeze instead of cleaning it

 fs/xfs/xfs_log.c   | 122 +++++++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_log.h   |   4 +-
 fs/xfs/xfs_mount.c |  34 +------------
 fs/xfs/xfs_mount.h |   1 -
 fs/xfs/xfs_super.c |  38 +-------------
 5 files changed, 106 insertions(+), 93 deletions(-)

-- 
2.26.2

