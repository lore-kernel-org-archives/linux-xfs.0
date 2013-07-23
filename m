Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 807E67F3F
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 16:02:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1B7A0AC008
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 14:02:36 -0700 (PDT)
Received: from mail-ve0-f173.google.com (mail-ve0-f173.google.com
	[209.85.128.173]) by cuda.sgi.com with ESMTP id
	sIPz2rDZmxy3LFT6 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Jul 2013 14:02:31 -0700 (PDT)
Received: by mail-ve0-f173.google.com with SMTP id jw11so6447148veb.18
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 14:02:30 -0700 (PDT)
Message-ID: <51EEEF61.40000@gmail.com>
Date: Tue, 23 Jul 2013 17:02:25 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/49] xfsprogs: patches for crc-dev branch
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<51EB80DB.80602@gmail.com> <20130722233240.GC19986@dastard>
	<51EDFA5A.7070402@gmail.com> <20130723044450.GG19986@dastard>
In-Reply-To: <20130723044450.GG19986@dastard>
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
Cc: xfs@oss.sgi.com

On 07/23/2013 12:44 AM, Dave Chinner wrote:
> On Mon, Jul 22, 2013 at 11:36:58PM -0400, Michael L. Semon wrote:
>> On 07/22/2013 07:32 PM, Dave Chinner wrote:
>>> On Sun, Jul 21, 2013 at 02:34:03AM -0400, Michael L. Semon wrote:
>>>> On 07/19/2013 02:44 AM, Dave Chinner wrote:
>>>>
>>>>> Comments, thoughts, flames?
>>>>
>>>> I was hoping that I could use this 3.12 patchset with a 3.11.0-rc 
>>>> kernel, but the xfstests look like a disaster by going that way.  
>>>
>>> We'll, if you don't have all the filtering patches that I posted a
>>> while back it'll make quite a mess with all the experimental
>>> warnings mkfs and repair emit, and the xfs_db tests that modify
>>> filesystem structures will all also fail...
>>
>> I've been slacking on xfstests updates.  The problem may exist 
>> between keyboard and chair, though:  I was trying to copy a merged 
>> xfsprogs from one PC to another, then build everything from `make 
>> distclean` after deleting /usr/include/xfs.  Something must have 
>> gone wrong...won't be the first time...
>>
>>> I'll repost them later today...
>>
>> I'll take this patchset home and see if any of them were not 
>> committed to the xfsprogs git:
>>
>> http://oss.sgi.com/archives/xfs/2013-06/msg00217.html
>>
>> Is this the correct patchset?
> 
> Yeah, that's it, thugh I have a more recent version of it locally...
> 
> Cheers,
> 
> Dave.


Thanks.  After applying this patchset and compiling dmapi, xfsprogs, 
xfsdump, and xfstests around in circles several times, it looks 
rather sane now.  Two issues remain, one reproduced on another PC:

1) The earlier worries about dmapi and hole punching comes from the 
results of xfs/145 being run.  It hasn't been that long, but I've 
forgotten the last time xfstests gave messages like "[not run] DMAPI 
modules not loaded."  dmapi is installed as a prerequisite; I have 
precisely zero knowledge of what happens when it is enabled.

2) There are two PCs: the one being discussed here, and the all-3.12 
setup that is in mid-bisect.  For CRC filesystems made by the new 
mkfs.xfs for the 3.11.0-rc and 3.10.0+ mid-bisect kernels, attempts 
to mount them fail with a dmesg like this (by memory)...

XFS(sdb6): ... unknown incompatible features (0x1) detected ...
Filesystem can not be safely mounted by this kernel.

Is there an extra flag that can be passed to mkfs.xfs for the sake 
of older CRC-capable kernels?  FWIW, both PCs could still mount 
CRC-enabled XFS filesystems made during the kernel 3.10-rc cycle.

Thanks again!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
