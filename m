Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Aug 2007 13:26:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7SKQn4p021032
	for <xfs@oss.sgi.com>; Tue, 28 Aug 2007 13:26:51 -0700
Message-ID: <46D48508.9060001@sandeen.net>
Date: Tue, 28 Aug 2007 15:26:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] clean up vnode^winode tracing
References: <46D11F1B.5020409@sandeen.net> <20070828200416.GG61154114@sgi.com>
In-Reply-To: <20070828200416.GG61154114@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> On Sun, Aug 26, 2007 at 01:35:07AM -0500, Eric Sandeen wrote:
>> Simplify vnode tracing calls by embedding function name & return addr
>> in the calling macro.
>>
>> Also do a lot of vnode->inode renaming for consistency, while
>> we're at it.
>>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>>
>> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
>> ===================================================================
>> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.c
>> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
>> @@ -1525,8 +1525,7 @@ xfs_vm_bmap(
>>  	struct inode		*inode = (struct inode *)mapping->host;
>>  	struct xfs_inode	*ip = XFS_I(inode);
>>  
>> -	vn_trace_entry(XFS_I(inode), __FUNCTION__,
>> -			(inst_t *)__return_address);
>> +	ip_trace_entry(XFS_I(inode));
> 
> s/ip_trace/xfs_itrace/
>

So xfs_itrace_entry, xfs_itrace_ref, xfs_itrace_exit etc is what you prefer?

-Eric
