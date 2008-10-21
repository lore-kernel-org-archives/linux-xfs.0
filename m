Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Oct 2008 00:34:39 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9L7YZw1023895
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 00:34:36 -0700
Message-ID: <48FD8676.7000305@sgi.com>
Date: Tue, 21 Oct 2008 18:36:22 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] trivial xfs_remove comment fixup
References: <20080807215849.GA11345@lst.de> <20081018123623.GB25304@lst.de>
In-Reply-To: <20081018123623.GB25304@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Ping?  This is just a trivial comment fixup, shouldn't be that hard to
> review..

This is to cleanup the comments from the xfs_rmd -> xfs_remove merge.
Ok then, its in.

> 
> On Thu, Aug 07, 2008 at 11:58:49PM +0200, Christoph Hellwig wrote:
>> The dp to ip comment should be for the unconditional xfs_droplink
>> call, and the "." link obviously only exists for directories,
>> so it should be in the is_dir conditional.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>> Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
>> ===================================================================
>> --- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-08-06 17:26:37.000000000 -0300
>> +++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-08-06 17:36:44.000000000 -0300
>> @@ -2014,7 +2014,7 @@ xfs_remove(
>>  			goto out_bmap_cancel;
>>  
>>  		/*
>> -		 * Drop the link from dp to ip.
>> +		 * Drop the "." link from ip to self.
>>  		 */
>>  		error = xfs_droplink(tp, ip);
>>  		if (error)
>> @@ -2029,7 +2029,7 @@ xfs_remove(
>>  	}
>>  
>>  	/*
>> -	 * Drop the "." link from ip to self.
>> +	 * Drop the link from dp to ip.
>>  	 */
>>  	error = xfs_droplink(tp, ip);
>>  	if (error)
> ---end quoted text---
> 
