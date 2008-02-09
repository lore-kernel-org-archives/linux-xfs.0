Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Feb 2008 22:44:30 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m196iLAf009588
	for <xfs@oss.sgi.com>; Fri, 8 Feb 2008 22:44:23 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 260D25B9FA4
	for <xfs@oss.sgi.com>; Fri,  8 Feb 2008 22:44:44 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id NlCvUFAGFoOkqpGh for <xfs@oss.sgi.com>; Fri, 08 Feb 2008 22:44:44 -0800 (PST)
Message-ID: <47AD4BD9.5030605@sandeen.net>
Date: Sat, 09 Feb 2008 00:44:41 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] recover from iclog allocation failures
References: <47AD3E11.7020608@redhat.com> <20080209063329.GA6840@infradead.org>
In-Reply-To: <20080209063329.GA6840@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Fri, Feb 08, 2008 at 11:45:53PM -0600, Eric Sandeen wrote:
>>  	mp->m_log = xlog_alloc_log(mp, log_target, blk_offset, num_bblks);
>> +	if (!mp->m_log)
>> +		return ENOMEM;
> 
> Currently there's no allocations in there that should be able to fail.

Well, actually...

> But actually marking these KM_MAYFAIL would be a good idea.
> 
>> @@ -1219,6 +1221,13 @@ xlog_alloc_log(xfs_mount_t	*mp,
>>  		prev_iclog = iclog;
>>  
>>  		bp = xfs_buf_get_noaddr(log->l_iclog_size, mp->m_logdev_targp);

This was failing for him I think.

>> +		if (!iclog || !bp) {
>> +			if (iclog)
>> +				kmem_free(iclog, sizeof(xlog_in_core_t));
>> +			log->l_iclog_bufs = i;
>> +			xlog_dealloc_log(log);
>> +			return NULL;
>> +		}
> 
> Please check for iclog beeing NULL before trying to allocate the buffer,
> and switch it to KM_MAYFAIL.  Given that there are two failing cases now
> it would make sense to have goto-unwinding here.

hmm yeah probably so.

> Also once you touch the memory allocation feel free to remove the
> useless casts of their return values.
> 
>> Index: linux-2.6.24.noarch/fs/xfs/xfs_mount.c
>> ===================================================================
>> --- linux-2.6.24.noarch.orig/fs/xfs/xfs_mount.c
>> +++ linux-2.6.24.noarch/fs/xfs/xfs_mount.c
>> @@ -1007,6 +1007,7 @@ xfs_mountfs(
>>  			error = XFS_ERROR(EINVAL);
>>  			goto error1;
>>  		}
>> +		uuid_mounted = 1;
> 
> How is this related to the rest of the patch?

if we errored out, we returned from mount w/o taking the uuid back out
of the table.

-Eric
