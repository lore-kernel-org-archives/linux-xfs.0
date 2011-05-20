Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4KFnRqS098501 for <xfs@oss.sgi.com>; Fri, 20 May 2011 10:49:27 -0500
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3505146CA86
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 08:49:24 -0700 (PDT)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id jo7V2jUBph1qJftC for
	<xfs@oss.sgi.com>; Fri, 20 May 2011 08:49:24 -0700 (PDT)
Date: Fri, 20 May 2011 17:49:20 +0200
From: Marc Lehmann <schmorp@schmorp.de>
Subject: Re: drastic changes to allocsize semantics in or around 2.6.38?
Message-ID: <20110520154920.GD5828@schmorp.de>
References: <20110520005510.GA15348@schmorp.de>
	<20110520025659.GO32466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110520025659.GO32466@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, May 20, 2011 at 12:56:59PM +1000, Dave Chinner <david@fromorbit.com> wrote:
[thanks for the thorough explanation]
> 
> So the question there: how is your workload accessing the files? Is
> it opening and closing them multiple times in quick succession after
> writing them?

I don't think so, but of course, when compiling a file, it will be linked
afterwards, so I guess it would be accessed at least once.

> I think it is triggering the "NFS server access pattern" logic and so
> keeping speculative preallocation around for longer.

Longer meaning practically infinitely :)

> I'd suggest removing the allocsize mount option - you shouldn't need
> it anymore because the new default behaviour resists fragmentation a
> whole lot better than pre-2.6.38 kernels.

I did remove it already, and will actively try this on our production
server which suffer from severe fragmentation (but xfs_fsr fixes that with
some work (suspending the logfile writing) anyway).

However, I would suggest that whatever heuristic 2.6.38 uses is deeply
broken at the momment, as NFS was not involved here at all (so no need for
it), the usage pattern was a simple compile-then-link-pattern (which is
very common), and there is really no need to cache this preallocation for
files that have been closed 8 hours ago and never touched since then.

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
