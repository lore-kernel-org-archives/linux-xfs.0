Return-Path: <SRS0=Ip4f=4C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14427C3B1B5
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Feb 2020 18:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0D3522314
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Feb 2020 18:15:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AbZOd132"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgBNSPg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Feb 2020 13:15:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44745 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726191AbgBNSPf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Feb 2020 13:15:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581704134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=x0ceAWZaMdkO4eR8Iug3njY3KUbrzvL53NY27Fgqfq8=;
        b=AbZOd132HodjvdAlYwH8CTvp+zdPNE9g3tTMaRzvDQA8zQ2FP8NMDtH8HD35Sj7417Otme
        DA3QJW9nilPjkpG9vFTKBCsqgBz2vebQX9HBXb9Bjyih4Ec4pOfl0ppFTXLuHJyk24mOvB
        NIzcSQfLyAW1hG38AOHNAf94Opl3TKE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-NgMJnY4tMCySkFfisX-SXw-1; Fri, 14 Feb 2020 13:15:30 -0500
X-MC-Unique: NgMJnY4tMCySkFfisX-SXw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDD53100550E
        for <linux-xfs@vger.kernel.org>; Fri, 14 Feb 2020 18:15:29 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70D375C126;
        Fri, 14 Feb 2020 18:15:29 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfs: fix iclog release error check race with shutdown
Date:   Fri, 14 Feb 2020 13:15:28 -0500
Message-Id: <20200214181528.24046-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Prior to commit df732b29c8 ("xfs: call xlog_state_release_iclog with
l_icloglock held"), xlog_state_release_iclog() always performed a
locked check of the iclog error state before proceeding into the
sync state processing code. As of this commit, part of
xlog_state_release_iclog() was open-coded into
xfs_log_release_iclog() and as a result the locked error state check
was lost.

The lockless check still exists, but this doesn't account for the
possibility of a race with a shutdown being performed by another
task causing the iclog state to change while the original task waits
on ->l_icloglock. This has reproduced very rarely via generic/475
and manifests as an assert failure in __xlog_state_release_iclog()
due to an unexpected iclog state.

Restore the locked error state check in xlog_state_release_iclog()
to ensure that an iclog state update via shutdown doesn't race with
the iclog release state processing code.

Reported-by: Zorro Lang <zlang@redhat.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f6006d94a581..f38fc492a14d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -611,6 +611,10 @@ xfs_log_release_iclog(
 	}
=20
 	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
+		if (iclog->ic_state =3D=3D XLOG_STATE_IOERROR) {
+			spin_unlock(&log->l_icloglock);
+			return -EIO;
+		}
 		sync =3D __xlog_state_release_iclog(log, iclog);
 		spin_unlock(&log->l_icloglock);
 		if (sync)
--=20
2.21.1

