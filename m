Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 19 Sep 2008 08:14:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8JFE4NW001259
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 08:14:04 -0700
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 93F1E127D821
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 08:15:36 -0700 (PDT)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202]) by cuda.sgi.com with ESMTP id Mfa2CLn4O2ZWeT8g for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 08:15:36 -0700 (PDT)
Message-ID: <48D3C216.8090905@thebarn.com>
Date: Fri, 19 Sep 2008 08:15:34 -0700
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: REVIEW: Fix for incore extent corruption.
References: <48D19A83.4040608@thebarn.com> <48D1CD46.4010104@sgi.com>    <48D1DCD5.7040502@thebarn.com> <48D218AE.9090400@sgi.com>    <48D2C97A.1070703@thebarn.com> <63352.131.252.241.230.1221776406.squirrel@sandeen.net> <48D2F795.3080104@sgi.com> <48D31B9A.1080803@sgi.com> <48D3456A.9090808@sandeen.net>
In-Reply-To: <48D3456A.9090808@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: lachlan@sgi.com, xfs@oss.sgi.com

Eric Sandeen wrote:
> Lachlan McIlroy wrote:
>   
>> Here's a patch to remove xfs_iext_irec_compact_full() like Russell
>> did in his original patch - are you guys happy with this?
>>
>> I'm putting it through it's paces now and so far it looks good.
>>     
>
> I'll have to think more about it, honestly.  Probably fine, but I've not
> looked at all the surrounding code, I was so far just looking for the
> original bug.
>   
Once I started looking at the pattern of extent buffer reductions before 
and after calling compact_page/full
I noticed even when we did a partial move the number of total buffers 
didn't go down.
I suppose you could end up with the stars and moon lining up just right 
and you would
do enough partial moves to free up a page.

Since this is all incore buffers space we are talking about all these 
space optimizations are
moot once the inode goes inactive and is flushed from cache.

I can't really think of a situation where not doing partial extent moves 
is really going to
create an issue but I might be missing something.


-Russell

> (FWIW, compact_full *does* get called reasonably frequently, but the
> memmove case is what's hard to hit...)
>
> -Eric
>
>   
>> --- a/fs/xfs/xfs_inode.c	2008-09-19 13:08:08.000000000 +1000
>> +++ b/fs/xfs/xfs_inode.c	2008-09-19 13:16:34.000000000 +1000
>> @@ -4157,7 +4166,7 @@ xfs_iext_indirect_to_direct(
>>  	ASSERT(nextents <= XFS_LINEAR_EXTS);
>>  	size = nextents * sizeof(xfs_bmbt_rec_t);
>>  
>> -	xfs_iext_irec_compact_full(ifp);
>> +	xfs_iext_irec_compact_pages(ifp);
>>  	ASSERT(ifp->if_real_bytes == XFS_IEXT_BUFSZ);
>>  
>>  	ep = ifp->if_u1.if_ext_irec->er_extbuf;
>>     
>
> ...
>
>   
