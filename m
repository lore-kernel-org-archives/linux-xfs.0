Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr002msb.fastweb.it ([85.18.95.86]:38316 "EHLO
        mr002msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbdIIWL6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Sep 2017 18:11:58 -0400
Received: from ceres.assyoma.it (93.63.55.57) by mr002msb.fastweb.it (8.5.140.05)
        id 59A9E6BA00593F00 for linux-xfs@vger.kernel.org; Sun, 10 Sep 2017 00:11:57 +0200
Subject: XFS and sector size on thin volumes
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sun, 10 Sep 2017 00:11:56 +0200
From: Gionatan Danti <g.danti@assyoma.it>
Message-ID: <d95f09118ee6cb2fe0562ad35303715c@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: g.danti@assyoma.it

Hi all,
I noticed that, when using both LVM thin volumes and ZVOLs, mkfs.xfs 
default to using 512-byte sector size.

Would setting sector size to 4K be benefical for filesystem performance?

 From what I know, sector size only affect journal and metadata writes. 
So, should I manually set sector size to 4K or it is not worth the 
(minor) inconvenience?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
