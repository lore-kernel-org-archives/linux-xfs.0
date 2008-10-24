Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 22:24:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9O5OVU7008479
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 22:24:32 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A3CB1B16630
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 22:24:27 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id ZmZsmeaZwG3LhKLt for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 22:24:27 -0700 (PDT)
Date: Fri, 24 Oct 2008 16:24:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: deadlock with latest xfs
Message-ID: <20081024052418.GO25906@disturbed>
References: <4900412A.2050802@sgi.com> <20081023205727.GA28490@infradead.org> <49013C47.4090601@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49013C47.4090601@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Fri, Oct 24, 2008 at 01:08:55PM +1000, Lachlan McIlroy wrote:
> Christoph Hellwig wrote:
>> On Thu, Oct 23, 2008 at 07:17:30PM +1000, Lachlan McIlroy wrote:
>>> another problem with latest xfs
>>
>> Is this with the 2.6.27-based ptools/cvs tree or with the 2.6.28 based
>> git tree?  It does looks more like a VM issue than a XFS issue to me.
>>
>
> It's with the 2.6.27-rc8 based ptools tree.  Prior to checking
> in these patches:
>
> Can't lock inodes in radix tree preload region
> stop using xfs_itobp in xfs_bulkstat
> free partially initialized inodes using destroy_inode
>
> I was able to stress a system for about 4 hours before it ran out
> of memory.  Now I hit the deadlock within a few minutes.  I need
> to roll back to find which patch changed the behaviour.

Does it go away when you add the "XFS: Fix race when looking up
reclaimable inodes" I sent this morning?

Also, is there a thread stuck in xfs_setfilesize() waiting on an
ilock during I/O completion?

i.e. did the log hang because I/O completion is stuck waiting on
an ilock that is held by a thread waiting on I/O completion?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
