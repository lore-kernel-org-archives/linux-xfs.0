Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Oct 2006 09:27:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k93GRBaG002440
	for <xfs@oss.sgi.com>; Tue, 3 Oct 2006 09:27:11 -0700
Date: Tue, 3 Oct 2006 12:25:22 -0400 (EDT)
From: Stephane Doyon <sdoyon@max-t.com>
Message-ID: <Pine.LNX.4.64.0610031221020.482@madrid.max-t.internal>
MIME-Version: 1.0
Subject: Re: Long sleep with i_mutex in xfs_flush_device(), affects NFS
 service, was: Re: several messages
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Trond Myklebust <trond.myklebust@fys.uio.no>, David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, nfs@lists.sourceforge.net, Shailendra Tripathi <stripathi@agami.com>

[Ouch... terribly sorry for the mangled subject line on my previous post, 
insufficient coffee I guess. Sheepishly re-posting in hope of untangling 
the discussion threading mess...]

---------- Forwarded message ----------
Date: Tue, 3 Oct 2006 09:39:55 -0400 (EDT)
From: Stephane Doyon <sdoyon@max-t.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>, David Chinner <dgc@sgi.com>
Cc:  <xfs@oss.sgi.com>,  <nfs@lists.sourceforge.net>,
     Shailendra Tripathi <stripathi@agami.com>
Subject: Re: several messages

Sorry for insisting, but it seems to me there's still a problem in need of 
fixing: when writing a 5GB file over NFS to an XFS file system and hitting 
ENOSPC, it takes on the order of 22hours before my application gets an error, 
whereas it would normally take about 2minutes if the file system did not become 
full.

Perhaps I was being a bit too "constructive" and drowned my point in 
explanations and proposed workarounds... You are telling me that neither NFS 
nor XFS is doing anything wrong, and I can understand your points of view, but 
surely that behavior isn't considered acceptable?

On Tue, 26 Sep 2006, Trond Myklebust wrote:

>  On Tue, 2006-09-26 at 16:05 -0400, Stephane Doyon wrote:
> >  I suppose it's not technically wrong to try to flush all the pages of the
> >  file, but if the server file system is full then it will be at its worse.
> >  Also if you happened to be on a slower link and have a big cache to flush,
> >  you're waiting around for very little gain.
>
>  That all assumes that nobody fixes the problem on the server. If
>  somebody notices, and actually removes an unused file, then you may be
>  happy that the kernel preserved the last 80% of the apache log file that
>  was being written out.
>
>  ENOSPC is a transient error: that is why the current behaviour exists.

On Tue, 3 Oct 2006, David Chinner wrote:

>  This deep in the XFS allocation functions, we cannot tell if we hold
>  the i_mutex or not, and it plays no part in determining if we have
>  space or not. Hence we don't touch it here.


>  I doubt it's a good idea for an NFS server, either.
[...]
>  Remember that XFS, like most filesystems, trades off speed for
>  correctness as we approach ENOSPC. Many parts of XFS slow down as we
>  approach ENOSPC, and this is just one example of where we need to be
>  correct, not fast.
[...]
>  IMO, this is a non-problem.  You're talking about optimising a
>  relatively rare corner case where correctness is more important than
>  speed and your test case is highly artificial. AFAIC, if you are
>  running at ENOSPC then you get what performance is appropriate for
>  correctness and if you are continually runing at ENOSPC, then buy
>  some more disks.....

My recipe to reproduce the problem locally is admittedly somewhat artificial, 
but the problematic usage definitely isn't: simply an app on an NFS client that 
happens to fill up a file system. There must be some way to handle this better.

Thanks
