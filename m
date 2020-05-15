Return-Path: <SRS0=g8AD=65=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 990FDC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 19:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66DF420758
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 19:14:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZvM8f8Ij"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgEOTOW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 May 2020 15:14:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41592 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726198AbgEOTOW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 May 2020 15:14:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589570061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=jFunLvmtUHXpwZzqPZW4iTFrNxcddW9zqBL2xmAe29E=;
        b=ZvM8f8IjwSadp6KE9eW4WMl6NDOKAHkU9FDG5qdPvZwdjnYME0R9mNcsxar0KctF3fYmtY
        yprgRT61+Hjwb7rjjNb9Gb4047TI0Xwbq5qYPNswKTBxgcgEp7VxD67zUN6MvnKMVIrfHL
        rT2lK329LbqkP9MDlYtheeJ9cbpn4yY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-YBjeorSTMCmXWL-s3zGIUw-1; Fri, 15 May 2020 15:14:19 -0400
X-MC-Unique: YBjeorSTMCmXWL-s3zGIUw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5978F83DA41
        for <linux-xfs@vger.kernel.org>; Fri, 15 May 2020 19:14:18 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3272F1024837
        for <linux-xfs@vger.kernel.org>; Fri, 15 May 2020 19:14:18 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mkfs.xfs: sanity check stripe geometry from blkid
Message-ID: <a673fbd3-5038-2dc8-8135-a58c24042734@redhat.com>
Date:   Fri, 15 May 2020 14:14:17 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We validate commandline options for stripe unit and stripe width, and
if a device returns nonsensical values via libblkid, the superbock write
verifier will eventually catch it and fail (noisily and cryptically) but
it seems a bit cleaner to just do a basic sanity check on the numbers
as soon as we get them from blkid, and if they're bogus, ignore them from
the start.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libfrog/topology.c b/libfrog/topology.c
index b1b470c9..38ed03b7 100644
--- a/libfrog/topology.c
+++ b/libfrog/topology.c
@@ -213,6 +213,19 @@ static void blkid_get_topology(
 	val = blkid_topology_get_optimal_io_size(tp);
 	*swidth = val;
 
+        /*
+	 * Occasionally, firmware is broken and returns optimal < minimum,
+	 * or optimal which is not a multiple of minimum.
+	 * In that case just give up and set both to zero, we can't trust
+	 * information from this device. Similar to xfs_validate_sb_common().
+	 */
+        if (*sunit) {
+                if ((*sunit > *swidth) || (*swidth % *sunit != 0)) {
+                        *sunit = 0;
+                        *swidth = 0;
+                }
+        }
+
 	/*
 	 * If the reported values are the same as the physical sector size
 	 * do not bother to report anything.  It will only cause warnings

