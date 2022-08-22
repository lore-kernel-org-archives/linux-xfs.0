Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73346C28D13
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Aug 2022 16:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237043AbiHVQ22 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Aug 2022 12:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiHVQ2U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Aug 2022 12:28:20 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E242A101B;
        Mon, 22 Aug 2022 09:28:17 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id s23so5869976wmj.4;
        Mon, 22 Aug 2022 09:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=kGcIKdRqU7mZG6oIgZsRqaH70DPckvwa8kwcbO1drxw=;
        b=l0aZG6wTUMBkbnd7w1hVXuyfQoLvTw+N/JmqIbM5j8GUonXHWvqPx0N5Z/OPEQNRlP
         vdk28fAttlIvfCM/sd8fTpCdwzigReIi//LJyRbrbQnTnBU3tAdGRSjifaa/2umqK5Ek
         pv92NAZQMZ6nO7dszPW2ZsSFmXog4LlFCM8p8PnX1YyZjXVCr7Mghwxn3LADL8jlrIAV
         Oiq+ZyA8fcFVCxkIC1XjSF+BkMCh3+jpZ/xBYQ6ZSSp9cURx5XL/Dg0PHTkIrOBBXWWT
         qKqk8UJ+ySCevsVlkLvgxn0NS058wP0Z6PFc53IZkKJhhCQU8jMarzGsnVI3D5gVdlR/
         rWrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=kGcIKdRqU7mZG6oIgZsRqaH70DPckvwa8kwcbO1drxw=;
        b=Se4qMcQsOtCpQnIhD9cjZ0P6xUWzd74esS02VE7hItV3vVUPnUEMqX/8psuAGsObWo
         SW424HSdkHAUlQxxRzCgCQj9iJuO2qwjC+KaC6TxK6u3calUd+Tbt9Ijcs8PQ83HcGSI
         vth4XHXY8WZ79SrLIB62AvvH9qwMPzI14rsSpukXWETkxz4xUsOA6NsfRLQvVYJFhTlv
         CSMJZlDLdEGUkIN3flW8IMvMY4RFyTCSyYY3Zrq103hCmN4e17jipESPNRG7jmxKIbFd
         acokemjMj8WxpAoQzh2tIiIXzZVCfaev+qmVjlljnDesXSsQ73lp9ooWr5GEGBBMYvfX
         6y+Q==
X-Gm-Message-State: ACgBeo3OwDMQa+y3LIxx23zN6749900KWf8Do8MWRPgPKXmjgpw9wNrE
        eDnQ7oHtflwIVQwLPLKwthyFH9N5e1A=
X-Google-Smtp-Source: AA6agR7RnNyN4Cc5TG8Zep3PZvoiGb3HVbsfeYnTET1CF9QADJPBfbmNYghDgdNPDzIDCDE/uDVBpw==
X-Received: by 2002:a05:600c:384f:b0:3a6:603c:4338 with SMTP id s15-20020a05600c384f00b003a6603c4338mr4493016wmr.192.1661185696458;
        Mon, 22 Aug 2022 09:28:16 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id z13-20020a5d44cd000000b00222ed7ea203sm11749229wrr.100.2022.08.22.09.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 09:28:16 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 CANDIDATE 5/6] xfs: return errors in xfs_fs_sync_fs
Date:   Mon, 22 Aug 2022 19:28:01 +0300
Message-Id: <20220822162802.1661512-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220822162802.1661512-1-amir73il@gmail.com>
References: <20220822162802.1661512-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 2d86293c70750e4331e9616aded33ab6b47c299d upstream.

Now that the VFS will do something with the return values from
->sync_fs, make ours pass on error codes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_super.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 6323974d6b3e..ff686cb16c7b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -757,6 +757,7 @@ xfs_fs_sync_fs(
 	int			wait)
 {
 	struct xfs_mount	*mp = XFS_M(sb);
+	int			error;
 
 	/*
 	 * Doing anything during the async pass would be counterproductive.
@@ -764,7 +765,10 @@ xfs_fs_sync_fs(
 	if (!wait)
 		return 0;
 
-	xfs_log_force(mp, XFS_LOG_SYNC);
+	error = xfs_log_force(mp, XFS_LOG_SYNC);
+	if (error)
+		return error;
+
 	if (laptop_mode) {
 		/*
 		 * The disk must be active because we're syncing.
-- 
2.25.1

