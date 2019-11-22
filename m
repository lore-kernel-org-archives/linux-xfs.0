Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BAD6C432C0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 18:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E746420715
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 18:19:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NpZXPvDc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfKVSTa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 13:19:30 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33211 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726686AbfKVSTa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 13:19:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574446769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+2h2JFdEc5Klx3rTMC6gNfmR9l30SdPNXNLzO2kZMBo=;
        b=NpZXPvDcL0fpkT4m0QJGjCs+lX1QPh00qcZZqu85KN5d4n/2hka8e+mUJntDUoRATpEOsy
        +NSV5PjkjPEG0zO3ialBKFrSADFJ12umfSo4lTFkSNBGwQSYAVECK0k+zqWURiluTOPy5x
        7DvE+p4VuuESqeBN5HMD8uWOIIGTwIs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-PBXv8VZiMZqxXM1oF3DkfQ-1; Fri, 22 Nov 2019 13:19:27 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E439C801E58
        for <linux-xfs@vger.kernel.org>; Fri, 22 Nov 2019 18:19:26 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CE9D9F47
        for <linux-xfs@vger.kernel.org>; Fri, 22 Nov 2019 18:19:26 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v2 PATCH 1/3] xfs: set t_task at wait time instead of alloc time
Date:   Fri, 22 Nov 2019 13:19:25 -0500
Message-Id: <20191122181927.32870-2-bfoster@redhat.com>
In-Reply-To: <20191122181927.32870-1-bfoster@redhat.com>
References: <20191122181927.32870-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: PBXv8VZiMZqxXM1oF3DkfQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The xlog_ticket structure contains a task reference to support task
scheduling associated with log reservation acquisition. This
reference is assigned at ticket allocation time, but otherwise there
is no reason log space cannot be reserved for a ticket from a
context different from the allocating context. Move the task
assignment to the log reservation blocking code where it is used.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6a147c63a8a6..0c0c035c5be0 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -262,6 +262,7 @@ xlog_grant_head_wait(
 =09int=09=09=09need_bytes) __releases(&head->lock)
 =09=09=09=09=09    __acquires(&head->lock)
 {
+=09tic->t_task =3D current;
 =09list_add_tail(&tic->t_queue, &head->waiters);
=20
 =09do {
@@ -3599,7 +3600,6 @@ xlog_ticket_alloc(
 =09unit_res =3D xfs_log_calc_unit_res(log->l_mp, unit_bytes);
=20
 =09atomic_set(&tic->t_ref, 1);
-=09tic->t_task=09=09=3D current;
 =09INIT_LIST_HEAD(&tic->t_queue);
 =09tic->t_unit_res=09=09=3D unit_res;
 =09tic->t_curr_res=09=09=3D unit_res;
--=20
2.20.1

