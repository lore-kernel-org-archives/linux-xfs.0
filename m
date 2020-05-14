Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D7FC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 03:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D590B206DC
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 03:45:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hUV5IL+H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgENDpj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 23:45:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43067 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725925AbgENDpj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 23:45:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589427937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=UyGxikIonJhpMWQ3koc441V7dMeldgLSaRZ1ligkcHU=;
        b=hUV5IL+H7dFI8ZxcTHpfAvax7twDSdBR+ysZedMBJ/4z4Y7RhF4MSz60bj79QCTX4ckz/h
        ypoEkUDnzS3x1vgawERL7vsnWc+fVwJrzrO4Dh/MP4/dpVijLMty0CNM65ka1BRdwvhHZr
        zj+u8eO9bLc+jSwD9t7TTKA0snfdS+E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-_FwneXJuOoSbAM37qY1JYQ-1; Wed, 13 May 2020 23:45:34 -0400
X-MC-Unique: _FwneXJuOoSbAM37qY1JYQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59E94107ACCA;
        Thu, 14 May 2020 03:45:33 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 012132E174;
        Thu, 14 May 2020 03:45:32 +0000 (UTC)
To:     Jan Kara <jack@suse.cz>, linux-xfs <linux-xfs@vger.kernel.org>
Cc:     =?UTF-8?B?UGV0ciBQw61zYcWZ?= <ppisar@redhat.com>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] quota-tools: Set FS_DQ_TIMER_MASK for individual xfs grace
 times
Message-ID: <72a454f1-c2ee-b777-90db-6bdfd4a8572c@redhat.com>
Date:   Wed, 13 May 2020 22:45:32 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs quota code doesn't currently allow increasing an individual
user's grace time, but kernel patches are in development for this.

In order for setquota to be able to send this update via
setquota -T, we need to add the FS_DQ_TIMER_MASK when we are trying
to update the grace times on an individual user's dquot.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I wonder if we should only be setting the LIMIT_MASK only if
(flags & COMMIT_LIMITS), but it doesn't seem to be a problem and
is unrelated to this change I'm leaving it alone for now, though if
anyone thinks it's better I can update the patch.

I'm putting together xfstests cases for this, if you want to wait
for those, that's fine.  Thanks!

diff --git a/quotaio_xfs.c b/quotaio_xfs.c
index b22c7b4..a4d6f67 100644
--- a/quotaio_xfs.c
+++ b/quotaio_xfs.c
@@ -166,6 +166,8 @@ static int xfs_commit_dquot(struct dquot *dquot, int flags)
 			xdqblk.d_fieldmask |= FS_DQ_BCOUNT;
 	} else {
 		xdqblk.d_fieldmask |= FS_DQ_LIMIT_MASK;
+		if (flags & COMMIT_TIMES) /* indiv grace period */
+			xdqblk.d_fieldmask |= FS_DQ_TIMER_MASK;
 	}
 
 	qcmd = QCMD(Q_XFS_SETQLIM, h->qh_type);

