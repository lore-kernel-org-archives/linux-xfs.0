Return-Path: <SRS0=yY6+=BX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D25DC433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 14:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3413020791
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 14:26:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BQR4y+LR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgHMO0s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Aug 2020 10:26:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54710 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726082AbgHMO0r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Aug 2020 10:26:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597328806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=++1bWx9Bj6bU4gRRj0LZq5QeusbZgbZx9UAC22MiD7E=;
        b=BQR4y+LR9NfCK/XVJrPUsYO6pN9ykBO3g6dgkIex6OybKi+EEDjZ/2f+DvuAFBHhEx8I6U
        ffAV1vomy1CqlyhTnWqgW/26K8yV/kYKz8EV5hG2yFlPSHQdZL8KM1xLPGfNojFhtQavfd
        RHVcQ8GFllznVEjhJVMRhegol3xTVBI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-eeg6H7iDNHqnHF-uPEkXWA-1; Thu, 13 Aug 2020 10:26:44 -0400
X-MC-Unique: eeg6H7iDNHqnHF-uPEkXWA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0574F100CF64
        for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2020 14:26:44 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.195.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F3F95B696
        for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2020 14:26:42 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] Get rid of kmem_realloc()
Date:   Thu, 13 Aug 2020 16:26:38 +0200
Message-Id: <20200813142640.47923-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks.

This is just to give continuity to the kmem cleanup. This series get rid of
kmem_realloc() and its users.

Patches have been tested with xfstests, no issues reported so far.

Cheers

Carlos Maiolino (2):
  xfs: remove kmem_realloc() users
  xfs: remove kmem_realloc()

 fs/xfs/kmem.c                  | 22 ----------------------
 fs/xfs/kmem.h                  |  1 -
 fs/xfs/libxfs/xfs_iext_tree.c  |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.c |  8 ++++----
 fs/xfs/xfs_log_recover.c       |  2 +-
 fs/xfs/xfs_mount.c             |  4 ++--
 fs/xfs/xfs_trace.h             |  1 -
 7 files changed, 8 insertions(+), 32 deletions(-)

-- 
2.26.2

