Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 70C2E29E04
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 09:38:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E4C9CAC005
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 07:38:27 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id d4ha53JXRZWiboVa for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 07:38:26 -0800 (PST)
Message-ID: <52976371.2030009@sandeen.net>
Date: Thu, 28 Nov 2013 09:38:25 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Problem with mkfs.xfs on a regular file
References: <20131127023119.GB13101@boogeyman>
	<20131127024713.GE10988@dastard>	<5296ACFB.4030901@sandeen.net>
	<20131128051626.GM10988@dastard>	<5296D5EB.2080008@sandeen.net>
	<20131128100107.GN10988@dastard> <20131128114705.GJ13101@boogeyman>
In-Reply-To: <20131128114705.GJ13101@boogeyman>
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
To: Phil White <cerise-xfs@l.armory.com>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/28/13, 5:47 AM, Phil White wrote:
> On Thu, Nov 28, 2013 at 09:01:07PM +1100, Dave Chinner wrote:
>> On Wed, Nov 27, 2013 at 11:34:35PM -0600, Eric Sandeen wrote:
>>> If only we had some way to tell, programatically, whether the mkfs target
>>> was a regular file or a block device, eh? ;)
>>>
>>> Seriously, I always thought the requirment to specify "-d file" was silly.
>>> And now I think it's even more silly, if it actually is required for
>>> proper behavior...
>>
>> It has always been required if you want mkfs to create the file for
>> you. And given that doing stuff like ioctl(BLKDISCARD) on files is
>> completely wrong, so I think it really is needed...
>>
>>>> What mkfs needs to do is reject devices that are files when "-d
>>>> file", "-l file" and "-r file" is not specified, and the problem
>>>> will go away because it will catch users who forget to tell mkfs
>>>> that it is supposed to be operating on an image file...
>>>
>>> Or maybe just stat() it, and DTRT?
>>
>> Well, we need to stat it to make sure that it's a file if "-d file"
>> is specified, and a block device if it's not. That will prevent this
>> problem.  Every other xfsprogs utility has to be told that it is
>> being pointed at an image file rather than a block device, so why
>> should mkfs be any different?
> 
> FWIW, I have a patch to just stat() and discard LIBXFS_DIRECT if the
> target is not a block device.  It worked for what I was doing and I
> wouldn't mind cleaning it up if need be.

I wonder if that's a little too surgical; today if we specify -d file,
we get xi.disfile=1, and set xi.dcreat=1 as well as long as -N wasn't specified.

Having xi.disfile set affects a few other behaviors after all, so
I just wonder if we should stat it early, set xi.disfile, and let all the
normal paths take it from there.  I'm not quite sure.

> The main thing is that it seems to me that mkfs mandates that the situation
> I outlined shouldn't ever fail.  That's probably something worth adding to
> xfstests as well.
> 
> And writing that test, I suppose, is something I don't mind doing either.

Tests are always welcome, that'd be great!

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
