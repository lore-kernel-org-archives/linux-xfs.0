Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60190 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751893AbeGFEGe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jul 2018 00:06:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6643rIC174082
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 04:06:34 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2k0dnjr3he-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 06 Jul 2018 04:06:34 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6646Xqi009842
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 04:06:33 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6646XEW012784
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 04:06:33 GMT
Subject: Re: [PATCH RFC 1/8] xfs: introduce inline data superblock feature bit
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
 <1530846750-6686-2-git-send-email-shan.hai@oracle.com>
 <20180706033416.GN32415@magnolia>
From: Shan Hai <shan.hai@oracle.com>
Message-ID: <ef36eaaa-5090-a6b2-2eba-5c684be3e62a@oracle.com>
Date: Fri, 6 Jul 2018 12:06:29 +0800
MIME-Version: 1.0
In-Reply-To: <20180706033416.GN32415@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 2018年07月06日 11:34, Darrick J. Wong wrote:
> On Fri, Jul 06, 2018 at 11:12:22AM +0800, Shan Hai wrote:
>> The data inlining is an on-disk format change, so introduce a new
>> superblock feature bit to work with the mkfs tool to handle the
>> inline data, the feature bit is set at mkfs time.
>>
>> Signed-off-by: Shan Hai <shan.hai@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_format.h | 10 +++++++++-
>>   fs/xfs/libxfs/xfs_fs.h     |  1 +
>>   fs/xfs/libxfs/xfs_sb.c     |  2 ++
>>   3 files changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index 059bc44c27e8..6066ba7fdaf7 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -469,10 +469,12 @@ xfs_sb_has_ro_compat_feature(
>>   #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
>>   #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
>>   #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
>> +#define XFS_SB_FEAT_INCOMPAT_INLINEDATA (1 << 3)	/* inline inode data */
>>   #define XFS_SB_FEAT_INCOMPAT_ALL \
>>   		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
>>   		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
>> -		 XFS_SB_FEAT_INCOMPAT_META_UUID)
>> +		 XFS_SB_FEAT_INCOMPAT_META_UUID|\
>> +		 XFS_SB_FEAT_INCOMPAT_INLINEDATA)
> Uh... don't go enabling this feature in the _ALL flags until you've
> finished putting all the code in...
>

Agreed, will fix it, thanks for the suggestion.

Thanks
Shan Hai
>>   
>>   #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
>>   static inline bool
>> @@ -550,6 +552,12 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
>>   		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
>>   }
>>   
>> +static inline bool xfs_sb_version_hasinlinedata(struct xfs_sb *sbp)
>> +{
>> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
>> +		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_INLINEDATA);
>> +}
>> +
>>   /*
>>    * end of superblock version macros
>>    */
>> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
>> index f3aa59302fef..ee1f7621c0e4 100644
>> --- a/fs/xfs/libxfs/xfs_fs.h
>> +++ b/fs/xfs/libxfs/xfs_fs.h
>> @@ -210,6 +210,7 @@ typedef struct xfs_fsop_resblks {
>>   #define XFS_FSOP_GEOM_FLAGS_SPINODES	0x40000	/* sparse inode chunks	*/
>>   #define XFS_FSOP_GEOM_FLAGS_RMAPBT	0x80000	/* reverse mapping btree */
>>   #define XFS_FSOP_GEOM_FLAGS_REFLINK	0x100000 /* files can share blocks */
>> +#define XFS_FSOP_GEOM_FLAGS_INLINEDATA	0x200000 /* inline data into inode */
>>   
>>   /*
>>    * Minimum and maximum sizes need for growth checks.
>> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
>> index 350119eeaecb..4002ed105b6b 100644
>> --- a/fs/xfs/libxfs/xfs_sb.c
>> +++ b/fs/xfs/libxfs/xfs_sb.c
>> @@ -1068,6 +1068,8 @@ xfs_fs_geometry(
>>   		geo->logsectsize = sbp->sb_logsectsize;
>>   	else
>>   		geo->logsectsize = BBSIZE;
>> +	if (xfs_sb_version_hasinlinedata(sbp))
>> +		geo->flags |= XFS_FSOP_GEOM_FLAGS_INLINEDATA;
>>   	geo->rtsectsize = sbp->sb_blocksize;
>>   	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
>>   
>> -- 
>> 2.11.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

