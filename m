Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC535C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 12:51:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AECA9610A2
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 12:51:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhJGMwx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Oct 2021 08:52:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32175 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231825AbhJGMww (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Oct 2021 08:52:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633611058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gsw6CCzr0OeFMz9nhNKB3zSBipSRjIKNC0N+5sdXn98=;
        b=Yxg3XWaCbhmfAzRTN7mIQL7ugSATYtkgIqqffcq2+w4uPh4SAm9mIwkZGiyQZpFJbfCvsu
        iqHp78b0FIjepvi0p8w/gofb4f1bxSLlph+fSNFGPTjLO8sJ7OTCg90lPOXQkPigVJrGRv
        5rK2CD/cBQMYAoeKJ4i5ZPcKvhKghOs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-rVkHYQ9cP1KpG86S2yWATw-1; Thu, 07 Oct 2021 08:50:56 -0400
X-MC-Unique: rVkHYQ9cP1KpG86S2yWATw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0B08A40C7
        for <linux-xfs@vger.kernel.org>; Thu,  7 Oct 2021 12:50:55 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.18.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CF1B2C175
        for <linux-xfs@vger.kernel.org>; Thu,  7 Oct 2021 12:50:54 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/3] xfs: fix perag iteration raciness
Date:   Thu,  7 Oct 2021 08:50:50 -0400
Message-Id: <20211007125053.1096868-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This adds an iteration function to the perag iteration macros to tweak
the logic and avoid some raciness with growfs when relying on the
presence of xfs_perag structures. This manifests as a couple assert
failures reproduced by xfs/104 (which only seem to reproduce on ppc64le
at the moment; I haven't really dug into why).

This probably could use a couple more patches tacked on: one to fix up
the tag based lookup macro and another to audit the existing callers and
remove any spurious xfs_perag_put() calls. I don't think the former is
currently an issue an practice, but we should probably eliminate the
flaw regardless. I'm just sending the initial fixup on its own as a
first pass..

Brian

Brian Foster (3):
  xfs: fold perag loop iteration logic into helper function
  xfs: rename the next_agno perag iteration variable
  xfs: terminate perag iteration reliably on end agno

 fs/xfs/libxfs/xfs_ag.h | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

-- 
2.31.1

