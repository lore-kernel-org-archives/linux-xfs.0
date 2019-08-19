Return-Path: <SRS0=Z/aa=WP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 867B9C3A5A0
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 13:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 504C42086C
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 13:06:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YV63shfr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfHSNGn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Aug 2019 09:06:43 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45937 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727551AbfHSNGn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Aug 2019 09:06:43 -0400
Received: by mail-pl1-f196.google.com with SMTP id y8so944665plr.12
        for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2019 06:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=e3lov9hyzHrWK4QG5v3c9wZDRkXF4+BnwHRIS1VEMsc=;
        b=YV63shfr2q+CZGeKaji67YrBjdTlClIbeG0JTa4ZnaNys4lb8+v6AOP/me1uC2Dq+e
         oxIa7Qy6gIdvm+Ad2ELO7nhB16BbX7xo2K/ngQVaXTE1Rd2D2LbHKaKGYlynShP52jzw
         xAS8yAwPGzNYzSUcIMlGqRxJl8R1niRsqYomEkWQLilqRzb8Tj1lD0DZ3AlP57bAnhZM
         t+LS55cve+rbB0EkExTsRXXP813mwO2DlpUmApTUqp8zxz+RSTpjgrd1DmlLMv0IjA/f
         TmCWUYhjqBtwjzhEHi+QiCgBe1GKjx4wAGKSaUfnt6kVhoQ+RYUmWZbTDW31uYkTcX1B
         Ny9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=e3lov9hyzHrWK4QG5v3c9wZDRkXF4+BnwHRIS1VEMsc=;
        b=hrK/gY7vCYD2VW8Wan6mcHV4IUeSN9sQl6st1D4sKemvNBZHmzJryNP4MtMEdX/ezB
         60TwECjRExAFDDqnXSFcco/xmsV04ZonUOTDrw/ldtEXJ1HPo3I8PrgbtZXy371+XZIH
         t9oj7D0AOQT6Wf8yp4VQrbpvD3sEuXmIdHPXXe2zEvYnsHeyfmF0HhyTnozUYCILpERO
         EB9INLhqhJYHWmDdGlz2sq9EJScbA1iWpUmBqw6RVDdb8SttnFFLP8Gko9mm5TldKUBt
         Fbe3RIrgnVfvKPwFerFSXEQhbL73G30qtjntpBfkVmJ+Vd1utlV1VYaPdtUgMI6KuWuO
         fP/A==
X-Gm-Message-State: APjAAAXtGF508ljCVh+2oupMn8ZZbKRFytcJMaw4h9grD3xa7saLDDva
        fM5xghPHKHEnLUAqaRofnw==
X-Google-Smtp-Source: APXvYqy4GH0U+fayFd7NMPOcIUl4owIoum0Ysec+WxUKnmWVkEXGSdPDrKcMcLJO7wuLGRwNMObJ/g==
X-Received: by 2002:a17:902:b582:: with SMTP id a2mr22411013pls.199.1566220002756;
        Mon, 19 Aug 2019 06:06:42 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id ay7sm13203511pjb.4.2019.08.19.06.06.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 06:06:42 -0700 (PDT)
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>, newtongao@tencent.com,
        jasperwang@tencent.com, xiakaixu1987@gmail.com
From:   kaixuxia <xiakaixu1987@gmail.com>
Subject: [PATCH V2] xfs: Fix agi&agf ABBA deadlock when performing rename with
 RENAME_WHITEOUT flag
Message-ID: <8eda2397-b7fb-6dd4-a448-a81628b48edc@gmail.com>
Date:   Mon, 19 Aug 2019 21:06:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When performing rename operation with RENAME_WHITEOUT flag, we will
hold AGF lock to allocate or free extents in manipulating the dirents
firstly, and then doing the xfs_iunlink_remove() call last to hold
AGI lock to modify the tmpfile info, so we the lock order AGI->AGF.

The big problem here is that we have an ordering constraint on AGF
and AGI locking - inode allocation locks the AGI, then can allocate
a new extent for new inodes, locking the AGF after the AGI. Hence
the ordering that is imposed by other parts of the code is AGI before
AGF. So we get the ABBA agi&agf deadlock here.

Process A:
Call trace:
  ? __schedule+0x2bd/0x620
  schedule+0x33/0x90
  schedule_timeout+0x17d/0x290
  __down_common+0xef/0x125
  ? xfs_buf_find+0x215/0x6c0 [xfs]
  down+0x3b/0x50
  xfs_buf_lock+0x34/0xf0 [xfs]
  xfs_buf_find+0x215/0x6c0 [xfs]
  xfs_buf_get_map+0x37/0x230 [xfs]
  xfs_buf_read_map+0x29/0x190 [xfs]
  xfs_trans_read_buf_map+0x13d/0x520 [xfs]
  xfs_read_agf+0xa6/0x180 [xfs]
  ? schedule_timeout+0x17d/0x290
  xfs_alloc_read_agf+0x52/0x1f0 [xfs]
  xfs_alloc_fix_freelist+0x432/0x590 [xfs]
  ? down+0x3b/0x50
  ? xfs_buf_lock+0x34/0xf0 [xfs]
  ? xfs_buf_find+0x215/0x6c0 [xfs]
  xfs_alloc_vextent+0x301/0x6c0 [xfs]
  xfs_ialloc_ag_alloc+0x182/0x700 [xfs]
  ? _xfs_trans_bjoin+0x72/0xf0 [xfs]
  xfs_dialloc+0x116/0x290 [xfs]
  xfs_ialloc+0x6d/0x5e0 [xfs]
  ? xfs_log_reserve+0x165/0x280 [xfs]
  xfs_dir_ialloc+0x8c/0x240 [xfs]
  xfs_create+0x35a/0x610 [xfs]
  xfs_generic_create+0x1f1/0x2f0 [xfs]
  ...

Process B:
Call trace:
  ? __schedule+0x2bd/0x620
  ? xfs_bmapi_allocate+0x245/0x380 [xfs]
  schedule+0x33/0x90
  schedule_timeout+0x17d/0x290
  ? xfs_buf_find+0x1fd/0x6c0 [xfs]
  __down_common+0xef/0x125
  ? xfs_buf_get_map+0x37/0x230 [xfs]
  ? xfs_buf_find+0x215/0x6c0 [xfs]
  down+0x3b/0x50
  xfs_buf_lock+0x34/0xf0 [xfs]
  xfs_buf_find+0x215/0x6c0 [xfs]
  xfs_buf_get_map+0x37/0x230 [xfs]
  xfs_buf_read_map+0x29/0x190 [xfs]
  xfs_trans_read_buf_map+0x13d/0x520 [xfs]
  xfs_read_agi+0xa8/0x160 [xfs]
  xfs_iunlink_remove+0x6f/0x2a0 [xfs]
  ? current_time+0x46/0x80
  ? xfs_trans_ichgtime+0x39/0xb0 [xfs]
  xfs_rename+0x57a/0xae0 [xfs]
  xfs_vn_rename+0xe4/0x150 [xfs]
  ...

In this patch we move the xfs_iunlink_remove() call to between
xfs_dir_canenter() and xfs_dir_createname(). By doing xfs_iunlink
_remove() firstly, we remove the AGI/AGF lock inversion problem.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
---
  fs/xfs/xfs_inode.c | 20 +++++++++++++++++---
  1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6467d5e..48691f2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3294,6 +3294,18 @@ struct xfs_iunlink {
  			if (error)
  				goto out_trans_cancel;
  		}
+
+		/*
+		 * Handle the whiteout inode and acquire the AGI lock, so
+		 * fix the AGI/AGF lock inversion problem.
+		 */
+		if (wip) {
+			ASSERT(VFS_I(wip)->i_nlink == 0);
+			error = xfs_iunlink_remove(tp, wip);
+			if (error)
+				goto out_trans_cancel;
+		}
+
  		/*
  		 * If target does not exist and the rename crosses
  		 * directories, adjust the target directory link count
@@ -3428,9 +3440,11 @@ struct xfs_iunlink {
  	if (wip) {
  		ASSERT(VFS_I(wip)->i_nlink == 0);
  		xfs_bumplink(tp, wip);
-		error = xfs_iunlink_remove(tp, wip);
-		if (error)
-			goto out_trans_cancel;
+		if (target_ip != NULL) {
+			error = xfs_iunlink_remove(tp, wip);
+			if (error)
+				goto out_trans_cancel;
+		}
  		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);

  		/*
-- 
1.8.3.1

-- 
kaixuxia
