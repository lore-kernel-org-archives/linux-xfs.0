Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 02:44:19 -0700 (PDT)
Received: from mondschein.lichtvoll.de (ms1.lichtvoll.de [194.150.191.234])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6K9i6DW030403
	for <linux-xfs@oss.sgi.com>; Thu, 20 Jul 2006 02:44:09 -0700
Received: from localhost (dslb-084-056-078-084.pools.arcor-ip.net [84.56.78.84])
	by mondschein.lichtvoll.de (Postfix) with ESMTP id B6A0EFA8A6
	for <linux-xfs@oss.sgi.com>; Thu, 20 Jul 2006 11:41:10 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: How does XFS handle file data with regards to journaling?
Date: Thu, 20 Jul 2006 11:43:40 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200607201143.40984.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Hello,

AFAIK XFS does not support real data journaling. But when does it write 
changes to file data? Does ist write it before or after it updates the 
journal? IOW does it support ordered writes as ext3 does?

data=ordered    (*)     All data are forced directly out to the main file
system prior to its metadata being committed to the journal.

Or does it work in writeback mode?

data=writeback      Data ordering is not preserved, data may be written
into the main file system after its metadata has been                      
committed to the journal.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
