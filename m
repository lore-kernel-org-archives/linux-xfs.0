Return-Path: <SRS0=ZINu=ZC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E4DC43331
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Nov 2019 06:24:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0224C21655
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Nov 2019 06:24:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PRKAVvE9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfKJGYS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Nov 2019 01:24:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45042 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726594AbfKJGYS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Nov 2019 01:24:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573367056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=T6U1kIYgS9qnxsjKVbkpoZ/HRaOwEVrIQHenDpKYnao=;
        b=PRKAVvE98Qb008x5bg4gQoxOzncNXSCawrAWoDX5ayGOSZ13Y0n2UXGjQRAyaY1OaioEMS
        rQxs2isZwvafZipSJazZZj9x303bzpuSQP2mbHvoUO5u7oFWwfyII78EW8iRQ0qR1z54Zn
        rjvKEvBww/219R+ylBRZyOLFltSHw/8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-Lhgx4r7MO5-8rWly-HjcOg-1; Sun, 10 Nov 2019 01:24:15 -0500
Received: by mail-wr1-f70.google.com with SMTP id q6so3791856wrv.11
        for <linux-xfs@vger.kernel.org>; Sat, 09 Nov 2019 22:24:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tf2drpE+lbV2B05Cq3PyH5wkLR1LV0D8hUFVj0YtsM4=;
        b=b+xWyO1jON5XAYSxWiCIFK/xsLE0N+UmqD+rODLKPdd7ctnTWGM/XrMewUYPrum9Uk
         5kdmkhuDDteVUyYUmPupfNlGdnvMoPTd+ZaNkoTWyY+6Kp7b/oG+4i30Y8UsP4YtaUjg
         4I3qu0UZ9V5/Id95Z8r90H5tKHSSOcyD+DQ4sb24A/mTBvKE6xk0gofM0KfBq8B5ivQI
         g11mSHGCNz0wVWiAdDoA2PqTRiYPptwHPiWPJDGCMOaEib3Uj3mQU9ZWlACJE4aEniMQ
         enXiUIdPZQuSHsDTXBbcm7ZGAcjYTjhnRerb8JGcmZvlIxI+zgSNxAHAszhgesMIagPn
         1MGQ==
X-Gm-Message-State: APjAAAWkTB5YSqpOm6isggc7v3toZdbfjypDbc4wnBlvQSGpiHUg6KWy
        IvnVJ2NLfKkxVbDymZVxbJj4EvahNmRDSJvPNCEyHYziwlJc16I91LxAMbzulpB+FM3l4pVlhcA
        vHmxsrQ3r7EQvzGRZLf7G
X-Received: by 2002:a1c:984b:: with SMTP id a72mr15784802wme.78.1573367053853;
        Sat, 09 Nov 2019 22:24:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqwCNX3Il915Sdx1I/aBgQLsN6knbQEblx2j8yayfijbgRkBVrMy6LsG0icdM+cpcKYcV2fKFQ==
X-Received: by 2002:a1c:984b:: with SMTP id a72mr15784796wme.78.1573367053680;
        Sat, 09 Nov 2019 22:24:13 -0800 (PST)
Received: from localhost.localdomain (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id b196sm16261618wmd.24.2019.11.09.22.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 22:24:12 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH v3 0/4] remove several typedefs in quota code
Date:   Sun, 10 Nov 2019 07:24:00 +0100
Message-Id: <20191110062404.948433-1-preichl@redhat.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
X-MC-Unique: Lhgx4r7MO5-8rWly-HjcOg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Eliminate some typedefs.


Pavel Reichl (4):
  xfs: remove the xfs_disk_dquot_t and xfs_dquot_t
  xfs: remove the xfs_quotainfo_t typedef
  xfs: remove the xfs_dq_logitem_t typedef
  xfs: remove the xfs_qoff_logitem_t typedef

 fs/xfs/libxfs/xfs_dquot_buf.c  |   8 +--
 fs/xfs/libxfs/xfs_format.h     |  10 +--
 fs/xfs/libxfs/xfs_trans_resv.c |   5 +-
 fs/xfs/xfs_dquot.c             |  20 +++---
 fs/xfs/xfs_dquot.h             | 111 +++++++++++++++++++--------------
 fs/xfs/xfs_dquot_item.h        |  34 +++++-----
 fs/xfs/xfs_log_recover.c       |   5 +-
 fs/xfs/xfs_qm.c                |  50 +++++++--------
 fs/xfs/xfs_qm.h                |   6 +-
 fs/xfs/xfs_qm_bhv.c            |   6 +-
 fs/xfs/xfs_qm_syscalls.c       |  29 +++++----
 fs/xfs/xfs_trans_dquot.c       |  56 ++++++++---------
 12 files changed, 181 insertions(+), 159 deletions(-)

--=20
2.23.0

