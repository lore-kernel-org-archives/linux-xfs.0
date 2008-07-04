Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Jul 2008 22:15:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m645EBqu018246
	for <xfs@oss.sgi.com>; Thu, 3 Jul 2008 22:14:14 -0700
Message-ID: <486DB1D9.20207@sgi.com>
Date: Fri, 04 Jul 2008 15:15:05 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] kill XFS_PURGE_INODE
References: <20080616062634.GA5971@lst.de> <20080702192224.GB18817@lst.de>
In-Reply-To: <20080702192224.GB18817@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Ping?  Already got a review from Dave.
> 
Yeah, this is basically a substitute and replace.

Okay, looks like there is also a s/VN_HOLD(XFS_ITOV())/IHOLD()/
thrown in too (which is what IHOLD is defined as).

I'll check it in.

--Tim

> On Mon, Jun 16, 2008 at 08:26:34AM +0200, Christoph Hellwig wrote:
>> Just a useless alias for IRELE.
>>
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>> Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm.c
>> ===================================================================
>> --- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm.c	2008-06-05 20:21:04.000000000 +0200
>> +++ linux-2.6-xfs/fs/xfs/quota/xfs_qm.c	2008-06-05 20:22:37.000000000 +0200
>> @@ -444,11 +444,11 @@ xfs_qm_unmount_quotas(
>>  		}
>>  	}
>>  	if (uqp) {
>> -		 XFS_PURGE_INODE(uqp);
>> +		 IRELE(uqp);
>>  		 mp->m_quotainfo->qi_uquotaip = NULL;
>>  	}
>>  	if (gqp) {
>> -		XFS_PURGE_INODE(gqp);
>> +		IRELE(gqp);
>>  		mp->m_quotainfo->qi_gquotaip = NULL;
>>  	}
>>  out:
>> @@ -1239,11 +1239,11 @@ xfs_qm_destroy_quotainfo(
>>  	xfs_qm_list_destroy(&qi->qi_dqlist);
>>  
>>  	if (qi->qi_uquotaip) {
>> -		XFS_PURGE_INODE(qi->qi_uquotaip);
>> +		IRELE(qi->qi_uquotaip);
>>  		qi->qi_uquotaip = NULL; /* paranoia */
>>  	}
>>  	if (qi->qi_gquotaip) {
>> -		XFS_PURGE_INODE(qi->qi_gquotaip);
>> +		IRELE(qi->qi_gquotaip);
>>  		qi->qi_gquotaip = NULL;
>>  	}
>>  	mutex_destroy(&qi->qi_quotaofflock);
>> @@ -1393,7 +1393,7 @@ xfs_qm_qino_alloc(
>>  	 * locked exclusively and joined to the transaction already.
>>  	 */
>>  	ASSERT(xfs_isilocked(*ip, XFS_ILOCK_EXCL));
>> -	VN_HOLD(XFS_ITOV((*ip)));
>> +	IHOLD(*ip);
>>  
>>  	/*
>>  	 * Make the changes in the superblock, and log those too.
>> Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm_syscalls.c
>> ===================================================================
>> --- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2008-05-23 09:31:39.000000000 +0200
>> +++ linux-2.6-xfs/fs/xfs/quota/xfs_qm_syscalls.c	2008-06-05 20:21:09.000000000 +0200
>> @@ -362,11 +362,11 @@ xfs_qm_scall_quotaoff(
>>  	 * if we don't need them anymore.
>>  	 */
>>  	if ((dqtype & XFS_QMOPT_UQUOTA) && XFS_QI_UQIP(mp)) {
>> -		XFS_PURGE_INODE(XFS_QI_UQIP(mp));
>> +		IRELE(XFS_QI_UQIP(mp));
>>  		XFS_QI_UQIP(mp) = NULL;
>>  	}
>>  	if ((dqtype & (XFS_QMOPT_GQUOTA|XFS_QMOPT_PQUOTA)) && XFS_QI_GQIP(mp)) {
>> -		XFS_PURGE_INODE(XFS_QI_GQIP(mp));
>> +		IRELE(XFS_QI_GQIP(mp));
>>  		XFS_QI_GQIP(mp) = NULL;
>>  	}
>>  out_error:
>> Index: linux-2.6-xfs/fs/xfs/quota/xfs_quota_priv.h
>> ===================================================================
>> --- linux-2.6-xfs.orig/fs/xfs/quota/xfs_quota_priv.h	2008-05-23 09:31:39.000000000 +0200
>> +++ linux-2.6-xfs/fs/xfs/quota/xfs_quota_priv.h	2008-06-05 20:21:09.000000000 +0200
>> @@ -158,9 +158,6 @@ for ((dqp) = (qlist)->qh_next; (dqp) != 
>>  #define XFS_IS_SUSER_DQUOT(dqp)		\
>>  	(!((dqp)->q_core.d_id))
>>  
>> -#define XFS_PURGE_INODE(ip)		\
>> -	IRELE(ip);
>> -
>>  #define DQFLAGTO_TYPESTR(d)	(((d)->dq_flags & XFS_DQ_USER) ? "USR" : \
>>  				 (((d)->dq_flags & XFS_DQ_GROUP) ? "GRP" : \
>>  				 (((d)->dq_flags & XFS_DQ_PROJ) ? "PRJ":"???")))
> ---end quoted text---
> 
