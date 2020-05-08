Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C37C38A2A
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 19:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A3972184D
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 19:36:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lna7A6qC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgEHTgw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 15:36:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31487 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726767AbgEHTgw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 15:36:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588966611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=CcDiqf3ilRTezHin4L/iz6nQLBOBIo1cMgsgDjHMGLg=;
        b=Lna7A6qC1fopxGtzQWOSYNSTcO54hU11Zy0Y7iahT1FxzZbl52Yi3DcZp1a1Y75JweD1eO
        xnckGsInJoRcI2OFyyyoP3GcWW3mtXftBss6moYuA8DLSOHVp75WS8EXP1wQsRRGwfHEAO
        0FdmjjHXHN6FjtfNbuS4ae6gP8IP8N0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-usyFaeupPeadxD0NW6CFZw-1; Fri, 08 May 2020 15:36:47 -0400
X-MC-Unique: usyFaeupPeadxD0NW6CFZw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04647835B43;
        Fri,  8 May 2020 19:36:47 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AB3F4707D8;
        Fri,  8 May 2020 19:36:46 +0000 (UTC)
To:     Jan Kara <jack@suse.cz>
Cc:     =?UTF-8?B?UGV0ciBQw61zYcWZ?= <ppisar@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] quota-tools: pass quota type to QCMD for Q_XFS_GETQSTAT
Message-ID: <0dcda75e-0142-043f-2df2-9155cb6b7ed1@redhat.com>
Date:   Fri, 8 May 2020 14:36:46 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Older kernels ignored the type sent to Q_XFS_GETQSTAT, and returned
timer information for the first quota type which was found to be
enabled.

As of 555b2c3da1fc ("quota: honor quota type in Q_XGETQSTAT[V] calls")
the kernel now honors the quota type requested, so send that from the
Q_XFS_GETQSTAT calls in quota tools.

Older kernels ignore the type altogether, so this change should be
backwards compatible with no change in behavior.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/quotaio_xfs.c b/quotaio_xfs.c
index 56daf89..b22c7b4 100644
--- a/quotaio_xfs.c
+++ b/quotaio_xfs.c
@@ -81,7 +81,7 @@ static int xfs_init_io(struct quota_handle *h)
 	struct xfs_mem_dqinfo info;
 	int qcmd;
 
-	qcmd = QCMD(Q_XFS_GETQSTAT, 0);
+	qcmd = QCMD(Q_XFS_GETQSTAT, h->qh_type);
 	memset(&info, 0, sizeof(struct xfs_mem_dqinfo));
 	if (quotactl(qcmd, h->qh_quotadev, 0, (void *)&info) < 0)
 		return -1;
diff --git a/quotaon_xfs.c b/quotaon_xfs.c
index d557a75..d137240 100644
--- a/quotaon_xfs.c
+++ b/quotaon_xfs.c
@@ -32,7 +32,7 @@ static int xfs_state_check(int qcmd, int type, int flags, const char *dev, int r
 	if (flags & STATEFLAG_ALL)
 		return 0;	/* noop */
 
-	if (quotactl(QCMD(Q_XFS_GETQSTAT, 0), dev, 0, (void *)&info) < 0) {
+	if (quotactl(QCMD(Q_XFS_GETQSTAT, type), dev, 0, (void *)&info) < 0) {
 		errstr(_("quotactl() on %s: %s\n"), dev, strerror(errno));
 		return -1;
 	}

