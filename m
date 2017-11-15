Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr001msb.fastweb.it ([85.18.95.85]:57540 "EHLO
        mr001msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753105AbdKORBT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2017 12:01:19 -0500
Received: from ceres.assyoma.it (93.63.55.57) by mr001msb.fastweb.it (8.5.140.05)
        id 59E3E61F015F8988 for linux-xfs@vger.kernel.org; Wed, 15 Nov 2017 18:01:17 +0100
Subject: Disabling barriers on NVC-backed HDD
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 15 Nov 2017 18:01:17 +0100
From: Gionatan Danti <g.danti@assyoma.it>
Message-ID: <8b91c685e344bdc5d084b11fab1d50af@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: g.danti@assyoma.it

Hi list,
I'm not sure this is the correct list to post my question; if so, feel 
free to ignore this message.

On XFS FAQs I (rightfully) read that barrier should be *always* enabled 
(and they are, by default), unless a write-loss protected writeback 
cache is used at the RAID card level. So far, so good.

Newer HDDs has themselves have a non-volatile cache (NVC) of some sort, 
basically:
- DRAM + eMCL: in a powerloss event, the DRAM cache is immediately 
dumped on the eMLC flash;
- DRAM + NOR flash: NOR mirrors a (small) portion of the DRAM cache, 
used for write acceleration purpose;
- dedicated "dump" areas on the disks: they effectively mirror a portion 
of the DRAM cache.

My question is: do you think it is safe to disable barriers, both for 
XFS and in general terms, on these disks? Or they should be considered 
as the same "dumb" unprotected DRAM caches found on classical HDD?

 From a side, these *are* powerloss-protected caches. Problem is that all 
these power-protection schemes are considered "secret sauce / trade 
secret" by HDD vendors and, for this reason, there are very little (if 
any) informations on their inner working.

Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
