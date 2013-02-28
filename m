Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 67FB57F83
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 22:38:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 540428F8040
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 20:38:17 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id YygpCoAUgCY9TTCs for <xfs@oss.sgi.com>;
	Wed, 27 Feb 2013 20:38:15 -0800 (PST)
Message-ID: <512EDF37.4050802@sandeen.net>
Date: Wed, 27 Feb 2013 22:38:15 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Read corruption on ARM
References: <CA+AKrqBQ=VG0oVsai+agywDKRgO9cG9AvT6mCTSZxKO3Si5Aiw@mail.gmail.com>
	<512D3856.5050305@sandeen.net>
	<CA+AKrqC+6nXuCxdY08MBLsjv1fOPJ6=1ruTHsfGqxosQmCi_jQ@mail.gmail.com>
	<512D49E2.40003@sandeen.net>
	<CA+AKrqCrphO-eKy0n=70O9hmB3mXttOsKmTdfRnPxgJM3_PAkQ@mail.gmail.com>
	<512E3BB2.6060407@sandeen.net>
	<CA+AKrqDq5xCNQo1X=MeRBq54ka0FGJEV5Rn6OzwY7eBfJ+8Wkw@mail.gmail.com>
	<512E7639.20205@sandeen.net> <512E89C2.9000302@sandeen.net>
	<CA+AKrqDaY4cgP+EPLepzUOU2jAOygTuj-0xDtOaGf+O0aRZV_g@mail.gmail.com>
	<512E903A.2020405@sandeen.net>
	<CA+AKrqAv7-5gGj_cNBNj=-nChKPzi+_HZmH=z2UABG9pDOmpBg@mail.gmail.com>
In-Reply-To: <CA+AKrqAv7-5gGj_cNBNj=-nChKPzi+_HZmH=z2UABG9pDOmpBg@mail.gmail.com>
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
To: Jason Detring <detringj@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On 2/27/13 8:57 PM, Jason Detring wrote:
> On 2/27/13, Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 2/27/13 4:56 PM, Jason Detring wrote:
>>> On 2/27/13, Eric Sandeen <sandeen@sandeen.net> wrote:
>>>> Can you send xfs.ko's from both native & cross-compiles?  Need debugging
>>>> info in the binaries (nonstripped)
>>>
>>> I don't have a native build, sorry :-(   I can put one together if
>>> necessary, but it will be quite a while on the Pi.
>>
>> Yah I found that out ;)  You could just make M=fs/xfs though?
> 
> Done.  These are also on the site at
>   <http://www.splack.org/~jason/projects/xfs-arm-corruption/tracetest/3.6.11-g89caf39/>
> The directory containing cross-compiled modules has been renamed
> xfs-modules-cross/ and the new natively built modules are beneath the
> xfs-modules-native/ directory.

re-cc'ing xfs list

So I used pahole to look at all structs, objdump -d to disassemble,
and md5sum'd the results to see what's different.

pi@raspberrypi ~ $ md5sum cross/*.dis cross/*.pahole native/*.dis native/*.pahole

<manual sort>

c0abd80c3bf049db5e1909fd851261cc  cross/xfs-O1-g.ko.pahole
c0abd80c3bf049db5e1909fd851261cc  cross/xfs-O2-g.ko.pahole
c0abd80c3bf049db5e1909fd851261cc  cross/xfs-Os-g.ko.pahole
c0abd80c3bf049db5e1909fd851261cc  native/xfs-O1-g.ko.pahole
c0abd80c3bf049db5e1909fd851261cc  native/xfs-O2-g.ko.pahole
c0abd80c3bf049db5e1909fd851261cc  native/xfs-Os-g.ko.pahole

so all structures look identical, good - but:

while disassembly of these two modules match:

d76f6ebf4d8a1b9f786facefbcf16f69  cross/xfs-O1-g.ko.dis
d76f6ebf4d8a1b9f786facefbcf16f69  native/xfs-O1-g.ko.dis

do you see the problem w/ the cross-compiled xfs-O1-g.ko as well?

the others differ:

349f3490a49f2ce539c2b058914f64f0  native/xfs-Os-g.ko.dis
91c8e8230774808b538c21a83106a5d7  cross/xfs-Os-g.ko.dis

649338e1b8eeed6a294504fc76a39cb0  native/xfs-O2-g.ko.dis
e52c2a48277326c313bba76aa0b33ab7  cross/xfs-O2-g.ko.dis

The diff of the disassembly of the others is huge, hard to
know where to start just yet.  Need an objdump mode that only
shows function-relative addresses or something to cut down
on the noise.

-Eric

> Slackware ARM (-current) also uses GCC 4.7.2 as its native compiler.
> The test modules built with it at -O2 are failing to read the
> ruby/1.9.1/ directory as well.  I don't know if that's fortunate (my
> homebrew compilers are just as good or bad as the distro's?) or
> unfortunate (I still have the problem and now I am diverging from your
> native RPi results that worked).
> 
> Is there maybe a memory or I/O tunable in the kernel .config that I've
> clobbered?
> 
> Jason
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
