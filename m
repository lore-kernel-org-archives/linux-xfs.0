Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 65CCC7F37
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 08:48:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 52581304066
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 06:48:39 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ee4Blz6EheSz2AoZ for <xfs@oss.sgi.com>;
	Wed, 27 Feb 2013 06:48:38 -0800 (PST)
Message-ID: <512E1CC7.9050100@sandeen.net>
Date: Wed, 27 Feb 2013 08:48:39 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Read corruption on ARM
References: <CA+AKrqBQ=VG0oVsai+agywDKRgO9cG9AvT6mCTSZxKO3Si5Aiw@mail.gmail.com>
	<512D390D.7060302@sandeen.net> <512D3C71.1030100@sandeen.net>
	<CA+AKrqACW65gAOHCOFsVZp790nGd=bjSZnSE18rHkAFPVy_y9Q@mail.gmail.com>
	<20130227021614.GZ5551@dastard>
In-Reply-To: <20130227021614.GZ5551@dastard>
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
Cc: Jason Detring <detringj@gmail.com>, xfs@oss.sgi.com

On 2/26/13 8:16 PM, Dave Chinner wrote:
> On Tue, Feb 26, 2013 at 05:21:15PM -0600, Jason Detring wrote:
>> On 2/26/13, Eric Sandeen <sandeen@sandeen.net> wrote:
>>> On 2/26/13 4:37 PM, Eric Sandeen wrote:
>>>> On 2/26/13 3:58 PM, Jason Detring wrote:
>>>>> Hello list,
>>>>
>>>> <snip>
>>>>
>>>>> This also seems to impact the Raspberry Pi.  Below shows a 256 MB test
>>>>> case filesystem.
>>>>> The filesystem was created on an x86-64 box by mkfs.xfs 3.1.8 and
>>>>> populated by kernel 3.6.9.
>>>>> This failure report is Linux 3.6.11-g89caf39 built by GCC 4.7.2 from
>>>>>    <https://github.com/raspberrypi/linux/commits/rpi-3.6.y>
>>>>> The problem appears to be tied to the filesystem, not the media,
>>>>> since both an external USB reader and a loopback-mounted image on the
>>>>> unit's main SD media show the same backtrace.  The loopback image was
>>>>> captured on other hardware, then copied onto the RPi via network.
>>>>
>>>> Missed this; let me fire up my pi and see if I can replicate it.
>>>
>>> Realized that I'll need to cross-compile xfs.ko I guess...
>>>
>>> But - do you see this when the *whole* kernel is cross-compiled?
>>> Building the kernel one way and xfs another way, with another gcc,
>>> is probably nothing but trouble.  :)
>>
>> Yes, I did.  I remember seeing it in months past when those compilers
>> were freshly released.  I only mixed-and-matched here as a spot check
>> to be sure the errors were still present.  For any Real Serious
>> Business, I'll build end-to-end with the same compiler.
>>
>> I've uploaded my demonstration problem file system here:
>>   <http://www.splack.org/~jason/projects/xfs-arm-corruption/problemimage.xfs>
>> This throws a backtrace when "find ." is run on the mountpoint.  The
>> junk in the file system is just that--filler.  Don't take the kernel
>> archives as debugging builds.
> 
> The filesystem image appears to be just fine. xfs_repair on x86_64 does
> not complain about it, nor does xfs_check. Mounting and running find
> on it on my current 3.8-dev kernel does not cause any problems,
> either. And looking directly at the structures on disk I can't see
> any obvious problems.

And works fine on my arm-compiled xfs.ko on my R-Pi.

> Hence whatever issue is being seen must be to do with the way the
> compiled ARM code is interpreting the on-disk structures....

s/compiled/cross-compiled/

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
