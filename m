Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B566AC64EC7
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Mar 2023 00:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjCAARL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Feb 2023 19:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCAARL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2023 19:17:11 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C33C3756F
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2023 16:17:10 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id h17-20020a17090aea9100b0023739b10792so11319749pjz.1
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2023 16:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=mfTAYLBEaWrnEQlSLDUfVeuVudXgswUQgr1qBwrdn8A=;
        b=kNBGji7evEbgPpHNb6lKg2Zm8XTF/4iwJMzZattmFGhKois3l7FmDQZ6zWGr6T3rwc
         IlpjiAOEUElq4w684Xpxu/+kNn6zQptXa0X7PPHhFsY7f6ya4/sy7xjhbEOW9CE7Mqk+
         9KZT5sOLeNUD1UcDCoXvlxuXAHaARUIgb/X3IKe4reFCj2srsIO9PrPH+rU7IlO7oGP/
         0ctDC4fHkWMbVOdmP+f5mrs7gJ/xC9lgwWL/l+khOlbCnn/iAYbdRox7QjaM+X8pPyK6
         v4lwTlbY49mRcyfTO0MHLBNUBdMjVcDOITsOFecRKfiRQF6zBZujhyztnlyE/US7RT/s
         vXAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mfTAYLBEaWrnEQlSLDUfVeuVudXgswUQgr1qBwrdn8A=;
        b=xDuQ5QOS64nHf2cCGS5lP+Qp14i1yTitSpHvW1TXb+IePt58KdwD7YqvQ9coSwHF5h
         COD30rFQvfbVZ1WLzfj6CY0HqxBrzt+04KRPmg4BQfmmf0HK2gM8iA/4iNus4ECaDXo3
         JZ7XSzIBZo0i6dOqUZ2gvfGsxS9LgOzLI2quIK1tcQpvrf0pxqpugzwUpknoH6NTip2c
         f+ENSWeZcOZgDQ4RKAYghezKsVycDRB+NXiyBwsM8E0HpswLJP3b9kQDWvid4kmp5M0S
         M85TyX/RsF/UUkRpBqbbSU610z5BSAro8mp33PxL8cykjX7vcBgfghdCsAXUFGMse8O7
         fVHg==
X-Gm-Message-State: AO0yUKXlpWBOI/Qd4elU1FST1d+GJDfreps1ibTdUomsKUL54LdjgzHQ
        jSnZ3h3Vog7K0UlvE8tZtm3EIJvXv9MI4eh8
X-Google-Smtp-Source: AK7set9gRqbes8aQsDm7wmBv9O7jtKkDck9rj76hGWkxqRlUIKyITKvBlBaB45YD3zSN3T7u1OdwxA==
X-Received: by 2002:a17:90b:3a8c:b0:234:c031:45e0 with SMTP id om12-20020a17090b3a8c00b00234c03145e0mr5108235pjb.25.1677629829605;
        Tue, 28 Feb 2023 16:17:09 -0800 (PST)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id g10-20020a17090a67ca00b00230b572e90csm6492702pjm.35.2023.02.28.16.17.08
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 16:17:09 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pXA9a-003K3d-73
        for linux-xfs@vger.kernel.org; Wed, 01 Mar 2023 11:17:06 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pXA9a-005WLa-0Q
        for linux-xfs@vger.kernel.org;
        Wed, 01 Mar 2023 11:17:06 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix off-by-one-block in xfs_discard_folio()
Date:   Wed,  1 Mar 2023 11:17:06 +1100
Message-Id: <20230301001706.1315973-1-david@fromorbit.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The recent writeback corruption fixes changed the code in
xfs_discard_folio() to calculate a byte range to for punching
delalloc extents. A mistake was made in using round_up(pos) for the
end offset, because when pos points at the first byte of a block, it
does not get rounded up to point to the end byte of the block. hence
the punch range is short, and this leads to unexpected behaviour in
certain cases in xfs_bmap_punch_delalloc_range.

e.g. pos = 0 means we call xfs_bmap_punch_delalloc_range(0,0), so
there is no previous extent and it rounds up the punch to the end of
the delalloc extent it found at offset 0, not the end of the range
given to xfs_bmap_punch_delalloc_range().

Fix this by handling the zero block offset case correctly.

Fixes: 7348b322332d ("xfs: xfs_bmap_punch_delalloc_range() should take a byte range")
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Found-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 41734202796f..429f63cfd7d4 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -466,6 +466,7 @@ xfs_discard_folio(
 {
 	struct xfs_inode	*ip = XFS_I(folio->mapping->host);
 	struct xfs_mount	*mp = ip->i_mount;
+	xfs_off_t		end_off;
 	int			error;
 
 	if (xfs_is_shutdown(mp))
@@ -475,8 +476,17 @@ xfs_discard_folio(
 		"page discard on page "PTR_FMT", inode 0x%llx, pos %llu.",
 			folio, ip->i_ino, pos);
 
-	error = xfs_bmap_punch_delalloc_range(ip, pos,
-			round_up(pos, folio_size(folio)));
+	/*
+	 * Need to be careful with the case where the pos passed in points to
+	 * the first byte of the folio - rounding up won't change the value,
+	 * but in all cases here we need to end offset to point to the start
+	 * of the next folio.
+	 */
+	if (pos == folio_pos(folio))
+		end_off = pos + folio_size(folio);
+	else
+		end_off = round_up(pos, folio_size(folio));
+	error = xfs_bmap_punch_delalloc_range(ip, pos, end_off);
 
 	if (error && !xfs_is_shutdown(mp))
 		xfs_alert(mp, "page discard unable to remove delalloc mapping.");
-- 
2.39.2

