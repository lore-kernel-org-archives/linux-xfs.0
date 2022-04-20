Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA45C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 08:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351437AbiDTIkg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 04:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236882AbiDTIkf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 04:40:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B11D29C9B
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 01:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650443869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Yn5RukFx7eLhzyRRbX3AC7rJFMPW1pHqs4tYoEeiiOA=;
        b=NbPEY7UyHjH5v/vexMf8lJLoGw8Lvdmrk5IKUpQOB9NZ6NR3wb4EoIwud6iIRQLAfIFi5m
        DZJG+dyX//8UodkwNgDdhEVkQjwNqW7eGh21xuy2NRm70evu5LTun6raI+LQpHXyqND0gQ
        BNrvw0RbBbookCx5bvArkgf1VI6lfz8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-bG2GvqDqMWqVVmBTJkmxzw-1; Wed, 20 Apr 2022 04:37:08 -0400
X-MC-Unique: bG2GvqDqMWqVVmBTJkmxzw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1BDFF80352D;
        Wed, 20 Apr 2022 08:37:08 +0000 (UTC)
Received: from zlang-laptop.redhat.com (ovpn-12-143.pek2.redhat.com [10.72.12.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 78498404E4B1;
        Wed, 20 Apr 2022 08:37:06 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/4] several long time unmerged patches from zlang
Date:   Wed, 20 Apr 2022 16:36:49 +0800
Message-Id: <20220420083653.1031631-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Recently I try to clean up all my old local branches of xfstests,  and found
some patches aren't merged for long time. I abandoned most of them, but some
of them might be still worth reviewing, so I rebased them to latest xfstests
and send out to get review.

[PATCH 1/4] is tiny patch for glusterfs testing failure.
[PATCH 2/4] is for large fs testing
[PATCH 3/4] and [4/4] are two different new cases to cover regression issues.

So feel free to give them your review point, especially the [4/4], it still
trigger a unknown xfs failure on latest upstream kernel.

Thanks,
Zorro

