Return-Path: <SRS0=C5JC=AS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C440BC433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jul 2020 13:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A179820773
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jul 2020 13:58:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="exQ0Q+s2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgGGN63 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jul 2020 09:58:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55154 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726805AbgGGN62 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jul 2020 09:58:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594130307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=ghQBaPttsrbTsNg/DiRe0yOy9Rbc54omlt1a9NvGn2I=;
        b=exQ0Q+s2uywpKq2qjjo/DFoxMzg/ldcu2M5AjICzJWcosq+nHqM2Vgzqw4NsDaQ4E90c/e
        8eP9rfAsIuw04da1fXKoLf2V0PExc+22odpvuCDZe7Ik3Jz0esdGATnBJlG0mUz/HVHk3G
        HpZqOWkotmTrjjp4c6hZb7TJJ5wC62I=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-xjalXwA1MM-K2M1KXNFiLQ-1; Tue, 07 Jul 2020 09:58:25 -0400
X-MC-Unique: xjalXwA1MM-K2M1KXNFiLQ-1
Received: by mail-pf1-f199.google.com with SMTP id b69so21413652pfb.14
        for <linux-xfs@vger.kernel.org>; Tue, 07 Jul 2020 06:58:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ghQBaPttsrbTsNg/DiRe0yOy9Rbc54omlt1a9NvGn2I=;
        b=M+Ia7q5X72yv0CvT0Z6LqfM8IF23eQ+0faJ5wNk+KaeaMwQ0o/APGy81hMjq7Cmgrw
         Adu5WReIu9XewfhMCkvi+6WGW15cMEuiOtFCm4gT5l1PYVdbrj4etQBypd548qvDWph1
         JAbQIhd2MxxJsRVmT8Ye38cSDnYck8fnZQ1axWZcg+n+BIPmx8VOT/Ervsor+UFiH1V0
         paHsID9DkXgNyPVW24rOEX1u/1ASbvbJ7hOYtQCNYJqWd1KoXV8TdxK3SJIHGIlrpgm8
         JwPCapv7czm6wIYP+tKy0lCSmcotgbrjKvGWoM49qrhogY6dKt/bz86fvXuXGsIKY3zL
         isuA==
X-Gm-Message-State: AOAM530PStQzkspTllfpHqsK9Kk+lZVQNO0mG+SemZc3Syu7zuzFrClK
        I09qFQ0tPmtzkn8f+bTkrva3b1wBFySq++sd62UUjfMmePYFiVhYmvdsw+8Sh6rBo47ttMVoiID
        RqwUn3eLgcSE5w+VB9P0R
X-Received: by 2002:a63:e60b:: with SMTP id g11mr46325936pgh.188.1594130304265;
        Tue, 07 Jul 2020 06:58:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfHU7Tku2EQ0Tp2j4X0GgbpYwjhSN/oehcdO0ozJJA83WqmQ1CPAdljIXILP8pnIn9zDOaMw==
X-Received: by 2002:a63:e60b:: with SMTP id g11mr46325908pgh.188.1594130303952;
        Tue, 07 Jul 2020 06:58:23 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n18sm23247271pfd.99.2020.07.07.06.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 06:58:23 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH 0/2] xfs: more unlinked inode list optimization v1
Date:   Tue,  7 Jul 2020 21:57:39 +0800
Message-Id: <20200707135741.487-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi forks,

This RFC patchset mainly addresses the thoughts [*] and [**] from Dave's
original patchset,
https://lore.kernel.org/r/20200623095015.1934171-1-david@fromorbit.com

In short, it focues on the following ideas mentioned by Dave:
 - use bucket 0 instead of multiple buckets since in-memory double
   linked list finally works;

 - avoid taking AGI buffer and unnecessary AGI update if possible, so
   1) add a new lock and keep proper locking order to avoid deadlock;
   2) insert a new unlinked inode from the tail instead of head;

In addition, it's worth noticing 3 things:
 - xfs_iunlink_remove() should support old multiple buckets in order
   to keep old inode unlinked list (old image) working when recovering.

 - (but) OTOH, the old kernel recovery _shouldn't_ work with new image
   since the bucket_index from old xfs_iunlink_remove() is generated
   by the old formula (rather than keep in xfs_inode), which is now
   fixed as 0. So this feature is not forward compatible without some
   extra backport patches;

 - a tail xfs_inode pointer is also added in the perag, which keeps 
   track of the tail of bucket 0 since it's mainly used for xfs_iunlink().

 - the old kernel recovery shouldn't work with new image since
     its bucket_index from old kernel is 

The git tree is also available at
git://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git tags/xfs/iunlink_opt_v1

Some limited test for debugging only is done (mainly fsstress and
manual power-cut tests), so it could not work as expected just like
my limited broken xfs knowledge. But I will go on improving this
patchset recently. 

Any comments and directions are welcome. :)

Thanks,
Gao Xiang

Gao Xiang (2):
  xfs: arrange all unlinked inodes into one list
  xfs: don't access AGI on unlinked inodes if it can

 fs/xfs/xfs_inode.c       | 283 ++++++++++++++++++++-------------------
 fs/xfs/xfs_log_recover.c |   6 +
 fs/xfs/xfs_mount.c       |   3 +
 fs/xfs/xfs_mount.h       |   3 +
 4 files changed, 160 insertions(+), 135 deletions(-)

-- 
2.18.1

