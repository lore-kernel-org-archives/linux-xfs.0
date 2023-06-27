Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3925C001B0
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jun 2023 22:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjF0WoZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jun 2023 18:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjF0WoX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jun 2023 18:44:23 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B8E272D
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 15:44:19 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1b51488ad67so28100925ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 15:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687905859; x=1690497859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Pt9hTh40OmTegOekLcRzx5llx2d/nej7rlH4ks8rf4=;
        b=mom7otQF0a2HN08fs9kdMIgmJR1YOyc7Tea2SHuWXX277jsbkhuVfpETqFNatTyNEo
         AQSI2f8ASRNhYHzvceu4kph06vQ9//cIGRUPu3xNWbSnbyPHuU7XAtT2PYethdfj01EV
         N2Za+WmccMR9ygztBScc17aLFOZ2Q9TGESZ5+lwKcwXqxywleVBV3R8cFpImntM0EH8/
         SwHB0mpiChMVeHii+VLrU4xW8vdROZFJ8Y5CAzNXbai9ren1iIORRIiUreLRTT7mUAJq
         9Njj2k3vYMgVmEdQuDvjoJTHUi6Krhis4xm+DbGLlV2uKhFf6Ab9AaVwlSdWi3+NAgOR
         xMFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687905859; x=1690497859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Pt9hTh40OmTegOekLcRzx5llx2d/nej7rlH4ks8rf4=;
        b=WavzeHeZwkwzCCNhDLpiBSbAiJXtAxU4uS83sAHukj7pEdvLmvhMpgxbmH/IUJveY7
         oIy3WS5HQCnniTZup4nF/LhkDzSMp9516Y1kUhKtS7iSIGtgBNi/cpt2MT0r6sNrwzmw
         PeVh4idqBgoaQfZecvLfH37CMsQ4iUF+NmxDdc+cwBgeXaL8tY4D5n3qZc5dhjHyjRf4
         pGiYDWTjkIjcVLpyLRSjlWSECAHLtjSJnQDBfRToxLhjY4duJDby+7xtAieSNS0yi64N
         b5ZSWvpDH9s0kjIksqK2OujAcCabRDRVbultip+V/kIWsWV5zGXmlbT5U3YXTngs2R9R
         UIXQ==
X-Gm-Message-State: AC+VfDzLcd878wxDUen8WNnYEAiNF24UdfoRp9QZqx+qPSCBYk9Vg7W8
        fSWKM+eyze7KwZ3RlFEHb+JZyOwvwnVlp2o5KYg=
X-Google-Smtp-Source: ACHHUZ6haVb/ehzeHZFWdzfjctyqRHDgzI7KB0p32JOJcvehJ+yGPjuuQe+Ov6hZmK7jPUD10lmF7A==
X-Received: by 2002:a17:903:2343:b0:1b5:54cc:fcb7 with SMTP id c3-20020a170903234300b001b554ccfcb7mr9955372plh.34.1687905858863;
        Tue, 27 Jun 2023 15:44:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-94-37.pa.vic.optusnet.com.au. [49.186.94.37])
        by smtp.gmail.com with ESMTPSA id jn16-20020a170903051000b001b53472353csm6403955plb.211.2023.06.27.15.44.17
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 15:44:17 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qEHPz-00GzwS-0z
        for linux-xfs@vger.kernel.org;
        Wed, 28 Jun 2023 08:44:15 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qEHPy-009Zm7-37
        for linux-xfs@vger.kernel.org;
        Wed, 28 Jun 2023 08:44:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/8] xfs: don't reverse order of items in bulk AIL insertion
Date:   Wed, 28 Jun 2023 08:44:05 +1000
Message-Id: <20230627224412.2242198-2-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230627224412.2242198-1-david@fromorbit.com>
References: <20230627224412.2242198-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

XFS has strict metadata ordering requirements. One of the things it
does is maintain the commit order of items from transaction commit
through the CIL and into the AIL. That is, if a transaction logs
item A before item B in a modification, then they will be inserted
into the CIL in the order {A, B}. These items are then written into
the iclog during checkpointing in the order {A, B}. When the
checkpoint commits, they are supposed to be inserted into the AIL in
the order {A, B}, and when they are pushed from the AIL, they are
pushed in the order {A, B}.

If we crash, log recovery then replays the two items from the
checkpoint in the order {A, B}, resulting in the objects the items
apply to being queued for writeback at the end of the checkpoint
in the order {A, B}. This means recovery behaves the same way as the
runtime code.

In places, we have subtle dependencies on this ordering being
maintained. One of this place is performing intent recovery from the
log. It assumes that recovering an intent will result in a
non-intent object being the first thing that is modified in the
recovery transaction, and so when the transaction commits and the
journal flushes, the first object inserted into the AIL beyond the
intent recovery range will be a non-intent item.  It uses the
transistion from intent items to non-intent items to stop the
recovery pass.

A recent log recovery issue indicated that an intent was appearing
as the first item in the AIL beyond the recovery range, hence
breaking the end of recovery detection that exists.

Tracing indicated insertion of the items into the AIL was apparently
occurring in the right order (the intent was last in the commit item
list), but the intent was appearing first in the AIL. IOWs, the
order of items in the AIL was {D,C,B,A}, not {A,B,C,D}, and bulk
insertion was reversing the order of the items in the batch of items
being inserted.

Lucky for us, all the items fed to bulk insertion have the same LSN,
so the reversal of order does not affect the log head/tail tracking
that is based on the contents of the AIL. It only impacts on code
that has implicit, subtle dependencies on object order, and AFAICT
only the intent recovery loop is impacted by it.

Make sure bulk AIL insertion does not reorder items incorrectly.

Fixes: 0e57f6a36f9b ("xfs: bulk AIL insertion during transaction commit")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans_ail.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 7d4109af193e..1098452e7f95 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -823,7 +823,7 @@ xfs_trans_ail_update_bulk(
 			trace_xfs_ail_insert(lip, 0, lsn);
 		}
 		lip->li_lsn = lsn;
-		list_add(&lip->li_ail, &tmp);
+		list_add_tail(&lip->li_ail, &tmp);
 	}
 
 	if (!list_empty(&tmp))
-- 
2.40.1

