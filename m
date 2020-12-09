Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D2FC19425
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 11:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0602623B77
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 11:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730761AbgLILak (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Dec 2020 06:30:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38375 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730767AbgLILak (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Dec 2020 06:30:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607513353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0KQ20MFQUU+bSgdi7YMzICXoutgAvArNnt6tvEj8la8=;
        b=KCR8umD4scTd61D4Q00FFTrBDHPzmixLhtdSfEqohIrUt1eV97s3leHu/cqTQiaTw65x+A
        AKe/XQcdYfh4mqYn+mcTiUu4KGL14GY2B9VmbRm/hGZ+9zawQYKfDfEkSoRUxhV9MuCORs
        oyivpYRbwm5ea251B1SpvmDUL/ZDZiA=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-qvIKcUWiOoehOXND2JtSIQ-1; Wed, 09 Dec 2020 06:29:11 -0500
X-MC-Unique: qvIKcUWiOoehOXND2JtSIQ-1
Received: by mail-pf1-f197.google.com with SMTP id q22so871666pfj.20
        for <linux-xfs@vger.kernel.org>; Wed, 09 Dec 2020 03:29:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0KQ20MFQUU+bSgdi7YMzICXoutgAvArNnt6tvEj8la8=;
        b=J49JUJMutTV+kVGu/4SleKxQER1eQNcnAxGnSNcCJPm9LBJ+DQiXD2oXAWopERmBuQ
         CEaEWrOjd1UPGQfINUDSP5tDw/2PBjP7TwOuLesSP5aJ/K6cu4lYGMuTegnxyOlZ0sMw
         tmJL+wDHancWwtPxcmkBVGn9U0+5eWywryUtypmDWb7/R+ZN+wpbI5OmW1Dx+19ODpL6
         QegVqXwfz3zjLW4yJSfDLKs1xlpeiFZ/G3VSOMYdmi3/rdTdKlJ2tcVXC6CrEcJERDCW
         7eJmFEiwNHNK7DPpyHQ9Dphu/WDyFoz0H9XP1dRX/dVksoxGjt9J+BsbExuuI13c72Us
         MgYg==
X-Gm-Message-State: AOAM533Wgir0fQ6s/uCZdupGMlMctYJE4ObT7CYfrkP9aS2aQTOqfCit
        L8HXASSQve9Mf0MMsx5eTcgFzfq5r4x3PT/4u30dthAB5MpgEmzLubC55vfM1z/oZne6MuHuunH
        ZpdHae2OqYlTtluigEQgI+gO7oHaRxSP+F+33UDJI+jBGUZ9v/T7+0/r0J9vNrtpJL5Pout6R3w
        ==
X-Received: by 2002:a05:6a00:16c4:b029:198:a95:a2ef with SMTP id l4-20020a056a0016c4b02901980a95a2efmr1718360pfc.43.1607513350269;
        Wed, 09 Dec 2020 03:29:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxkBzYGgXXlrVkysLItVIyUnsBcpniGohss2JaBKXYoGDX1aoVWAeUgRz4h8meMpgvdzH6I4g==
X-Received: by 2002:a05:6a00:16c4:b029:198:a95:a2ef with SMTP id l4-20020a056a0016c4b02901980a95a2efmr1718328pfc.43.1607513349856;
        Wed, 09 Dec 2020 03:29:09 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y5sm2231280pfp.45.2020.12.09.03.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 03:29:09 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v5 0/6] xfs: some xfs_dialloc() cleanup
Date:   Wed,  9 Dec 2020 19:28:14 +0800
Message-Id: <20201209112820.114863-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

This is v4 of the following patchset
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

I'm re-runing xfstests -g auto with the whole series for now since
a bit left behind this time, hopefully no extra issues here. I've
dropped all RVBs from "[PATCH v4 3/6]" since some more modification
here...

Thanks for your time.

changes since v4:
 - collect RVBs from v4;
 - (3/6) get rid of an unnecessary comment (Christoph);

changes since v3 (Christoph):
 - (2/6) get rid of a brace;
 - (2/6) keeping xfs_buf_relse() in the callers;
 - (2/6) get rid of "XXX:" comment;
 - (3/6) rename xfs_ialloc() to xfs_init_new_inode();
 - (3/6) rename pino to parent_ino;
 - (3/6) convert the return type from int to struct xfs_inode *
         (so I dropped all RVBs of this patch, since more modification
          here....)
 - (4/6) refine a comment;
 - (5/6) add a found_ag lebel to have a central place for the
         sucessful return, since there are somewhat too many labels here,
         I didn't add another error lebel to make *IO_agbp = NULL and
         return error;
 - (6/6) drop the else after the break.

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

 fs/xfs/libxfs/xfs_ialloc.c | 174 +++++++++++++------------
 fs/xfs/libxfs/xfs_ialloc.h |  36 +++---
 fs/xfs/xfs_inode.c         | 258 +++++++++----------------------------
 fs/xfs/xfs_inode.h         |   6 +-
 fs/xfs/xfs_qm.c            |  27 ++--
 fs/xfs/xfs_symlink.c       |   8 +-
 6 files changed, 196 insertions(+), 313 deletions(-)

-- 
2.27.0

