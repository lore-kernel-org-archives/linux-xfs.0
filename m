Return-Path: <SRS0=IeGX=YO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BC8CA9EAF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 12:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEEA4205C9
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 12:13:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D7oX80lJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbfJUMN1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 08:13:27 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26528 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727050AbfJUMN1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Oct 2019 08:13:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571660006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/E2x9XADXGQf3FQTli67dtlrNlPIjd+cEkwW5kPL7mc=;
        b=D7oX80lJOx/kbc1QB3yMK0rsSkfctnQJkgoB1B25zL5rGT4srm6Ia2V8dSw5XQ4R+hepue
        Nj/ZNVfRt9PUTWcnZB7He1X5afnHaYIhuXqmyNXCBOKHLuA8xBPg9IMbKSa0Xca7fMI1UR
        02Lnr4cNJbeH84SNgHnXd9gfWoP7IZM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-u8Y7pcu4OlKJ2uN0ij-frA-1; Mon, 21 Oct 2019 08:13:24 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B46D65E9
        for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2019 12:13:23 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6DCF65D9E2
        for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2019 12:13:23 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/2] xfs: rely on minleft instead of total for bmbt res
Date:   Mon, 21 Oct 2019 08:13:20 -0400
Message-Id: <20191021121322.25659-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: u8Y7pcu4OlKJ2uN0ij-frA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a v2 that is a combination of two series. Patch 1 is Carlos' and
Dave's patch [1] (that replaces my original patch 1) with an additional
modification based on discussion with Dave [2] in the original v1 post
of this series. Patch 2 is a repost from my previous v1 [3].

Note that this combination of changes is currently untested AFAIA. I'm
planning to run through some tests today and will report back on any
issues...

Brian

v2:
- Added xfs_bmap_btalloc() changes to patch 1.

[1] https://lore.kernel.org/linux-xfs/20190918082453.25266-2-cmaiolino@redh=
at.com/
[2] https://lore.kernel.org/linux-xfs/20190914220035.GY16973@dread.disaster=
.area/
[3] https://lore.kernel.org/linux-xfs/20190912143223.24194-3-bfoster@redhat=
.com/

Brian Foster (1):
  xfs: don't set bmapi total block req where minleft is sufficient

Dave Chinner (1):
  xfs: cap longest free extent to maximum allocatable

 fs/xfs/libxfs/xfs_alloc.c |  3 ++-
 fs/xfs/libxfs/xfs_bmap.c  | 19 +++++++++----------
 fs/xfs/xfs_bmap_util.c    |  4 ++--
 fs/xfs/xfs_dquot.c        |  4 ++--
 fs/xfs/xfs_iomap.c        |  4 ++--
 fs/xfs/xfs_reflink.c      |  4 ++--
 fs/xfs/xfs_rtalloc.c      |  3 +--
 7 files changed, 20 insertions(+), 21 deletions(-)

--=20
2.20.1

