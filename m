Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7266EC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 08:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351401AbiDTIkp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 04:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376766AbiDTIko (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 04:40:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E771329C9B
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 01:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650443879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iIdcAmi1AacA2/ltxfZkRyqpVORYvmpGlrzulm5XL/Y=;
        b=anALIk2/Plhb7deulzIUOTdeKQzDoKWj0NibaWOt1UiHQOTm+bFtjmdWWBgwGqwD9ZZfqO
        e8m2AZVUFGxqppjou4pwPLq7BVJKtYjnrXM9V+plcqSdDvTbQNakZjEVO0CeGU5bss8gXD
        ZIJTfJ102LYjkJBFCw4g8pIJ5yYA8zw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-dNep_4C8O2WnANv1p7HW_w-1; Wed, 20 Apr 2022 04:37:15 -0400
X-MC-Unique: dNep_4C8O2WnANv1p7HW_w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 77C931857F16;
        Wed, 20 Apr 2022 08:37:15 +0000 (UTC)
Received: from zlang-laptop.redhat.com (ovpn-12-143.pek2.redhat.com [10.72.12.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DEC2840D1B98;
        Wed, 20 Apr 2022 08:37:12 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] src/t_rename_overwrite: fsync to flush the rename operation result
Date:   Wed, 20 Apr 2022 16:36:50 +0800
Message-Id: <20220420083653.1031631-2-zlang@redhat.com>
In-Reply-To: <20220420083653.1031631-1-zlang@redhat.com>
References: <20220420083653.1031631-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The generic/035 fails on glusterfs due to glusterfs (or others like
it), the file state can't be updated in time in client side, there's
time delay. So call fsync to get the right file state after rename.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 src/t_rename_overwrite.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/t_rename_overwrite.c b/src/t_rename_overwrite.c
index c5cdd1db..8dcf8d46 100644
--- a/src/t_rename_overwrite.c
+++ b/src/t_rename_overwrite.c
@@ -2,6 +2,7 @@
 #include <fcntl.h>
 #include <err.h>
 #include <sys/stat.h>
+#include <unistd.h>
 
 int main(int argc, char *argv[])
 {
@@ -25,6 +26,7 @@ int main(int argc, char *argv[])
 	res = rename(path1, path2);
 	if (res == -1)
 		err(1, "rename(\"%s\", \"%s\")", path1, path2);
+	fsync(fd);
 
 	res = fstat(fd, &stbuf);
 	if (res == -1)
-- 
2.31.1

