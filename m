Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFFC1C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 12:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D7A523A54
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 12:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgLHMWV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Dec 2020 07:22:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37422 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729425AbgLHMWU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Dec 2020 07:22:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607430053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=mzLFoleVdZC+mg8Zt26qz3IPlJ9Wf9zVniqaHTBlxJg=;
        b=FMy8IYYSWB5WNt4Azbwf1Q5wFemFs59DVp5NNSBk3sFGxaztQEWB/hx/0r6Uk1F3cZPg10
        uGw1aEN3XN/Mw1p0aieE6HXRKgTZx25d1aNXoKZiPKoIQmo7PwSg3AbF5U1jM4AhEnaUy/
        nl2tYyLlwK9IxwwySqPkF51kBVW2evg=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-dm1IqUe-OVWGtuv1zmNOqQ-1; Tue, 08 Dec 2020 07:20:52 -0500
X-MC-Unique: dm1IqUe-OVWGtuv1zmNOqQ-1
Received: by mail-pg1-f197.google.com with SMTP id c6so3169172pgt.19
        for <linux-xfs@vger.kernel.org>; Tue, 08 Dec 2020 04:20:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mzLFoleVdZC+mg8Zt26qz3IPlJ9Wf9zVniqaHTBlxJg=;
        b=iwzmEoWrg5KEPWNdMFF4PYiljSV+qCT5Fzjj4H/SactLVLHntHKJL+tIATWUeqhq5K
         hUUU8t3HfEbj0fgl+W6T3Jkm+ovH+QIJbBzkORez6BBRX7RgjDxJvlOC8tMBQXMBxmV0
         7O8s9fA+ReWO000VeLXGJFd9L2xhx1kTJRLqQkmH3Yq7QY0cjmsYUg9d/BwL0pOSkamq
         ltIPrGqufikYzMI/HVKppRnEYpG016hNBbn9xmHNmr/+Q55CjtjzLEoZJ2a7gpgWZhyL
         YhxMc8OSVvUK714XMAVn1BJog6fPmLVqNJiIABotXQBOauyMXhVZ7TTc44EcFfspqfa2
         vy1A==
X-Gm-Message-State: AOAM5335ngw86GqEgfky0yZ22nnLXaeq9dQGMw5NgvlGt3xzfnqRfvql
        3kUtpC+S/Lyvn2XQ9lh7yBtX3OxB666UjTJbxk4Kt5YzcBFON0SkkDnAEpZ8Rky5zUkROMjmsN2
        T5sI9EEYtl49AzpR8VTk9Kutf1i1Pa/t0eRNCIKPv57zwIXqGDuSE4pZ0ese00wXE+zUWQGCBgg
        ==
X-Received: by 2002:a17:90a:3ee3:: with SMTP id k90mr4033053pjc.164.1607430050879;
        Tue, 08 Dec 2020 04:20:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJywx7qRMZQnm3fQ701Iq1YGi6bFyKi1hYMplcVtfoOmKVwT4Fb5mUwNZqwDSIj8XcBUptbIzQ==
X-Received: by 2002:a17:90a:3ee3:: with SMTP id k90mr4033024pjc.164.1607430050501;
        Tue, 08 Dec 2020 04:20:50 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a29sm1156926pfr.73.2020.12.08.04.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 04:20:49 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 0/6] xfs: some xfs_dialloc() cleanup
Date:   Tue,  8 Dec 2020 20:19:57 +0800
Message-Id: <20201208122003.3158922-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
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
 fs/xfs/xfs_inode.c         | 259 +++++++++----------------------------
 fs/xfs/xfs_inode.h         |   6 +-
 fs/xfs/xfs_qm.c            |  27 ++--
 fs/xfs/xfs_symlink.c       |   8 +-
 6 files changed, 197 insertions(+), 313 deletions(-)

-- 
2.18.4

