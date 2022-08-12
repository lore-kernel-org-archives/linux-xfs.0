Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7A38C00140
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Aug 2022 09:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbiHLJNe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Aug 2022 05:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbiHLJNe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Aug 2022 05:13:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5BEB9A8318
        for <linux-xfs@vger.kernel.org>; Fri, 12 Aug 2022 02:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660295612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9l3Sm9NqPhbBQinVFUliw13GS22OFGn9c1QuB2zx0qQ=;
        b=OTxBuyLCXYnzyXnoS4fMx5f6UAqgH5NXSlBKpdzYxCv7dtl3suLoUcBDqK9gkJYsJznhxg
        qHDHCU1q4IR+jJVVF+Mc2jequjOVyvOQsWRMfO+K5H9UGpr8g9d3dUpbCcPFojL8MYsLLc
        rCdmJYmtCsoo2xjxn0+aEFQou+iAdrw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-5ZAXc6qZO3GY_5DGpf-DYQ-1; Fri, 12 Aug 2022 05:13:30 -0400
X-MC-Unique: 5ZAXc6qZO3GY_5DGpf-DYQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 729FC85A581
        for <linux-xfs@vger.kernel.org>; Fri, 12 Aug 2022 09:13:30 +0000 (UTC)
Received: from [10.10.0.108] (unknown [10.40.192.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AEBF40D296C
        for <linux-xfs@vger.kernel.org>; Fri, 12 Aug 2022 09:13:29 +0000 (UTC)
Subject: [PATCH V2 0/2] xfsdump: Remove remaining 'slave' wording from xfsdump
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Date:   Fri, 12 Aug 2022 11:13:28 +0200
Message-ID: <166029523522.24268.4512887046014709993.stgit@orion>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

While at it, also clean up trailing white spaces from xfsdump.html

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

Changelog:
	- V1 had 2 hunks belonging to patch 2, wrongly misplaced on patch 1
	- Clean the polish translation for 'worker', somebody with polish
	  language knowledge should translate it, but I'm sure the current
	  translation doesn't apply for 'worker'.

Carlos Maiolino (2):
      Remove trailing white spaces from xfsdump.html
      Rename worker threads from xfsdump's documentation


 doc/xfsdump.html | 444 +++++++++++++++++++++++------------------------
 po/de.po         |   4 +-
 po/pl.po         |   4 +-
 3 files changed, 226 insertions(+), 226 deletions(-)

--

