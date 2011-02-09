Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p191MEkj167289
	for <linux-xfs@oss.sgi.com>; Tue, 8 Feb 2011 19:22:15 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4A2DD304089
	for <linux-xfs@oss.sgi.com>; Tue,  8 Feb 2011 17:24:46 -0800 (PST)
Message-ID: <4D51ECDD.1030606@sgi.com>
Date: Tue, 08 Feb 2011 19:24:45 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: xfsdump SGI_FS_BULKSTAT errno = 22, how could this IRIX bug get
	into Ubuntu 10.04 Lucid between kernels 2.6.32-27 and 2.6.32-26?
References: <iibmah$dlp$1@dough.gmane.org> <4D49A35B.6030009@sgi.com>
	<20110203045836.GV11040@dastard>
	<4D4ABEF7.7000400@lueckdatasystems.com>
	<20110204000823.GW11040@dastard>
	<4D4C0965.9010905@lueckdatasystems.com>
	<20110204204927.GZ11040@dastard> <4D505C48.8050203@sgi.com>
	<20110207212320.GC2559@dastard> <4D506744.9010303@sgi.com>
	<20110207220421.GD2559@dastard>
In-Reply-To: <20110207220421.GD2559@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@oss.sgi.com, Dann Frazier <dannf@debian.org>, Michael Lueck <mlueck@lueckdatasystems.com>

On 02/07/2011 04:04 PM, Dave Chinner wrote:
> On Mon, Feb 07, 2011 at 03:42:28PM -0600, Bill Kendall wrote:
>> On 02/07/2011 03:23 PM, Dave Chinner wrote:
>>> On Mon, Feb 07, 2011 at 02:55:36PM -0600, Bill Kendall wrote:
>>>> On 02/04/2011 02:49 PM, Dave Chinner wrote:
>>>>> On Fri, Feb 04, 2011 at 09:12:53AM -0500, Michael Lueck wrote:
>>>>>> Dave Chinner wrote:
>>>>>>> Ok, so xfsdump i seeing a short bulkstat, then an EINVAL returned
>>>>>> >from the next bulkstat. That's not a race condition, and makes me
>>>>>>> think you have some kind of on-disk corruption.
>>>>>>
>>>>>> Very odd that some kind of on-disk corruption is suddenly causing
>>>>>> xfsdump problems starting with Ubuntu 10.04 (Lucid) kernel
>>>>>> 2.6.32-27 and persisting in 2.6.32-28.
>>>>>
>>>>> Not really. The newer kernels have code in them that does more
>>>>> validity checks than previous kernels, so older kernels would have
>>>>> erroneously and silently returned unlinked files to xfsdump and have
>>>>> them backed up. IOWs, you'd never notice such a corruption with
>>>>> xfsdump. On the new kernel, xfsdump gets an EINVAL error to such
>>>>> occurrences, which it should have in the first place.
>>>>>
>>>>>> And there is one other person who confirmed this xfsdump problem
>>>>>> running Lucid with kernel 2.6.32-28. They reported their "me too"
>>>>>> in the Ubuntu bug tracker.
>>>>>>
>>>>>> Could it be that 2.6.32-26 and prior managed to write something to
>>>>>> disk corrupted, and the newer code is tripping on it?
>>>>>
>>>>> That's what I'm trying to find out. Or it could be something as
>>>>> simple as your disk has had an undetected bit error that has flipped
>>>>> a bit in the inode allocation btree.
>>>>>
>>>>
>>>> Hi Dave,
>>>>
>>>> I am able to reproduce this on a system running Ubuntu 10.4
>>>> (2.6.32-28). I took a metadump of the filesystem and moved it to
>>>> a system running 10.10 (2.6.35-25), and was able to successfully
>>>> dump it there. Likewise it dumps fine on 2.6.38-rc1. So this
>>>> suggests an issue with the Ubuntu 10.4 kernel.
>>>
>>> 2.6.35 hasn't had the untrusted inode lookup patches back ported to
>>> it, so it's no surprise that it isn't having problems - it's just
>>> like the older 2.6.32 kernels.
>>
>> I thought it landed in 2.6.35 and then a regression was fixed in
>> 2.6.36. The untrusted inode lookup changes are referenced here:
>> http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.35
>
> My bad, I just checked the regression fix. I have no idea if it got
> back ported to 2.6.35-stable or not - it probably didn't judging by
> your results.....
>
>>> Hmmm, can you find out if there is any specific pattern to the inode
>>> numbers that are returning EINVAL? Maybe the inode allocbt freespace
>>> record checks aren't quite correct in the backport (like the
>>> original bogus alignment assumption I made).
>>
>> I'll take a look.

The failing bulkstats, at least the ones I've checked so far, are 
hitting this path in xfs_bulkstat():

/*
  * Skip if this inode is free.
  */
if (XFS_INOBT_MASK(chunkidx) & irbp->ir_free) {
	lastino = ino;
	continue;
}

The backport of the 4 untrusted inode lookup commits looks okay to
me, however I think they depend on commit
7dce11dbac54fce777eea0f5fb25b2694ccd7900 (xfs: always use iget in
bulkstat), which was checked in shortly before the untrusted
inode lookup changes. When that commit is added to the Ubuntu
2.6.32-28 kernel, xfsdump runs fine on the 2 filesystems of mine
that were exhibiting the problem.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
