Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6497DC43460
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 11:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 314EC611BE
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 11:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240701AbhDFL43 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Apr 2021 07:56:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58366 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343607AbhDFL42 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Apr 2021 07:56:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617710181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=f5v2i9B8+MWA1Et7LCuECNHAOcKsQWJI8D+H1T85pRQ=;
        b=U58njVI5a2cfeq2Lp48YM/zXLcPJ0tjUatu1EDecIgT7t2fvwQlRhhORDSQsasO9K2Yfn3
        2FKfVx4fBD1dwnzTZpBVAY2AMf7PsL1I6YQ6jtvj4twyRtHhT8o9Y4ujh2YCE2LieIfPJo
        9hw/64Oj2ykfqnKfKPDym+LPm0OMlEg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-IFFFkHpmOeagQiE_e6Baxg-1; Tue, 06 Apr 2021 07:56:19 -0400
X-MC-Unique: IFFFkHpmOeagQiE_e6Baxg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52229E99C1
        for <linux-xfs@vger.kernel.org>; Tue,  6 Apr 2021 11:56:18 +0000 (UTC)
Received: from andromeda.redhat.com (unknown [10.40.192.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A444660937
        for <linux-xfs@vger.kernel.org>; Tue,  6 Apr 2021 11:56:17 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V2] Add dax mount option to man xfs(5)
Date:   Tue,  6 Apr 2021 13:56:12 +0200
Message-Id: <20210406115613.19211-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Details are already in kernel's documentation, but make dax mount option
information accessible through xfs(5) manpage.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

Changelog:
	V2:
	 - Add changes suggested by Darrick on his review.

 man/man5/xfs.5 | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
index 7642662f..372dc08a 100644
--- a/man/man5/xfs.5
+++ b/man/man5/xfs.5
@@ -133,6 +133,23 @@ by the filesystem.
 CRC enabled filesystems always use the attr2 format, and so
 will reject the noattr2 mount option if it is set.
 .TP
+.BR dax=value
+Set CPU direct access (DAX) behavior for the current filesystem. This mount
+option accepts the following values:
+
+"dax=inode" DAX will be enabled only on regular files with FS_XFLAG_DAX applied.
+
+"dax=never" DAX will not be enabled for any files. FS_XFLAG_DAX will be ignored.
+
+"dax=always" DAX will be enabled for all regular files, regardless of the
+FS_XFLAG_DAX state.
+
+If no option is used when mounting a filesystem stored on a DAX capable device,
+dax=inode will be used as default.
+
+For details regarding DAX behavior in kernel, please refer to kernel's
+documentation at filesystems/dax.txt
+.TP
 .BR discard | nodiscard
 Enable/disable the issuing of commands to let the block
 device reclaim space freed by the filesystem.  This is
-- 
2.30.2

