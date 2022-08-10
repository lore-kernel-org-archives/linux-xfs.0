Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E216C00140
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Aug 2022 10:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiHJKxb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Aug 2022 06:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiHJKxb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Aug 2022 06:53:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5EA9D31347
        for <linux-xfs@vger.kernel.org>; Wed, 10 Aug 2022 03:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660128809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=j40RIz9e+IEaZiERtbyBvjmT/NZEkHZR6oDGA6rwImU=;
        b=Ui/apjip1Q7qB9AQNnRpU16gpFVmTqSHzdfvurqZ+nTnnp+dAiUpbrjce/dLJerw37HajK
        HA7fnqpwBlMcU1y+bygNGXa/4zsA0prXDZ+qRBbAJ38eHtt8Lp1hQgAoPRWsqycBS+tVBe
        yira1DriIX09l/Zte8fGi1QpGm3J0xY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-385-64LRiWq8N7CA44yLK3QcFQ-1; Wed, 10 Aug 2022 06:53:20 -0400
X-MC-Unique: 64LRiWq8N7CA44yLK3QcFQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4D371C006C3
        for <linux-xfs@vger.kernel.org>; Wed, 10 Aug 2022 10:53:20 +0000 (UTC)
Received: from [10.10.0.108] (unknown [10.40.193.197])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DC031121314
        for <linux-xfs@vger.kernel.org>; Wed, 10 Aug 2022 10:53:20 +0000 (UTC)
Subject: [PATCH 0/2] xfsdump: Remove remaining 'slave' wording from xfsdump
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Date:   Wed, 10 Aug 2022 12:53:19 +0200
Message-ID: <166012867440.10085.15666482309699207253.stgit@orion>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

While at it, also clean up trailing white spaces from xfsdump.html

---

Carlos Maiolino (2):
      Remove trailing white spaces from xfsdump.html
      Rename worker threads from xfsdump's documentation


 doc/xfsdump.html | 444 +++++++++++++++++++++++------------------------
 po/de.po         |   4 +-
 2 files changed, 224 insertions(+), 224 deletions(-)

--
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

