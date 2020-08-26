Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B2AAC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 14:38:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 637D322B40
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 14:38:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RNyLfAlC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgHZOiV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 10:38:21 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60009 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726690AbgHZOiU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 10:38:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598452698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=v2nnPmwa65h6MBTZz39axfmcrlcjYYl7+MRhTHyerWo=;
        b=RNyLfAlCKIv+/AiNwUjPQtFRVXEuV7hmtZVCZattw6PdCoK1fktI/OFwh7EgDBH+1H9kQo
        GuQ+jzONWitfqy3kWw+4Xs5UrxgwZFyLsCArrNDEXxhZzFZOFQ1ncS+wrdcBXPftJ5iW9M
        QpiD3Gwhev1b9M5J1xhNQnCiEkZOgmY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-Wli2kP78O76oy15sQh4nWA-1; Wed, 26 Aug 2020 10:38:16 -0400
X-MC-Unique: Wli2kP78O76oy15sQh4nWA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8882107464E;
        Wed, 26 Aug 2020 14:38:15 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-11.rdu2.redhat.com [10.10.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6AA8A50EB6;
        Wed, 26 Aug 2020 14:38:15 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/4] fix up generic dmlogwrites tests to work with XFS
Date:   Wed, 26 Aug 2020 10:38:11 -0400
Message-Id: <20200826143815.360002-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

We've still had lingering false positive failure reports on some of
these generic dmlogwrites tests on XFS due to metadata ordering issues.
The logwrites mechanism relies on discard to provide zeroing behavior to
avoid this, but if that is not available, this can result in subtle
failures that take time to diagnose.

This series updates the remaining generic dmlogwrites tests to use the
same scheme we used in generic/482 to address this problem, which is to
explicitly use a thin volume for predictable discard support. It also
adds a discard zeroing behavior check as a backstop against future
tests. The thought crossed my mind of pushing much of this code down
into the common dmlogwrites code to reduce duplication, but I didn't
want to get too deep into the weeds of reworking the common code to
address this problem in a handful of tests.

Thoughts, reviews, flames appreciated.

Brian

Brian Foster (4):
  generic: require discard zero behavior for dmlogwrites on XFS
  generic/455: use thin volume for dmlogwrites target device
  generic/457: use thin volume for dmlogwrites target device
  generic/470: use thin volume for dmlogwrites target device

 common/dmlogwrites | 10 ++++++++--
 common/rc          | 14 ++++++++++++++
 tests/generic/455  | 36 ++++++++++++++++++++++--------------
 tests/generic/457  | 33 +++++++++++++++++++++------------
 tests/generic/470  | 24 ++++++++++++++++++------
 5 files changed, 83 insertions(+), 34 deletions(-)

-- 
2.25.4

