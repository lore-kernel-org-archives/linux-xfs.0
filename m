Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3BF6C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 15:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 795CC64E1F
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 15:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237280AbhCOPDW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 11:03:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41450 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232697AbhCOPDA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Mar 2021 11:03:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615820579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SuUrfSUVYcvqwv+V2phKH037J7pY14xAe8WG1eVhE/c=;
        b=DQnYIPIDCk41hfB8RYKhWawr9utjDuInxz5wjKyvK5tebVPG9swPWtCCfMMLtJigEQOnl8
        pPJab1NelT8v4iZxnOTT/Y1yxQIBagSNYauEinpof8uQMUx1kNzgPdN80BqHkNFG+aOG5j
        fH7Z12rNIrhEFnzLb62nWVBpchBln+s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-b6xBBW-6MeOQ2XkeiepQaw-1; Mon, 15 Mar 2021 11:02:57 -0400
X-MC-Unique: b6xBBW-6MeOQ2XkeiepQaw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97C8081426D
        for <linux-xfs@vger.kernel.org>; Mon, 15 Mar 2021 15:02:56 +0000 (UTC)
Received: from andromeda.lan (unknown [10.40.194.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF4216B8E5
        for <linux-xfs@vger.kernel.org>; Mon, 15 Mar 2021 15:02:55 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] Add dax mount option to man xfs(5)
Date:   Mon, 15 Mar 2021 16:02:50 +0100
Message-Id: <20210315150250.11870-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Details are already in kernel's documentation, but make dax mount option
information accessible through xfs(5) manpage.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 man/man5/xfs.5 | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
index 7642662f..46b0558a 100644
--- a/man/man5/xfs.5
+++ b/man/man5/xfs.5
@@ -133,6 +133,24 @@ by the filesystem.
 CRC enabled filesystems always use the attr2 format, and so
 will reject the noattr2 mount option if it is set.
 .TP
+.BR dax=value
+Set DAX behavior for the current filesystem. This mount option accepts the
+following values:
+
+"dax=inode" DAX will be enabled only on files with FS_XFLAG_DAX applied.
+
+"dax=never" DAX will be disabled by the whole filesystem including files with
+FS_XFLAG_DAX applied"
+
+"dax=always" DAX will be enabled to every file in the filesystem inclduing files
+without FS_XFLAG_DAX applied"
+
+If no option is used when mounting a pmem device, dax=inode will be used as
+default.
+
+For details regarding DAX behavior in kernel, please refer to kernel's
+documentation at filesystems/dax.txt
+.TP
 .BR discard | nodiscard
 Enable/disable the issuing of commands to let the block
 device reclaim space freed by the filesystem.  This is
-- 
2.29.2

