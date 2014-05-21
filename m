Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8FA3D7F4E
	for <xfs@oss.sgi.com>; Wed, 21 May 2014 11:51:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1B834AC004
	for <xfs@oss.sgi.com>; Wed, 21 May 2014 09:51:06 -0700 (PDT)
Received: from mx01-fr.bfs.de (mx01-fr.bfs.de [193.174.231.67]) by
	cuda.sgi.com with ESMTP id vMZT6YoNMokvoLQG for
	<xfs@oss.sgi.com>; Wed, 21 May 2014 09:51:00 -0700 (PDT)
Message-ID: <537CD96D.2090901@bfs.de>
Date: Wed, 21 May 2014 18:50:53 +0200
From: walter harms <wharms@bfs.de>
MIME-Version: 1.0
Subject: Re: [patch] [XFS] indent an if statement
References: <20140521122746.GD23396@mwanda>
	<20140521142909.GA22281@infradead.org>
	<20140521143550.GC15585@mwanda>
In-Reply-To: <20140521143550.GC15585@mwanda>
Reply-To: wharms@bfs.de
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
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, kernel-janitors@vger.kernel.org, xfs@oss.sgi.com



Am 21.05.2014 16:35, schrieb Dan Carpenter:
> On Wed, May 21, 2014 at 07:29:09AM -0700, Christoph Hellwig wrote:
>> On Wed, May 21, 2014 at 03:27:46PM +0300, Dan Carpenter wrote:
>>> The "n += 32;" goes with the if statement on the line before so it
>>> should be indented.
>>>
>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>>
>>> diff --git a/fs/xfs/xfs_bit.h b/fs/xfs/xfs_bit.h
>>> index f1e3c90..f685942 100644
>>> --- a/fs/xfs/xfs_bit.h
>>> +++ b/fs/xfs/xfs_bit.h
>>> @@ -67,7 +67,7 @@ static inline int xfs_lowbit64(__uint64_t v)
>>>  	} else {	/* upper bits */
>>>  		w = (__uint32_t)(v >> 32);
>>>  		if (w && (n = ffs(w)))
>>> -		n += 32;
>>> +			n += 32;
>>
>> If we want to clean up this stuff let's do it properly:
>>
>> 		if (w) {
>> 			n = ffs(w);
>> 			if (n)
>> 				n += 32;
>> 		}
>>
> 


This looks like a ffsll() maybe there are other implemantions and we can
make a generic version (acualy i found only a ffsll() in nouvou, NTL).

just my 2 cents,

re,
 wh


> Sure.  I will resend.
> 
> regards,
> dan carpenter
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
