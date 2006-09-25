Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Sep 2006 07:33:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8PEXNaG026464
	for <xfs@oss.sgi.com>; Mon, 25 Sep 2006 07:33:24 -0700
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9DC4B45E459
	for <xfs@oss.sgi.com>; Mon, 25 Sep 2006 07:32:44 -0700 (PDT)
Message-ID: <4517E88E.4020809@sandeen.net>
Date: Mon, 25 Sep 2006 09:32:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Data type overflow in xfs_trans_unreserve_and_mod_sb
References: <55EF1E5D5804A542A6CA37E446DDC206655888@mapibe17.exchange.xchg> <45179573.3020007@agami.com>
In-Reply-To: <45179573.3020007@agami.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Shailendra Tripathi <stripathi@agami.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Timothy Shimmin <tes@sgi.com>

Shailendra Tripathi wrote:
> Hi David,
>           As part of fixing xfs_reserve_blocks issue, you might want to 
> fix an issue in xfs_trans_unreserve_and_mod_sb as well. Since, I am on 
> much older version, my patch is not applicable on newer trees. However, 
> the patch is attached for your reference.
> 
> The problem is as below:
> 
> Superblock modifications required during transaction are stored in delta 
> fields in transaction. These fields are applied to the superblock when 
> transaction commits.
> 
> The in-core superblock changes are done in 
> xfs_trans_unreserve_and_mod_sb. It calls xfs_mod_incore_sb_batch 
> function to apply the changes. This function tries to apply the deltas 
> and if it fails for any reason, it backs out all the changes. One 
> typical modification done is like that:
> 
>         case XFS_SBS_DBLOCKS:
>                 lcounter = (long long)mp->m_sb.sb_dblocks;
>                 lcounter += delta;
>                 if (lcounter < 0) {
>                         ASSERT(0);
>                         return (XFS_ERROR(EINVAL));
>                 }
>                 mp->m_sb.sb_dblocks = lcounter;
>                 return (0);
> 
> So, when it returns EINVAL, the second part of the code backs out the 
> changes made to superblock. However, the worst part is that 
> xfs_trans_unreserve_and_mod_sb does not return any error value. 

Hm, yep, just ASSERT(error == 0);

I suppose this is the trickiness of canceling a transaction at some points...

> The 
> transaction appears to be committed peacefully without returning the 
> error. You don't notice this unless you do I/O on the filesystem. Later, 
> it hits some sort of in-memory corruption or other errors.
> 
> We hit this issue in our testing we tried to grow the filesystem from 
> from 100GB to 10000GB. This is beyond the interger (31 bits) limit and, 
> hence, for dblocks and fdblocks,  xfs_mod_sb struct does not pass in 
> correct data.
> 
> 

First thoughts, "long" won't help on 32 bit machines, perhaps this should be an 
explicitly-sized 64-bit type?

-Eric

p.s. good to see agami's recently active participation on the list!
