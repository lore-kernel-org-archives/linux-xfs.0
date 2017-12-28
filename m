Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr012msb.fastweb.it ([85.18.95.109]:54252 "EHLO
        mr012msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754445AbdL1XT6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Dec 2017 18:19:58 -0500
Received: from ceres.assyoma.it (93.63.55.57) by mr012msb.fastweb.it (5.8.043)
        id 5A415010004076E9 for linux-xfs@vger.kernel.org; Fri, 29 Dec 2017 00:14:14 +0100
Subject: Block size and read-modify-write
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 29 Dec 2017 00:14:14 +0100
From: Gionatan Danti <g.danti@assyoma.it>
Message-ID: <021d36d95a9de952ddd38cc56d18df4f@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: g.danti@assyoma.it

Hi list,
I would ask a question: how XFS block size affect read-modify-write in 
case of very small writes?

For example, suppose an XFS filesystem with the default 4K data block 
size. Am I correct saying that:
- a 512B normal, cached writes will cause a read-modify-write of the 
entire 4K sector?
- a 512B O_DIRECT write will *not* cause a read-modify-write of the 4K 
sector, rather it will be flushed to disk as-is (512 bytes in length)?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
