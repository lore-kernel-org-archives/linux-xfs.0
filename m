Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr014msb.fastweb.it ([85.18.95.103]:53204 "EHLO
        mr014msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751357AbeBXS0K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Feb 2018 13:26:10 -0500
Received: from ceres.assyoma.it (93.63.55.57) by mr014msb.fastweb.it (5.8.043)
        id 5A91255F000B9CDA for linux-xfs@vger.kernel.org; Sat, 24 Feb 2018 19:20:48 +0100
Subject: Reflink (cow) copy of busy files
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sat, 24 Feb 2018 19:20:48 +0100
From: Gionatan Danti <g.danti@assyoma.it>
Message-ID: <9e69fcd01e1c02ea53e0e1ac66d60d24@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: g.danti@assyoma.it

Hi all,
I have a question on how CoW/reflink works when used on busy files, as 
vm image files, databases, ecc.

In short: can reflink-copy be used to create a crash-consistent snapshot 
of, say, a busy vm disk file? Or the db/vm/whatever should be quiesced 
before taking the copy (ie: similarly to how lvm call fsfreeze during 
the snapshot)?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
