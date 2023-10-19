Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE18CDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 20:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235530AbjJSUEO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 16:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbjJSUEN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 16:04:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B453116
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 13:04:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD60EC433C7;
        Thu, 19 Oct 2023 20:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697745851;
        bh=+yZXA4IGbBsCWf04ZH8ini35O/Peregitjz+XPvsL4s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R9UWRzsHAScRcovVrtWJ87OkZWhq+bpI4bmRF/d3VsLrUJtOi94p/ukGUMWHmkSaB
         w63RSxKuwVjvYNva/rGE2eOl+g6OypgRkANts6BGxrXv8yZDjg85uJnASFT7tJ5P+L
         HvayhnI19V23MX0Eu+mlPYB7IS8dMuYldKbc50TaZUQ1SZdeBxX2hOjXiKmk53eh2L
         15xA78QXqo4Mb0vWobO7cAsC+z1F11OAwjf5Cc+P1hj+PP6Qj7YYMqm5TG4gvQNFdT
         njbTdJXm1tWVMc7URJPF4WTSY7U8K/4L8jls4oUGrCGO22DFGY13HiLkUJl3uYdWTz
         g5kemiJ6wUprw==
Date:   Thu, 19 Oct 2023 13:04:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4] xfs: allow read IO and FICLONE to run concurrently
Message-ID: <20231019200411.GN3195650@frogsfrogsfrogs>
References: <20231017201208.18127-1-catherine.hoang@oracle.com>
 <ZS92TizgnKHdBtDb@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZS92TizgnKHdBtDb@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 17, 2023 at 11:08:14PM -0700, Christoph Hellwig wrote:
> On Tue, Oct 17, 2023 at 01:12:08PM -0700, Catherine Hoang wrote:
> > One of our VM cluster management products needs to snapshot KVM image
> > files so that they can be restored in case of failure. Snapshotting is
> > done by redirecting VM disk writes to a sidecar file and using reflink
> > on the disk image, specifically the FICLONE ioctl as used by
> > "cp --reflink". Reflink locks the source and destination files while it
> > operates, which means that reads from the main vm disk image are blocked,
> > causing the vm to stall. When an image file is heavily fragmented, the
> > copy process could take several minutes. Some of the vm image files have
> > 50-100 million extent records, and duplicating that much metadata locks
> > the file for 30 minutes or more. Having activities suspended for such
> > a long time in a cluster node could result in node eviction.
> > 
> > Clone operations and read IO do not change any data in the source file,
> > so they should be able to run concurrently. Demote the exclusive locks
> > taken by FICLONE to shared locks to allow reads while cloning. While a
> > clone is in progress, writes will take the IOLOCK_EXCL, so they block
> > until the clone completes.
> 
> Sorry for being pesky, but do you have some rough numbers on how
> much this actually with the above workload?

Well... the stupid answer is that I augmented generic/176 to try to race
buffered and direct reads with cloning a million extents and print out
when the racing reads completed.  On an unpatched kernel, the reads
don't complete until the reflink does:

--- /tmp/fstests/tests/generic/176.out  2023-07-11 12:18:21.617971250 -0700
+++ /var/tmp/fstests/generic/176.out.bad        2023-10-19 10:22:04.771017812 -0700
@@ -2,3 +2,8 @@
 Format and mount
 Create a many-block file
 Reflink the big file
+start reflink Thu Oct 19 10:19:19 PDT 2023
+end reflink Thu Oct 19 10:20:06 PDT 2023
+buffered read ioend Thu Oct 19 10:20:06 PDT 2023
+direct read ioend Thu Oct 19 10:20:06 PDT 2023
+finished waiting Thu Oct 19 10:20:06 PDT 2023

Yowza, a minute's worth of read latency!  On a patched kernel, the reads
complete while the clone is running:

--- /tmp/fstests/tests/generic/176.out  2023-07-11 12:18:21.617971250 -0700
+++ /var/tmp/fstests/generic/176.out.bad        2023-10-19 10:22:25.528685643 -0700
@@ -2,3 +2,552 @@
 Format and mount
 Create a many-block file
 Reflink the big file
+start reflink Thu Oct 19 10:19:24 PDT 2023
+buffered read ioend Thu Oct 19 10:19:24 PDT 2023
+direct read ioend Thu Oct 19 10:19:24 PDT 2023
+buffered read ioend Thu Oct 19 10:19:24 PDT 2023
+direct read ioend Thu Oct 19 10:19:24 PDT 2023
+buffered read ioend Thu Oct 19 10:19:24 PDT 2023
+buffered read ioend Thu Oct 19 10:19:24 PDT 2023
+buffered read ioend Thu Oct 19 10:19:25 PDT 2023
+buffered read ioend Thu Oct 19 10:19:25 PDT 2023
+direct read ioend Thu Oct 19 10:19:25 PDT 2023
...
+buffered read ioend Thu Oct 19 10:20:06 PDT 2023
+buffered read ioend Thu Oct 19 10:20:07 PDT 2023
+buffered read ioend Thu Oct 19 10:20:07 PDT 2023
+direct read ioend Thu Oct 19 10:20:07 PDT 2023
+buffered read ioend Thu Oct 19 10:20:07 PDT 2023
+buffered read ioend Thu Oct 19 10:20:07 PDT 2023
+buffered read ioend Thu Oct 19 10:20:07 PDT 2023
+end reflink Thu Oct 19 10:20:07 PDT 2023
+direct read ioend Thu Oct 19 10:20:07 PDT 2023
+finished waiting Thu Oct 19 10:20:07 PDT 2023

So as you can see, reads from the reflink source file no longer
experience a giant latency spike.  I also wrote an fstest to check this
behavior; I'll attach it as a separate reply.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
