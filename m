Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 21:06:28 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3M461cT031019
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 21:06:02 -0700
Message-ID: <480D641B.8060301@melbourne.sgi.com>
Date: Tue, 22 Apr 2008 14:05:47 +1000
From: Greg Banks <gnb@melbourne.sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Don't initialise new inode generation numbers to zero
 V2
References: <20080422015806.GU108924158@sgi.com>
In-Reply-To: <20080422015806.GU108924158@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> Don't initialise new inode generation numbers to zero
>
> When we allocation new inode chunks, we initialise the generation
> numbers to zero. This works fine until we delete a chunk and then
> reallocate it, resulting in the same inode numbers but with a
> reset generation count. This can result in inode/generation
> pairs of different inodes occurring relatively close together.
>
> Given that the inode/gen pair makes up the "unique" portion of
> an NFS filehandle on XFS, this can result in file handles cached
> on clients being seen on the wire from the server but refer to
> a different file. This causes .... issues for NFS clients.
>
> Hence we need a unique generation number initialisation for
> each inode to prevent reuse of a small portion of the generation
> number space. Make this initialiser per-allocation group so
> that it is not a single point of contention in the filesystem,
> and increment it on every allocation within an AG to reduce the
> chance that a generation number is reused for a given inode number
> if the inode chunk is deleted and reallocated immediately
> afterwards.
>
> Version 2:
> o remove persistent per-AGI agi_newinogen field and replace with
>   randomly generated 32 bit number for each new cluster. This prevents
>   NFS clients from potentially guessing what the next generation
>   number is going to be.
>   
I'm confused, why would an NFS client be trying to guess the generation
number?  AFAICS the important thing is to ensure that the (inode,gen)
tuple isn't reused for a long time to prevent accidental filehandle
identity issues on clients; whether the gen is predictable or not
doesn't matter at all.  You could just as well use a 32 bit hash of the
nanosecond-precision timestamp when the inode cluster is first
allocated.  This patch seems to me to be draining entropy from the
random bit pool, which is needed for important things on the network,
for little benefit.

-- 
Greg Banks, P.Engineer, SGI Australian Software Group.
The cake is *not* a lie.
I don't speak for SGI.
