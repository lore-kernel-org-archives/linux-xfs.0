Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Mar 2008 16:31:54 -0800 (PST)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m230VkSj030411
	for <xfs@oss.sgi.com>; Sun, 2 Mar 2008 16:31:46 -0800
Message-ID: <47CB4700.9090808@sgi.com>
Date: Mon, 03 Mar 2008 11:32:00 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] remove superflous xfs_readsb call in xfs_mountfs
References: <20071218174829.GA3195@lst.de> <20080222034845.GA5354@lst.de>
In-Reply-To: <20080222034845.GA5354@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Tue, Dec 18, 2007 at 06:48:29PM +0100, Christoph Hellwig wrote:
>> When xfs_mountfs is called by xfs_mount xfs_readsb was called 35 lines
>> above unconditionally, so there is no need to try to read the superblock
>> if it's not present.  If any other port doesn't have the superblock
>> read at this point it should just call it directly from it's xfs_mount
>> equivalent.
> 
> Ping?
Looks good, will be in shortly.

Don

> 
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>> Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
>> ===================================================================
>> --- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2007-12-17 14:34:57.000000000 +0100
>> +++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2007-12-17 14:35:17.000000000 +0100
>> @@ -968,11 +968,6 @@ xfs_mountfs(
>>  	int		uuid_mounted = 0;
>>  	int		error = 0;
>>  
>> -	if (mp->m_sb_bp == NULL) {
>> -		error = xfs_readsb(mp, mfsi_flags);
>> -		if (error)
>> -			return error;
>> -	}
>>  	xfs_mount_common(mp, sbp);
>>  
>>  	/*
> ---end quoted text---
> 
