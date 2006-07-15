Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 15 Jul 2006 03:49:40 -0700 (PDT)
Received: from mondschein.lichtvoll.de (ms2.lichtvoll.de [194.150.191.235] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6FAnPDW020010
	for <linux-xfs@oss.sgi.com>; Sat, 15 Jul 2006 03:49:26 -0700
Received: from localhost (dslb-084-056-076-199.pools.arcor-ip.net [84.56.76.199])
	by mondschein.lichtvoll.de (Postfix) with ESMTP id 85260FA510
	for <linux-xfs@oss.sgi.com>; Sat, 15 Jul 2006 12:47:05 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: XFS and write barrier
Date: Sat, 15 Jul 2006 12:48:56 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200607151248.56603.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Hello,

I am currently gathering information to write an article about journal 
filesystems with emphasis on write barrier functionality, how it works, 
why journalling filesystems need write barrier and the current 
implementation of write barrier support for different filesystems.

I have quite good informations on XFS already, but some questions remain:

1) Is it safe to use write barriers with 2.6.16 or should one use 2.6.17 
instead? This relates to:

-----------------------------------------------------------------------
commit b04ed21a1fdbfe48ee0738519a4d1af09589dfea
Author: Nathan Scott <nathans@sgi.com>
Date:   Wed Jan 11 15:32:17 2006 +1100

    [XFS] Disable write barriers for now till intermittent IO errors are
    understood.

    SGI-PV: 912426
    SGI-Modid: xfs-linux-melb:xfs-kern:202962a

    Signed-off-by: Nathan Scott <nathans@sgi.com>
-----------------------------------------------------------------------

What are those intermittent IO errors? I googled but did not find a 
discussion of this change.

2) I experienced three XFS corruptions in one week on 2.6.16 with enabled 
write caches, but (by default) disabled write barriers, but on 2.6.15 - 
with enabled write cache as well - it only very rarely got corrupted. 
Does anyone have any hint as to why this may have been the case? Thing is 
that the system went down, the kernel crashed while it was in use.

I am suspecting that the kernel went down due to other instabilities and 
then XFS got corrupted by out of order writes. But it may also been 
related to a different IO path and / or changes in the write barrier 
implementation in the block layer. Any ideas? 

No worries, if not, I simply write so. ;) It just would be nice to know 
why. I know its difficult to retrospect especially as I do not have the 
syslogs from those occasions anymore.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
