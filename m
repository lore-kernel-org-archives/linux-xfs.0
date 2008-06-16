Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jun 2008 20:53:44 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5G3rfeW005076
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 20:53:41 -0700
Received: from larry.melbourne.sgi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 0636E17C849B
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 20:54:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130]) by cuda.sgi.com with SMTP id uvWmRmhYY6vtEOFm for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 20:54:36 -0700 (PDT)
Message-ID: <4855E4C0.4090309@sgi.com>
Date: Mon, 16 Jun 2008 13:57:52 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Prevent extent btree block allocation failures
References: <485223E4.6030404@sgi.com> <20080613134418.GA31720@infradead.org>
In-Reply-To: <20080613134418.GA31720@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Fri, Jun 13, 2008 at 05:38:12PM +1000, Lachlan McIlroy wrote:
>> This change fixes xfs_bmap_extents_to_btree(), xfs_bmap_local_to_extents(),
>> xfs_bmbt_split() and xfs_bmbt_newroot() so that they can search other AGs
>> for the space needed.  Since we have reserved the space these allocations
>> are now guaranteed to succeed.
> 
> This looks good and makes lot of sense to me.  Please also add a comment
> to enum xfs_alloctype in xfs_alloc.h about the danger of the allocation
> types that never go out of the AG when used inside transactions.

The flags already have comments?  Are you referring specifically to the
fact we have reserved space somewhere in the filesystem but expect to find
it in a single AG?

> 
>> In order to search all AGs I had to revert
>> a change made to xfs_alloc_vextent() that prevented a search from looking
>> at AGs lower than the starting AG.  This original change was made to prevent
>> out of order AG locking when allocating multiple extents on data writeout
>> but since we only allocate one extent at a time now this particular problem
>> can't happen.
> 
> This one also makes sense, but I have a very bad gut feeling about it.
> There's nothing preventing the same deadlock scenario from coming back
> when people modify the highlevel data allocator again.  We really need
> some sort of assert to trigger early in that case to not got a nasty
> hard to trigger deadlock.

Yes I agree.  I was thinking about making the allocation of a second data
extent in the same transaction a conditional try operation to avoid the
deadlock.  If a caller to the allocator provides room to return more than
one extent then I don't think we have to return more than one - multiple
extents in one transaction is just an optimisation.

> 
>> +			if (++(args->agno) == mp->m_sb.sb_agcount)
> 
> and while we're at it this should be
> 
> 			if (++args->agno == mp->m_sb.sb_agcount)

Done, thanks.
