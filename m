Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5966DC433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 16:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED0F9207A9
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 16:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgLCQMr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 11:12:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27960 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726032AbgLCQMr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 11:12:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607011880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=5nMTU9mMEU+qoq8ZHlLIn2iet3xgFCHFmr//MgH63hA=;
        b=GG6VpEujwZDdw1HKOZiJ5dkJeE5UdIba8oyVFxCUaPZt00KDkDws2hHM+rwtBR+j4sj9hI
        ZxY6d85FC4qSD8UwPFWAGhrwWImr6HF+XBiWmIRVysJocDL9CzibBdojDRAR+mQBe146PW
        O00lMMFNy6d7EdqrrUaCW+yw1nFGwFM=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377--mZwJwp3Ntujc3Str8quaA-1; Thu, 03 Dec 2020 11:11:18 -0500
X-MC-Unique: -mZwJwp3Ntujc3Str8quaA-1
Received: by mail-pl1-f198.google.com with SMTP id n8so1458730plp.3
        for <linux-xfs@vger.kernel.org>; Thu, 03 Dec 2020 08:11:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5nMTU9mMEU+qoq8ZHlLIn2iet3xgFCHFmr//MgH63hA=;
        b=Eo2HutgOTUXgFoz7Xkvfz8BHSilA/Z06ggf/guxuo9bftnEe9UY7O+QV4ZocH8f96/
         3ue5l1G9xfiq1l4opB3JeqfpLxwm2e51/eCMKR9CLtu60yhAyMCzSc/3ntNmVVWrME6s
         8Yi6ZdH4q1KXllHh7YftapEB3qInXaAG7xEo/x2Vx46eg57eASJyBHM4Q5CwXdIQPYxp
         VWQfp+++00s/n+Yb8GNUMnScNwOPV5QxKPME3KYHe8FHAZHmQASLdd8B1ikL8igxH1mr
         hBjsfMMjvSTlBNo9B04u97uON5GTyhSzQvktYLRbdJkSU6pR/ryEyhfkgipATX/PXWXR
         9Z0w==
X-Gm-Message-State: AOAM531QfDgglWdEhKOMJ9KVGii9P6aWbkeAY8N7OwyQ2f+2p8tO0f0P
        Uyz5hbUptd7PlCYLSfmO0mao1pcMhvwDSj1fvxlqV+gNRhdF0ckDA15+zIbJpdnAohZ6QZPUPGt
        pMMyYHznjRZTWgBZopaOqjk5KNoqidxBd6hwcYEuNBjZMXKlbt9D4lcChC4PMEK1CFcLFjBGruw
        ==
X-Received: by 2002:a63:db18:: with SMTP id e24mr3641708pgg.155.1607011877262;
        Thu, 03 Dec 2020 08:11:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwckhr5L1vjAHWbsv+IzrHXwzC7h6QTSAA4mjiX9DDrKHCs7/Q3b/l5367Izwc7aeZK1aHJ6g==
X-Received: by 2002:a63:db18:: with SMTP id e24mr3641682pgg.155.1607011876944;
        Thu, 03 Dec 2020 08:11:16 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l1sm1738798pgg.4.2020.12.03.08.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 08:11:16 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v2 0/6] xfs: some xfs_dialloc() cleanup
Date:   Fri,  4 Dec 2020 00:10:22 +0800
Message-Id: <20201203161028.1900929-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

This is v2 of the following patchset
https://lore.kernel.org/r/20201124155130.40848-1-hsiangkao@redhat.com
, which tends to simplify xfs_dialloc() logic.

This version includes Dave's original patch
https://lore.kernel.org/r/20201124221623.GC2842436@dread.disaster.area

to avoid the original double call of xfs_dialloc() and confusing
ialloc_context with some split in order for better review and minor
modification (e.g. ino isn't passed in xfs_ialloc()).

I'm not quite sure what's messy ENOSPC mentioned in the original
patch since return 0 and *ipp = NULL in xfs_dir_ialloc() would cause
NULL-dereference in its callers, so I leave this part alone
(at a glance, the final shape looks almost ok...)

I dropped [PATCH v1 3/3] since xfs_ialloc_select_ag() already looks
simple enough (comments about this are welcome... I can re-add this
if needed.)

I don't change "tri-state return value" of xfs_ialloc_ag_alloc()
since comments from Christoph and Darrick are not strong... (more
comments are welcome as well.)

I ran xfstests -g auto with this series and it seems no noticable
strange happening, yet I'm not quite sure if it may still have
potential issues...

Thanks for your time.

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

 fs/xfs/libxfs/xfs_ialloc.c | 173 ++++++++++++++------------
 fs/xfs/libxfs/xfs_ialloc.h |  36 +++---
 fs/xfs/xfs_inode.c         | 242 +++++++++----------------------------
 3 files changed, 169 insertions(+), 282 deletions(-)

-- 
2.18.4

