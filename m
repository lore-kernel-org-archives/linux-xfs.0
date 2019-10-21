Return-Path: <SRS0=IeGX=YO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A2BCA9EB9
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 09:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59D0A2089C
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 09:32:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BO1gsIUG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfJUJcr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 05:32:47 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36913 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727737AbfJUJcr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Oct 2019 05:32:47 -0400
Received: by mail-pg1-f193.google.com with SMTP id p1so7445982pgi.4
        for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2019 02:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=h2OtWClt4Dz8GTKJ+r8RFkhMxv3eYOWG+IOESHEbPwY=;
        b=BO1gsIUGc17yS+s2VYq2G5TpkpVshdyX4zo2Y8JvjE30w/OP1lDHphVgscvHfOIErm
         V+Ul/6zBh/RsuNf8+wNkHgVPmrw0KJwi6LyJRy+PMu9LogW17ogsQLttk2RcY17y7HiM
         mSxotO5hOHMom4j35otanOWn3R5Zr2J5MhTWF6xtGqz2A+AcpMcNHPKs+pP5a1xBQC1l
         YeBc1YxR9PvXkRJqVlZFJrHaxgtMAFODCe2NnyBaa1tHm/wlHwGB9bBZ/JGweMspRsQF
         719I1aV9eKu5E35b2lsC7aL5rAumGzYSL7ypa69QqeHXpdCnrV8OCHSQYTe/f6VJlVla
         k5TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=h2OtWClt4Dz8GTKJ+r8RFkhMxv3eYOWG+IOESHEbPwY=;
        b=Ibna6oTkZ1fnQParzIUq5hF24XqJZa4JZoTjMkSa4vbKO9ElTATlQ1+2pxSUJ3ySuh
         4UcW0E8DPcmEl0FroF0qKrrwvFnBhGAhcSOe9tuASDMXZa8mlZ/4xnowITie035043Nd
         d/iiOiE4xWNUbWSY9P0869O+WrfsvMT7KT517mHyOyfltGPNeu8Hxpm8FA394vpNYxUi
         0ojWzHIF9cWYiKwXrDaB1Z98Qes3/200wrAkO+4QxMeIK3ilJr3gbCyGnm39gxDRpQuS
         Iz/2MpNrswW67uYTgcmA6mw6UI7gWg0zAlAikiOApKrKOvNjVz42Wo6fyPWXm1XVnKLI
         6Lrg==
X-Gm-Message-State: APjAAAWZMWcw5lUknC71ORKkwhpumlrryALjdXw7MMqB2ss/zxS61gNM
        5CChVPuz9pK5ui+XSEzFsFV7wNs=
X-Google-Smtp-Source: APXvYqwckeA5QuKWzT+64T5yTE9X5gmgQaeaLdZdVtO9TISh9PMkd1QmHnyaJ73OmFAZRCz6dqrQjA==
X-Received: by 2002:a63:cf46:: with SMTP id b6mr24428639pgj.90.1571650366765;
        Mon, 21 Oct 2019 02:32:46 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id 207sm15011295pfu.129.2019.10.21.02.32.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2019 02:32:46 -0700 (PDT)
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
From:   kaixuxia <xiakaixu1987@gmail.com>
Subject: [PATCH] xfs: remove the duplicated inode log fieldmask set
Message-ID: <8df3c417-4fb2-f37b-6f27-3df069903c08@gmail.com>
Date:   Mon, 21 Oct 2019 17:32:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The xfs_bumplink() call has set the inode log fieldmask XFS_ILOG_CORE,
so the next xfs_trans_log_inode() call is not necessary.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 18f4b26..b0c81f1d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3327,7 +3327,6 @@ struct xfs_iunlink {
 			goto out_trans_cancel;
 
 		xfs_bumplink(tp, wip);
-		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
 		VFS_I(wip)->i_state &= ~I_LINKABLE;
 	}
 
-- 
1.8.3.1

-- 
kaixuxia
