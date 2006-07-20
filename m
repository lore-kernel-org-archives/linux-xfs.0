Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 03:06:17 -0700 (PDT)
Received: from mondschein.lichtvoll.de (ms2.lichtvoll.de [194.150.191.235] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6KA61DW001318
	for <linux-xfs@oss.sgi.com>; Thu, 20 Jul 2006 03:06:01 -0700
Received: from localhost (dslb-084-056-078-084.pools.arcor-ip.net [84.56.78.84])
	by mondschein.lichtvoll.de (Postfix) with ESMTP id 705A5FA8A6
	for <linux-xfs@oss.sgi.com>; Thu, 20 Jul 2006 12:03:03 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Question on the WriteCache / WriteBarrier FAQ entry
Date: Thu, 20 Jul 2006 12:05:34 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200607201205.34750.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Hello,

I try to fully understand this entry:

"Many drives use a write back cache in order to speed up the performance 
of writes. However, there are conditions such as power failure when the 
write cache memory is never flushed to the actual disk. This causes 
problems for XFS and journaled filesystems in general because they rely 
on knowing when a write has completed to the disk. They need to know that 
the log information has made it to disk before allowing metadata to go to 
disk. When the metadata makes it to disk then the tail of the log can 
move. So if the writes never make it to the physical disk, then the 
ordering is violated and the log and metadata can be lost, resulting in 
filesystem corruption."

I have problems with: "When the metadata makes it to disk then the tail of 
the log can move". What does that mean exactly?

What I imagine is this: XFS write transaction to its log and the log 
grows. When writing the meta data changes of a complete transaction XFS 
removes it from the log. Now when the metadata changes of a transaction 
has been written completely but the transaction itself has not, it may 
happen that a transaction is removed from the on disk log before it has 
been written. But even when this does not happen there are metadata 
changes on disk that the log doesn't know about.

So there are two situations where unordered writes can make a journalling 
filesystem corrupt:

1) Metadata make it to disk before the transaction that belongs to them => 
There are metadata changes that XFS doesn't know about.

2) A transaction might be deleted from the log before it has been written 
=> This leads to a corrupted log.

Is that correct and complete? Please give feedback. 

You may use any of my text here to update / clarify the FAQ ;-)

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
