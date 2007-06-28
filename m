Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 08:06:15 -0700 (PDT)
Received: from over.ny.us.ibm.com (over.ny.us.ibm.com [32.97.182.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5SF5ltL031183
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 08:05:49 -0700
Received: from e3.ny.us.ibm.com ([192.168.1.103])
	by pokfb.esmtp.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l5SEb36F029553
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 10:37:06 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5SDXZJJ013202
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 09:33:35 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5SEarFS525944
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 10:36:53 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5SEaqnt019292
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 10:36:53 -0400
Subject: Re: [PATCH 0/6][TAKE5] fallocate system call
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
In-Reply-To: <20070628025543.9467216f.akpm@linux-foundation.org>
References: <20070510005926.GT85884050@sgi.com>
	 <20070510115620.GB21400@amitarora.in.ibm.com>
	 <20070510223950.GD86004887@sgi.com> <20070511110301.GB28425@in.ibm.com>
	 <20070512080157.GF85884050@sgi.com>
	 <20070612061652.GA6320@amitarora.in.ibm.com>
	 <20070613235217.GS86004887@sgi.com>
	 <20070614091458.GH5181@schatzie.adilger.int>
	 <20070614120413.GD86004887@sgi.com>
	 <20070614193347.GN5181@schatzie.adilger.int>
	 <20070625132810.GA1951@amitarora.in.ibm.com>
	 <20070628025543.9467216f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 28 Jun 2007 10:36:47 -0700
Message-Id: <1183052207.4420.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com, xfs@oss.sgi.com

On Thu, 2007-06-28 at 02:55 -0700, Andrew Morton wrote:

> Please drop the non-ext4 patches from the ext4 tree and send incremental
> patches against the (non-ext4) fallocate patches in -mm.
> 
The ext4 fallocate() patches are dependent on the core fallocate()
patches, so ext4 patch-queue and git tree won't compile (it's not based
on mm tree) without the core changes.

We can send ext4 fallocate patches (incremental patches against mm tree)
and drop the full fallocate patches(ext4 and non ext4 part) from ext4
patch queue if you prefer this way.

> And try to get the code finished?  Time is pressing.
> 
I looked at the mm tree, there are other ext4 features/changes that are
currently in ext4-patch-queue(not ext4 git tree) that not in part of
ext4 series yet. Ted, can you merge those patches to your git tree?
Thanks!


Thanks for your patience.

Mingming.
