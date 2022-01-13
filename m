Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75C85C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jan 2022 13:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235279AbiAMNhF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jan 2022 08:37:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235278AbiAMNhF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jan 2022 08:37:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642081024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1HzGMlj5VTj8Tt+8dSXpFSTHVt/zsoDcQbCs/pFikFc=;
        b=D/lWId9wD7MW/mM5j7LdhMsrz4lpo30EnHOmUYWOKHxcuFEqopX2yw2B0kuGircaGYVHBs
        tq+ZN0rgVMK88Pt1sHoNO1S7+yssFzVUYt7M3it/ZL+RAuzgqAhEuimzF/iuLtrH7Tt4dJ
        9lvS9QvB6LO0rUIZfX8nAdAGu1Mh9uU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-3jX10Af7PGWbs_M6w26M-Q-1; Thu, 13 Jan 2022 08:37:03 -0500
X-MC-Unique: 3jX10Af7PGWbs_M6w26M-Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9555F19251A7
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jan 2022 13:37:02 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53FA984A2A
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jan 2022 13:37:02 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] xfs: a couple misc/small deferred inactivation tweaks
Date:   Thu, 13 Jan 2022 08:36:59 -0500
Message-Id: <20220113133701.629593-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is just a couple small gc tweaks associated with deferred
inactivation. Patch 1 is intended to be a fix for a race described in
the commit log description. I think it's equivalent to the intent of the
current code, but could be mistaken. Patch 2 is intended to be a
usability improvement around freeze vs. inode reclaim given the new
behavior of the latter wrt deferred inactivation. Full disclosure: the
idea of patch 2 has previously shown to be contentious. My view is this
is a simple and incremental improvement over current upstream behavior,
so I'm posting it regardless. Feel free to drop it in favor of existing
behavior or something else.

Brian

Brian Foster (2):
  xfs: flush inodegc workqueue tasks before cancel
  xfs: run blockgc on freeze to avoid iget stalls after reclaim

 fs/xfs/xfs_icache.c | 22 ++++------------------
 fs/xfs/xfs_super.c  | 19 +++++++++++++++++--
 2 files changed, 21 insertions(+), 20 deletions(-)

-- 
2.31.1

