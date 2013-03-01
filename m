Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4C5647FA1
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 22:54:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 348988F8040
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 20:54:23 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	pJP2YEFWdQCCkE3m for <xfs@oss.sgi.com>;
	Thu, 28 Feb 2013 20:54:21 -0800 (PST)
Date: Fri, 1 Mar 2013 15:54:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Read corruption on ARM
Message-ID: <20130301045418.GS5551@dastard>
References: <512E89C2.9000302@sandeen.net>
	<CA+AKrqDaY4cgP+EPLepzUOU2jAOygTuj-0xDtOaGf+O0aRZV_g@mail.gmail.com>
	<512E903A.2020405@sandeen.net>
	<CA+AKrqAv7-5gGj_cNBNj=-nChKPzi+_HZmH=z2UABG9pDOmpBg@mail.gmail.com>
	<512EDF37.4050802@sandeen.net> <512EE20A.7010103@sandeen.net>
	<512EEAB8.4070306@sandeen.net>
	<CA+AKrqCuyb0mD7tQgjGDbSP5Gc+OohtU76htEazO=guxJUgddQ@mail.gmail.com>
	<20130301022539.GR5551@dastard> <5130181B.5050807@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5130181B.5050807@sandeen.net>
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
Cc: Jason Detring <detringj@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Feb 28, 2013 at 08:53:15PM -0600, Eric Sandeen wrote:
> On 2/28/13 8:25 PM, Dave Chinner wrote:
> > On Thu, Feb 28, 2013 at 03:38:51PM -0600, Jason Detring wrote:
> >> On 2/27/13, Eric Sandeen <sandeen@sandeen.net> wrote:
> >>> On 2/27/13 10:50 PM, Eric Sandeen wrote:
> >>>> On 2/27/13 10:38 PM, Eric Sandeen wrote:
> >>>>
> >>>> ...
> >>>>
> >>>>> re-cc'ing xfs list
> >>>>>
> >>>>> So I used pahole to look at all structs, objdump -d to disassemble,
> >>>>> and md5sum'd the results to see what's different.
> >>>>>
> >>>>> pi@raspberrypi ~ $ md5sum cross/*.dis cross/*.pahole native/*.dis
> >>>>> native/*.pahole
> >>>>>
> >>>>> <manual sort>
> >>>>>
> >>>>> c0abd80c3bf049db5e1909fd851261cc  cross/xfs-O1-g.ko.pahole
> >>>>> c0abd80c3bf049db5e1909fd851261cc  cross/xfs-O2-g.ko.pahole
> >>>>> c0abd80c3bf049db5e1909fd851261cc  cross/xfs-Os-g.ko.pahole
> >>>>> c0abd80c3bf049db5e1909fd851261cc  native/xfs-O1-g.ko.pahole
> >>>>> c0abd80c3bf049db5e1909fd851261cc  native/xfs-O2-g.ko.pahole
> >>>>> c0abd80c3bf049db5e1909fd851261cc  native/xfs-Os-g.ko.pahole
> >>>>>
> >>>>> so all structures look identical, good - but:
> >>>>>
> >>>>> while disassembly of these two modules match:
> >>>>>
> >>>>> d76f6ebf4d8a1b9f786facefbcf16f69  cross/xfs-O1-g.ko.dis
> >>>>> d76f6ebf4d8a1b9f786facefbcf16f69  native/xfs-O1-g.ko.dis
> >>>>>
> >>>>> do you see the problem w/ the cross-compiled xfs-O1-g.ko as well?
> >>
> >> No, I didn't.  The problem has only shown itself on the -O2 builds,
> >> both native and cross-compiled.  Lower optimization levels don't show
> >> any of the symptoms.
> >>
> >> Perhaps a better comparison would be-O2 builds among working and
> >> non-working compilers?   You'd asked for these before, but I just
> >> finished them today.  The modules, build logs, and fs/xfs/ build trees
> >> are up at
> >>   <http://www.splack.org/~jason/projects/xfs-arm-corruption/3.6.11-g89caf39/>
> >> A quick rundown:
> >>   -cross-gcc4.4:  OK
> >>   -cross-gcc4.5:  OK
> >>   -cross-gcc4.6:  BAD
> >>   -cross-gcc4.7:  BAD
> >>   -cross-gcc4.8:  OK
> >> Some of these don't seem to want to rmmod after they've been inserted.
> >>  Argh reboots.
> > 
> > Do we really need to go any further than this to say conclusively
> > that this is a compiler problem? It's clearly not a problem with the
> > C code in that some compilers produce working code....
> > 
> > i.e. what steps do we need to take to get -cross-gcc4.[67]
> > blacklisted when it comes to building ARM kernels?
> 
> Yeah, agreed.  (FWIW, I had misunderstood earlier; it's not a
> cross-compile problem, it sounds like any native or cross compile
> with 4.6 or 4.7 above a certain optimization level fails).
> 
> We could be helpful by tracking down the problem perhaps, but if it
> is already fixed, perhaps no reason to do so (unless it was an
> accidental fix that might show up again)
> 
> I suppose we could do something like :
> 
> #if defined(__arm__) && if __GNUC__ == 4 && (__GNUC_MINOR__ == 6 || __GNUC_MINOR__ == 7)
> #warning gcc-4.[67] is known to miscompile xfs on arm.  A different compiler version is recommended.
> #endif
> 
> The curious side of me still wants to track down what failed. ;)  Maybe weekend work.

I wouldn't use a warning - make it break the build immediately.
Maybe you could use BUILD_BUG_ON() for this....

Indeed, I'd even suggest sending a patch to lkml that blacklists
those ARM compiler versions altogether. i.e. if the compiler
miscompiles one kernel module, you can't trust any of the rest of
the kernel to correctly compiled, either...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
