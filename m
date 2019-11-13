Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5428C17441
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 00:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97D4621D7F
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 00:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfKMAmx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 19:42:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:39806 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbfKMAmw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Nov 2019 19:42:52 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Nov 2019 16:42:51 -0800
X-IronPort-AV: E=Sophos;i="5.68,298,1569308400"; 
   d="scan'208";a="198274341"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.157])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Nov 2019 16:42:47 -0800
From:   ira.weiny@intel.com
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
        linux-mm@kvack.org, Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH V2 0/2] Move swap functions out of address space operations
Date:   Tue, 12 Nov 2019 16:42:42 -0800
Message-Id: <20191113004244.9981-1-ira.weiny@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

As suggested by Jan Kara, move swap_[de]activate to file_operations to simplify
address space operations for coming changes.

I'm not sure if this should go through Al Viro or Andrew Morton so I'm sending
it to both of you.  Sorry if this is a problem.  Let me know if there is
something else I should do.

Ira Weiny (2):
  fs: Clean up mapping variable
  fs: Move swap_[de]activate to file_operations

 fs/btrfs/file.c     | 341 ++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/inode.c    | 340 -------------------------------------------
 fs/f2fs/data.c      | 123 ----------------
 fs/f2fs/file.c      | 122 ++++++++++++++++
 fs/iomap/swapfile.c |   3 +-
 fs/nfs/file.c       |   4 +-
 fs/xfs/xfs_aops.c   |  13 --
 fs/xfs/xfs_file.c   |  12 ++
 include/linux/fs.h  |  10 +-
 mm/swapfile.c       |  12 +-
 10 files changed, 488 insertions(+), 492 deletions(-)

-- 
2.21.0

