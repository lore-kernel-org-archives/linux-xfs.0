Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EAE907CBF
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 17:21:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 647D2AC001
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 15:21:18 -0800 (PST)
Received: from mail-wg0-f49.google.com (mail-wg0-f49.google.com
	[74.125.82.49]) by cuda.sgi.com with ESMTP id OYsiR4Yg6cCziXQy
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Feb 2013 15:21:16 -0800 (PST)
Received: by mail-wg0-f49.google.com with SMTP id 15so3777231wgd.28
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 15:21:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <512D3C71.1030100@sandeen.net>
References: <CA+AKrqBQ=VG0oVsai+agywDKRgO9cG9AvT6mCTSZxKO3Si5Aiw@mail.gmail.com>
	<512D390D.7060302@sandeen.net> <512D3C71.1030100@sandeen.net>
Date: Tue, 26 Feb 2013 17:21:15 -0600
Message-ID: <CA+AKrqACW65gAOHCOFsVZp790nGd=bjSZnSE18rHkAFPVy_y9Q@mail.gmail.com>
Subject: Re: Read corruption on ARM
From: Jason Detring <detringj@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 2/26/13, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 2/26/13 4:37 PM, Eric Sandeen wrote:
>> On 2/26/13 3:58 PM, Jason Detring wrote:
>>> Hello list,
>>
>> <snip>
>>
>>> This also seems to impact the Raspberry Pi.  Below shows a 256 MB test
>>> case filesystem.
>>> The filesystem was created on an x86-64 box by mkfs.xfs 3.1.8 and
>>> populated by kernel 3.6.9.
>>> This failure report is Linux 3.6.11-g89caf39 built by GCC 4.7.2 from
>>>    <https://github.com/raspberrypi/linux/commits/rpi-3.6.y>
>>> The problem appears to be tied to the filesystem, not the media,
>>> since both an external USB reader and a loopback-mounted image on the
>>> unit's main SD media show the same backtrace.  The loopback image was
>>> captured on other hardware, then copied onto the RPi via network.
>>
>> Missed this; let me fire up my pi and see if I can replicate it.
>
> Realized that I'll need to cross-compile xfs.ko I guess...
>
> But - do you see this when the *whole* kernel is cross-compiled?
> Building the kernel one way and xfs another way, with another gcc,
> is probably nothing but trouble.  :)

Yes, I did.  I remember seeing it in months past when those compilers
were freshly released.  I only mixed-and-matched here as a spot check
to be sure the errors were still present.  For any Real Serious
Business, I'll build end-to-end with the same compiler.

I've uploaded my demonstration problem file system here:
  <http://www.splack.org/~jason/projects/xfs-arm-corruption/problemimage.xfs>
This throws a backtrace when "find ." is run on the mountpoint.  The
junk in the file system is just that--filler.  Don't take the kernel
archives as debugging builds.

Jason

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
