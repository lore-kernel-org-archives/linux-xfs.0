Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 512EEEB64DA
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jun 2023 00:20:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjFTAUa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jun 2023 20:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFTAU3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Jun 2023 20:20:29 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9BDE61
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2023 17:20:28 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-666e6541c98so3338711b3a.2
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2023 17:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687220427; x=1689812427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Pt9hTh40OmTegOekLcRzx5llx2d/nej7rlH4ks8rf4=;
        b=GbnFiocqO85x+M+m7Ju2sHYW5p0JzESgmaYRxwT4giSk2LrDsxwAVvw0/yARnK6U0u
         3XHqwUOmRxYHqYXKA4x5mSkkQR4MrZyzffjozD83q42k7o73qXRrfQIdVXTZTRrKZEwM
         6KbWOMrY1ih4JyTG3bfm2NgBXDpCgh1zgSbaE9fExbJzZ2agC4c1IhdyT/9NO1aBN0J9
         4saFeesWVBYwkvYEaqC5fG8U0sFnoBHlU4QQebarHbiZRKyNGObMoGOZGB5XH3oSTX/y
         KDR7KP0DWXFMkVewQxlJVKq9TxaAisYlqXX7PD/c7QmcY5v6ZYqcxVC76WhNZXKoVXLD
         Soug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687220427; x=1689812427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Pt9hTh40OmTegOekLcRzx5llx2d/nej7rlH4ks8rf4=;
        b=WQDPRo8P7uAa5UsZ4jMYM6AfRwTx7qqXt+HX2f1XMFmgeMPVKqzBiEappvtAVBnFlx
         TtaUfudGHLcxN1MGu/cSuWfLqaUknrw62ivRAEpLyhHeOzDkgERvlTb7Lx1l+zrqqUCx
         Lj8Z4oPuSfxwTqtjPuLJ2FGno9Zue560Jadc9qhZGVrzAXR7mwA1+9UOkXgac9bra4ip
         jV8azr17J3TB9p5cAIfNZSH5rlBYwyJVLKMFJ7I8/jVcoD8VwqVsjqG5m9f7EnegLhsk
         kw5lSu3hHGRwF+CTUcYs9ROT1V/MxKBJsDmEXPn8jN4Uu8gkJw7j8c1EU1JuaYiRBt1b
         L8rQ==
X-Gm-Message-State: AC+VfDyoICWOIC1I14wVHO8q+t5AAK54DfzlE5fOmzYO0RM8At9zy/2H
        yNmRpx8r21quhqmuSl5/U+UEHrhyJ0acpNQBOfo=
X-Google-Smtp-Source: ACHHUZ4LJGA8zlr+n6LpNGpvknputMaYQioVU3/TKDjBsi4Dy4cA8X3W5Q0FsKKogxF7eX7awt3Qfw==
X-Received: by 2002:a05:6a20:6a2b:b0:10f:1d33:d667 with SMTP id p43-20020a056a206a2b00b0010f1d33d667mr15144089pzk.5.1687220427457;
        Mon, 19 Jun 2023 17:20:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id k25-20020aa792d9000000b0065da94fe921sm200548pfa.50.2023.06.19.17.20.26
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 17:20:26 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qBP6d-00Dqg7-13
        for linux-xfs@vger.kernel.org;
        Tue, 20 Jun 2023 10:20:23 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qBP6d-004dly-01
        for linux-xfs@vger.kernel.org;
        Tue, 20 Jun 2023 10:20:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] xfs: don't reverse order of items in bulk AIL insertion
Date:   Tue, 20 Jun 2023 10:20:17 +1000
Message-Id: <20230620002021.1038067-2-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230620002021.1038067-1-david@fromorbit.com>
References: <20230620002021.1038067-1-david@fromorbit.com>
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

