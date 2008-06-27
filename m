Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 23:38:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5R6cndg028161
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 23:38:51 -0700
Message-ID: <48648B2B.3080709@sgi.com>
Date: Fri, 27 Jun 2008 16:39:39 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Fix use after free when closing log/rt devices
References: <48647746.5010007@sgi.com> <20080627063219.GA25015@infradead.org>
In-Reply-To: <20080627063219.GA25015@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>



Christoph Hellwig wrote:
> On Fri, Jun 27, 2008 at 03:14:46PM +1000, Lachlan McIlroy wrote:
>> The call to xfs_free_buftarg() will free the memory used by it's argument
>> so we need to save the bdev to pass to xfs_blkdev_put()
>>
>> Lachlan
>>
>> --- fs/xfs/linux-2.6/xfs_super.c_1.432	2008-06-27 14:51:17.000000000 +1000
>> +++ fs/xfs/linux-2.6/xfs_super.c	2008-06-27 14:59:26.000000000 +1000
>> @@ -781,13 +781,17 @@ STATIC void
>> xfs_close_devices(
>> 	struct xfs_mount	*mp)
>> {
>> +	struct block_device	*bdev;
>> +
>> 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
>> +		bdev = mp->m_logdev_targp->bt_bdev;
>> 		xfs_free_buftarg(mp->m_logdev_targp);
>> -		xfs_blkdev_put(mp->m_logdev_targp->bt_bdev);
>> +		xfs_blkdev_put(bdev);
>> 	}
>> 	if (mp->m_rtdev_targp) {
>> +		bdev = mp->m_rtdev_targp->bt_bdev;
>> 		xfs_free_buftarg(mp->m_rtdev_targp);
>> -		xfs_blkdev_put(mp->m_rtdev_targp->bt_bdev);
>> +		xfs_blkdev_put(bdev);
>> 	}
> 
> Looks good, alhough two local variables inside the ifs might be cleaner:
> 
> 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
> 		struct block_device *logdev = mp->m_logdev_targp->bt_bdev;
> 
> 		xfs_free_buftarg(mp->m_logdev_targp);
> 		xfs_blkdev_put(logdev);
> 	}
> 
> 	...

do we have any QA tests that test external log?

-- Mark
