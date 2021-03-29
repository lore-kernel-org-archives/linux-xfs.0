Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 196B8C433C1
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 18:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB153601FD
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 18:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhC2SQQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 14:16:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41883 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230509AbhC2SQK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 14:16:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617041770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=MsbqPuUyeI0vwe18KcbG9kd3ZOrWCrXq7qkfvZa8wSM=;
        b=aVMNrq/LSgGM/PLM3xZtuU9mJKRHnjrAVoXwv2EZd9rxZEse/pyvrjQ8OtMgYa2A1mfWQY
        udPX4WDyJti5kx3CMYDP0g7/fdbxLfbUti0hobvarQK5HojZOdW4gsbBQsyKdeJSc0UJHY
        pA/bmclK4ZGwyQSqBKRwbSiFyEpMYLY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-jYOvD3QrPnKLabKeD1b-CA-1; Mon, 29 Mar 2021 14:16:08 -0400
X-MC-Unique: jYOvD3QrPnKLabKeD1b-CA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97287107ACCA;
        Mon, 29 Mar 2021 18:16:07 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 196A660C5B;
        Mon, 29 Mar 2021 18:16:07 +0000 (UTC)
Date:   Mon, 29 Mar 2021 14:16:04 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: attr fork related fstests failures on for-next
Message-ID: <YGIZZLoiyULTaUev@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

I'm seeing a couple different fstests failures on current for-next that
appear to be associated with e6a688c33238 ("xfs: initialise attr fork on
inode create"). The first is xfs_check complaining about sb versionnum
bits on various tests:

generic/003 16s ... _check_xfs_filesystem: filesystem on /dev/mapper/test-scratch is inconsistent (c)
(see /root/xfstests-dev/results//generic/003.full for details)
# cat results/generic/003.full
...
_check_xfs_filesystem: filesystem on /dev/mapper/test-scratch is inconsistent (c)
*** xfs_check output ***
sb versionnum missing attr bit 10
*** end xfs_check output
...
#

With xfs_check bypassed, repair eventually complains about some attr
forks. The first point I hit this variant is generic/117:

generic/117 9s ... _check_xfs_filesystem: filesystem on /dev/mapper/test-scratch is inconsistent (r)
(see /root/xfstests-dev/results//generic/117.full for details)
# cat results//generic/117.full
...
_check_xfs_filesystem: filesystem on /dev/mapper/test-scratch is inconsistent (r)
*** xfs_repair -n output ***
...
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
bad attr fork offset 24 in dev inode 135, should be 1
would have cleared inode 135
bad attr fork offset 24 in dev inode 142, should be 1
would have cleared inode 142
...

Both problems disappear with e6a688c33238 reverted.

Brian

