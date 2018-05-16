Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:35821 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751096AbeEPRyU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 13:54:20 -0400
Received: by mail-pf0-f179.google.com with SMTP id x9-v6so736934pfm.2
        for <linux-xfs@vger.kernel.org>; Wed, 16 May 2018 10:54:20 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v3 0/2] iomap: swapfile tweaks
Date: Wed, 16 May 2018 10:54:09 -0700
Message-Id: <cover.1526493125.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, Aleksei Besogonov <cyberax@amazon.com>, kernel-team@fb.com

From: Omar Sandoval <osandov@fb.com>

Changes from v2:

- Move up inline flag check, which Christoph is going to turn into a
  type at some point
- Remove null address check, since it doesn't make sense for
  IOMAP_MAPPED or IOMAP_UNWRITTEN

Omar Sandoval (2):
  iomap: provide more useful errors for invalid swap files
  iomap: don't allow holes in swapfiles

 fs/iomap.c | 43 +++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

-- 
2.17.0

