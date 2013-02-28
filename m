Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2E3287F8B
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 23:27:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0D92D304051
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2013 21:27:21 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BR7uXj9bj5WPGMm7 for <xfs@oss.sgi.com>;
	Wed, 27 Feb 2013 21:27:21 -0800 (PST)
Message-ID: <512EEAB8.4070306@sandeen.net>
Date: Wed, 27 Feb 2013 23:27:20 -0600
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
	<512EDF37.4050802@sandeen.net> <512EE20A.7010103@sandeen.net>
In-Reply-To: <512EE20A.7010103@sandeen.net>
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

On 2/27/13 10:50 PM, Eric Sandeen wrote:
> On 2/27/13 10:38 PM, Eric Sandeen wrote:
> 
> ...
> 
>> re-cc'ing xfs list
>>
>> So I used pahole to look at all structs, objdump -d to disassemble,
>> and md5sum'd the results to see what's different.
>>
>> pi@raspberrypi ~ $ md5sum cross/*.dis cross/*.pahole native/*.dis native/*.pahole
>>
>> <manual sort>
>>
>> c0abd80c3bf049db5e1909fd851261cc  cross/xfs-O1-g.ko.pahole
>> c0abd80c3bf049db5e1909fd851261cc  cross/xfs-O2-g.ko.pahole
>> c0abd80c3bf049db5e1909fd851261cc  cross/xfs-Os-g.ko.pahole
>> c0abd80c3bf049db5e1909fd851261cc  native/xfs-O1-g.ko.pahole
>> c0abd80c3bf049db5e1909fd851261cc  native/xfs-O2-g.ko.pahole
>> c0abd80c3bf049db5e1909fd851261cc  native/xfs-Os-g.ko.pahole
>>
>> so all structures look identical, good - but:
>>
>> while disassembly of these two modules match:
>>
>> d76f6ebf4d8a1b9f786facefbcf16f69  cross/xfs-O1-g.ko.dis
>> d76f6ebf4d8a1b9f786facefbcf16f69  native/xfs-O1-g.ko.dis
>>
>> do you see the problem w/ the cross-compiled xfs-O1-g.ko as well?
>>
>> the others differ:
>>
>> 349f3490a49f2ce539c2b058914f64f0  native/xfs-Os-g.ko.dis
>> 91c8e8230774808b538c21a83106a5d7  cross/xfs-Os-g.ko.dis
>>
>> 649338e1b8eeed6a294504fc76a39cb0  native/xfs-O2-g.ko.dis
>> e52c2a48277326c313bba76aa0b33ab7  cross/xfs-O2-g.ko.dis
>>
>> The diff of the disassembly of the others is huge, hard to
>> know where to start just yet.  Need an objdump mode that only
>> shows function-relative addresses or something to cut down
>> on the noise.
> 
> Could you try the same, to isolate the differences: objdump -d
> all of the *.o files for, say, the -O2 build, md5sum & compare,
> and see which ones differ?

And one more test.  Every time you hit the error, it causes
a log replay on the next mount since the fs has shut down.

Can you try

# mount; umount; mount; test

so that you start the test from a clean mount, and see if you still hit it?

Maybe save that image off before you do that test just in case it changes
the state.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
