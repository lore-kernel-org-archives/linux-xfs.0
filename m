Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 12:10:23 -0700 (PDT)
Received: from over.ny.us.ibm.com (over.ny.us.ibm.com [32.97.182.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5SJAEtL008470
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 12:10:15 -0700
Received: from e6.ny.us.ibm.com ([192.168.1.106])
	by pokfb.esmtp.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l5SIjCWi000718
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 14:45:12 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5SIkJ2O018601
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 14:46:19 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5SIj98j320122
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 14:45:09 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5SIj8G6032626
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 14:45:09 -0400
Subject: Re: [PATCH 0/6][TAKE5] fallocate system call
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
In-Reply-To: <20070628113342.c9c0f49c.akpm@linux-foundation.org>
References: <20070510223950.GD86004887@sgi.com>
	 <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com>
	 <20070612061652.GA6320@amitarora.in.ibm.com>
	 <20070613235217.GS86004887@sgi.com>
	 <20070614091458.GH5181@schatzie.adilger.int>
	 <20070614120413.GD86004887@sgi.com>
	 <20070614193347.GN5181@schatzie.adilger.int>
	 <20070625132810.GA1951@amitarora.in.ibm.com>
	 <20070628025543.9467216f.akpm@linux-foundation.org>
	 <20070628175757.GA1674@amitarora.in.ibm.com>
	 <20070628113342.c9c0f49c.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 28 Jun 2007 13:45:02 -0500
Message-Id: <1183056302.9880.28.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Thu, 2007-06-28 at 11:33 -0700, Andrew Morton wrote:
> On Thu, 28 Jun 2007 23:27:57 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> 
> > > Please drop the non-ext4 patches from the ext4 tree and send incremental
> > > patches against the (non-ext4) fallocate patches in -mm.
> > 
> > Please let us know what you think of Mingming's suggestion of posting
> > all the fallocate patches including the ext4 ones as incremental ones
> > against the -mm.
> 
> I think Mingming was asking that Ted move the current quilt tree into git,
> presumably because she's working off git.

I moved the fallocate patches to the very end of the series in the quilt
tree.  This way the patches will be in the quilt tree for testing, but
Ted can easily leave them out of the git tree so you and Linus won't
pull them with the ext4 patches.

Fortunately, the ext4-specific fallocate patches don't conflict with the
other patches in the queue, so they can (at least for now) be handled
independently in the -mm tree.

> I'm not sure what to do, really.  The core kernel patches need to be in
> Ted's tree for testing but that'll create a mess for me.
> 
> ug.
> 
> Options might be
> 
> a) I drop the fallocate patches from -mm and from the ext4 tree, hack up
>    any needed build fixes, then just wait for it all to mature and then
>    think about it again
> 
> b) We do what we normally don't do and reserve the syscall slots in mainline.

-- 
David Kleikamp
IBM Linux Technology Center
