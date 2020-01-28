Return-Path: <SRS0=UJS8=3R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC8BC2D0DB
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 14:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3AC22467E
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 14:55:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bmwq7AZM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgA1Ozm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jan 2020 09:55:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48241 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726162AbgA1Ozm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jan 2020 09:55:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580223341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wdNY+1f+3lYUyGjiH4w8du73JtCcWum4o5Zuxld4Eac=;
        b=Bmwq7AZMCarm+yS9nlJudtpopi/xEnTv+Tc3iEKSQ3Bs7ABQlDhQEocn2ze9iBkswXFJJL
        7wj5KNJcOnLyb76P1G1OcFEpqVsWWD3seVa8U3a6lPmGZRpAbSqN5mrokkZJfoCVk7jGnU
        XiY+ipGweKa6ud4j6w3cx1eD3QTpTnI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-pK1F1eEQMLWAXDYjGFOOyw-1; Tue, 28 Jan 2020 09:55:39 -0500
X-MC-Unique: pK1F1eEQMLWAXDYjGFOOyw-1
Received: by mail-wr1-f70.google.com with SMTP id u18so8041256wrn.11
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2020 06:55:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wdNY+1f+3lYUyGjiH4w8du73JtCcWum4o5Zuxld4Eac=;
        b=WNJBDws/Da0Gtk8C4hcNqRn8WV1al8TUBhi/xJSYRSenM0oScjK50a/gt25n255a80
         Tl0LbMidZjfFZOh72JyRxuD2rNwAHzj4fB1I4g+UcDkjghYO5clmYCtkGKwYXThD7kJS
         Bvi0oHzC+rHaOaPmDOftb6ao3y3fYnLLm/f1qQGXMiavtNxqEdlFFdY6YaIE1lGJ7aHe
         5DxTqs2h/v+hY+KfZwnqRkvMee6BU1SJPsPxk2J9/IQ+kG1zMx2IjqT5WvzuA56KnlTY
         c781IqykyYuEK9zwZKYnN8kb0GC2FEH2lnwEwf4AUb3p5tQh2ECPYymG1TQD2W5H1CCM
         l5jQ==
X-Gm-Message-State: APjAAAXADVWNqeKsffZAHIfB8pHwXLfQwz/OxDcdIbaV6fvhHCMP7AJK
        HV4A3HqFXtp8SyH9LS+fClzy4MT8gU3MM7Ndg7xIZi1QSFBeZ+PzdXuylYnyFviw6F+8PXpw5r9
        pJoapyD+hBqnjl7EXMWpv
X-Received: by 2002:adf:e641:: with SMTP id b1mr29135637wrn.34.1580223337329;
        Tue, 28 Jan 2020 06:55:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqw5EAYIJwj32HayLnQY4M3dBvUVo6WZ7bfyCewKb9KVGT4QUT8x73UQncJUxXOqly7GxRfv1g==
X-Received: by 2002:adf:e641:: with SMTP id b1mr29135626wrn.34.1580223337183;
        Tue, 28 Jan 2020 06:55:37 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id q130sm3325939wme.19.2020.01.28.06.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2020 06:55:35 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH 0/4] xfs: Remove wrappers for some semaphores
Date:   Tue, 28 Jan 2020 15:55:24 +0100
Message-Id: <20200128145528.2093039-1-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove some wrappers that we have in XFS around the read-write semaphore
locks.

The goal of cleanup is to remove mrlock_t structure and its mr*()
wrapper functions and replace it with native rw_semaphore type and its
native calls.

Pavel Reichl (4):
  xfs: change xfs_isilocked() to always use lockdep()
  xfs: Remove mr_writer field from mrlock_t
  xfs: Make i_lock and i_mmap native rwsems
  xfs: replace mr*() functions with native rwsem calls

 fs/xfs/mrlock.h    | 78 ----------------------------------------------
 fs/xfs/xfs_inode.c | 43 ++++++++++++++-----------
 fs/xfs/xfs_inode.h |  6 ++--
 fs/xfs/xfs_iops.c  |  4 +--
 fs/xfs/xfs_linux.h |  1 -
 fs/xfs/xfs_super.c |  6 ++--
 6 files changed, 32 insertions(+), 106 deletions(-)
 delete mode 100644 fs/xfs/mrlock.h

-- 
2.24.1

