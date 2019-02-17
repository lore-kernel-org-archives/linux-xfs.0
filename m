Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk1-f176.google.com ([209.85.222.176]:44993 "EHLO
        mail-qk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfBQUgO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Feb 2019 15:36:14 -0500
From: Ric Wheeler <ricwheeler@gmail.com>
Subject: [LSF/MM TOPIC] More async operations for file systems - async
 discard?
Message-ID: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
Date: Sun, 17 Feb 2019 15:36:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: lsf-pc@lists.linux-foundation.org
Cc: linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-block@vger.kernel.org

One proposal for btrfs was that we should look at getting discard out of the 
synchronous path in order to minimize the slowdown associated with enabling 
discard at mount time. Seems like an obvious win for "hint" like operations like 
discard.

I do wonder where we stand now with the cost of the various discard commands - 
how painful is it for modern SSD's? Do we have a good sense of how discard 
performance scales as the request size increases? Do most devices "no op" a 
discard operation when issued against an already discarded region?

Would this be an interesting topic to discuss in a shared block/file system session?

Regards,

Ric
