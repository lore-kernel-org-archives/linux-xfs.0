Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 13:29:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8JKTquw007823
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 13:29:54 -0700
Message-ID: <46F186A7.7050301@sandeen.net>
Date: Wed, 19 Sep 2007 15:29:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] kill XFS_INOBT_IS_FREE_DISK
References: <20070919161202.GA18130@lst.de> <46F16752.1090702@sandeen.net> <20070919202239.GA32475@lst.de>
In-Reply-To: <20070919202239.GA32475@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:

> 
>> HAVE_SPLICE
> 
> 
> Backward compat?

ah, yeah, it's for 2.4:

0 xfs/linux-2.6/xfs_linux.h <global>  104 #define HAVE_SPLICE
1 fs/xfs/xfs_vnodeops.c     <global> 4718 #ifdef HAVE_SPLICE

can probably go soon eh.  HAVE_PERCPU_SB can too (not sure why it's not
in my list)  There may be others that are just for 2.4.

> 
>> nested_spinlock
>> nested_spinunlock
> 
> don't your patches kill these?

yeah, I just checked pristine cvs.

-Eric
