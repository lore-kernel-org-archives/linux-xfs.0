Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BEE3C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 18:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D94220756
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 18:46:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cSp/Gy5A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgERSq6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 14:46:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44501 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727938AbgERSq5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 14:46:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589827616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=p6yShWJFSZNZAIi10ntndwRV3k+3QXV1FfY9tJKNbMc=;
        b=cSp/Gy5AvRDgws9SU3rTkG6485qI5yHjpIxkdb1I/kmXxKX3cU5wecYYMcvZAKIB2VUwiR
        +cHYheK39PxCmLKFYg3kAdja/5VXcmqLTkXC4x9bApO7Vbz48Lr0YtKNw1egTBCLcY9oEU
        OWVaba91cIWsrQPM3vv3SYJN/kXJKcc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-aWUe7aJnM8uIJL5HjZFmQQ-1; Mon, 18 May 2020 14:46:54 -0400
X-MC-Unique: aWUe7aJnM8uIJL5HjZFmQQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 829A31005510
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 18:46:53 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5606560BF3
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 18:46:53 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/SEVERAL] xfs, xfstests, xfsprogs: quota timer updates
Message-ID: <ea649599-f8a9-deb9-726e-329939befade@redhat.com>
Date:   Mon, 18 May 2020 13:46:52 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is work to enhance xfs quota timers for per-type timers and per-user
timer extension.

I'll do 3 sub-series here, for kernel, userspace, and fstests.

-Eric

