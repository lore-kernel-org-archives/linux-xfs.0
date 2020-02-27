Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F79BC35DF1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 14:48:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CFF9246E4
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 14:48:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aJsT668B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbgB0Nn0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 08:43:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41622 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729962AbgB0NnZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 08:43:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582811004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Im0n69uG6RtvEN39KMCO8NYo3nRdviWHfombc8Moe7Q=;
        b=aJsT668BO2qDIPASojTPplusDEMEp2vZA7xVcGKUJe9PS4MUPnsKxkp6kaQWYyTIZe1K9+
        srvJv8N2ZhjJdprgits2IZHHubm4r95sYE63ZZE+ii0VxrjnfK2p7FL35s6343o1puwzzG
        MHCh9kDI8r5JQKYmRPFw8ITf0aIR+H0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-vOWZTHG-NiW3YyALfS6avQ-1; Thu, 27 Feb 2020 08:43:23 -0500
X-MC-Unique: vOWZTHG-NiW3YyALfS6avQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 404C713EA
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 13:43:22 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00E7F5DA7C
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 13:43:21 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v5 PATCH 1/9] xfs: set t_task at wait time instead of alloc time
Date:   Thu, 27 Feb 2020 08:43:13 -0500
Message-Id: <20200227134321.7238-2-bfoster@redhat.com>
In-Reply-To: <20200227134321.7238-1-bfoster@redhat.com>
References: <20200227134321.7238-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The xlog_ticket structure contains a task reference to support
blocking for available log reservation. This reference is assigned
at ticket allocation time, which assumes that the transaction
allocator will acquire reservation in the same context. This is
normally true, but will not always be the case with automatic
relogging.

There is otherwise no fundamental reason log space cannot be
reserved for a ticket from a context different from the allocating
context. Move the task assignment to the log reservation blocking
code where it is used.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f6006d94a581..df60942a9804 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -262,6 +262,7 @@ xlog_grant_head_wait(
 	int			need_bytes) __releases(&head->lock)
 					    __acquires(&head->lock)
 {
+	tic->t_task =3D current;
 	list_add_tail(&tic->t_queue, &head->waiters);
=20
 	do {
@@ -3601,7 +3602,6 @@ xlog_ticket_alloc(
 	unit_res =3D xfs_log_calc_unit_res(log->l_mp, unit_bytes);
=20
 	atomic_set(&tic->t_ref, 1);
-	tic->t_task		=3D current;
 	INIT_LIST_HEAD(&tic->t_queue);
 	tic->t_unit_res		=3D unit_res;
 	tic->t_curr_res		=3D unit_res;
--=20
2.21.1

