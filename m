Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr003msb.fastweb.it ([85.18.95.87]:47794 "EHLO
        mr003msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933917AbdEVOZk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 May 2017 10:25:40 -0400
Received: from ceres.assyoma.it (93.63.55.57) by mr003msb.fastweb.it (8.5.140.05)
        id 58BF8D44032015D6 for linux-xfs@vger.kernel.org; Mon, 22 May 2017 16:25:38 +0200
From: Gionatan Danti <g.danti@assyoma.it>
Subject: Shutdown filesystem when a thin pool become full
Message-ID: <c25a8ccc-f143-989d-3d49-3fe8753aa6f7@assyoma.it>
Date: Mon, 22 May 2017 16:25:37 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: it-IT
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: g.danti@assyoma.it

Hi all,
I have a question regarding how to automatically shutdown (or put in 
read-only mode) an XFS filesystem which reside on a full thin pool.

Background info: when a thin pool become full, it will deny any new 
unallocated writes, but will continue to allow writes to 
already-allocated storage chunks. So, it behave as a badly damaged disk, 
where some places can be written, but others throw an error.

Playing with dmsetup table it is possible to deny *all* I/O to the 
volume, but it require careful monitor and a sensible script to do the 
right thing (tm).

 From my testing, it happear that XFS will shutdown itself when a 
metadata write fails, however, failed *data* update will continue 
without triggering any filesystem response. Is this by design? Can I do 
something about that?

As a side note, I perfectly understand that async writes should *not* 
put the filesystem in suspended state; however, I found this behavior 
for synchronized writes also.

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
