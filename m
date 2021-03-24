Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE72DC433C1
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 01:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B358619D3
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 01:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhCXBHl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 21:07:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37182 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233880AbhCXBHK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Mar 2021 21:07:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616548023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0cjtMwjnK4jiiB/hqWTIpaSdyw5bIe4JNXWIdVzjyAo=;
        b=RV43hNInCF5PLK4PIX2HQtxzTzYOjmhcJFxl0jpijbkt7i1MlhKWyOGEkeLzNVOSylXmGI
        AuUMY23IqR2cb9dn1zDavuostGqDeNdM15n8g9F9z0HRDhivYsDtdWI7evAdZwEWctTNCK
        1Mo4q82SporGO7LgGFi3S8E7wI8n81o=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-1sx2H62AN521dill0BjRmQ-1; Tue, 23 Mar 2021 21:07:01 -0400
X-MC-Unique: 1sx2H62AN521dill0BjRmQ-1
Received: by mail-pj1-f69.google.com with SMTP id oc10so503147pjb.8
        for <linux-xfs@vger.kernel.org>; Tue, 23 Mar 2021 18:07:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0cjtMwjnK4jiiB/hqWTIpaSdyw5bIe4JNXWIdVzjyAo=;
        b=XMT+1wEQNWEigfhETV+L/ITB729Bsb7YEkVrYNzWfyZsmzobV3RDGItJj/i9X+9ZeL
         qw2qdHt96F0XrxT7LWlo1R9cAlRYlb7j3pk4yuszZyqD6bhi1MfA/BxzFN/gOi2Z7OL5
         PYlOtnIkGMLE1zSjvtm1nnSxAgDmE+FsVAcerEPUMPuQ9aZjRrkFRVfz4HYl4qiTebzb
         eLHpeBgyOek438MRG86Zr8yD1OuAlhLBL9SWoHesNZ9KvM9QSKQO6XPkpmxf6AuRD5hs
         TGHSWn7dtSGEUt3HQRqqlMVt8fUJOWwBkKbadUBZ6x6dNgkQJtaNl09T1nzK9dbRozU/
         Q8Bw==
X-Gm-Message-State: AOAM531EDHQlYX4SGWSDeg4TEpcQhOBJwiMBCIIeKtN+1Kej+itPlJNl
        c+94uzdEj20pWlBOb0wLltQG1Q4KWXmkZGyMm/qZlaU0AoDb/HgCpTsLJ3PazNhRiHjpS4wYOiE
        HPTKfv7wQZho2VY4ZzwCypPRExXS8b+oPcMzyoop5tsaNQMWIwzVKltkKjAPx6siVFa6/bsaJDw
        ==
X-Received: by 2002:aa7:9293:0:b029:1df:4e2:c981 with SMTP id j19-20020aa792930000b02901df04e2c981mr742727pfa.41.1616548020238;
        Tue, 23 Mar 2021 18:07:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8O3zAa++jQ3gL7IrFtLF/IhxSHvCcQJSNMXYs08xHvn4aahG9+/Yj23exMzrjzj4A118nzA==
X-Received: by 2002:aa7:9293:0:b029:1df:4e2:c981 with SMTP id j19-20020aa792930000b02901df04e2c981mr742669pfa.41.1616548019743;
        Tue, 23 Mar 2021 18:06:59 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t18sm379219pgg.33.2021.03.23.18.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 18:06:59 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v9 0/5] xfs: support shrinking free space in the last AG
Date:   Wed, 24 Mar 2021 09:06:16 +0800
Message-Id: <20210324010621.2244671-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

v9: https://lore.kernel.org/r/20210305025703.3069469-1-hsiangkao@redhat.com

This patchset attempts to support shrinking free space in the last AG.
This version mainly addresses previous review of v8. Hope I don't miss
previous comments...

changes since v8 (Brian):
 - [2/5] rename to `lastag_extended';
 - [2/5] use `delta' instead;
 - [3/5] refine several comments;
 - [3/5] lock agf buffer here to close perag reservation race window;
 - [4/5] drop unnecessary `nb == mp->m_sb.sb_dblocks' check.
 - [4/5] refine a comment.

Thanks for the time!

Thanks,
Gao Xiang

Gao Xiang (5):
  xfs: update lazy sb counters immediately for resizefs
  xfs: hoist out xfs_resizefs_init_new_ags()
  xfs: introduce xfs_ag_shrink_space()
  xfs: support shrinking unused space in the last AG
  xfs: add error injection for per-AG resv failure

 fs/xfs/libxfs/xfs_ag.c       | 115 +++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h       |   2 +
 fs/xfs/libxfs/xfs_ag_resv.c  |   6 +-
 fs/xfs/libxfs/xfs_errortag.h |   4 +-
 fs/xfs/xfs_error.c           |   3 +
 fs/xfs/xfs_fsops.c           | 194 ++++++++++++++++++++++-------------
 fs/xfs/xfs_trans.c           |   1 -
 7 files changed, 248 insertions(+), 77 deletions(-)

-- 
2.27.0

