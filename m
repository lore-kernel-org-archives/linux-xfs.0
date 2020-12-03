Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 992FEC433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5607A2220F
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgLCUDB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 15:03:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27944 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726048AbgLCUDA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 15:03:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607025694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x5QE1pRGHKH8C82UA89lRDO5ZFY/NVfWYtH4q15aBUg=;
        b=Kv9BxjLV1HOuyAL0IJM4n2awawc8G9cfQ4h8pH9c7bPXpvODR21mROoHsgQA4epau2BvEr
        P7x/jExnz4FLdQdW0WrK8PXE1O09DVe+bY+0sJBkIRhdqlzxNgunWRxC3YuheroqJYbM3w
        XNpUpXpe78Vq0sXGl2nt3hqspfZ353s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-prMTEcPMOK6fCLR5PyJleQ-1; Thu, 03 Dec 2020 15:01:32 -0500
X-MC-Unique: prMTEcPMOK6fCLR5PyJleQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC36D56B5A
        for <linux-xfs@vger.kernel.org>; Thu,  3 Dec 2020 20:01:24 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C41A960BFA
        for <linux-xfs@vger.kernel.org>; Thu,  3 Dec 2020 20:01:24 +0000 (UTC)
Subject: [PATCH 3/3] xfs_quota: make manpage non-male-specific
From:   Eric Sandeen <sandeen@redhat.com>
To:     xfs <linux-xfs@vger.kernel.org>
References: <44dcd8f3-0585-e463-499f-44256d8bad8d@redhat.com>
Message-ID: <9fde98da-d221-87d0-a401-2c82cf1df35f@redhat.com>
Date:   Thu, 3 Dec 2020 14:01:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <44dcd8f3-0585-e463-499f-44256d8bad8d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Users are not exclusively male, so fix that implication.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 man/man8/xfs_quota.8 | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
index bfdc2e4f..beb6da13 100644
--- a/man/man8/xfs_quota.8
+++ b/man/man8/xfs_quota.8
@@ -128,7 +128,7 @@ To most users, disk quotas are either of no concern or a fact of life
 that cannot be avoided.
 There are two possible quotas that can be imposed \- a limit can be set
 on the amount of space a user can occupy, and there may be a limit on
-the number of files (inodes) he can own.
+the number of files (inodes) they can own.
 .PP
 The
 .B quota
@@ -167,10 +167,10 @@ the file, not only are the recent changes lost, but possibly much, or even
 all, of the contents that previously existed.
 .br
 There are several possible safe exits for a user caught in this situation.
-He can use the editor shell escape command to examine his file space
+They can use the editor shell escape command to examine his file space
 and remove surplus files.  Alternatively, using
 .BR sh (1),
-he can suspend
+they can suspend
 the editor, remove some files, then resume it.
 A third possibility is to write the file to some other filesystem (perhaps
 to a file on
-- 
2.17.0

