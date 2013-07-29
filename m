Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8DEBC7F3F
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 23:11:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1A110AC003
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 21:11:04 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id CC8P4q5LFr2gE3ch
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 21:11:04 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id BAE5C6C114
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 23:11:03 -0500 (CDT)
Message-ID: <51F5EB56.5040909@hardwarefreak.com>
Date: Sun, 28 Jul 2013 23:11:02 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: A short digression on FOSS (Re: understanding speculative
	preallocation)
References: <20130729000247.GA13468@dastard>
	<32553786.2492.1375056392388.JavaMail.root@benjamin.baylink.com>
	<20130729024105.GC13468@dastard> <51F5DDB3.7010109@sandeen.net>
In-Reply-To: <51F5DDB3.7010109@sandeen.net>
Reply-To: stan@hardwarefreak.com
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
To: xfs@oss.sgi.com

On 7/28/2013 10:12 PM, Eric Sandeen wrote:
> On 7/28/13 9:41 PM, Dave Chinner wrote:
>> On Sun, Jul 28, 2013 at 08:06:32PM -0400, Jay Ashworth wrote:
>>> ----- Original Message -----
>>>> From: "Dave Chinner" <david@fromorbit.com>
>>>
>>>> Sure, they have diverged signficant;y as we've backported various
>>>> bits of XFs fetaures and bug fixes back into RHEL6. As have every
>>>> other distro that doesn't track mainline directly. That's why you
>>>> need to look at the kernel source package to know what code the
>>>> distro is running.
>>>
>>> And... all the way back to Jason's original question:
>>>
>>> The way that you get the information out of a kernel/kernel RPM to 
>>> determine which XFS version it's running... is?  Cause it's clearly
>>> not obvious to either him or me.
>>
>> The "version" of XFS that you are running is that of the
>> kernel you are running. i.e. 2.6.32-279.x.y or 2.6.32-358.x.y.
> 
> IOWS:  There is no spoon.  ;)

Excellent quote Eric, love the Matrix movies.

I think the problem here is a lack of understanding of the kernel
development and commit process.  AFAIK there's not a single Linux
subsystem that has a standalone version number or versioning scheme.
Not the other filesystems, not the USB subsystem, SCSI, ATA, etc.  The
version of each is simply the version of the kernel they are included in.

I've been wondering throughout this thread where anyone got the idea
that there is an XFS version that can be traced/tracked.  Maybe because
xfsprogs have a version number?  The way to track XFS changes from
kernel to kernel is to look at the commits, as others have already stated.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
