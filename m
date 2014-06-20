Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9E7027F3F
	for <xfs@oss.sgi.com>; Fri, 20 Jun 2014 18:24:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6827A304084
	for <xfs@oss.sgi.com>; Fri, 20 Jun 2014 16:24:09 -0700 (PDT)
Received: from mail-qg0-f44.google.com (mail-qg0-f44.google.com
	[209.85.192.44]) by cuda.sgi.com with ESMTP id toGPiEztFCFbE0et
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 20 Jun 2014 16:24:07 -0700 (PDT)
Received: by mail-qg0-f44.google.com with SMTP id j107so4099235qga.31
	for <xfs@oss.sgi.com>; Fri, 20 Jun 2014 16:24:06 -0700 (PDT)
Message-ID: <53A4C291.9060409@gmail.com>
Date: Fri, 20 Jun 2014 19:24:01 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: xfs_repair issue with ACLs on v5 XFS when beyond v4 limits
References: <5396799F.3050801@gmail.com> <20140610055254.GF9508@dastard>
	<539A61B2.5040202@gmail.com> <20140619033552.GJ4453@dastard>
In-Reply-To: <20140619033552.GJ4453@dastard>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On 06/18/2014 11:35 PM, Dave Chinner wrote:
> On Thu, Jun 12, 2014 at 10:28:02PM -0400, Michael L. Semon wrote:
>> On 06/10/2014 01:52 AM, Dave Chinner wrote:
>>> On Mon, Jun 09, 2014 at 11:21:03PM -0400, Michael L. Semon wrote:
>>>> Hi!  I've been running around in circles trying to work with too many 
>>>> ACLs, even losing my ability to count for a while.  Along the way, 
>>>> xfs_repair from git xfsprogs (last commit around May 27) is showing 
>>>> the following symptoms:
>>>>
>>>> On v5-superblock XFS...
>>>>
>>>> 1) When the ACL count is just above the limit from v4-superblock XFS--
>>>> 96 is a good test figure--`xfs_repair -n` and `xfs_repair` will both 
>>>> end in a segmentation fault.
>>>
>>> I couldn't reproduce this - I suspect that this is a problem with
>>> the ACL struct having a hardcoded array size or userspace not
>>> having the correct padding in the on-disk structure definition and
>>> you are on a 32bit system. I think I've fixed that in the patch
>>> below.
>>
>> Maybe.  Pentium III has a narrower cacheline than the Pentium 4, so 
>> I was not surprised to see holes in the XFS kernel code, even in the 
>> non-XFS kernel structs.  Do I need to upgrade something (ACL, system 
>> kernel headers, etc.) or would a pahole trip through libxfs be more 
>> revealing?
>>
>> What I'm getting is that if xfs_repair is counting between 200 and 
>> 256 ACLs, it will mention that there are too many ACLs, and it will 
>> segfault.  With your patch, the areas below and above this range are 
>> OK.
>>
>> A sample session like the one I overwrote last time looks like this:
>>
>> Phase 1 - find and verify superblock...
>> Phase 2 - using internal log
>>         - zero log...
>>         - scan filesystem freespace and inode maps...
>>         - found root inode chunk
>> Phase 3 - for each AG...
>>         - scan and clear agi unlinked lists...
>>         - process known inodes and perform inode discovery...
>>         - agno = 0
>> Too many ACL entries, count 250
>> entry contains illegal value in attribute named SGI_ACL_FILE or SGI_ACL_DEFAULT
>> (segfault, either Error 4 or Error 5, forgot to bring dmesg)
> 
> Ok, your test found a bug in the patch that was causing segv's - at
> about 20 ACLs, not 250. It's not the same as what you have reported,
> but it was a stack corruption bug and so may just be triggering
> differently on your machines.
> 
> Can you try the patch below?

This patch works!  The range from 4 ACL entries to the ACL limit 
seems to be fine to xfs_repair.  No segfaults, and the ACL limit is 
OK for this case.
 
>> Maybe not...your E-mail patch doesn't have the git version at the 
>> bottom, so I wondered whether I installed the entire patch.  What 
>> I did get went through `git am` just fine, with one whitespace error.
> 
> That's because I didn't use git directly to generate it. As you
> found out, it's still a valid patch...

Indeed.  All is well here, and hopefully, xfs_repair is a patch or two 
more ready for the masses.

Good work!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
