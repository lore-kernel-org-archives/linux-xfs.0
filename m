Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 02:23:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3U9NDSL024069
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 02:23:20 -0700
Message-ID: <48183AA5.9030804@decisionsoft.co.uk>
Date: Wed, 30 Apr 2008 10:23:49 +0100
From: Stuart Rowan <strr-debian@decisionsoft.co.uk>
Reply-To: strr-debian@decisionsoft.co.uk
MIME-Version: 1.0
Subject: Re: TAKE 979416 - Don't initialise new inode generation numbers to
 zero
References: <20080429004144.757D658C4C15@chook.melbourne.sgi.com>
In-Reply-To: <20080429004144.757D658C4C15@chook.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Is this liable to affect the stable releases, 2.6.24.y and 2.6.25.y? If so, 
is it appropriate for forwarding to the stable team?

I only ask because we have a heavily used NFS /home-directory server that 
uses XFS for the underlying store.

Cheers,
Stu.

David Chinner wrote, on 29/04/08 01:41:
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
> number space. Use a random number to initialise the generation
> number so we don't need to keep any new state on disk whilst
> making the new number difficult to guess from previous allocations.
> 
> Date:  Tue Apr 29 10:41:26 AEST 2008
> Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
> Inspected by:  hch@infradead.org
> 
> The following file(s) were checked into:
>   longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb
> 
> 
> Modid:  xfs-linux-melb:xfs-kern:31001a
> fs/xfs/xfs_ialloc.c - 1.199 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> xfs_ialloc.c.diff?r1=text&tr1=1.199&r2=text&tr2=1.198&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.c.diff?r1=text&tr1=1.199&r2=text&tr2=1.198&f=h
> 	- use random32() to initialise the generation in newly allocated
> 	  inodes to prevent short term reuse of inode,gen pairs which
> 	  can cause ESTALE problems for NFS clients.
> 
> 
> 
