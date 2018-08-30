Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f43.google.com ([209.85.208.43]:40257 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727117AbeH3Ua7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Aug 2018 16:30:59 -0400
Received: by mail-ed1-f43.google.com with SMTP id j62-v6so2401791edd.7
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 09:28:03 -0700 (PDT)
MIME-Version: 1.0
From: Joshi <joshiiitr@gmail.com>
Date: Thu, 30 Aug 2018 21:57:50 +0530
Message-ID: <CA+1E3rJCdcLJVYrj89H1HQDr7ETpZzQzueb6oqg3eJnNZ_q+UQ@mail.gmail.com>
Subject: xfs log write design
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This must be novice topic for the list, please excuse the ignorance.

When it comes to log write scheme in XFS, I wonder if I can draw
parallel with any journaling mode of Ext4 (ordered or writeback)?
I checked xlog_sync() code, and found that each log IO is marked with
PREFLUSH and FUA (for internal log case).
This perhaps makes it similar to "ordered" journal mode of Ext4.
But I am not sure about exact intent of choosing PREFLUSH for log
write i.e.whether it is for all previous non-log IO (meta and data) or
only for meta-IO. Nor I am sure whether xfs makes a conscious choice
to issue data writes before meta or journal I/Os.


Thanks,
-- 
Joshi
