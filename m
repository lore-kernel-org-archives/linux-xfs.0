Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Aug 2008 20:44:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7J3iiJj012461
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2008 20:44:45 -0700
Message-ID: <48AA439B.6080907@sgi.com>
Date: Tue, 19 Aug 2008 13:52:59 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Allocate inode tracing buffers before locking inode	cluster
References: <48A92BC6.5020105@sgi.com> <20080818081403.GJ19760@disturbed>
In-Reply-To: <20080818081403.GJ19760@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Mon, Aug 18, 2008 at 05:59:02PM +1000, Lachlan McIlroy wrote:
>> Trying to allocate memory while holding the inode cluster locked can cause
>> deadlocks; a thread creating an inode will have the inode cluster locked
>> and is stuck allocating memory, pdflush/kswapd are both trying to push out
>> dirty pages and convert delayed allocations which need space in the log and
>> xfsaild is trying to push on the tail of the log but is stuck trying to
>> acquire the inode cluster lock.
>>
>> I tried fixing this with KM_NOFS but turned a two-way deadlock into a
>> three-way deadlock.  This patch moves the allocation of the inode tracing
>> buffers before we lock the inode cluster.  We can also leak memory because
>> we don't free these allocations if we return from this function early so
>> use xfs_idestroy() to fully clean up the inode first.
> 
> Seems sane, but I think it should be wrapped up in the
> xfs_inode_alloc() code added as part of the 'Make use of the
> init-once slab optimisation' patch I posted recently. This
> moves the initialisation of all things inode related into a
> separate function - xfs_inode_alloc() - instead of doing all
> these intialisations around the place....
> 

Okay, sounds like a good idea.  I'll pull that patch in first.
