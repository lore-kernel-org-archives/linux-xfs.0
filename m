Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:45424 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751581AbeBAOeY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Feb 2018 09:34:24 -0500
Received: by mail-qk0-f173.google.com with SMTP id z12so19581131qkf.12
        for <linux-xfs@vger.kernel.org>; Thu, 01 Feb 2018 06:34:24 -0800 (PST)
Date: Thu, 1 Feb 2018 09:34:22 -0500
From: Josef Bacik <josef@toxicpanda.com>
Subject: [LSF/MM TOPIC] File system memory management topics
Message-ID: <20180201143422.phir5f2wwv6udnqe@destiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org

Hello,

I've been lazily working through various mm related issues with file systems for
the last couple of years and would like to talk about current progress and work
thats left to be done.  Some of the topics I want to cover are

* Metadata tracking, writeback, and reclaim
* Smarter fs cache shrinking
* Non-page size block size handling

Dave please tell me you are going to be there this year?  It's going to be
completely useless for me to talk about this stuff if you aren't in the room.
These are all big topics in and of themselves so if we just need to get you, me,
Jan, and some poor MM guy locked in a room with a couple of bottles of liquor
until we figure it out then that's fine.

I'm hoping to have the metadata tracking stuff fixed up and at least mergable by
LSF, but there's still stuff to be added to that infrastructure later on, and
the other topics we need to agree on a direction.  Thanks,

Josef
