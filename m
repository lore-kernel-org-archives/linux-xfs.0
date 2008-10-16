Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Oct 2008 17:17:26 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9G0HNwi010041
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 17:17:23 -0700
Message-ID: <48F68877.50507@sgi.com>
Date: Thu, 16 Oct 2008 11:19:03 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] remove exports of inline functions
References: <20081006181626.GA15388@lst.de> <20081015104840.GA8853@lst.de>
In-Reply-To: <20081015104840.GA8853@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Mon, Oct 06, 2008 at 08:16:26PM +0200, Christoph Hellwig wrote:
>> Recent gcc starts to complain about exports of functions marked static
>> inline, so let's get rid of those.
> 
> note that the complain is in the form of a kernel doesn't link, so any
> chance we could get this patch in?

Yes, picking it up now.

>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
>> ===================================================================
>> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2008-10-07 01:08:33.000000000 +0000
>> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2008-10-07 01:09:58.000000000 +0000
>> @@ -153,8 +153,6 @@
>>  EXPORT_SYMBOL(kmem_zalloc);
>>  EXPORT_SYMBOL(kmem_zone_alloc);
>>  EXPORT_SYMBOL(kmem_zalloc_greedy);
>> -EXPORT_SYMBOL(kmem_zone_free);
>> -EXPORT_SYMBOL(kmem_zone_init);
>>  EXPORT_SYMBOL(kmem_zone_zalloc);
>>  EXPORT_SYMBOL(xfs_address_space_operations);
>>  EXPORT_SYMBOL(xfs_dir_file_operations);
>> @@ -217,8 +215,6 @@
>>  EXPORT_SYMBOL(xfs_finish_reclaim_all);
>>  EXPORT_SYMBOL(xfs_freesb);
>>  EXPORT_SYMBOL(xfs_fs_cmn_err);
>> -EXPORT_SYMBOL(xfs_highbit32);
>> -EXPORT_SYMBOL(xfs_highbit64);
>>  EXPORT_SYMBOL(xfs_idestroy);
>>  EXPORT_SYMBOL(xfs_iextract);
>>  EXPORT_SYMBOL(xfs_iext_add);
>> @@ -227,10 +223,7 @@
>>  EXPORT_SYMBOL(xfs_iext_idx_to_irec);
>>  EXPORT_SYMBOL(xfs_iext_insert);
>>  EXPORT_SYMBOL(xfs_iext_remove);
>> -EXPORT_SYMBOL(xfs_iflock);
>> -EXPORT_SYMBOL(xfs_iflock_nowait);
>>  EXPORT_SYMBOL(xfs_iflush);
>> -EXPORT_SYMBOL(xfs_ifunlock);
>>  EXPORT_SYMBOL(xfs_iget);
>>  EXPORT_SYMBOL(xfs_ilock);
>>  EXPORT_SYMBOL(xfs_ilock_map_shared);
> ---end quoted text---
> 
