Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19856 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750902AbdK2SsW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Nov 2017 13:48:22 -0500
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH v3 10/17] xfs: extent transaction reservations for parent
 attributes
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
 <1510942905-12897-11-git-send-email-allison.henderson@oracle.com>
 <20171128185802.GP21412@magnolia>
Message-ID: <b69490be-02c4-0771-6d93-aded8791542a@oracle.com>
Date: Wed, 29 Nov 2017 11:48:18 -0700
MIME-Version: 1.0
In-Reply-To: <20171128185802.GP21412@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On 11/28/2017 11:58 AM, Darrick J. Wong wrote:

> On Fri, Nov 17, 2017 at 11:21:38AM -0700, Allison Henderson wrote:
>> From: Dave Chinner<dchinner@redhat.com>
>>
>> We need to add, remove or modify parent pointer attributes during
>> create/link/unlink/rename operations atomically with the dirents in the parent
>> directories being modified. This means they need to be modified in the same
>> transaction as the parent directories, and so we need to add the required
>> space for the attribute modifications to the transaction reservations.
>>
>> [achender: rebased, added xfs_sb_version_hasparent stub]
>>
>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
>> Signed-off-by: Allison Henderson<allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_format.h     |   5 ++
>>   fs/xfs/libxfs/xfs_trans_resv.c | 103 ++++++++++++++++++++++++++++++++---------
>>   2 files changed, 85 insertions(+), 23 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index b9ea5bf..121862a 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -556,6 +556,11 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
>>   		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
>>   }
>>   
>> +static inline bool xfs_sb_version_hasparent(struct xfs_sb *sbp)
>> +{
>> +	return false; /* We'll enable this at the end of the set */
>> +}
>> +
>>   /*
>>    * end of superblock version macros
>>    */
>> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
>> index 6bd916b..54399e2 100644
>> --- a/fs/xfs/libxfs/xfs_trans_resv.c
>> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
>> @@ -802,29 +802,30 @@ xfs_calc_sb_reservation(
>>   	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
>>   }
>>   
>> +/*
>> + * Namespace reservations.
>> + *
>> + * These get tricky when parent pointers are enabled as we have attribute
>> + * modifications occurring from within these transactions. Rather than confuse
>> + * each of these reservation calculations with the conditional attribute
>> + * reservations, add them here in a clear and concise manner. This assumes that
>> + * the attribute reservations have already been calculated.
>> + *
>> + * Note that we only include the static attribute reservation here; the runtime
>> + * reservation will have to be modified by the size of the attributes being
>> + * added/removed/modified. See the comments on the attribute reservation
>> + * calculations for more details.
>> + *
>> + * Note for rename: rename will vastly overestimate requirements. This will be
>> + * addressed later when modifications are made to ensure parent attribute
>> + * modifications can be done atomically with the rename operation.
>> + */
>>   void
>> -xfs_trans_resv_calc(
>> +xfs_calc_namespace_reservations(
>>   	struct xfs_mount	*mp,
>>   	struct xfs_trans_resv	*resp)
>>   {
>> -	/*
>> -	 * The following transactions are logged in physical format and
>> -	 * require a permanent reservation on space.
>> -	 */
>> -	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp);
>> -	if (xfs_sb_version_hasreflink(&mp->m_sb))
>> -		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
>> -	else
>> -		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
>> -	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>> -
>> -	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp);
>> -	if (xfs_sb_version_hasreflink(&mp->m_sb))
>> -		resp->tr_itruncate.tr_logcount =
>> -				XFS_ITRUNCATE_LOG_COUNT_REFLINK;
>> -	else
>> -		resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
>> -	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>> +	ASSERT(resp->tr_attrsetm.tr_logres > 0);
>>   
>>   	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
>>   	resp->tr_rename.tr_logcount = XFS_RENAME_LOG_COUNT;
>> @@ -846,15 +847,69 @@ xfs_trans_resv_calc(
>>   	resp->tr_create.tr_logcount = XFS_CREATE_LOG_COUNT;
>>   	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>>   
>> +	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
>> +	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
>> +	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>> +
>> +	if (!xfs_sb_version_hasparent(&mp->m_sb))
>> +		return;
>> +
>> +	/* rename can add/remove/modify 2 parent attributes */
>> +	resp->tr_rename.tr_logres += 2 * max(resp->tr_attrsetm.tr_logres,
>> +					     resp->tr_attrrm.tr_logres);
>> +	resp->tr_rename.tr_logcount += 2 * max(resp->tr_attrsetm.tr_logcount,
>> +					       resp->tr_attrrm.tr_logcount);
>> +
>> +	/* create will add 1 parent attribute */
>> +	resp->tr_create.tr_logres += resp->tr_attrsetm.tr_logres;
>> +	resp->tr_create.tr_logcount += resp->tr_attrsetm.tr_logcount;
>> +
>> +	/* mkdir will add 1 parent attribute */
>> +	resp->tr_mkdir.tr_logres += resp->tr_attrsetm.tr_logres;
>> +	resp->tr_mkdir.tr_logcount += resp->tr_attrsetm.tr_logcount;
>> +
>> +	/* link will add 1 parent attribute */
>> +	resp->tr_link.tr_logres += resp->tr_attrsetm.tr_logres;
>> +	resp->tr_link.tr_logcount += resp->tr_attrsetm.tr_logcount;
>> +
>> +	/* symlink will add 1 parent attribute */
>> +	resp->tr_symlink.tr_logres += resp->tr_attrsetm.tr_logres;
>> +	resp->tr_symlink.tr_logcount += resp->tr_attrsetm.tr_logcount;
>> +
>> +	/* remove will remove 1 parent attribute */
>> +	resp->tr_remove.tr_logres += resp->tr_attrrm.tr_logres;
>> +	resp->tr_remove.tr_logcount = resp->tr_attrrm.tr_logcount;
> djwong, clearly reviewing patches in reverse order:
>
> This looks pretty similar to the function in the next patch; can they
> be combined into a single helper?
I think so, I'll see if I can get it consolidated
>> +}
>> +
>> +void
>> +xfs_trans_resv_calc(
>> +	struct xfs_mount	*mp,
>> +	struct xfs_trans_resv	*resp)
>> +{
>> +	/*
>> +	 * The following transactions are logged in physical format and
>> +	 * require a permanent reservation on space.
>> +	 */
>> +	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp);
>> +	if (xfs_sb_version_hasreflink(&mp->m_sb))
>> +		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
>> +	else
>> +		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
>> +	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>> +
>> +	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp);
>> +	if (xfs_sb_version_hasreflink(&mp->m_sb))
>> +		resp->tr_itruncate.tr_logcount =
>> +				XFS_ITRUNCATE_LOG_COUNT_REFLINK;
>> +	else
>> +		resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
>> +	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>> +
>>   	resp->tr_create_tmpfile.tr_logres =
>>   			xfs_calc_create_tmpfile_reservation(mp);
>>   	resp->tr_create_tmpfile.tr_logcount = XFS_CREATE_TMPFILE_LOG_COUNT;
>>   	resp->tr_create_tmpfile.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>>   
>> -	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
>> -	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
>> -	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>> -
>>   	resp->tr_ifree.tr_logres = xfs_calc_ifree_reservation(mp);
>>   	resp->tr_ifree.tr_logcount = XFS_INACTIVE_LOG_COUNT;
>>   	resp->tr_ifree.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>> @@ -886,6 +941,8 @@ xfs_trans_resv_calc(
>>   		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
>>   	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>>   
>> +	xfs_calc_namespace_reservations(mp, resp);
>> +
>>   	/*
>>   	 * The following transactions are logged in logical format with
>>   	 * a default log count.
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message tomajordomo@vger.kernel.org
>> More majordomo info athttp://vger.kernel.org/majordomo-info.html

