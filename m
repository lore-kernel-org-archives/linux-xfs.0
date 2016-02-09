Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C630729DF5
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 15:45:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A86C7304039
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 13:45:53 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id i76CEnWEiCaWvn8e for <xfs@oss.sgi.com>;
	Tue, 09 Feb 2016 13:45:51 -0800 (PST)
Subject: Re: [PATCH] xfsprogs: guard fsxattr definition for newer kernels
References: <56BA24A9.4090403@redhat.com> <20160209195502.GR27429@dastard>
	<56BA4495.9060304@redhat.com> <20160209211010.GA14668@dastard>
	<56BA59B6.3030803@sandeen.net> <20160209214433.GD14668@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56BA5E0E.7030209@sandeen.net>
Date: Tue, 9 Feb 2016 15:45:50 -0600
MIME-Version: 1.0
In-Reply-To: <20160209214433.GD14668@dastard>
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



On 2/9/16 3:44 PM, Dave Chinner wrote:
> On Tue, Feb 09, 2016 at 03:27:18PM -0600, Eric Sandeen wrote:
>>
>>
>> On 2/9/16 3:10 PM, Dave Chinner wrote:
>>> On Tue, Feb 09, 2016 at 01:57:09PM -0600, Eric Sandeen wrote:
>>>> On 2/9/16 1:55 PM, Dave Chinner wrote:
>>>>> On Tue, Feb 09, 2016 at 11:40:57AM -0600, Eric Sandeen wrote:
>>>>>> After 334e580,
>>>>>> fs: XFS_IOC_FS[SG]SETXATTR to FS_IOC_FS[SG]ETXATTR promotion
>>>>>>
>>>>>> the file include/linux/fs.h now defines struct fsxattr.
>>>>>>
>>>>>> It defines FS_IOC_FSGETXATTR as well, so use that to wrap
>>>>>> our local definition, and skip it if the kernel is providing
>>>>>> it so that we don't get multiple definitions.
>>>>>>
>>>>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>>>>> ---
>>>>>>
>>>>>> Should the kernel also #define HAVE_FSXATTR to help existing
>>>>>> xfsprogs-devel installations?
>>>>>>
>>>>>> (And what if headers are included in the other order?  Should
>>>>>> we try to guard on the kernel side or no?)
>>>>>
>>>>> I've already sent a patch to fix this - it was with the foreign
>>>>> filesystem xfs_quota patch....
>>>>
>>>> Oh, sorry, spaced it.
>>>>
>>>> What do you think of the HAVE_FSXATTR definition in fs.h?
>>>
>>> Which fs.h? The include/linux/fs.h file does not have such
>>> guards...
>>
>> If include/linux/fs.h defined HAVE_FSXATTR, a subsequent inclusion
>> of xfs_fs.h would not redefine the structure, because it is
>> guarded with that (for irix!)
> 
> That's why I changed it to check if the ioctl is defined, rather
> than checking for HAVE_FSXATTR.

Right, but I'm talking about protecting older, existing versions of
xfsprogs headers which use HAVE_FSXATTR as the guard.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
