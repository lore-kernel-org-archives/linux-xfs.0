Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 Mar 2007 08:07:30 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2TF7L6p018552
	for <linux-xfs@oss.sgi.com>; Thu, 29 Mar 2007 08:07:22 -0700
Received: from localhost (dslb-084-057-114-201.pools.arcor-ip.net [84.57.114.201])
	by mail.lichtvoll.de (Postfix) with ESMTP id 4542B5AD36
	for <linux-xfs@oss.sgi.com>; Thu, 29 Mar 2007 17:07:19 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: cache flush support in SATA drives (was: Re: Questions about XFS)
Date: Thu, 29 Mar 2007 17:07:18 +0200
References: <200703131440.56678.clflush@chello.be> <200703161136.32234.Martin@lichtvoll.de> <20070317004731.GA5236@jdc.local>
In-Reply-To: <20070317004731.GA5236@jdc.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200703291707.18246.Martin@lichtvoll.de>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Samstag 17 März 2007 schrieb Jason White:

> This might be slightly off-topic, but in choosing a SATA drive for a
> desktop machine, what features/standard-complaince should one look for
> in order to ensure that write barriers work? I know this involves
> flushing the drive cache, but is this support mandatory in any of the
> applicable standards?

Hello Jason!

I have no exact idea. I just now that dmesg usually tells you whether 
cache flushes are supported.

But shouldn't modern SATA drives support NCQ anyway? Since NCQ doesn't 
make any sense without the ability to flush the cache, I *think* any SATA 
drive with NCQ support should do. NCQ support would allow the block layer 
to offload the write barrier request ordering at least partly to the 
device firmware.

"ii. For devices which have queue depth greater than 1 but don't
support ordered tags, block layer ensures that the requests preceding
a barrier request finishes before issuing the barrier request.  Also,
it defers requests following the barrier until the barrier request is
finished.  Older SCSI controllers/drives and SATA drives fall in this
category."

(Documentation/block/barrier.txt of Linux Kernel 2.6.20.4)

This also indicates that SATA drives should support NCQ.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
