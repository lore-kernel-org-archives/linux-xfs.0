Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Aug 2007 03:40:26 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l78AeKbm022883
	for <xfs@oss.sgi.com>; Wed, 8 Aug 2007 03:40:22 -0700
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 0A36D122A9
	for <xfs@oss.sgi.com>; Wed,  8 Aug 2007 12:40:25 +0200 (CEST)
From: Andi Kleen <ak@suse.de>
Subject: XFS thread inflation in 2.6.23rc
Date: Wed, 8 Aug 2007 12:40:21 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081240.21548.ak@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


In 2.6.23rc I have a new kernel thread running from XFS:

30137 ?        S<     0:00 [xfs_mru_cache]


Is that one really needed? Can it be started only on demand when that MRU
feature is used? 

Thanks,

-Andi
