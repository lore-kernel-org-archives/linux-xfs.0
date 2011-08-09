Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p79BFWEj090850 for <xfs@oss.sgi.com>; Tue, 9 Aug 2011 06:15:32 -0500
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF7981BB3C01
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2011 04:15:31 -0700 (PDT)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id Zf6wT2EBl7E2Jutv for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2011 04:15:31 -0700 (PDT)
Date: Tue, 9 Aug 2011 13:15:27 +0200
From: Marc Lehmann <schmorp@schmorp.de>
Subject: Re: frequent kernel BUG and lockups - 2.6.39 + xfs_fsr
Message-ID: <20110809111526.GA7631@schmorp.de>
References: <20110806122556.GB20341@schmorp.de> <20110807102625.GJ3162@dastard>
	<20110808190222.GB7087@schmorp.de> <201108091210.50204@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201108091210.50204@zmi.at>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Tue, Aug 09, 2011 at 12:10:48PM +0200, Michael Monnerie <michael.monnerie@is.it-management.at> wrote:
> First of all, please calm down. Getting personal is not bringing us 
> anywhere.

Well, it's not me who's getting personal, so...?

> > Logic error - if I can corrupt an XFS without special privileges then
> > this is not a problem with xfs_fsr, but simply a kernel bug in the
> > xfs code. And a rather big one, one step below a remote exploit.
> 
> No, it's not a kernel bug because as long as you don't use xfs_fsr, 
> nothing will ever happen.

"As long as you don't boot, it will not crash".

xfs_fsr uses syscalls, just like other applications. According to your
(wrong) logic, if an application uses chown and this causes a kernel oops,
this is also not a kernel bug.

Thats of course wrong - it's the kernel that crashes when an applicaiton
does certain access patterns.

> (rw,nodiratime,relatime,logbufs=8,logbsize=256k,attr2,barrier,largeio,swalloc)
> and sometimes also 
> ,allocsize=64m

As has been reported on this list, this option is really harmful on
current xfs - in my case, it lead to xfs causing ENOSPC even when the disk
was 40% empty (~188gb).

> and I can't find evidence for fragmentation that would be harmful.Yes 

Well, define "harmful" - slow logfile reads aren't what I consider
"harmful" either. It's just very very slow.

> The allocsize option helps a lot there. I looked at one webserver access 
> log, it has 640MB with 99 fragments, but that's not a lot. On our 
> Spamgate I see 250MB logs with 374 fragments.

Well, if it were one fragment, you could read that in 4-5 seconds, at 374
fragments, it's probably around 6-7 seconds. Thats not harmful, but if you
extrapolate this to a few gigabytes and a lot of files, it becomes quite
the overhead.

> don't use the allocsize option there, which I changed now that I looked 

That allocsize option is no longer reasonable with newer kernels, as the
kernel will reserve 64m diskspace even for 1kb files indefinitely.

> > If XFS is bad at append-only workloads, which is the most common type
> > of workload, then XFS fails to be very relevant for the real world.
> 
> may be valid for your world, not mine. We have webservers, fileservers 
> and database servers, all of which are not really append style, but more 
> delete-and-recreate.

If you find a way of recreating files without appending to them, let me
know.

The problem with fragmentatioon is that it happens even for a few writers
for "create file" workloads (which do append...).

You probably make a distinction between "writing a file fast" and "writing
a file slow", but the distinction is not a qualitative difference. On busy
servers thta create a lot of files, you get fragmentation the same way
as on less busy servers that write files slower. There is little to no
difference in the resulting patterns.

> Well, db-servers are rather exceptional here.

Yes, append style is what makes up for the vast majority of disk writes on
a normal system, db-servers excepted indeed.

> But if the numbers for fragmentation on your servers are true, you must 
> have a very good test case for fragmentation prevention. Therefore it 
> could be really interesting if you could grab what Dave Chinner asked 
> for:

I'll keep it in mind.

> And maybe he could use it for optimizations. Is there any tool on Linux 
> to record such I/O patterns?

I presume strace would do, but thats where the "lot of work" comes in. If
there is a ready-to-use tool, that would of course make it easy.

-- 
                The choice of a       Deliantra, the free code+content MORPG
      -----==-     _GNU_              http://www.deliantra.net
      ----==-- _       generation
      ---==---(_)__  __ ____  __      Marc Lehmann
      --==---/ / _ \/ // /\ \/ /      schmorp@schmorp.de
      -=====/_/_//_/\_,_/ /_/\_\

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
