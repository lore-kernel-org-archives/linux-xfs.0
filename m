Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36BAC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 03:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiJMDPw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Oct 2022 23:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiJMDPu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Oct 2022 23:15:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4957CA893
        for <linux-xfs@vger.kernel.org>; Wed, 12 Oct 2022 20:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665630940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MEmJzOUJecGzhWwCrJfytl0SKP7I5a0qmcuswDIF+Ds=;
        b=ABthMWIJEMk/LbAHrU2Jf5/p1sYmLf4FFUTeGy9kEW7+6TtDbRJNtzmmKiIWuDfkKHRcEz
        52i5OIdtvaCd9d8TIy2ZnFmdDwHOPdwQVngOWJKNRvPImNw4XMvRyIvPGtoXojySA/wU5Q
        khiJGtqlPagju4OSKsSjVz0hJ4co1eE=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-551-K-Tai93EMPm2hGBA95YAow-1; Wed, 12 Oct 2022 23:15:32 -0400
X-MC-Unique: K-Tai93EMPm2hGBA95YAow-1
Received: by mail-pl1-f199.google.com with SMTP id c10-20020a170902d48a00b001825736b382so499398plg.15
        for <linux-xfs@vger.kernel.org>; Wed, 12 Oct 2022 20:15:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MEmJzOUJecGzhWwCrJfytl0SKP7I5a0qmcuswDIF+Ds=;
        b=2pM7KWbQKB8YPH9Q1fVOOJRhbxC0dU+MUL7rU899u1xh3PARr12kI/6wPJPn+EHdKW
         rO+TbkMCpVjhmfsVNDKFwJh+TMbbtsr1xnWbquPt+YOt/xv76mVQaKTP0B1ZPz1t3v8F
         +9oMcwSRMNrKyR1F1PN7U6GyBg0RnEAUEW6A2xVQ6miIPWCxA3u8oQY16+RDmYTGtfi7
         ujT63pAvPy35uGnc6OflF9GuwVLQVazhfaZw6+0HRjjvgR9u3gi7OBS963z83HicPPQP
         sht7iDwkD8E65+pS7ZpvXt3FWzTr4ysXcUCtMHs4slThZtclQMXX2s11raM6SpQwseCG
         EPXg==
X-Gm-Message-State: ACrzQf1GN2R7YgWwKeA2JKHyY4r8koY0jwjdH/GeX4KXQTRzQMyNaze2
        n4j0sHab8objwVP2WP5WMr84FtunyPUAnYbPAN/DKt1JlzQHP4s++2YQMFUMxln6lTzj3WYPhSg
        82+s/vEzXh8Dm3MvJhZ6lQTQOxOEyLTsr+HMc/C2BxrWzo+ADy4cA4lMDBpKzl2fx3gj5SNHK
X-Received: by 2002:a17:903:1112:b0:179:ce23:dd57 with SMTP id n18-20020a170903111200b00179ce23dd57mr34029211plh.114.1665630930796;
        Wed, 12 Oct 2022 20:15:30 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6+YEVbArYMkVlYjL5/dNqU4tXUtg/VCYFwlh+bG1oqgD7fBxCvFU2SmlPxBmEDOMTPid8t4A==
X-Received: by 2002:a17:903:1112:b0:179:ce23:dd57 with SMTP id n18-20020a170903111200b00179ce23dd57mr34029187plh.114.1665630930443;
        Wed, 12 Oct 2022 20:15:30 -0700 (PDT)
Received: from snowcrash.redhat.com ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b00176b84eb29asm11273085plk.301.2022.10.12.20.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 20:15:29 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH v3 0/4] xfsrestore: fix inventory unpacking
Date:   Thu, 13 Oct 2022 14:15:14 +1100
Message-Id: <20221013031518.1815861-1-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When xfsrestore reads its inventory from tape it fails to convert the media
record on bigendian systems, if the online inventory is unavailable this results
in invalid data being writen to the online inventory and failure to restore
non-directory files.

The series fixes the converstion and related issues.

---
v2
- Seperate out cleanup and content.c changes, fix whitespace.
- Show a full reproducer in the first patch.
V3
- Fix whitespace and Signed-off-by.
- Make for loop formatting consistent.
- Rename patches to make their intent clearer.
- Add xfsdump: fix on-media inventory stream packing.
- Add descriptions that reproduce the stream problems.

Donald Douwsma (4):
  xfsrestore: fix on-media inventory media unpacking
  xfsrestore: fix on-media inventory stream unpacking
  xfsdump: fix on-media inventory stream packing
  xfsrestore: untangle inventory unpacking logic

 inventory/inv_stobj.c | 42 +++++++++++++++---------------------------
 restore/content.c     | 13 +++++--------
 2 files changed, 20 insertions(+), 35 deletions(-)

-- 
2.31.1

