Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q48EcS61186666 for <xfs@oss.sgi.com>; Tue, 8 May 2012 09:38:28 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id QcsyqEKbdo2xWD6S for <xfs@oss.sgi.com>;
	Tue, 08 May 2012 07:38:26 -0700 (PDT)
Message-ID: <4FA92FE1.5040706@sandeen.net>
Date: Tue, 08 May 2012 09:38:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix delalloc quota accounting on failure
References: <1336474133-27732-1-git-send-email-david@fromorbit.com>
	<4FA92DA7.4090809@sandeen.net>
In-Reply-To: <4FA92DA7.4090809@sandeen.net>
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

On 5/8/12 9:28 AM, Eric Sandeen wrote:
> On 5/8/12 5:48 AM, Dave Chinner wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> xfstest 270 was causing quota reservations way beyond what was sane
>> (ten to hundreds of TB) for a 4GB filesystem. There's a sign problem
>> in the error handling path of xfs_bmapi_reserve_delalloc() because
>> xfs_trans_unreserve_quota_nblks() simple negates the value passed -
>> which doesn't work for an unsigned variable. This causes
>> reservations of close to 2^32 block instead of removing a
>> reservation of a handful of blocks.
>>
>> Fix the same problem in the other xfs_trans_unreserve_quota_nblks()
>> callers where unsigned integer variables are used, too.
>>
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Ouch!
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> as far as it goes, but a couple thoughts:
> 
> 1) Should the cast be done in the macro so new callers don't get tripped up?
> 2) Should we just remove the ninos argument from the macro?  It's always passed as 0 (and could potentially suffer the same problem)
> 
> something like:
> 
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index b50ec5b..f771838 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -370,8 +370,8 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
>  #define xfs_qm_unmount_quotas(mp)
>  #endif /* CONFIG_XFS_QUOTA */
>  
> -#define xfs_trans_unreserve_quota_nblks(tp, ip, nblks, ninos, flags) \
> -	xfs_trans_reserve_quota_nblks(tp, ip, -(nblks), -(ninos), flags)
> +#define xfs_trans_unreserve_quota_nblks(tp, ip, nblks, flags) \
> +	xfs_trans_reserve_quota_nblks(tp, ip, -((long)nblks), 0, flags)
>  #define xfs_trans_reserve_quota(tp, mp, ud, gd, nb, ni, f) \
>  	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, nb, ni, \
>  				f | XFS_QMOPT_RES_REGBLKS)
> 

There are also 2 other callers that "already" fixed this, sortakinda:

xfs_bunmapi()

                        /* Update realtime/data freespace, unreserve quota */
...
                                (void)xfs_trans_reserve_quota_nblks(NULL,
                                        ip, -((long)del.br_blockcount), 0,
                                        XFS_QMOPT_RES_REGBLKS);

                                (void)xfs_trans_reserve_quota_nblks(NULL,
                                        ip, -((long)del.br_blockcount), 0,
                                        XFS_QMOPT_RES_REGBLKS);

those could be an unreserve call instead, with the sign fix embedded in the macro.

And while we're at it it seems nobody calls xfs_trans_reserve_quota_nblks() with ninos != 0 so I think that arg could be removed from that function too, not just the macro, in another patch.

-Eric



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
