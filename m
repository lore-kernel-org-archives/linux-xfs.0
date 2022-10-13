Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E5BBC43217
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 03:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiJMDP4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Oct 2022 23:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiJMDPy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Oct 2022 23:15:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC86D2CF0
        for <linux-xfs@vger.kernel.org>; Wed, 12 Oct 2022 20:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665630951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UaKxwXZs5j3I47+jfA+D9uXp42ETQG8kiqYPq0Jybsk=;
        b=PsRQGAMdQBC9M7jU3l93FRHi7jvy3f0g+PgBahTjfDfd48YjbZPFwCEoIZbyVfzzumfm7G
        EgfFtl9gCmHDCS6nlsB194HdVyWq3DkpZkM9pwlaUEuUIriREVnnNPL7084oAK+pwSvfnU
        UdSFHdGaunmBV6MM5HD7xzev109or/4=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-127-U7NVBiy-NVS9Zgn_xYMvAA-1; Wed, 12 Oct 2022 23:15:50 -0400
X-MC-Unique: U7NVBiy-NVS9Zgn_xYMvAA-1
Received: by mail-pj1-f69.google.com with SMTP id mq15-20020a17090b380f00b0020ad26fa5edso2498702pjb.7
        for <linux-xfs@vger.kernel.org>; Wed, 12 Oct 2022 20:15:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UaKxwXZs5j3I47+jfA+D9uXp42ETQG8kiqYPq0Jybsk=;
        b=upXsS8dPE40wa0GH+KriCRw/Ex+HEhN12tF1+yxr0Fb32C/wnw0ulwXRz5tmqHMnh5
         0OlQ5bE000rivMXVSGhelzbJRQPoPSZJp1N7TR1bZQyFuo3XNU9vZh/deqYQ8jouDKOS
         5LCWxe6o7CT4yY3gNpoFY81f5A5oQoJ5qKvXqnSyc1QF+Q7S6pEl8TnEKN7uoaOUBmYn
         PMktIush6q8rXlSuorZQ3V/mGeA0kYSwGg5Z2opB7tqrYzpbdgZKijkCj6wVjIdgFMkY
         raPiQzH9hOBCZEOuQv/6xCNKnk/D9j715Ct7Hlr8rghR7ZdpYp09Ea9ZAxBw61Oy9V/b
         Zy+A==
X-Gm-Message-State: ACrzQf1jTGjanBmhPiWy46J1E1qrvn7+jTJAbqFrXqFlbSi15FGaaB7m
        eHj/S1ZvGlkVktWLFHC+whxwtmhl9x9Picr/lXvrMIAp3Wk+sFd2oRswexmAXu/8H4g2cyIq4D7
        mUi56s7jM2XF4NI6CfclFT67aqWsQGze4RCSwuynMdij/SKBRmwvmkfmyfsddDjopmOxi9aTE
X-Received: by 2002:a17:90a:1b65:b0:1f7:4725:aa6e with SMTP id q92-20020a17090a1b6500b001f74725aa6emr8466523pjq.179.1665630949099;
        Wed, 12 Oct 2022 20:15:49 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4cSgParvKTnjfX2j2MSF/yq3Qsu09qXVanrZribhb3aJUMV1kJM8fuigvYjSEwFIfiYO5vBw==
X-Received: by 2002:a17:90a:1b65:b0:1f7:4725:aa6e with SMTP id q92-20020a17090a1b6500b001f74725aa6emr8466497pjq.179.1665630948703;
        Wed, 12 Oct 2022 20:15:48 -0700 (PDT)
Received: from snowcrash.redhat.com ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b00176b84eb29asm11273085plk.301.2022.10.12.20.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 20:15:48 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 4/4] xfsrestore: untangle inventory unpacking logic
Date:   Thu, 13 Oct 2022 14:15:18 +1100
Message-Id: <20221013031518.1815861-5-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221013031518.1815861-1-ddouwsma@redhat.com>
References: <20221013031518.1815861-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

stobj_unpack_sessinfo returns bool_t, fix logic in pi_addfile so errors
can be properly reported.

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 restore/content.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/restore/content.c b/restore/content.c
index b3999f9..04b6f81 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -5463,17 +5463,14 @@ pi_addfile(Media_t *Mediap,
 			 * desc.
 			 */
 			sessp = 0;
-			if (!buflen) {
-				ok = BOOL_FALSE;
-			} else {
-			    /* extract the session information from the buffer */
-			    if (stobj_unpack_sessinfo(bufp, buflen, &sessinfo)<0) {
-				ok = BOOL_FALSE;
-			    } else {
+			ok = BOOL_FALSE;
+			/* extract the session information from the buffer */
+			if (buflen &&
+			    stobj_unpack_sessinfo(bufp, buflen, &sessinfo)) {
 				stobj_convert_sessinfo(&sessp, &sessinfo);
 				ok = BOOL_TRUE;
-			    }
 			}
+
 			if (!ok || !sessp) {
 				mlog(MLOG_DEBUG | MLOG_WARNING | MLOG_MEDIA, _(
 				      "on-media session "
-- 
2.31.1

