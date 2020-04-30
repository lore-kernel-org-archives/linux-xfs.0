Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E8AFC4724C
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 21:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 171B32071C
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 21:42:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IixQl6L9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgD3VmA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 17:42:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26791 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726447AbgD3VmA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 17:42:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588282919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZESnp6elIBUFq8FSdDs/+o+VO3ku7zknLv4RJbSZ5es=;
        b=IixQl6L9oX00rpK5PMKYgaTBMgNRSyTMUYZli4e0JwqoK+f6og5R9JhDf53jqyhvD5A0Y9
        2R32T2xiY9o9w7EGsJ23q8SNFdr2tQ7aslMYqG33wozAvEUdib35cAIePH0aV8Q58yHeS5
        hdxET1YmSI15Ffp9/rTmy8ioFGL6dV0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-Z8rs3yC6PG6RyCSoKhWmsg-1; Thu, 30 Apr 2020 17:41:57 -0400
X-MC-Unique: Z8rs3yC6PG6RyCSoKhWmsg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9141D805738
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 21:41:56 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B0796A944
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 21:41:56 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_io: copy_range can take up to 8 arguments
Message-ID: <08c6de7b-4caf-1162-29e5-94d8dfe959d6@redhat.com>
Date:   Thu, 30 Apr 2020 16:41:55 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If we use the "-f N" variant for the source file specification, we will
have up to 8 total arguments.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index 68525047..d154fa76 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -179,7 +179,7 @@ copy_range_init(void)
 	copy_range_cmd.name = "copy_range";
 	copy_range_cmd.cfunc = copy_range_f;
 	copy_range_cmd.argmin = 1;
-	copy_range_cmd.argmax = 7;
+	copy_range_cmd.argmax = 8;
 	copy_range_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	copy_range_cmd.args = _("[-s src_off] [-d dst_off] [-l len] src_file | -f N");
 	copy_range_cmd.oneline = _("Copy a range of data between two files");

