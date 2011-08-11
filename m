Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7BM4Oab008045 for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 17:04:24 -0500
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 838CE18AF15B
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 15:04:20 -0700 (PDT)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id aA449fHAm9dT9jYS for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2011 15:04:20 -0700 (PDT)
Date: Fri, 12 Aug 2011 00:04:19 +0200
From: Marc Lehmann <schmorp@schmorp.de>
Subject: Re: frequent kernel BUG and lockups - 2.6.39 + xfs_fsr
Message-ID: <20110811220418.GB12808@schmorp.de>
References: <20110806122556.GB20341@schmorp.de> <201108091210.50204@zmi.at>
	<20110809111526.GA7631@schmorp.de> <201108100859.27576@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201108100859.27576@zmi.at>
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

On Wed, Aug 10, 2011 at 08:59:26AM +0200, Michael Monnerie <michael.monnerie@is.it-management.at> wrote:
> > current xfs - in my case, it lead to xfs causing ENOSPC even when the
> > disk was 40% empty (~188gb).
> 
> Was this the "NFS optimization" stuff? I don't like that either.

The NFS server apparently opens and closes files very often (probably on
every read/write or so, I don't know the details), so XFS was
benchmark-improved by keeping the preallocation as long as the inode is in
memory.

Practical example: on my box (8GB ram), I upgraded the kernel and started a
buildroot build. When I came back 8 hours later the disk was full (some
hundreds of gigabytes), even though df showed 300gb or so of free space.

That was caused by me setting allocsize=64m and this causing every 3kb
object file to use 64m of diskspace (which du showed, but df didn't).

To me, thats an obvious bug, and a dirty hack (you shouldn't fix the NFS
server by hacking some band-aid into XFS), but to my surprise I was told
on this list that this is important for performance, and my use case
isn't what XFS is designed for, but thta XFS is designed for good NFS server
performance.

> > Well, if it were one fragment, you could read that in 4-5 seconds, at
> > 374 fragments, it's probably around 6-7 seconds. Thats not harmful,
> > but if you extrapolate this to a few gigabytes and a lot of files,
> > it becomes quite the overhead.
> 
> True, if you have to read tons of log files all day. That's not my 
> normal use case, so I didn't bother about that until now.

I am well aware that there are lots of different use cases. I see that
myself because I have so diverse usages on my disks and servers (desktop,
media server, news server, web server, game server... all quite different).

It'r clear that XFS can't handle all this magically, and that this is not
a problem in XFS itself, what I do find a bit scary is this "XFS is not
made for you" attitude that I was recently confronted with.

> Just "as long as the inode is cached" or something, I remember that 
> "echo 3 >drop_caches" cleans that up. Still ugly, I'd say.

Yeah, the more ram you have, the more diskspace is lost.

> > If you find a way of recreating files without appending to them, let
> > me know.
> 
> Seems we have a different meaning of "append". For me, append is when an 
> existing file is re-opened, and data added just to the end of it.

That rules out many, if not most, log file write patterns, which are
classical examples of "append workloads" - most apps do not reopen log
files, they create/open them once and then wrote them, often, but always,
relatively slowly.

Syslog is a good example of something that wouldn't be an "append"
according to your definition, but typically is seen as such.

Speed is the really only differentiating factor between "append" and
"create only", and in practise a filesystem can only catch this by seeing
if something is sitll in ram ("recent use, fast writes") or not, or
keeping this information on-disk (which can be a dangerous trade-off).

And yes, your deifntiino is valid - I don't think there is an obvious
consensus on which is used, but I think my definition (which includes log
files) is more common.

> > I presume strace would do, but thats where the "lot of work" comes
> > in. If there is a ready-to-use tool, that would of course make it
> > easy.
> 
> It's a pity that such a generic tool doesn't existing. I can't believe 
> that. Doesn't anybody have such a tool at hand?

Yeah, I'm listening :) I hope it doesn't boil down to an instrumented
kernel :(

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
