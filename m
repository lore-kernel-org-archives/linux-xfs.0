Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:34245 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752995AbcKRAIB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2016 19:08:01 -0500
Received: by mail-pf0-f179.google.com with SMTP id c4so39384157pfb.1
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2016 16:08:00 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 0/2] Btrfs: make a source length of 0 imply EOF for dedupe
Date: Thu, 17 Nov 2016 16:07:48 -0800
Message-Id: <cover.1479427384.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>, Christoph Hellwig <hch@infradead.org>, kernel-team@fb.com

From: Omar Sandoval <osandov@fb.com>

This is the follow-up to the discussions here [1] and here [2] that
makes Btrfs treat a src_length of 0 to dedupe as "until EOF". The
implementation is straightforward, but there are a few catches that
convinced me to post this as an RFC:

1. We still don't know for sure whether userspace cares about the
   original Btrfs behavior. Darrick and I both seem to think not, but
   hopefully someone will speak up if it matters to them.
2. When doing the implicit EOF, XFS returns 0 for bytes_deduped. I
   copied this in my implementation, but I'm guessing that's a bug
   rather than a feature.
3. Both XFS and Btrfs cap each dedupe operation to 16MB, but the
   implicit EOF gets around this in the existing XFS implementation. I
   copied this for the Btrfs implementation.

So now we have 3 options:

a) Apply these patches as-is.
b) Fix XFS to both return the actual bytes_deduped and cap the length
   for the EOF case. Do the same for Btrfs.
c) Make XFS consistent with the existing Btrfs behavior.

I'm starting to lean towards option c after writing this cover letter,
but I might as well send these out and get a second opinion.

Thanks!

1: http://marc.info/?l=linux-btrfs&m=146828374631829&w=2
2: http://marc.info/?l=linux-btrfs&m=147694962912532&w=2

Omar Sandoval (2):
  Btrfs: refactor btrfs_extent_same() slightly
  Btrfs: make a source length of 0 imply EOF for dedupe

 fs/btrfs/ioctl.c | 45 ++++++++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

-- 
2.10.2

