Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n97MNTP9215469 for <xfs@oss.sgi.com>; Wed, 7 Oct 2009 17:23:29 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4DBE04AD054
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2009 15:24:55 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id ovdH7VYEpSjrHO28 for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2009 15:24:55 -0700 (PDT)
Message-ID: <4ACD1536.9060004@sandeen.net>
Date: Wed, 07 Oct 2009 17:24:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] fix readahead calculations in	xfs_dir2_leaf_getdents()
References: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AD38@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AD38@cf--amer001e--3.americas.sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs mailing list <xfs@oss.sgi.com>, tobias@lists.yoper.com

Alex Elder wrote:
> Eric Sandeen wrote:
>> Christoph Hellwig wrote:
>>> On Fri, Sep 25, 2009 at 02:42:26PM -0500, Eric Sandeen wrote:
>>>> V2: use min() as suggested by Jeff, it's tidier.
>>> I disagree with that, with the cast it looks pretty horrible.
>>> At least use min_t to avoid the case, but what's wrong with:
>>>
>>>> +		/* bufsize may have just been a guess; don't go negative */
>>>> +		bufsize = min((bufsize - length), (size_t)0);
>>> 		bufsize = bufsize - length > 0 ? bufsize - length : 0;
>> ok, that's fine too.
>>
>> I'll pick one.
>>
>>> Anyway, takes this as a
>>>
>>>
>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>>
>>> for any variant.
>>>
>> thanks,
>> -Eric
> 
> I'm going to put in this version:
> 
> 		bufsize = bufsize > length ? bufsize - length : 0;

Fine by me, thanks!

-Eric

> I.e.:
> 
> --- a/fs/xfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/xfs_dir2_leaf.c
> @@ -854,6 +854,7 @@ xfs_dir2_leaf_getdents(
>  			 */
>  			ra_want = howmany(bufsize + mp->m_dirblksize,
>  					  mp->m_sb.sb_blocksize) - 1;
> +			ASSERT(ra_want >= 0);
>  
>  			/*
>  			 * If we don't have as many as we want, and we haven't
> @@ -1088,7 +1089,8 @@ xfs_dir2_leaf_getdents(
>  		 */
>  		ptr += length;
>  		curoff += length;
> -		bufsize -= length;
> +		/* bufsize may have just been a guess; don't go negative */
> +		bufsize = bufsize > length ? bufsize - length : 0;
>  	}
>  
>  	/*
> 
> 					-Alex
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
