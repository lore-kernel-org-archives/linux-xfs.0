Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 730C3C4361A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21E252220F
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgLCUht (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 15:37:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36767 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbgLCUht (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 15:37:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607027783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+DCZm0Q0Fgd4ypUuvF/PxJEPbXRMh4JFWU924i6OYkc=;
        b=C0dHd+/Gfinv8ZUlrnTeAYZIq8T56FTfsDVFrPkApjl7FZXcvSoPAEP3JbJEOMnWOPDIa2
        lR5jqHO7VPtc57wD+IbQkhWdaMQ82ki9kuf6ZQnWq7b040n9zqSfVB56VbYeoA200X7lBo
        jYPgpI4GXK+7Jo5VwIbX09o/cLdlqow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-9Mxa1tGxM--2zbtaYOgKDg-1; Thu, 03 Dec 2020 15:36:20 -0500
X-MC-Unique: 9Mxa1tGxM--2zbtaYOgKDg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA7608042A2
        for <linux-xfs@vger.kernel.org>; Thu,  3 Dec 2020 20:36:19 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1F6F5D9CC
        for <linux-xfs@vger.kernel.org>; Thu,  3 Dec 2020 20:36:19 +0000 (UTC)
Subject: [PATCH 1/3 V2] xfs_quota: document how the default quota is stored
From:   Eric Sandeen <sandeen@redhat.com>
To:     xfs <linux-xfs@vger.kernel.org>
References: <44dcd8f3-0585-e463-499f-44256d8bad8d@redhat.com>
 <2e9b1d0f-7ad8-b42a-ac2b-b1fdd9a9fb45@redhat.com>
Message-ID: <22ed7fd0-15ce-5906-d09a-eef15dece2bd@redhat.com>
Date:   Thu, 3 Dec 2020 14:36:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <2e9b1d0f-7ad8-b42a-ac2b-b1fdd9a9fb45@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Nowhere in the xfs_quota man page is the default quota described;
what it does or where it is stored.  Add some brief information
about this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 man/man8/xfs_quota.8 | 5 +++++
 1 file changed, 5 insertions(+)

V2: use "user" only in the generic sense as the rest of the overview does, and
do not refer to the "root user" specifically, rather to the root/#0 ID.

(project lists "#0" and user/group lists "root")

diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
index dd0479cd..be04fb30 100644
--- a/man/man8/xfs_quota.8
+++ b/man/man8/xfs_quota.8
@@ -178,6 +178,11 @@ to a file on
 where the user's quota has not been exceeded.
 Then after rectifying the quota situation, the file can be moved back to the
 filesystem it belongs on.
+.SS Default Quotas
+The XFS quota subsystem allows a default quota to be enforced for any user which
+does not have a quota limit explicitly set.
+These limits are stored in and displayed as the root / ID #0 limits, although
+they do not actually limit the root user.
 .SH USER COMMANDS
 .TP
 .B print

