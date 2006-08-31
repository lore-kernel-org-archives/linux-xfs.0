Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 Aug 2006 01:03:46 -0700 (PDT)
Received: from e4.ny.us.ibm.com (e4.ny.us.ibm.com [32.97.182.144])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7V83SDW003004
	for <xfs@oss.sgi.com>; Thu, 31 Aug 2006 01:03:28 -0700
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k7V82tSJ025235
	for <xfs@oss.sgi.com>; Thu, 31 Aug 2006 04:02:55 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k7V82tj5013894
	for <xfs@oss.sgi.com>; Thu, 31 Aug 2006 04:02:55 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k7V82spG013394
	for <xfs@oss.sgi.com>; Thu, 31 Aug 2006 04:02:54 -0400
Message-ID: <44F6979C.4070309@cn.ibm.com>
Date: Thu, 31 Aug 2006 16:02:36 +0800
From: Yao Fei Zhu <walkinair@cn.ibm.com>
Reply-To: walkinair@cn.ibm.com
MIME-Version: 1.0
Subject: Re: kernel BUG in __xfs_get_blocks at fs/xfs/linux-2.6/xfs_aops.c:1293!
References: <44F67847.6030307@cn.ibm.com> <20060831074742.GD807830@melbourne.sgi.com>
In-Reply-To: <20060831074742.GD807830@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, haveblue@us.ibm.com, xfs@oss.sgi.com

David Chinner wrote:

>
>Hmmmm. We've mapped a range that has been reserved for a delayed
>allocate extent during a direct I/O. That should not happen as XFS
>flushes delalloc extents before executing a direct read and holds
>the I/O lock which will prevent any new writes from mapping new
>delalloc extents. Something went astray, though. :(
>
>Can you give me some more detail on the machine you're running?
>e.g. How many CPUs, RAM and what type of disk subsystem you are using?
>That will make it easier for us to try to reproduce this problem.
>
>Cheers,
>
>Dave.
>  
>
The test box is an IBM System p5 Linux partition, allocated with
0.8 physical POWER5+ cpu processing unit/ 2 virtual processors and 8GB 
memory.
The disk is exported by AIX Virtual IO Server.

BTW, I have CONFIG_PPC_64K_PAGES enabled.
 
