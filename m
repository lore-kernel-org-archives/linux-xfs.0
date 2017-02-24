Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227145855.wb2nfzrrxvjsx5ph@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47994 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751057AbdBXKZo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Feb 2017 05:25:44 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1OAOSSk127676
        for <linux-xfs@vger.kernel.org>; Fri, 24 Feb 2017 05:25:44 -0500
Received: from e23smtp02.au.ibm.com (e23smtp02.au.ibm.com [202.81.31.144])
        by mx0a-001b2d01.pphosted.com with ESMTP id 28tdh2cva2-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Fri, 24 Feb 2017 05:25:43 -0500
Received: from localhost
        by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 24 Feb 2017 20:25:41 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
        by d23dlp03.au.ibm.com (Postfix) with ESMTP id CCCCC3578052
        for <linux-xfs@vger.kernel.org>; Fri, 24 Feb 2017 21:25:38 +1100 (EST)
Received: from d23av06.au.ibm.com (d23av06.au.ibm.com [9.190.235.151])
        by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v1OAPUjR35455062
        for <linux-xfs@vger.kernel.org>; Fri, 24 Feb 2017 21:25:38 +1100
Received: from d23av06.au.ibm.com (localhost [127.0.0.1])
        by d23av06.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v1OAP52N011095
        for <linux-xfs@vger.kernel.org>; Fri, 24 Feb 2017 21:25:06 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: Clarification on inode alignment
Date: Fri, 24 Feb 2017 15:54:26 +0530
In-Reply-To: <20170224000852.GF17542@dastard>
References: <1735943.rpnT4cuqyx@localhost.localdomain> <20170224000852.GF17542@dastard>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2430065.bKG4XOb8hV@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: dchinner@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>, "sandeen@sandeen.net" <sandeen@sandeen.net>, "Darrick J . Wong" <darrick.wong@oracle.com>

On Friday, February 24, 2017 11:08:52 AM Dave Chinner wrote:
> > However I still don't understand how non-aligned inode clusters (64 inodes in
> > a single cluster) would break the inode number to disk location
> > arithmetic calculations. Could you please explain it?
> 
> First, you need to understand the correct terminology: "inode
> cluster" vs "inode chunk"
> 
> inode chunk: unit of inode allocation, always 64 contiguous inodes
> 		referenced by a single inobt record
> 
> inode cluster: a buffer used to do inode IO, whose size is dependent
> 		on superblock flags and field values
> 
> The inobt record records the AGBNO of the inode chunk, and
> internally then indexes the inodes in the chunk from 0 to 63.
> 
> Inode clusters are independent of the inobt record. The number of
> inodes in a cluster buffer is dependent on the inode size and the
> inode cluster buffer size. The size of the inode cluster buffer is
> dependent on filesystem block size and inode alignment.
> 
> Take, for example, v4 filesystem, 4k fsb, 256 byte inodes, with
> everything indexed to zero to show that the maths to derive
> everything from chunk_agbno + ino # is simple:
> 
> chunk @ agbno
> 	+-------------------------------------------+
> ino#	0          16	      32         48
> 
> block	0	   1	      2          3
> 	+----------+----------+----------+----------+
> agbno   +0	   +1	      +2	 +3
> 
> cluster	0		      1
> 	+---------------------+---------------------+
> agbno	+0		      +2
> 
> All nice an simple, yes? So we can clearly see that an inode number
> of AGBNO | INO# can be mapped to the physical block
> 
> 	chunk_agbno + (INO# / inodes per block)
> 
> And the cluster buffer physical location is:
> 
> 	chunk_agbno + (INO# / inodes per cluster)
> 
> Ok, so the math is simple (as you've noticed), but it doesn't
> explain the alignment constraints. The question is this:
> what assumption does this math make about the relationship
> between the inode number and the physical location of the inode?
> 
> ....
> 
> ....
> 
> That's right, it assumes that chunk_agbno + INO# can only map to a
> single physical location and so never overlaps with another inode
> chunk. i.e. this cannot happen as a result of a inode free/alloc
> operation pair:
> 
> Free:
> chunk @ agbno
> 	+-------------------------------------------+
> ino#	0          16	      32         48
> 
> Alloc:
> chunk @ agbno+3
> 					+-------------------------------------------+
> 				ino#	0          16	      32         48
> 
> If we have the overlapping chunk allocation ranges like this, then
> we can have multiple inode numbers that map to the same physical
> location.  in the above case, both of the inode numbers (agbno | 48)
> and (agbno + 3 | 0) map to the same physical location but they have
> different cluster buffer address (i.e. agbno+2 vs agbno+3)
> 
> So, when you get an inode number, how do you know it is valid and
> you haven't raced with an unlink that just removed the underlying
> inode chunk? You can do a buffer lookup to see if it's stale, but
> that has all sorts of problems in that a key constraint is that we
> must not have overlapping buffers in the cache.  How do we know what
> buffers we need to look up (and how do we do it in a race free
> manner) to ensure that all the original inode cluster buffers have
> been invalidated and their transactions committed during an
> allocation?
> 
> IOWs, without jumping through all sorts of cluster buffer coherence
> validation hoops we end up with free vs allocation and free vs
> lookup races on the cluster buffers if we just use inode number
> conversions for physical buffer mapping. That's complex, costly and
> extremely error prone, so we essentially have to treat all inode
> numbers as untrusted because of these races.
> 
> There are two ways to solve this problem.
> 	1) always look up the inobt record for an inode number to
> 	get the chunk_agbno from the inobt as locking the AGI for
> 	lookup guarantees no alloc/lookup/free races can occur; or
> 
> 	2) Ensure that inode chunks never overlap by physically
> 	aligning them at allocation time, hence ensuring that every
> 	physical address maps to exactly one inode number and
> 	cluster buffer address.
> 
> XFS implemented 1) back in 1994 when inode cluster buffers were
> introduced.  The issue with this is that inobt lookups every time we
> want to map an inode number is that it is excitingly expensive. If
> we know the inode number is correct (i.e. cames from other internal
> metadata that we've already validated), then this is overhead we can
> avoid if we constraint the disk format via method 2).
> 
> That was done more than 20 years ago:
> 
> commit 07d3e5d3764a8cf02d2e40397da0018c5c60f70a
> Author: Doug Doucette <doucette@engr.sgi.com>
> Date:   Tue Jun 4 19:08:18 1996 +0000
> 
>     Support for aligned inode allocation (bug 385316).  Support for
>     superblock versioning (bug 385292).  Some cleanup.
> 
> And we've used aligned inodes ever since....
> 

Dave, Thanks a lot for describing the decisions behind the requirement of
inode alignment.

-- 
chandan

