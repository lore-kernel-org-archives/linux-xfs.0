Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD0BC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Apr 2022 17:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244917AbiDRRGd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Apr 2022 13:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346817AbiDRRGd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Apr 2022 13:06:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B4CA62C136
        for <linux-xfs@vger.kernel.org>; Mon, 18 Apr 2022 10:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650301432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=iuBwlS+iOm9wZ3hANlOYzEc1PVMxMApmp3RpKe4H0IA=;
        b=RGRCInUJATYSjUu1gLp/WwP7uMim4JjUuyYqC4h7dWxhpfiIsOjKji8GRFf7za3PctYnM3
        lAr0s1YMgP+un5SvdpOJHWJYs93kRj3+Df+ivVybn2jQN5N1PmH9Ko28f7kqO9vgYjtLW7
        2QMAeBIgiBaeHcFCzJMKqTUQ64VpC7o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-263-ZuQD5yzTNNy1oPRbEPt2Jg-1; Mon, 18 Apr 2022 13:03:49 -0400
X-MC-Unique: ZuQD5yzTNNy1oPRbEPt2Jg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30C81299E762;
        Mon, 18 Apr 2022 17:03:49 +0000 (UTC)
Received: from zlang-laptop.redhat.com (ovpn-12-143.pek2.redhat.com [10.72.12.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB42040D2826;
        Mon, 18 Apr 2022 17:03:46 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, sandeen@redhat.com
Subject: [PATCH v3 0/2] remove _wipe_fs and add a new dump test
Date:   Tue, 19 Apr 2022 01:03:24 +0800
Message-Id: <20220418170326.425762-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

As we talked in version~2 of [PATCH 2/2] [1], Dave said "common/dump::_wipe_fs()
is effectively just _scratch_mkfs() followed by mounting it. It does not need
to exist at all." So we decided to remove _wipe_fs() function entirely from
all xfstests cases.

So:
[PATCH v3 1/2] is a new patch to remove _wipe_fs.
[PATCH v3 2/2] avoid using WIPE_FS parameter

[1]
https://lore.kernel.org/fstests/20220411083433.omc3yvn75k5ap6zk@zlang-mailbox/

Thanks,
Zorro

