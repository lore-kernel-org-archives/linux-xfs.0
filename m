Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 936BEC4361B
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Dec 2020 22:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CD3223603
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Dec 2020 22:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbgLPWdi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Dec 2020 17:33:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48934 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727151AbgLPWdh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Dec 2020 17:33:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608157931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pdLVyM0DA04qmVEHMeq/CfFG55dtbGoINRXDdnV+n30=;
        b=H4+NW1DdlePNZpmMHu6GIpsjJZAmMcXfajfULdXmeQ+rTQY7JgscZDO4NdB7tXyk9yIUrm
        AzKIfMG0DpmVqydCTlNCfsBO40OZ4iAsXTdj2N0nn/T6lBovXzHS/pGYH63Z/Hp5BFU14z
        Cuq2iJFEHiKVkoq6vzJ9G6arCzMQ9CU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-fPIjcCl3NLe3Jcm3JeYYNg-1; Wed, 16 Dec 2020 17:32:09 -0500
X-MC-Unique: fPIjcCl3NLe3Jcm3JeYYNg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A99EC73A0;
        Wed, 16 Dec 2020 22:32:08 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4802560C47;
        Wed, 16 Dec 2020 22:32:08 +0000 (UTC)
Subject: [PATCH V2] xfsdump: don't try to generate .ltdep in inventory/
From:   Eric Sandeen <sandeen@redhat.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Thomas Deutschmann <whissi@gentoo.org>
References: <15af018c-caf7-71e7-c353-96775d7173ba@redhat.com>
Message-ID: <ad5ad420-1c4d-7f53-a2a6-51480836ea09@redhat.com>
Date:   Wed, 16 Dec 2020 16:32:07 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <15af018c-caf7-71e7-c353-96775d7173ba@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

.ltdep gets generated from CFILES, and there are none in inventory/
so trying to generate it in that dir leads to a non-fatal error when
the include invokes the rule to build the .ltdep file:

Building inventory
    [LTDEP]
gcc: fatal error: no input files
compilation terminated.

inventory/ - like common/ - has files that get linked into other dirs,
and .ltdep is generated in those other dirs, not in inventory/.

So, simply remove the .ltdep include/generation from the inventory/
dir, because there is no reason or ability to generate the file here.

Reported-by: Thomas Deutschmann <whissi@gentoo.org>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: more comprehensive problem description

diff --git a/inventory/Makefile b/inventory/Makefile
index cda145e..6624fba 100644
--- a/inventory/Makefile
+++ b/inventory/Makefile
@@ -12,5 +12,3 @@ LSRCFILES = inv_api.c inv_core.c inv_fstab.c inv_idx.c inv_mgr.c \
 default install install-dev:
 
 include $(BUILDRULES)
-
--include .ltdep

