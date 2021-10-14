Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09D79C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 17:59:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D75DE61152
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 17:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhJNSBM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 14:01:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21762 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231612AbhJNSBM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Oct 2021 14:01:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634234347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CaIC6t6YXXvAgGj/b/UTSLusM9hT2zc2pYMAmgikNEA=;
        b=G0tItqQjuw6rgaTM3Fqov1gcCxezD+pY2/LWL8SfQQ5KU0NBQhdmHv3VdTGtcQ7hOnt0oO
        +UpoCZxNcuzJUh4SjwtTQrDMMGugk5teVGj+Yb2QyxK7Qo+vYSSC5X3qmyPJu5tZ/yE5/N
        QvCGTlgEB/jI9Pzt1ktCrPoSOr87eeE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-fxFlUjH0NTiwnQVfXEKo2g-1; Thu, 14 Oct 2021 13:59:04 -0400
X-MC-Unique: fxFlUjH0NTiwnQVfXEKo2g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE4E6802CB8
        for <linux-xfs@vger.kernel.org>; Thu, 14 Oct 2021 17:59:03 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73DA95C1A3
        for <linux-xfs@vger.kernel.org>; Thu, 14 Oct 2021 17:59:03 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 0/4] xfs: fix perag iteration raciness
Date:   Thu, 14 Oct 2021 13:58:58 -0400
Message-Id: <20211014175902.1519172-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

v3:
- Code style, Fixes: and RvB: tags.
v2: https://lore.kernel.org/linux-xfs/20211012165203.1354826-1-bfoster@redhat.com/
- Factoring and patch granularity.
v1: https://lore.kernel.org/linux-xfs/20211007125053.1096868-1-bfoster@redhat.com/

Brian Foster (4):
  xfs: fold perag loop iteration logic into helper function
  xfs: rename the next_agno perag iteration variable
  xfs: terminate perag iteration reliably on agcount
  xfs: fix perag reference leak on iteration race with growfs

 fs/xfs/libxfs/xfs_ag.h | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

-- 
2.31.1

