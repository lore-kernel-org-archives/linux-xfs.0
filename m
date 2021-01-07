Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7822C4360C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 21:38:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBA5B23601
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 21:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbhAGViE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jan 2021 16:38:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59820 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726948AbhAGViE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jan 2021 16:38:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610055397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6y2EmEKtACttD78X+2J3drSE7+qMQxO5zbf7lMSi8Os=;
        b=hb442w694CknWv5p8jGwk3I7aYRZWkWxMrg4tCfpRCqvMXkwcBOnUCXiYtvgU7/Q/Yhjg5
        jITShiQj3WiGw0If6FSJDEo8jgSJHBebTLEssau68kmb8NfKcDGz6vtruIMoDAvN3fc9Ta
        /DxNRVMXuv8gPzWmuRdBCEHuH6abyV4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-KUy4Sxl5MbKcFNZN0YZAWw-1; Thu, 07 Jan 2021 16:36:35 -0500
X-MC-Unique: KUy4Sxl5MbKcFNZN0YZAWw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B99568030AF;
        Thu,  7 Jan 2021 21:36:34 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8196810013BD;
        Thu,  7 Jan 2021 21:36:34 +0000 (UTC)
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] xfs: do not allow reflinking inodes with the dax flag set
Message-ID: <862a665f-3f1b-64e0-70eb-00cc35eaa2df@redhat.com>
Date:   Thu, 7 Jan 2021 15:36:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Today, xfs_reflink_remap_prep() will reject inodes which are in the CPU
direct access state, i.e. IS_DAX() is true.  However, it is possible to
have inodes with the XFS_DIFLAG2_DAX set, but which are not activated as
dax, due to the flag being set after the inode was loaded.

To avoid confusion and make the lack of dax+reflink crystal clear for the
user, reject reflink requests for both IS_DAX and XFS_DIFLAG2_DAX inodes
unless DAX mode is impossible due to mounting with -o dax=never.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
V2: Allow reflinking dax-flagged inodes in "mount -o dax=never" mode

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 6fa05fb78189..e238a5b7b722 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1308,6 +1308,15 @@ xfs_reflink_remap_prep(
 	if (IS_DAX(inode_in) || IS_DAX(inode_out))
 		goto out_unlock;
 
+	/*
+	 * Until we have dax+reflink, don't allow reflinking dax-flagged
+	 * inodes unless we are in dax=never mode.
+	 */
+	if (!(mp->m_flags & XFS_MOUNT_DAX_NEVER) &&
+	     (src->i_d.di_flags2 & XFS_DIFLAG2_DAX ||
+	      dest->i_d.di_flags2 & XFS_DIFLAG2_DAX))
+		goto out_unlock;
+
 	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
 			len, remap_flags);
 	if (ret || *len == 0)

