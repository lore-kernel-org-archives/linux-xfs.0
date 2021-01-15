Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC95C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Jan 2021 10:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56B0A23603
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Jan 2021 10:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbhAOKa1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Jan 2021 05:30:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37037 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726385AbhAOKa0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jan 2021 05:30:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610706540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
        bh=wdP4iQmlD8iZLG+/IFm/8BjMWp+1e9cT0sOwqRGIZhM=;
        b=JpLKl9BM75UbosSuIwaJgZEss+/sAdIB0aJ2cb/Zy/HPHq3zTQD9YGADRrvEzL4HgdF/so
        HsDGkKqmTBiBtaDQPBgpZnc8asJuuaJhMfDnFYf/O26nWcTpZ64h44rKCmTpajzsdkZnTn
        bAvWD8wE75ud24tWDT7qFZyO/9l3SRQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-EsuUS2OWPVi7v1XvStxGvQ-1; Fri, 15 Jan 2021 05:28:56 -0500
X-MC-Unique: EsuUS2OWPVi7v1XvStxGvQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50155A0C06;
        Fri, 15 Jan 2021 10:28:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 39DB750DD6;
        Fri, 15 Jan 2021 10:28:55 +0000 (UTC)
Received: from zmail26.collab.prod.int.phx2.redhat.com (zmail26.collab.prod.int.phx2.redhat.com [10.5.83.33])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1A7514BB7B;
        Fri, 15 Jan 2021 10:28:55 +0000 (UTC)
Date:   Fri, 15 Jan 2021 05:28:55 -0500 (EST)
From:   Yumei Huang <yuhuang@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com, sandeen@sandeen.net, bfoster@redhat.com
Message-ID: <1492355130.64829487.1610706535069.JavaMail.zimbra@redhat.com>
In-Reply-To: <316142100.64829455.1610706461022.JavaMail.zimbra@redhat.com>
Subject: [PATCH] xfs: Fix assert failure in xfs_setattr_size()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.72.13.201, 10.4.195.28]
Thread-Topic: Fix assert failure in xfs_setattr_size()
Thread-Index: IVfCrl9xjGlgng/OgkOngutZXxrZtw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

An assert failure is triggered by syzkaller test due to
ATTR_KILL_PRIV is not cleared before xfs_setattr_size.
As ATTR_KILL_PRIV is not checked/used by xfs_setattr_size,
just remove it from the assert.

Signed-off-by: Yumei Huang <yuhuang@redhat.com>
---
 fs/xfs/xfs_iops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 67c8dc9..f1e21b6 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -846,7 +846,7 @@
         ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
         ASSERT(S_ISREG(inode->i_mode));
         ASSERT((iattr->ia_valid & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
-                ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
+                ATTR_MTIME_SET|ATTR_TIMES_SET)) == 0);
 
         oldsize = inode->i_size;
         newsize = iattr->ia_size;
-- 
1.8.3.1

