Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1735BC64E7A
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 19:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A52FD2168B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 19:22:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GEtquvnk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731223AbgLATWZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 14:22:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54425 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731228AbgLATWY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 14:22:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606850458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6/IyALS7KHJ2Olm3ECqctIZehuWkeHoDQYSyBlXhYNE=;
        b=GEtquvnkkvHG8rXmbKf+5AxE29IbtT76KIDxmT1CwCWQ9EDOK3/GZPVG6MY+kN9a/KwmDj
        txSLX6XSlIoQnI48P2eSRaimOmQTNQASTXMfIl4+3yZtEVZlukxsymhZnlmZR1Kw8SqKqU
        ru4L/lbPszA2tXQwfka5ixug5UG+AGY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-if_ZwcopP6Oay9oNERmmiQ-1; Tue, 01 Dec 2020 14:20:56 -0500
X-MC-Unique: if_ZwcopP6Oay9oNERmmiQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0349805BE8
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 19:20:55 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C78546086F
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 19:20:55 +0000 (UTC)
Subject: [RFC PATCH 2/2] xfs: do not allow reflinking inodes with the dax flag
 set
From:   Eric Sandeen <sandeen@redhat.com>
To:     xfs <linux-xfs@vger.kernel.org>
References: <1d87a83e-ba03-b735-f19a-955a09bcdcf7@redhat.com>
Message-ID: <07c41ba8-ecb7-5042-fa6c-dd8c9754b824@redhat.com>
Date:   Tue, 1 Dec 2020 13:20:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <1d87a83e-ba03-b735-f19a-955a09bcdcf7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Today, xfs_reflink_remap_prep() will reject inodes which are in the CPU
direct access state, i.e. IS_DAX() is true.  However, it is possible to
have inodes with the XFS_DIFLAG2_DAX set, but which are not activated as
dax, due to the dax=never mount option, or due to the flag being set after
the inode was loaded.

To avoid confusion and make the lack of dax+reflink crystal clear for the
user, reject reflink requests for both IS_DAX and XFS_DIFLAG2_DAX inodes.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

This is RFC because as Darrick says, it introduces a new failure mode for
reflink. On the flip side, today the user can reflink a chattr +x'd file,
but cannot chattr +x a reflinked file, which seems a best a bit asymmetrical
and confusing... see xfs_ioctl_setattr_xflags()

 fs/xfs/xfs_reflink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 6fa05fb78189..b69dbb992b0c 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1308,6 +1308,11 @@ xfs_reflink_remap_prep(
 	if (IS_DAX(inode_in) || IS_DAX(inode_out))
 		goto out_unlock;
 
+	/* Until we have dax+reflink don't even allow the flags to co-exist */
+	if (src->i_d.di_flags2 & XFS_DIFLAG2_DAX ||
+	    dest->i_d.di_flags2 & XFS_DIFLAG2_DAX)
+		goto out_unlock;
+
 	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
 			len, remap_flags);
 	if (ret || *len == 0)
-- 
2.17.0

