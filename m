Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 May 2007 05:51:58 -0700 (PDT)
Received: from over.ny.us.ibm.com (over.ny.us.ibm.com [32.97.182.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4GCprfB003674
	for <xfs@oss.sgi.com>; Wed, 16 May 2007 05:51:54 -0700
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
	by pokfb.esmtp.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l4GCLNIk015559
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 16 May 2007 08:21:24 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4GCLLcA031457
	for <xfs@oss.sgi.com>; Wed, 16 May 2007 08:21:21 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4GCLJ02269472
	for <xfs@oss.sgi.com>; Wed, 16 May 2007 06:21:21 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4GCLJmm004801
	for <xfs@oss.sgi.com>; Wed, 16 May 2007 06:21:19 -0600
Subject: Re: [PATCH 1/5][TAKE3] fallocate() implementation on i86, x86_64
	and powerpc
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
In-Reply-To: <20070516031626.GM85884050@sgi.com>
References: <20070330071417.GI355@devserv.devel.redhat.com>
	 <20070417125514.GA7574@amitarora.in.ibm.com>
	 <20070418130600.GW5967@schatzie.adilger.int>
	 <20070420135146.GA21352@amitarora.in.ibm.com>
	 <20070420145918.GY355@devserv.devel.redhat.com>
	 <20070424121632.GA10136@amitarora.in.ibm.com>
	 <20070426175056.GA25321@amitarora.in.ibm.com>
	 <20070515193722.GA3487@amitarora.in.ibm.com>
	 <20070515195421.GA2948@amitarora.in.ibm.com>
	 <20070515200359.GA5834@amitarora.in.ibm.com>
	 <20070516031626.GM85884050@sgi.com>
Content-Type: text/plain
Date: Wed, 16 May 2007 07:21:16 -0500
Message-Id: <1179318076.10313.6.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Wed, 2007-05-16 at 13:16 +1000, David Chinner wrote:
> On Wed, May 16, 2007 at 01:33:59AM +0530, Amit K. Arora wrote:

> > Following changes were made to the previous version:
> >  1) Added description before sys_fallocate() definition.
> >  2) Return EINVAL for len<=0 (With new draft that Ulrich pointed to,
> >     posix_fallocate should return EINVAL for len <= 0.
> >  3) Return EOPNOTSUPP if mode is not one of FA_ALLOCATE or FA_DEALLOCATE
> >  4) Do not return ENODEV for dirs (let individual file systems decide if
> >     they want to support preallocation to directories or not.
> >  5) Check for wrap through zero.
> >  6) Update c/mtime if fallocate() succeeds.
> 
> Please don't make this always happen. c/mtime updates should be dependent
> on the mode being used and whether there is visible change to the file. If no
> userspace visible changes to the file occurred, then timestamps should not
> be changed.

i_blocks will be updated, so it seems reasonable to update ctime.  mtime
shouldn't be changed, though, since the contents of the file will be
unchanged.

> e.g. FA_ALLOCATE that changes file size requires same semantics of ftruncate()
> extending the file, otherwise no change in timestamps should occur.
> 
> Cheers,
> 
> Dave.
-- 
David Kleikamp
IBM Linux Technology Center
