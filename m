Return-Path: <SRS0=YlU2=7J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D999FC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 May 2020 17:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4ACD2065F
	for <linux-xfs@archiver.kernel.org>; Wed, 27 May 2020 17:26:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cyFmyOZw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgE0R0V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 May 2020 13:26:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24861 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728042AbgE0R0U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 May 2020 13:26:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590600379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=4WIzwGvE0rYHEe1oivdeqdDndbIeLP4IthkubW34TM4=;
        b=cyFmyOZw0IBWUuR79rG2/BkkvBzSdnzyc8wMEG8oLtuIPvw6Ak36R9I/TGSnsChUHBU2BS
        85/i61eaNkJaoxyWAFxTiWyOvpOAeAwniRk1ocOMqOAtAue6E1shS2Y4KjiiSvNQNhROHv
        LjIOLHARqy0sTSB/2/xA/Ml3dX1k970=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-22Bv_aO_OIeNf5_cAguIrw-1; Wed, 27 May 2020 13:26:17 -0400
X-MC-Unique: 22Bv_aO_OIeNf5_cAguIrw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66A20835B44
        for <linux-xfs@vger.kernel.org>; Wed, 27 May 2020 17:26:16 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1434A1A8F5
        for <linux-xfs@vger.kernel.org>; Wed, 27 May 2020 17:26:16 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH RFC] mkfs.xfs: do not set log stripe unit for probed sw <= 2
Message-ID: <08ddc67b-392f-efe0-ffd2-a7295a42bac6@redhat.com>
Date:   Wed, 27 May 2020 12:26:15 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If the stripe width of a device is only 2x or 1x the stripe unit, there
is no parity disk on this device, and setting a larger log stripe unit
will not avoid any RMW cycles.  However, a large log stripe unit does
have significant penalties for IO amplification because every log write
will be rounded up to the log stripe unit.

This was recently highlighted by a user running bonnie++ in sync mode,
where the default RAID10 geometry of 256k/512k yielded results which
were 4x slower than a smaller log stripe unit. While bonnie++ may not
be the benchmark of choice, it does highlight this issue.

Because a larger log stripe unit yields no RMW benefit on a device with
no parity disks, avoid setting in these cases.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

... thoughts?

Am I missing a reason why we /would/ still want lsunit in this case?

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2e6cd280..4da69b29 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2407,13 +2407,15 @@ _("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
 	}
 
 	/*
-	 * check that log sunit is modulo fsblksize or default it to dsunit.
+	 * check that log sunit is modulo fsblksize or default it to dsunit
+	 * if this looks like a parity device (swidth > 2x sunit).
 	 */
 	if (lsunit) {
 		/* convert from 512 byte blocks to fs blocks */
 		cfg->lsunit = DTOBT(lsunit, cfg->blocklog);
 	} else if (cfg->sb_feat.log_version == 2 &&
-		   cfg->loginternal && cfg->dsunit) {
+		   cfg->loginternal && cfg->dsunit &&
+		   (cfg->dswidth / cfg->dsunit > 2)) {
 		/* lsunit and dsunit now in fs blocks */
 		cfg->lsunit = cfg->dsunit;
 	}

