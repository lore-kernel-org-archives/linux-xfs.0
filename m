Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF629C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62A1A221F4
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgLCUCW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 15:02:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29648 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726681AbgLCUCV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 15:02:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607025655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LDZnwIJru2s2CYmb1mcHfPmBYQjUYOel/yUcOh7HVug=;
        b=LMql/OIwhuuixo/V/gK4wYc4sqE9SQcpunyh+Pn40gvGu+35giYM8hFyFnJmW03pZ5ieSK
        qwe8156ABuBYfH/9iM1b62++DLKBnsoZXJSmjZXNAinQ5hQhlvg8BkUW8yEbLRWyPzAhze
        PL8oYQLwC3YzEdYatYe4qYI+RotWPL0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-x9NsKO4wPCClAkfVFZzTmQ-1; Thu, 03 Dec 2020 15:00:53 -0500
X-MC-Unique: x9NsKO4wPCClAkfVFZzTmQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 25380192D7B7
        for <linux-xfs@vger.kernel.org>; Thu,  3 Dec 2020 20:00:43 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD77972F91
        for <linux-xfs@vger.kernel.org>; Thu,  3 Dec 2020 20:00:42 +0000 (UTC)
Subject: [PATCH 2/3] xfs_quota: Remove delalloc caveat from man page
From:   Eric Sandeen <sandeen@redhat.com>
To:     xfs <linux-xfs@vger.kernel.org>
References: <44dcd8f3-0585-e463-499f-44256d8bad8d@redhat.com>
Message-ID: <8fe85780-d68e-6d33-349b-66dad73858c3@redhat.com>
Date:   Thu, 3 Dec 2020 14:00:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <44dcd8f3-0585-e463-499f-44256d8bad8d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Ever since
89605011915a ("xfs: include reservations in quota reporting")
xfs quota has been in sync with delayed allocations, so this caveat
is no longer relevant or correct; remove it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 man/man8/xfs_quota.8 | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
index b3c4108e..bfdc2e4f 100644
--- a/man/man8/xfs_quota.8
+++ b/man/man8/xfs_quota.8
@@ -725,17 +725,8 @@ Same as above without a need for configuration files.
 .in -5
 .fi
 .SH CAVEATS
-XFS implements delayed allocation (aka. allocate-on-flush) and this
-has implications for the quota subsystem.
-Since quota accounting can only be done when blocks are actually
-allocated, it is possible to issue (buffered) writes into a file
-and not see the usage immediately updated.
-Only when the data is actually written out, either via one of the
-kernels flushing mechanisms, or via a manual
-.BR sync (2),
-will the usage reported reflect what has actually been written.
 .PP
-In addition, the XFS allocation mechanism will always reserve the
+The XFS allocation mechanism will always reserve the
 maximum amount of space required before proceeding with an allocation.
 If insufficient space for this reservation is available, due to the
 block quota limit being reached for example, this may result in the
-- 
2.17.0


