Return-Path: <SRS0=9CIi=XZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B77C32792
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 13:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49D3F216F4
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Sep 2019 13:59:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UCoK2I+7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730266AbfI3N7U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 09:59:20 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38671 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729738AbfI3N7U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 09:59:20 -0400
Received: by mail-pf1-f193.google.com with SMTP id h195so5671554pfe.5
        for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2019 06:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=jZP8HjBK20oJxsyY3hFzVSXhJhggLiaT6Eyx2aXU7oE=;
        b=UCoK2I+7rJg7EtLmYFcJ+W0QlNIEF0dHCEVhCHz4ZDa2vWERmStawpDiV+6UG++77K
         eqEptkhQxNvTqv4LP0keTfzn0nbOBwp7Id476C/b+tZ6q6Ox/2cY26DDzIfE11CryZ9L
         TL+KZEYzfpRqUwzXNTQTdoiiRO5b6agbXvgcohOYMiBFLeCsZhN5SRkrXZYn1hOhLO6+
         lBZRxrkJVU/M4ecuUMAdEZuhdYXpO2pOpqDtjC8+guhnjDBhZBAQJ8mu+CINzXWwcvZp
         b0OTj5Zw6wrKIPLBI+Upoit1vbRyDHfG22mGlRzvLq7uxbk8HGdZaeKWc3PuZhaJ9nUw
         mk0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jZP8HjBK20oJxsyY3hFzVSXhJhggLiaT6Eyx2aXU7oE=;
        b=OG3AIcHMf5qns+qC7R6NAAPB/dfeo9s3ADiEoX46BKu0CualIazZqMYESsyVP3CeB7
         Um/odZvWHKdlbM67wgEfQ6TWbc9yfHgVln/R+ViIte+IrbpQY+/kezjeV4MCpwD1QmZ6
         h+Z4IvnujaM/j8KgGinmYsHJ/df1Ec01jgcpgn/lgKXq27TOiNImPm9Qf2GOaFNezWb1
         jSzSgdB2Ru2vEDyqr3xQzDKtq2c/Rz7PkBJYhXI6MQZ3ntHdaQX593SjE+8RU/zsCjR4
         McTFMB7PglMjst+q33+vV5Zds30B6ToQlWQFHDNehNQNAE9hc79hfOQlw3WC4m9CB0vs
         JEPw==
X-Gm-Message-State: APjAAAWXsfjfcsb3z1YlMp1ZOJTiK9s3WCosjM+PabYqx4w084eVgtL9
        2uKE7IbA/uTnym3pI059yWxZZMExEJs=
X-Google-Smtp-Source: APXvYqxvtWrSvaEmQJxcQ2ATWACv/1zFIxhcJHljQIgfgXD00JLwKW1+hONUFEW2UBggDFu60cQI8A==
X-Received: by 2002:a63:5652:: with SMTP id g18mr5445933pgm.283.1569851959781;
        Mon, 30 Sep 2019 06:59:19 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1951:51d2:a1e1:b995:3e46:902d])
        by smtp.gmail.com with ESMTPSA id p68sm23424815pfp.9.2019.09.30.06.59.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 30 Sep 2019 06:59:18 -0700 (PDT)
From:   Aliasgar Surti <aliasgar.surti500@gmail.com>
X-Google-Original-From: Aliasgar Surti
To:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Cc:     Aliasgar Surti <aliasgar.surti500@gmail.com>
Subject: [PATCH] xfs: removed unused error variable from xchk_refcountbt_rec
Date:   Mon, 30 Sep 2019 19:28:54 +0530
Message-Id: <1569851934-10718-1-git-send-email-aliasgar.surti500@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Aliasgar Surti <aliasgar.surti500@gmail.com>

Removed unused error variable. Instead of using error variable,
returned the value directly as it wasn't updated.

Signed-off-by: Aliasgar Surti <aliasgar.surti500@gmail.com>
---
 fs/xfs/scrub/refcount.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 93b3793b..0cab11a 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -341,7 +341,6 @@ xchk_refcountbt_rec(
 	xfs_extlen_t		len;
 	xfs_nlink_t		refcount;
 	bool			has_cowflag;
-	int			error = 0;
 
 	bno = be32_to_cpu(rec->refc.rc_startblock);
 	len = be32_to_cpu(rec->refc.rc_blockcount);
@@ -366,7 +365,7 @@ xchk_refcountbt_rec(
 
 	xchk_refcountbt_xref(bs->sc, bno, len, refcount);
 
-	return error;
+	return 0;
 }
 
 /* Make sure we have as many refc blocks as the rmap says. */
-- 
2.7.4

