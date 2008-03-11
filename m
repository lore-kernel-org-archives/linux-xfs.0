Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Mar 2008 10:30:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2BHUDMX025044
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 10:30:17 -0700
Received: from sargon.lncsa.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7169EF64F6F
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 10:30:44 -0700 (PDT)
Received: from sargon.lncsa.com (sargon.lncsa.com [212.99.8.251]) by cuda.sgi.com with ESMTP id hnuchaShsZCPFF1q for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 10:30:44 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by sargon.lncsa.com (Postfix) with ESMTP id DF7EC3013BA3
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 18:30:02 +0100 (CET)
Received: from sargon.lncsa.com ([127.0.0.1])
	by localhost (sargon.lncsa.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 19-VkScLCTve for <xfs@oss.sgi.com>;
	Tue, 11 Mar 2008 18:30:02 +0100 (CET)
Received: from zenon.apartia.fr (zenon.apartia.fr [10.0.3.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "zenon.apartia.fr", Issuer "ca.apartia.fr" (verified OK))
	by sargon.lncsa.com (Postfix) with ESMTP id B86E83015E26
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 18:30:02 +0100 (CET)
Received: from trajan.apartia.fr (trajan.apartia.fr [10.0.3.121])
	by zenon.apartia.fr (Postfix) with ESMTP id 38C4C59C5B414
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 18:29:58 +0100 (CET)
Date: Tue, 11 Mar 2008 18:29:58 +0100
From: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Subject: can I shrink an xfs?
Message-ID: <20080311172958.GA31833@apartia.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

Is it possible to shrink an xfs? I tried using xfs_growfs to no avail.

	zenon:~# xfs_growfs -D 650000000 /backup
	meta-data=/dev/md2               isize=256    agcount=32, agsize=20539552 blks
			 =                       sectsz=4096  attr=1
	data     =                       bsize=4096   blocks=657265248, imaxpct=25
			 =                       sunit=16     swidth=48 blks
	naming   =version 2              bsize=4096  
	log      =internal               bsize=4096   blocks=32768, version=2
			 =                       sectsz=4096  sunit=1 blks, lazy-count=0
	realtime =none                   extsz=196608 blocks=0, rtextents=0
	data size 650000000 too small, old size is 657265248

... even though the fs is 80% full only.

Thanks,
