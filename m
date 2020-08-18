Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B59C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 13:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D94520738
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 13:31:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W9LlCt9C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgHRNbd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 09:31:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32829 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726398AbgHRNb2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 09:31:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597757468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=Hezqc3eWpXIdLLQbKDneGoj3ZQtxZvBzf/n8JakxaDs=;
        b=W9LlCt9CJ4etDZr/5jzfrlRMzBB9gd7shqnMPAdcJBMlPD0kBJQ7U8bFPV3VT7pYzw/ND4
        UTNt3vhkFibLdXxnn5S0E7Ptin8xjctZquzAWnusBAo0Qr55UejVb/PL3d3hzWR7bJRsKo
        +WqWfipRU6aQPOi0yeLPJJo/rtXQZY0=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-nvBTkpmQOYSv7fl-e7nBIA-1; Tue, 18 Aug 2020 09:31:07 -0400
X-MC-Unique: nvBTkpmQOYSv7fl-e7nBIA-1
Received: by mail-pl1-f198.google.com with SMTP id w20so3279193plp.8
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 06:31:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Hezqc3eWpXIdLLQbKDneGoj3ZQtxZvBzf/n8JakxaDs=;
        b=KQprlNQ5frqELmUhgpYJ5ZIYGTryuZZV83IkB6J0KifgcVWrPJ/w3BkDGabJvo6mA2
         1ZHXwuyKPLjHdnrOu2erh+tI++Q3T+h3LYgQSqnDA0qm24kuwfEk8yUxOHezIeJGOoDU
         z5Pd7YpHCS6cHat+rTGv8A6qv8C7r8EUy8N5Uj+k6TB8V+i+KMYkdtsdqSzFHq3l9ii1
         bq619HanNeF/EvFhOv687gWRktdL4djEOOIEPToZUf7CuqG1NOxD4DphhxhtdSDCi8bz
         k6Nk+gr3yUvIWcNcyptLTpUWR+SlpRuDGN5/zq3bN4MRUJa0GEjWUsb2/fpto5cgjbG8
         87kw==
X-Gm-Message-State: AOAM532cMyLgZnEDFK9UrSGrQdESzMhuBWWZjKa6jOMGxbjAAz4pXlWV
        cB+uDov6VeykJafYuA9uHZ6qPH4zYEXDXaqz0wtSFgCozGG4/HMmtcvolLc2pVOCt+xq37q7r3u
        Z/wpHx8KKk/Rs6DdwMsCu
X-Received: by 2002:a17:902:6f01:: with SMTP id w1mr15229569plk.49.1597757465773;
        Tue, 18 Aug 2020 06:31:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYUpGB/521ywfIoa4wU97h4VO1nAfTqNv38M0YK5IzJGkHNT7sjPmCCdWe2KBfObSjKGtezw==
X-Received: by 2002:a17:902:6f01:: with SMTP id w1mr15229541plk.49.1597757465445;
        Tue, 18 Aug 2020 06:31:05 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h5sm24563099pfq.146.2020.08.18.06.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 06:31:04 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH v4 0/3] xfs: more unlinked inode list optimization v4
Date:   Tue, 18 Aug 2020 21:30:12 +0800
Message-Id: <20200818133015.25398-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200724061259.5519-1-hsiangkao@redhat.com>
References: <20200724061259.5519-1-hsiangkao@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi forks,

This is RFC v4 version which is based on Dave's latest patchset:
 https://lore.kernel.org/r/20200812092556.2567285-1-david@fromorbit.com

I didn't send out v3 because it was based on Dave's previous RFC
patchset, but I'm still not quite sure to drop RFC tag since this
version is different from the previous versions...

Changes since v2:
 - rebase on new patchset, and omit the original first patch
   "xfs: arrange all unlinked inodes into one list" since it now
   has better form in the base patchset;

 - a tail xfs_inode pointer is no longer needed since the original
   patchset introduced list_head iunlink infrastructure and it can
   be used to get the tail inode;

 - take pag_iunlink_mutex lock until all iunlink log items are
   committed. Otherwise, xfs_iunlink_log() order would not be equal
   to the trans commit order so it can mis-reorder and cause metadata
   corruption I mentioned in v2.

   In order to archive that, some recursive count is introduced since
   there could be several iunlink operations in one transaction,
   and introduce some per-AG fields as well since these operations
   in the transaction may not operate inodes in the same AG. we may
   also need to take AGI buffer lock in advance (e.g. whiteout rename
   path) due to iunlink operations and locking order constraint.
   For more details, see related inlined comments as well...

 - "xfs: get rid of unused pagi_unlinked_hash" would be better folded
   into original patchset since pagi_unlinked_hash is no longer needed.

============

[Original text]

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


The git tree is also available at
git://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git tags/xfs/iunlink_opt_v4

Gitweb:
https://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git/log/?h=xfs/iunlink_opt_v4


Some preliminary tests are done (including fstests, but there seems
some pre-exist failures and I haven't looked into yet). And I confirmed
there was no previous metadata corruption mentioned in RFC v2 anymore.

To confirm that I'm in the right direction, I post the latest version
now since it haven't been updated for a while.

Comments and directions are welcomed. :)

Thanks,
Gao Xiang

Gao Xiang (3):
  xfs: get rid of unused pagi_unlinked_hash
  xfs: introduce perag iunlink lock
  xfs: insert unlinked inodes from tail

 fs/xfs/xfs_inode.c        | 194 ++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_inode.h        |   1 +
 fs/xfs/xfs_iunlink_item.c |  16 ++++
 fs/xfs/xfs_mount.c        |   4 +
 fs/xfs/xfs_mount.h        |  14 +--
 5 files changed, 193 insertions(+), 36 deletions(-)

-- 
2.18.1

