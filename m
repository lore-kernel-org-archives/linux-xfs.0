Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50258 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751360AbeAaWRl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jan 2018 17:17:41 -0500
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] Parent pointer future use cases
References: <588cad68-78eb-88de-49c3-716330b70cd5@oracle.com>
 <20180131184653.GA4841@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <a5f3c350-c349-af59-52c2-239cd21c7c49@oracle.com>
Date: Wed, 31 Jan 2018 15:17:36 -0700
MIME-Version: 1.0
In-Reply-To: <20180131184653.GA4841@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-xfs <linux-xfs@vger.kernel.org>



On 01/31/2018 11:46 AM, Darrick J. Wong wrote:
> On Tue, Jan 30, 2018 at 08:56:07PM -0700, Allison Henderson wrote:
>> Hi everyone!
>>
>> Recently I have been working towards adding a new parent pointer patch set
>> to xfs.  Briefly summarized, goal of the feature is to enable an application
>> to quickly derive an inodes path from the mount point by storing information
>> about the inodes parent(s) in an extended attribute.  Currently, I am aware
>> of the intent to use the feature as part of an online scrub and repair
>> feature.
> 
> The online fs check use case is that we iterate every inode in the
> filesystem from start to finish via file handles, and if we find some
> damage it would be much more helpful to be able to report the file path
> to userspace (e.g. "/foo/bar/file is corrupt" vs. "inode 325325 is
> corrupt").
> 
> A second use is for xfs_repair and/or online fs repair -- instead of
> dumping files orphaned by a destroyed directory in lost+found, we have
> the possibility of rebuilding that directory by scanning all the inodes
> to see which ones have parent pointers to the broken directory and then
> rebuilding it from there.  Easy enough to do in xfs_repair, but will be
> significantly more challenging to do it in the kernel <cough>.
> 
> The third use I can think of relates to past years' discussion of head
> de-pop and pmem badblocks -- given a range of defective storage, we can
> cross reference that with the reverse mapping to figure out which
> (inode, offset) are affected, and try to use parent pointers to turn the
> inode numbers into file paths.  We can also figure out if metadata is
> affected and start a rebuild operation (though obviously if the rmap
> data is affected then we're toast).
> 
>> Looking forward however, I would like to know about any other
>> future coding intents that might make use of this feature.  For example,
>> optimizing file system shrink or exportfs operations?  Are there certain
> 
> Not sure it'll help for fs shrink, but clearly the exportfs part of the
> discussion has taken off. :)
> 
>> interfaces or test cases that would be helpful to have?  I know the patch
>> set has had a complicated history, so ideally being aware of how folks may
>> go about using it may help to construct test cases to route out flaws sooner
>> rather than later.
> 
> I posted a userspace ioctl interface strawman here, implementing use
> case #1 from above:
> https://marc.info/?l=linux-xfs&m=151270557232472&w=2
> 
> Basic parent pointer iteration and path construction are provided in
> userspace, bolted atop the in-kernel parent pointer iterator that
> behaves similarly to the existing xfs file-handle attribute iterator.
> 
> --D

Yes, I think I have an earlier version of that patch in my tree already, 
so I'll make sure those work.  :-)

Thank you everyone for all your feedback, this gives me some more ideas 
of use cases I can run it through as it comes up.  Hoping to have 
another set of it out soon for people to look through.  Thanks all!

Allison

> 
>>
>> Thank you!
>>
>> Allison Henderson
