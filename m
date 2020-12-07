Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 269B4C4361B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 00:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE27A22E03
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 00:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgLGARv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 19:17:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbgLGARv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 19:17:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607300184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=arLRkQrSmtcekdmYF1wqhKBraPVO37lkBMVtTEGzYn4=;
        b=L0n3ikMoCdEeL4GnvKB6rmmssjUJf5YL4RSjHx3CegW2B1+fiE++h3sThzR+IUzluOH9Tf
        CRkCocC2P+/YcnG29e4k0Qbrgt9NeQRUPCOIVF9WvTI0W7OTmCIV3nC6XmtPB7EkyGRMQZ
        NotbB1Oat1FutkL9IP4s3l4BC+pvY5g=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-5XqyA3VdPyyxJgHrWppxag-1; Sun, 06 Dec 2020 19:16:23 -0500
X-MC-Unique: 5XqyA3VdPyyxJgHrWppxag-1
Received: by mail-pf1-f197.google.com with SMTP id k13so7864024pfc.2
        for <linux-xfs@vger.kernel.org>; Sun, 06 Dec 2020 16:16:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=arLRkQrSmtcekdmYF1wqhKBraPVO37lkBMVtTEGzYn4=;
        b=uOz5mI7vZ2OyxuRWkWzNvcsSAoi24s4JKc1EfwsOFvZpTL8G99kiz2+yKsNO7bm0Od
         2ozwc9OolL8jX3BUWkceeYwOzJJUdaALMkgDAfctZGh0XvlV0MTERuTNe+M37stCr2nV
         rAEFRFqbLvlfEm8ZMDW9m6AvnH3Kk75i13+1Pa1K5t8W4gQz0mkY+GJPeFPmwUwnjZgk
         GaEPhJij40YHnd+lkQRirHgLbofdy9PyE7aiJ+ZcpNncxRjra6cdYOKW5saxrZ2hJZqf
         nIv+fADIVEv+ursU/bir68DKNCDckTBse9sIpwz26H+Qf9LAFrp2isYGkK8znTPeYA8+
         09eg==
X-Gm-Message-State: AOAM5331fTI0hYGBZhhlYe54dOGyS8uPLL/vj3IbTwm8r197kIkc4jPv
        IlVGfXJXaBcevfV7nIPY9PH4tXJzlFQaKhtG7DCXcLjNdfY9DL7Qbae2LqiZhQbfBEw0bqxyBun
        vyNcbL+Ag1lwaJhWCGL4ZB4SXy6YMdG7+ASeuFxYgrYyTb+T7Imm6ncoeVg1iqgCHRxqI+U8RFA
        ==
X-Received: by 2002:aa7:9198:0:b029:18b:3835:3796 with SMTP id x24-20020aa791980000b029018b38353796mr13607932pfa.9.1607300181799;
        Sun, 06 Dec 2020 16:16:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzwB8hMmD9XsrVWIEVwsyjqMG8Vd6h8IsMWgwSSdLGyETERRvG8M3c4Ydy5jydqs4Frlhr6GQ==
X-Received: by 2002:aa7:9198:0:b029:18b:3835:3796 with SMTP id x24-20020aa791980000b029018b38353796mr13607910pfa.9.1607300181399;
        Sun, 06 Dec 2020 16:16:21 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o9sm8218056pjl.11.2020.12.06.16.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 16:16:20 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3 0/6] xfs: some xfs_dialloc() cleanup
Date:   Mon,  7 Dec 2020 08:15:27 +0800
Message-Id: <20201207001533.2702719-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

This is v3 of the following patchset
https://lore.kernel.org/r/20201124155130.40848-1-hsiangkao@redhat.com
, which tends to simplify xfs_dialloc() logic.

This version includes Dave's original patch
https://lore.kernel.org/r/20201124221623.GC2842436@dread.disaster.area

to avoid the original double call of xfs_dialloc() and confusing
ialloc_context with some split in order for better review and minor
modification (e.g. ino isn't passed in xfs_ialloc()).

I'm not quite sure what's messy ENOSPC mentioned in the original
patch since return 0 and *ipp = NULL in xfs_dir_ialloc() would cause
NULL-dereference in its callers, so I leave this part alone, although
I think noroom has no use at all (it can be cleaned up as well with
a following patch) (at a glance, the final shape looks almost ok...)

I dropped [PATCH v1 3/3] since xfs_ialloc_select_ag() already looks
simple enough (comments about this are welcome... I can re-add this
if needed.)

I ran xfstests -g auto with the whole series and it seems no
noticable strange happening, yet I'm not quite sure if it may still
have potential issues...

Thanks for your time.

changes since v2:
 - use struct xfs_dquot_acct * instead of void * on dqinfo (Darrick);
 - rename xfs_ialloc() to xfs_dir_ialloc_init() (Dave);
 - fix a temporary state compile error due to (ialloc_context ->
   &ialloc_context) on [PATCH v2 3/6];
 - collect more RVBs from the reply of v2;
 - Cc Eric to confirm dqinfo;

changes since v1:
 - add Dave's patch with spilt and minor update;
 - update comments above xfs_ialloc_ag_alloc() suggested by Darrick;
 - collect RVBs to
    "xfs: convert noroom, okalloc in xfs_dialloc() to bool"
    "xfs: kill ialloced in xfs_dialloc()"
   since no real logic changes ("(!error)" to "(error==0)" suggested
   by Darrick has been updated).

Thanks,
Gao Xiang

Dave Chinner (4):
  xfs: introduce xfs_dialloc_roll()
  xfs: move on-disk inode allocation out of xfs_ialloc()
  xfs: move xfs_dialloc_roll() into xfs_dialloc()
  xfs: spilt xfs_dialloc() into 2 functions

Gao Xiang (2):
  xfs: convert noroom, okalloc in xfs_dialloc() to bool
  xfs: kill ialloced in xfs_dialloc()

 fs/xfs/libxfs/xfs_ialloc.c | 173 ++++++++++++++-------------
 fs/xfs/libxfs/xfs_ialloc.h |  36 +++---
 fs/xfs/xfs_inode.c         | 237 +++++++++----------------------------
 3 files changed, 163 insertions(+), 283 deletions(-)

-- 
2.18.4

