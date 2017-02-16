Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32837 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754386AbdBPMXF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2017 07:23:05 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1GCJO5n013343
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2017 07:23:04 -0500
Received: from e23smtp07.au.ibm.com (e23smtp07.au.ibm.com [202.81.31.140])
        by mx0a-001b2d01.pphosted.com with ESMTP id 28n6rcd7h2-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2017 07:23:03 -0500
Received: from localhost
        by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 16 Feb 2017 22:23:01 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
        by d23dlp03.au.ibm.com (Postfix) with ESMTP id C1B603578052
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2017 23:22:57 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
        by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v1GCMnEJ34930710
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2017 23:22:57 +1100
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
        by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v1GCMPTA017392
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2017 23:22:25 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH] xfs: do not unconditionally enable hasalign feature on V5 filesystems
Date: Thu, 16 Feb 2017 17:52:06 +0530
In-Reply-To: <5443d317-838b-4d93-b513-15b9c18cb019@sandeen.net>
References: <1487174254-9002-1-git-send-email-chandan@linux.vnet.ibm.com> <7dd96d6b-ccb5-105f-18aa-207e1c28c625@sandeen.net> <5443d317-838b-4d93-b513-15b9c18cb019@sandeen.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2023843.7By95Kpbey@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Wednesday, February 15, 2017 09:29:35 PM Eric Sandeen wrote:
> On 2/15/17 10:13 AM, Eric Sandeen wrote:
> > Hm, the intent of the _haslign() function is to say that V5 must always
> > imply the "alignbit" - i.e. we don't want to grow an infinite feature
> > matrix, and by the time you get to V5 supers, there are many things which
> > cannot be turned on or off, such as this feature.
> 
> I'm rethinking this a bit; while my question may have uncovered
> another real bug, I think maybe your patch /is/ ok.
> 
> While the intent /was/ to ensure that some features are not optional
> on V5 filesystems, the mkfs code itself might end up turning off inode
> alignment for sufficiently large filesystem blocks and sufficiently
> small inode sizes.  The reality is, for sufficiently large fs blocks,
> every new inode chunk allocation is aligned, because it is sub-block
> sized.  And so there is nothing uniquely "aligned" about any allocation.
> 
> i.e. on v4 superblocks, the right combination of inode size & fs block
> size will turn off the alignment feature, even if the user did not
> request it.
> 
> So for v5 supers, it does seem odd to report the presence of the
> alignment feature even when the flag is not set in the superblock
> due to the geometry details.
> 
> This goes way back to:
> 
>  04a1e6c5b xfs: add CRC checks to the superblock
> 
> which doesn't really explain why the xfs_sb_version_hasalign got
> changed.
> 
> Anyway; it probably makes sense to do a targeted fix to resolve
> the issue you've run into, but we might want to take a broader
> look at when the alignment feature (and feature flag) gets set
> and reported, to make sure that it is all consistent and as expected.
> 

Right. I will post the new patch (one that uses xfs_icluster_size_fsb()
instead of XFS_B_TO_FSBT()) and then look at the rest of the alignment feature
usages. Thanks for your guidance.

-- 
chandan

