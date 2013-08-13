Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A304C7F5F
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 10:58:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6A47E304039
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 08:58:17 -0700 (PDT)
Received: from e28smtp05.in.ibm.com (e28smtp05.in.ibm.com [122.248.162.5]) by
	cuda.sgi.com with ESMTP id C5DsF3L5fxAbAEsq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Aug 2013 08:58:14 -0700 (PDT)
Received: from /spool/local
	by e28smtp05.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <chandan@linux.vnet.ibm.com>;
	Tue, 13 Aug 2013 21:21:55 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 8A6EC394004D
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 21:28:00 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r7DFxVrV36503800
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 21:29:31 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r7DFw8i8029539 for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 21:28:08 +0530
From: chandan <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH] _test_generic_punch: Extend $testfile's size to work with
	64k block.
Date: Tue, 13 Aug 2013 21:28:06 +0530
Message-ID: <1795219.CLAn9GhObP@localhost.localdomain>
In-Reply-To: <20130812011155.GL12779@dastard>
References: <3326777.u9YeDIQiYF@localhost.localdomain>
	<20130812011155.GL12779@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: sekharan@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Hello Dave,

> So, to do this properly, I'd suggest that the code needs to scale
> the offset/size of the IO being done by the filesystem block size,
> not use a fixed size. Using a filter on the bmap output to handle
> the different block ranges will ensure everything works correctly
> from a golden output POV, except for one thing - the md5sum.
> 
Yes, we did try the approach of using variable block size and scaling
the offset values in the filter function. But we got stuck
working with md5sum (since we would need two sets of md5sums (with and
without '-k' option) per block size). As suggested, I will be
reposting the patch to use "_requires_le_4k_blocksize".

chandan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
