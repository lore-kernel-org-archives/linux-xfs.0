Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CB5207F9B
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 20:53:18 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4782CAC002
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 18:53:18 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 6JbUplI42v121jQt for <xfs@oss.sgi.com>;
	Thu, 28 Feb 2013 18:53:16 -0800 (PST)
Message-ID: <5130181B.5050807@sandeen.net>
Date: Thu, 28 Feb 2013 20:53:15 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Read corruption on ARM
References: <CA+AKrqDq5xCNQo1X=MeRBq54ka0FGJEV5Rn6OzwY7eBfJ+8Wkw@mail.gmail.com>
	<512E7639.20205@sandeen.net> <512E89C2.9000302@sandeen.net>
	<CA+AKrqDaY4cgP+EPLepzUOU2jAOygTuj-0xDtOaGf+O0aRZV_g@mail.gmail.com>
	<512E903A.2020405@sandeen.net>
	<CA+AKrqAv7-5gGj_cNBNj=-nChKPzi+_HZmH=z2UABG9pDOmpBg@mail.gmail.com>
	<512EDF37.4050802@sandeen.net> <512EE20A.7010103@sandeen.net>
	<512EEAB8.4070306@sandeen.net>
	<CA+AKrqCuyb0mD7tQgjGDbSP5Gc+OohtU76htEazO=guxJUgddQ@mail.gmail.com>
	<20130301022539.GR5551@dastard>
In-Reply-To: <20130301022539.GR5551@dastard>
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
Cc: Jason Detring <detringj@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On 2/28/13 8:25 PM, Dave Chinner wrote:
> On Thu, Feb 28, 2013 at 03:38:51PM -0600, Jason Detring wrote:
>> On 2/27/13, Eric Sandeen <sandeen@sandeen.net> wrote:
>>> On 2/27/13 10:50 PM, Eric Sandeen wrote:
>>>> On 2/27/13 10:38 PM, Eric Sandeen wrote:
>>>>
>>>> ...
>>>>
>>>>> re-cc'ing xfs list
>>>>>
>>>>> So I used pahole to look at all structs, objdump -d to disassemble,
>>>>> and md5sum'd the results to see what's different.
>>>>>
>>>>> pi@raspberrypi ~ $ md5sum cross/*.dis cross/*.pahole native/*.dis
>>>>> native/*.pahole
>>>>>
>>>>> <manual sort>
>>>>>
>>>>> c0abd80c3bf049db5e1909fd851261cc  cross/xfs-O1-g.ko.pahole
>>>>> c0abd80c3bf049db5e1909fd851261cc  cross/xfs-O2-g.ko.pahole
>>>>> c0abd80c3bf049db5e1909fd851261cc  cross/xfs-Os-g.ko.pahole
>>>>> c0abd80c3bf049db5e1909fd851261cc  native/xfs-O1-g.ko.pahole
>>>>> c0abd80c3bf049db5e1909fd851261cc  native/xfs-O2-g.ko.pahole
>>>>> c0abd80c3bf049db5e1909fd851261cc  native/xfs-Os-g.ko.pahole
>>>>>
>>>>> so all structures look identical, good - but:
>>>>>
>>>>> while disassembly of these two modules match:
>>>>>
>>>>> d76f6ebf4d8a1b9f786facefbcf16f69  cross/xfs-O1-g.ko.dis
>>>>> d76f6ebf4d8a1b9f786facefbcf16f69  native/xfs-O1-g.ko.dis
>>>>>
>>>>> do you see the problem w/ the cross-compiled xfs-O1-g.ko as well?
>>
>> No, I didn't.  The problem has only shown itself on the -O2 builds,
>> both native and cross-compiled.  Lower optimization levels don't show
>> any of the symptoms.
>>
>> Perhaps a better comparison would be-O2 builds among working and
>> non-working compilers?   You'd asked for these before, but I just
>> finished them today.  The modules, build logs, and fs/xfs/ build trees
>> are up at
>>   <http://www.splack.org/~jason/projects/xfs-arm-corruption/3.6.11-g89caf39/>
>> A quick rundown:
>>   -cross-gcc4.4:  OK
>>   -cross-gcc4.5:  OK
>>   -cross-gcc4.6:  BAD
>>   -cross-gcc4.7:  BAD
>>   -cross-gcc4.8:  OK
>> Some of these don't seem to want to rmmod after they've been inserted.
>>  Argh reboots.
> 
> Do we really need to go any further than this to say conclusively
> that this is a compiler problem? It's clearly not a problem with the
> C code in that some compilers produce working code....
> 
> i.e. what steps do we need to take to get -cross-gcc4.[67]
> blacklisted when it comes to building ARM kernels?

Yeah, agreed.  (FWIW, I had misunderstood earlier; it's not a
cross-compile problem, it sounds like any native or cross compile
with 4.6 or 4.7 above a certain optimization level fails).

We could be helpful by tracking down the problem perhaps, but if it
is already fixed, perhaps no reason to do so (unless it was an
accidental fix that might show up again)

I suppose we could do something like :

#if defined(__arm__) && if __GNUC__ == 4 && (__GNUC_MINOR__ == 6 || __GNUC_MINOR__ == 7)
#warning gcc-4.[67] is known to miscompile xfs on arm.  A different compiler version is recommended.
#endif

The curious side of me still wants to track down what failed. ;)  Maybe weekend work.

-Eric



> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
