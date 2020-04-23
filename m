Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B78EEC55185
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 02:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80C9D20747
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 02:37:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BWfSTJ0T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgDWChm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 22:37:42 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50995 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726054AbgDWChl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Apr 2020 22:37:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587609460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=LkZ/8MWeqZ5S/vYO3vYlYpPdDs7AyCkbzSxgRUvre8Q=;
        b=BWfSTJ0Tk+Y5/7Q+5KXMv9XBod7+mpUrWit/GkjeZPZ6VYFFCVcHFegDuOv8e6cXezoEBt
        qcwO+JJeyatuH6N5yPktbenKOuOxYourGpp8Bdlc3NLUmwY5L/YkMXZ5KvFTTCRr7XJsIW
        ovGCTecFcySX81pcVKZzJ4rm6W0uJ2c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-LKNGaf8GOV6rjnkoWzOJzw-1; Wed, 22 Apr 2020 22:36:36 -0400
X-MC-Unique: LKNGaf8GOV6rjnkoWzOJzw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C5B61005510
        for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2020 02:36:35 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 213255DA7B
        for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2020 02:36:35 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: define printk_once variants for xfs messages
Message-ID: <c3aee5bb-806a-d51d-0c0f-b0d6a10fa737@redhat.com>
Date:   Wed, 22 Apr 2020 21:36:34 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There are a couple places where we directly call printk_once() and one
of them doesn't follow the standard xfs subsystem printk format as a
result.

#define printk_once variants to go with our existing printk_ratelimited
#defines so we can do one-shot printks in a consistent manner.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 0b05e10995a0..802a96190d22 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -31,15 +31,27 @@ void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
 }
 #endif
 
-#define xfs_printk_ratelimited(func, dev, fmt, ...)		\
+#define xfs_printk_ratelimited(func, dev, fmt, ...)			\
 do {									\
 	static DEFINE_RATELIMIT_STATE(_rs,				\
 				      DEFAULT_RATELIMIT_INTERVAL,	\
 				      DEFAULT_RATELIMIT_BURST);		\
 	if (__ratelimit(&_rs))						\
-		func(dev, fmt, ##__VA_ARGS__);			\
+		func(dev, fmt, ##__VA_ARGS__);				\
 } while (0)
 
+#define xfs_printk_once(func, dev, fmt, ...)			\
+({								\
+	static bool __section(.data.once) __print_once;		\
+	bool __ret_print_once = !__print_once; 			\
+								\
+	if (!__print_once) {					\
+		__print_once = true;				\
+		func(dev, fmt, ##__VA_ARGS__);			\
+	}							\
+	unlikely(__ret_print_once);				\
+})
+
 #define xfs_emerg_ratelimited(dev, fmt, ...)				\
 	xfs_printk_ratelimited(xfs_emerg, dev, fmt, ##__VA_ARGS__)
 #define xfs_alert_ratelimited(dev, fmt, ...)				\
@@ -57,6 +69,11 @@ do {									\
 #define xfs_debug_ratelimited(dev, fmt, ...)				\
 	xfs_printk_ratelimited(xfs_debug, dev, fmt, ##__VA_ARGS__)
 
+#define xfs_warn_once(dev, fmt, ...)				\
+	xfs_printk_once(xfs_warn, dev, fmt, ##__VA_ARGS__)
+#define xfs_notice_once(dev, fmt, ...)				\
+	xfs_printk_once(xfs_notice, dev, fmt, ##__VA_ARGS__)
+
 void assfail(struct xfs_mount *mp, char *expr, char *f, int l);
 void asswarn(struct xfs_mount *mp, char *expr, char *f, int l);
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index c5513e5a226a..bb91f04266b9 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1300,10 +1300,9 @@ xfs_mod_fdblocks(
 		spin_unlock(&mp->m_sb_lock);
 		return 0;
 	}
-	printk_once(KERN_WARNING
-		"Filesystem \"%s\": reserve blocks depleted! "
-		"Consider increasing reserve pool size.",
-		mp->m_super->s_id);
+	xfs_warn_once(mp,
+"Reserve blocks depleted! Consider increasing reserve pool size.");
+
 fdblocks_enospc:
 	spin_unlock(&mp->m_sb_lock);
 	return -ENOSPC;
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index bb3008d390aa..b101feb2aab4 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -58,9 +58,8 @@ xfs_fs_get_uuid(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
-	printk_once(KERN_NOTICE
-"XFS (%s): using experimental pNFS feature, use at your own risk!\n",
-		mp->m_super->s_id);
+	xfs_notice_once(mp,
+"Using experimental pNFS feature, use at your own risk!");
 
 	if (*len < sizeof(uuid_t))
 		return -EINVAL;

