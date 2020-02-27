Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1166EC11D3D
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 20:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D82A62469C
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 20:36:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YGH2wJVD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbgB0Ugm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 15:36:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26233 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726793AbgB0Ugm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 15:36:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582835801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xZl+beKLNuW8qITzc+wXWy4v4xqUdd/CVQtjT3z+ixI=;
        b=YGH2wJVDsiuKkFT/d9x71/gmdiuZbzBW0GAuC1qOS/vDVHzC4PyxVuDOgWl2vmoB9/nLpp
        7IDoV8lmWLT5KmwJAe5eeJcGlUYuHsGo4O3umaeRo46rxDTkH3bmVJgSMJkvhJkwuQAuED
        TyCdXnj+0RonNzUcSzXYfp0i4Rq3zH8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-KW6yAc8PNeqaEydMVWAKeQ-1; Thu, 27 Feb 2020 15:36:39 -0500
X-MC-Unique: KW6yAc8PNeqaEydMVWAKeQ-1
Received: by mail-wr1-f71.google.com with SMTP id s13so332743wru.7
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 12:36:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xZl+beKLNuW8qITzc+wXWy4v4xqUdd/CVQtjT3z+ixI=;
        b=I6SvBwjNu7lyBIagpKLM7PezT+Dn8yRjoNAxL2zAgMXKcCogM8v8rUrcGb2GHwMSh1
         k2GG54XsR/lUyEIWDDJRznhcF318E4o9kCJFsoJXHOBvxrJ/9lMEV+KcWSlrsV2cfz7J
         6G8z3A3nC/K4sdDhJeCUGF/bahSBURzPLRXR/8b687xL3L9Kte0qKTPs3crqCX9cVDY/
         gMadx3adUN/5lhcNM62isgGwlOYNgdWFCiX6fki1fP1AP7yyv+9sxOv/4RzuvTuUUkx1
         t6elcB+bJ3woqIxWEWZV3g0jNz+tGCi3lDDJpcActP2g24ET1TpCl0XbBtnnzmF3uE5f
         P+OQ==
X-Gm-Message-State: APjAAAVaxIWanuTX3qWT8OtqH6Mm3TY911dwUbu3uuPFjJAvbBR/6RPf
        mh7cirKKZQDHBV7FRuN2bF3suxQJRUy1pUZZFY4rfeQqGTnsF8tYUG0wsmQp5oiLnnuRdEeH9ee
        awJRDwAJpQ+tVevdH9kDl
X-Received: by 2002:adf:c44a:: with SMTP id a10mr604024wrg.279.1582835797887;
        Thu, 27 Feb 2020 12:36:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqypkOoMw2ZNcnIM7hKe6sEfMc/+n6oC21Qnfiot8U+7f6Mn1RpJf1LwvyhWXf107DusLLqCww==
X-Received: by 2002:adf:c44a:: with SMTP id a10mr604013wrg.279.1582835797708;
        Thu, 27 Feb 2020 12:36:37 -0800 (PST)
Received: from localhost.localdomain (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id e11sm9217157wrm.80.2020.02.27.12.36.37
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 12:36:37 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 0/4] xfs: Remove wrappers for some semaphores
Date:   Thu, 27 Feb 2020 21:36:32 +0100
Message-Id: <20200227203636.317790-1-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove some wrappers that we have in XFS around the read-write semaphore
locks.

The goal of this cleanup is to remove mrlock_t structure and its mr*()
wrapper functions and replace it with native rw_semaphore type and its
native calls.

Pavel Reichl (4):
  xfs: Refactor xfs_isilocked()
  xfs: clean up whitespace in xfs_isilocked() calls
  xfs: xfs_isilocked() can only check a single lock type
  xfs: replace mrlock_t with rw_semaphores

 fs/xfs/libxfs/xfs_bmap.c |  8 ++--
 fs/xfs/mrlock.h          | 78 -------------------------------------
 fs/xfs/xfs_file.c        |  3 +-
 fs/xfs/xfs_inode.c       | 84 +++++++++++++++++++++++-----------------
 fs/xfs/xfs_inode.h       |  6 +--
 fs/xfs/xfs_iops.c        |  4 +-
 fs/xfs/xfs_linux.h       |  2 +-
 fs/xfs/xfs_qm.c          |  2 +-
 fs/xfs/xfs_super.c       |  6 +--
 9 files changed, 65 insertions(+), 128 deletions(-)
 delete mode 100644 fs/xfs/mrlock.h

-- 
2.24.1

