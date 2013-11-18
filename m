Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ED94329E04
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 15:52:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DC4BC304064
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 13:52:35 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id e4ku39BFfNXm1gcZ for <xfs@oss.sgi.com>;
	Mon, 18 Nov 2013 13:52:34 -0800 (PST)
Message-ID: <528A8C21.2070801@sandeen.net>
Date: Mon, 18 Nov 2013 15:52:33 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 0/5] xfs: more patches for 3.13
References: <1383280040-21979-1-git-send-email-david@fromorbit.com>	<20131106230133.GX1935@sgi.com>
	<20131107015706.GM6188@dastard>	<5282D2D3.3040601@sandeen.net>
	<20131114011610.GM6188@dastard>	<528657BB.8090206@sandeen.net>
	<52866008.4010309@sandeen.net> <20131117194830.GT6188@dastard>
In-Reply-To: <20131117194830.GT6188@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On 11/17/13, 1:48 PM, Dave Chinner wrote:
> On Fri, Nov 15, 2013 at 11:55:20AM -0600, Eric Sandeen wrote:
>> On 11/15/13, 11:19 AM, Eric Sandeen wrote:
>>> On 11/13/13, 7:16 PM, Dave Chinner wrote:
>>>
>>>> That's client side, not server side, so that's the NFS client inode
>>>> it is locking, not the server side XFS inode.
>>>
>>> Ah, geez, you're right. (x3)
>>>
>>> <snip>
>>>
>>>> Server side, where i_version is pulled out of an XFS inode:
>>>>
>>>> $ git grep i_version fs/nfsd
>>>> fs/nfsd/nfs3xdr.c:      fhp->fh_post_change = fhp->fh_dentry->d_inode->i_version;
>>>> fs/nfsd/nfs4xdr.c:              write64(p, inode->i_version);
>>>> fs/nfsd/nfsfh.h:                fhp->fh_pre_change = inode->i_version;
>>>> $
>>>>
>>>> the nfsfh.h hit is in fill_pre_wcc(), which appears to be called
>>>> under i_mutex but not i_lock. The xdr encoding functions don't
>>>> appear to be holding i_lock, and may be holding i_mutex, but I
>>>> haven't looked that far.
>>>
>>> I'm still not sure how  . . . 
>>
>> ugh didn't mean to send this reply quite yet, sorry.
>>
>> Not sure how we do an unlocked read on a 32-bit machine that doesn't potentially
>> get the wrong answer.  I talked to Bruce about it a bit; nothing jumped out at
>> us.  At worst (?) it seems that if you happened to race on a read at exactly
>> the 2^32'nd modification, you might go backwards.  
>>
>> As Bruce says, even if so, maybe "so rare we don't care?"
> 
> Especially as it requires 2^32 modifications to first be made to the
> file before there's even the possibility of a high word race on a
> read and then there's only one increment we could race with before
> it doesn't chnge again for another 2^32 modifications.
> 
> Hence, at 1 in 4 billion modifications potentially causing a problem,
> I'd agree with the "so rare we don't care" assessment.

Ok, I'm sold.

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
