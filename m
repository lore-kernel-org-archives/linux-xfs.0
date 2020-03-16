Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C09C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 17:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D425D20409
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 17:23:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ADGmONtQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732062AbgCPRXP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 13:23:15 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:49720 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731674AbgCPRXP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 13:23:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584379394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aGWXXxT1m5h58goCw53QWFCg/y8Ow4m2zHnweK1DPZ0=;
        b=ADGmONtQEw7WnB7e9AFV0tSkp8sa3FPi0e+pgE69W6Fjd2RqpQKElkTV5bB/y2Xu1AgVWN
        nU2MI9LqhqSOKdpt/PBZiEJt0ZXUqVVTGk+8G4SVUj3ez6jpG4eM0L+8Zi+nuDZ5OAxDoA
        9uxScI6p683uaLeHPttZAOc29989JgU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-A_MI1DOjOJaTWrqy2GelJw-1; Mon, 16 Mar 2020 13:23:12 -0400
X-MC-Unique: A_MI1DOjOJaTWrqy2GelJw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03276198F34A
        for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2020 17:00:33 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC8375C1B2
        for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2020 17:00:32 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] xfs: quotaoff shutdown fixes
Date:   Mon, 16 Mar 2020 13:00:30 -0400
Message-Id: <20200316170032.19552-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This fixes a couple issues I noticed with quotaoff when working on the
auto relog stuff. Patch 1 creates a helper and patch 2 uses it to
address a shutdown hang and memory leak. Thoughts, reviews, flames
appreciated.

Brian

Brian Foster (2):
  xfs: factor out quotaoff intent AIL removal and memory free
  xfs: fix unmount hang and memory leak on shutdown during quotaoff

 fs/xfs/xfs_dquot_item.c  | 44 ++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_dquot_item.h  |  1 +
 fs/xfs/xfs_qm_syscalls.c | 13 ++++++------
 3 files changed, 43 insertions(+), 15 deletions(-)

--=20
2.21.1

