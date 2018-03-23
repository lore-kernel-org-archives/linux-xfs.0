Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33786 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752718AbeCWOC7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Mar 2018 10:02:59 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH V2] xfs: implement cgroup writeback support
Date: Fri, 23 Mar 2018 10:00:59 -0400
Message-ID: <93EC9E59-A4CD-4DA8-AD3E-308CDD9F0244@fb.com>
In-Reply-To: <f13839700d372a4663a08a11883e9c89b13056ca.1521752282.git.shli@fb.com>
References: <f13839700d372a4663a08a11883e9c89b13056ca.1521752282.git.shli@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shaohua Li <shli@kernel.org>
Cc: linux-xfs@vger.kernel.org, Kernel-team@fb.com, bfoster@redhat.com, Shaohua Li <shli@fb.com>, Tejun Heo <tj@kernel.org>, "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>



On 22 Mar 2018, at 17:11, Shaohua Li wrote:

> From: Shaohua Li <shli@fb.com>
>
> Basically this is a copy of commit 001e4a8775f6(ext4: implement cgroup
> writeback support). Tested with a fio test, verified writeback is
> throttled against cgroup io.max write bandwidth, also verified moving
> the fio test to another cgroup and the writeback is throttled against
> new cgroup setting.
>
> This only controls the file data write for cgroup. For metadata, since
> xfs dispatches the metadata write in specific threads, it's possible 
> low
> prio app's metadata could harm high prio app's metadata. A while back,
> Tejun has a patch to force metadata belonging to root cgroup for 
> btrfs.
> I had a similiar patch for xfs too. But Since Tejun's patch isn't in
> upstream, I'll delay post the xfs patch.

I think we've worked out all the problems on the btrfs/generic patch 
set, we'll get those sent out shortly.

-chris
