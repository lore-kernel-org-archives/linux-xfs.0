Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 18:20:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9H1KVCA022228
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 18:20:32 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3CD7B14201EA
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 18:22:12 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id SUt2nWx6LEjZhnJP for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 18:22:12 -0700 (PDT)
Date: Fri, 17 Oct 2008 12:21:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: another problem with latest code drops
Message-ID: <20081017012141.GJ25906@disturbed>
References: <48F6A19D.9080900@sgi.com> <20081016060247.GF25906@disturbed> <48F6EF7F.4070008@sgi.com> <20081016072019.GH25906@disturbed> <48F6FCB7.6050905@sgi.com> <20081016222904.GA31761@disturbed> <48F7E7BA.4070209@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F7E7BA.4070209@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Oct 17, 2008 at 11:17:46AM +1000, Lachlan McIlroy wrote:
> Dave Chinner wrote:
>>> I am seeing a lot of memory used here though:
>>>
>>> 116605669 116605669  26%    0.23K 6859157       17  27436628K selinux_inode_security
>>
>> Ah - I don't run selinux. Sounds like a bug that needs reporting
>> to lkml...
>
> I'm sure this is caused by your changes that introduced inode_init_always().
> It re-initialises an existing inode without destroying it first so it calls
> security_inode_alloc() without calling security_inode_free().

I can't think of how. The layers above XFS are symmetric:

	alloc_inode()
	  inode_init_always()
	    security_inode_alloc()
	.....
	security_inode_free()
	->destroy_inode()

So the filesystems should never, ever need to know about the
security context attached to the inode. The changes that introduced
inode_init_always() do not change this symmetry - we do:

	xfs_inode_alloc()
	  inode_init_always()
	    security_inode_alloc()
	.....
	security_inode_free()
	->destroy_inode()

And we should have this symmetry everywhere.

<thinks for a bit>

Hmmmm - maybe the xfs_iget_cache_miss failure paths where we call
xfs_idestroy() could leak contexts. We should really call xfs_iput()
because we have an initialised linux inode at this point and so
we need to go through destroy_inode(). I'll have a bit more of
a look, but this doesn't seem to account for the huge number of
leaked contexts you reported....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
