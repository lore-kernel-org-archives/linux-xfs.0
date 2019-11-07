Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD2CC5DF61
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 16:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41C2C2087E
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 16:51:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IQOHdCvj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730618AbfKGQvG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 11:51:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47304 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726810AbfKGQvG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 11:51:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573145465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=A2hZ5Me7mmoUlV9sCqUp8TU6j3HZZAmu/y4kpMNdwew=;
        b=IQOHdCvj6hxzJ5ehMgXjVr2fWyp6fSJXd8x5U2i5QmsYjkK3ry+TyhtAToGmUOp+YnlUN+
        WxC9c7kRcauDEgFMnXUVvA/Hm2BuC6wMvvZnLlMd571l8m50g3wO6uZXMIdK14J52sO/R6
        vkOzo0/3Lvnl8IhGGH9jM8+EhspwTjw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-SfFzD-Q_MDmVJuIVVZ4ehA-1; Thu, 07 Nov 2019 11:51:01 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EB8E1005500;
        Thu,  7 Nov 2019 16:51:00 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 596925C298;
        Thu,  7 Nov 2019 16:51:00 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_io: fix memory leak in add_enckey
Cc:     Eric Biggers <ebiggers@google.com>
Message-ID: <4eb1073f-91fb-a4bc-aae8-d54dc5a6b8aa@redhat.com>
Date:   Thu, 7 Nov 2019 10:50:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
MIME-Version: 1.0
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: SfFzD-Q_MDmVJuIVVZ4ehA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Invalid arguments to add_enckey will leak the "arg" allocation,
so fix that.

Fixes: ba71de04 ("xfs_io/encrypt: add 'add_enckey' command")
Fixes-coverity-id: 1454644
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/io/encrypt.c b/io/encrypt.c
index 17d61cfb..c6a4e190 100644
--- a/io/encrypt.c
+++ b/io/encrypt.c
@@ -696,6 +696,7 @@ add_enckey_f(int argc, char **argv)
 =09=09=09=09goto out;
 =09=09=09break;
 =09=09default:
+=09=09=09free(arg);
 =09=09=09return command_usage(&add_enckey_cmd);
 =09=09}
 =09}

