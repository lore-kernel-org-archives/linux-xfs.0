Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC096C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 16:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBF5460EBB
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 16:52:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhJLQyI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 12:54:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36138 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230420AbhJLQyI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Oct 2021 12:54:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634057526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=q+WqnRINyx2bducJTdc5IBYqmUW2FWnR2kyP1PlXPUM=;
        b=IbY2lgZPKwDOeRStOPw/UhRLjAfM8OlpMDtEMAD8zAom+pnl2IsniMFbkdAlp4lf4MBD13
        O4rgdlGjg0FCv67jX97tBedYszeWlWJt3xW4saZZBG+p35S5R6A848OcTpkjomQmSC8+EE
        PMmv+VR6CGTcyzdPU1qwHn2enoTP/cw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-9Bb7GMD6PqmWeg7c3qLEsw-1; Tue, 12 Oct 2021 12:52:04 -0400
X-MC-Unique: 9Bb7GMD6PqmWeg7c3qLEsw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDACFBD524
        for <linux-xfs@vger.kernel.org>; Tue, 12 Oct 2021 16:52:03 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.18.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CBED61093
        for <linux-xfs@vger.kernel.org>; Tue, 12 Oct 2021 16:52:03 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/4] xfs: fix perag iteration raciness
Date:   Tue, 12 Oct 2021 12:51:59 -0400
Message-Id: <20211012165203.1354826-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

v2:
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

