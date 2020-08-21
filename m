Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C3DC433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 00:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1F1120702
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 00:05:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ggtXwmVc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgHUAFn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 20:05:43 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58677 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725834AbgHUAFm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 20:05:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597968341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=256jyEv088V8PWDueUOpVkuYVKhhyL9sHBBzhdGZHuY=;
        b=ggtXwmVcWpCwXc2JoarHFzEU/BCsZzRrhpJ/htoqs3jxNi1dmXXU4zUDPKTJ/IiZMZO8Mp
        l9dvzjjoX2mxja8/wMqe6wza7qdwRFJHipZ+pgFooJWCg/UUXoj1s76P/q/SENhwYTIWQg
        NVDKy9v1YPNXzQp7mn1cY6getULWHk8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-y-ZOQpvuOfCgcUbj2Hjszg-1; Thu, 20 Aug 2020 20:05:38 -0400
X-MC-Unique: y-ZOQpvuOfCgcUbj2Hjszg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19D0F80733B
        for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2020 00:05:38 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E202D5C1CF
        for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2020 00:05:37 +0000 (UTC)
Subject: [PATCH 1/2] xfs_db: short circuit type_f if type is unchanged
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org
References: <8b1ab1c4-64f6-5410-bf40-30776dae4dd5@redhat.com>
Message-ID: <784ed247-0467-093b-1113-ff80a1289cbd@redhat.com>
Date:   Thu, 20 Aug 2020 19:05:37 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <8b1ab1c4-64f6-5410-bf40-30776dae4dd5@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There's no reason to go through the type change code if the
type has not been changed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/type.c b/db/type.c
index 3cb1e868..572ac6d6 100644
--- a/db/type.c
+++ b/db/type.c
@@ -216,6 +216,8 @@ type_f(
 		tt = findtyp(argv[1]);
 		if (tt == NULL) {
 			dbprintf(_("no such type %s\n"), argv[1]);
+		} else if (iocur_top->typ == tt) {
+			return 0;
 		} else {
 			if (iocur_top->typ == NULL)
 				dbprintf(_("no current object\n"));

