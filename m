Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 21 Sep 2008 19:07:40 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8M27caJ027223
	for <xfs@oss.sgi.com>; Sun, 21 Sep 2008 19:07:38 -0700
Message-ID: <48D70051.4000402@sgi.com>
Date: Mon, 22 Sep 2008 12:17:53 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
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
Cc: Russell Cattelan <cattelan@thebarn.com>, xfs@oss.sgi.com

Eric Sandeen wrote:
> Lachlan McIlroy wrote:
>> Here's a patch to remove xfs_iext_irec_compact_full() like Russell
>> did in his original patch - are you guys happy with this?
>>
>> I'm putting it through it's paces now and so far it looks good.
> 
> I'll have to think more about it, honestly.  Probably fine, but I've not
> looked at all the surrounding code, I was so far just looking for the
> original bug.
> 
> (FWIW, compact_full *does* get called reasonably frequently, but the
> memmove case is what's hard to hit...)
xfs_iext_irec_compact_full() is probably getting called frequently from
xfs_iext_indirect_to_direct() which we only ever call when the number of
extents will fit into one extent buffer so we will never need the memmove
case in xfs_iext_irec_compact_full() and we can safely call
xfs_iext_irec_compact_pages() instead.

I wonder why xfs_iext_irec_compact_pages() is doing a memmove() instead
of a memcpy().

> 
> -Eric
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
> 
> ...
> 
