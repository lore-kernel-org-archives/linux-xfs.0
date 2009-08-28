Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7SLvJpF178409 for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 16:57:30 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfs: simplify xfs_trans_iget
Date: Fri, 28 Aug 2009 16:58:14 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ABF0@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20090828194243.GA6204@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Fri, Aug 28, 2009 at 12:02:06PM -0500, Alex Elder wrote:
>> This function was only ever called as a helper by xfs_trans_iget().
>> And it does the same things as xfs_iget() does, but in a more
>> restricted  context.  One difference I see is that this verifies
>> the transaction pointers match--and if they do not, it returns NULL.
>> 
>> In xfs_iget(), meanwhile, there is no such check.  I'm not familiar
>> enough with the transaction code to know what circumstances that
>> might lead a hashed inode without a matching transaction pointer,
>> but thought I'd point it out anyway in hopes you maybe did...
> 
> I'm always happy about people actually looking deep into the code in
> reviews.
> 
> Let's got through the above case in detail:
> 
> To have i_tansp set the inode must be locked.  So assuming we have an

That alone answers just about everything...

> inode in a transaction that is not your.  We will no go on to the
> xfs_iget once the xfs_inode_incore is gone.  But as part of xfs_iget
> we will lock the inode exclusively, which means we have to wait
> until the other transaction unlocks the inode.  Also if this was
> for some reason no true we would immediately hit the ASSERT in
> xfs_trans_ijoin which chcks that the i_transp pointer is NULL.
> 
>>>  		xfs_inode_item_init(ip, ip->i_mount);
>>>  	iip = ip->i_itemp;
>>>  	ASSERT(iip->ili_flags == 0);
>>> -	ASSERT(iip->ili_ilock_recur == 0);
>>> -	ASSERT(iip->ili_iolock_recur == 0);
>> 
>> These are the only other references, and (assuming we've done
>> a lot of testing with ASSERT() enabled) it is evident that
>> these are always zero at this point.  In any case, what this
>> means is that xfs_trans_ijoin() must never be called after
>> xfs_trans_iget() has been called on a hashed inode.  Again,
>> I'm not familiar enough with how we manage transactions to
>> to verify by inspection this is the case, but I presume it is.
> 
> I think this is where the above invariant that an inode in a transaction
> must always be locked kicks in again.

Looks good.  Thanks for the explanation.

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
