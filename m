Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:38556 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751332AbeEPQp6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 12:45:58 -0400
Received: by mail-pl0-f66.google.com with SMTP id c11-v6so757171plr.5
        for <linux-xfs@vger.kernel.org>; Wed, 16 May 2018 09:45:58 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2 0/2] iomap: swapfile tweaks
Date: Wed, 16 May 2018 09:45:49 -0700
Message-Id: <cover.1526488995.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, Aleksei Besogonov <cyberax@amazon.com>, kernel-team@fb.com

From: Omar Sandoval <osandov@fb.com>

Changes from v1:

- Added patch 1 to provide more useful error messages (suggested by me)
  and move the bdev check (suggested by Christoph)
- Changed patch 2 to simply delete the hole check, since it will be
  caught by the mapped || unwritten check below

Based on xfs-linux/for-next. Thanks!

Omar Sandoval (2):
  iomap: provide more useful errors for invalid swap files
  iomap: don't allow holes in swapfiles

 fs/iomap.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

-- 
2.17.0

