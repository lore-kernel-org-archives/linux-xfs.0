Return-Path: <SRS0=M45Y=YE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DAD7ECE596
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 14:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA19F20679
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 14:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbfJKOOh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Oct 2019 10:14:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:53718 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728190AbfJKOOh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Oct 2019 10:14:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 822ABAAF1;
        Fri, 11 Oct 2019 14:14:35 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 9881B1E3C04; Fri, 11 Oct 2019 16:14:33 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, <linux-xfs@vger.kernel.org>,
        darrick.wong@oracle.com, Dave Chinner <david@fromorbit.com>,
        Matthew Bobrowski <mbobrowski@mbobrowski.org>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2 v2] iomap: Waiting for IO in iomap_dio_rw()
Date:   Fri, 11 Oct 2019 16:14:30 +0200
Message-Id: <20191011125520.11697-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

here is new version of the series with small changes people suggested:

Changes since v1:
* The new function argument of iomap_dio_rw() does not get overridden by
 is_sync_kiocb() the caller is responsible for this.

---
Original motivation:

when doing the ext4 conversion of direct IO code to iomap, we found it very
difficult to handle inode extension with what iomap code currently provides.
Ext4 wants to do inode extension as sync IO (so that the whole duration of
IO is protected by inode->i_rwsem), also we need to truncate blocks beyond
end of file in case of error or short write. Now in ->end_io handler we don't
have the information how long originally the write was (to judge whether we
may have allocated more blocks than we actually used) and in ->write_iter
we don't know whether / how much of the IO actually succeeded in case of AIO.

Thinking about it for some time I think iomap code makes it unnecessarily
complex for the filesystem in case it decides it doesn't want to perform AIO
and wants to fall back to good old synchronous IO. In such case it is much
easier for the filesystem if it just gets normal error return from
iomap_dio_rw() and not just -EIOCBQUEUED.

The first patch in the series adds argument to iomap_dio_rw() to wait for IO
completion (internally iomap_dio_rw() already supports this!) and the second
patch converts XFS waiting for unaligned DIO write to this new API.

What do people think?

								Honza 
Previous versions:
Link: http://lore.kernel.org/r/20191009202736.19227-1-jack@suse.cz
