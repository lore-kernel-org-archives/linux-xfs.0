Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB27AC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 21:49:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A72A20818
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 21:49:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EqOzAILD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfKLVt3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 16:49:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24883 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726376AbfKLVt3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 16:49:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573595367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=foJoTS5qBF3pwbN2BIPtPzJVfv27PYxv8/rwXo4aVSg=;
        b=EqOzAILDzmKeAgfZlMnjd5/97sjp+3n7+qqLD5F4UZXOM688DXTM07Vc3K92VsCmh7DKMX
        ZzBouaq8Xnf6k/8y9sh9D3zp++V60Dl1GWJ+sl+A8XLe/N2edkcV0vmmJyy9oNS2t1cPkN
        C94LdWEE2Bmo4dFMVsO19LV1JgS/X/w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-uJukUmMHPpGSrGfIzYi91g-1; Tue, 12 Nov 2019 16:49:26 -0500
Received: by mail-wr1-f70.google.com with SMTP id p6so86005wrs.5
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2019 13:49:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Me1RoLr60bwLApAi7Tz6D08XYXwc+YMAZIpf/QB6g8s=;
        b=qfAdsollq52//kVG/rKoEjz3R4prlu7lQjPTfSdyHMvwNK9k/M/kyV/ujnZRmDwL7/
         STty17TDEb+9rxuQenoPRpmi2sTD+VXCDF+kj20YOT6sZuPM+ngDjGT/dQrH1VbUbfx0
         w+OSIftW3PdP7HrVUXl9/aKxDQuYKyiMOaFLAwwRpiFgZNtzOYiZ8oM3mFj1Tq+u1o4B
         MmEDTwTIcEVH7y4U1zQfxRgySFO3gTEIeHOuJ3xj57kpYS7nLg9WembGtA3MD7YKgIMi
         uZGxWp7lIfBqE/Bj4u481WdoNuEPGzuwv/RBAg7r1SZ3QNU12S+IjgL21QpULNXUW6FL
         HfJw==
X-Gm-Message-State: APjAAAV2RNnho9ROZF61GXyC3o5Bo3T867hh+AtBt+6rDT4Gs326Iddj
        Zds9jNGDHxl9iMovAe7Q9aNT8RLBkF8HGvqUjJWuPtolpqCU2vl+5Z+2GHV+QwHFjNAEl7z1pOX
        rQR/jsxp5ay6+43cLC7pM
X-Received: by 2002:a05:6000:1083:: with SMTP id y3mr26378423wrw.290.1573595365303;
        Tue, 12 Nov 2019 13:49:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqxYICP7aEnhhLqAdP8nhrQCqyCBcqYPV8pumDyeB8T3I3htve0ToTVzTxaLJPtKonTJuBqxCA==
X-Received: by 2002:a05:6000:1083:: with SMTP id y3mr26378417wrw.290.1573595365162;
        Tue, 12 Nov 2019 13:49:25 -0800 (PST)
Received: from preichl.redhat.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id x6sm252681wrw.34.2019.11.12.13.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 13:49:24 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH v4 0/5] xfs: remove several typedefs in quota code
Date:   Tue, 12 Nov 2019 22:33:05 +0100
Message-Id: <20191112213310.212925-1-preichl@redhat.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
X-MC-Unique: uJukUmMHPpGSrGfIzYi91g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Eliminate some typedefs.


Pavel Reichl (5):
  xfs: remove the xfs_disk_dquot_t and xfs_dquot_t
  xfs: remove the xfs_quotainfo_t typedef
  xfs: remove the xfs_dq_logitem_t typedef
  xfs: remove the xfs_qoff_logitem_t typedef
  Replace function declartion by actual definition

 fs/xfs/libxfs/xfs_dquot_buf.c  |   8 +-
 fs/xfs/libxfs/xfs_format.h     |  10 +--
 fs/xfs/libxfs/xfs_trans_resv.c |   6 +-
 fs/xfs/xfs_dquot.c             |  20 ++---
 fs/xfs/xfs_dquot.h             |  98 +++++++++++------------
 fs/xfs/xfs_dquot_item.h        |  34 ++++----
 fs/xfs/xfs_log_recover.c       |   5 +-
 fs/xfs/xfs_qm.c                |  50 ++++++------
 fs/xfs/xfs_qm.h                |   6 +-
 fs/xfs/xfs_qm_bhv.c            |   6 +-
 fs/xfs/xfs_qm_syscalls.c       | 139 ++++++++++++++++-----------------
 fs/xfs/xfs_trans_dquot.c       |  54 ++++++-------
 12 files changed, 217 insertions(+), 219 deletions(-)

--=20
2.23.0

