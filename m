Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40265 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751851AbdK2Ssy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Nov 2017 13:48:54 -0500
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH v3 08/17] xfs: add parent pointer support to attribute
 code
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
 <1510942905-12897-9-git-send-email-allison.henderson@oracle.com>
 <20171128190146.GR21412@magnolia>
Message-ID: <86d16ea3-871b-5c2b-52bd-d2311e7a50c3@oracle.com>
Date: Wed, 29 Nov 2017 11:48:47 -0700
MIME-Version: 1.0
In-Reply-To: <20171128190146.GR21412@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Mark Tinguely <tinguely@sgi.com>, Dave Chinner <dchinner@redhat.com>

On 11/28/2017 12:01 PM, Darrick J. Wong wrote:

> On Fri, Nov 17, 2017 at 11:21:36AM -0700, Allison Henderson wrote:
>> From: Mark Tinguely<tinguely@sgi.com>
>>
>> Add the new parent attribute type. XFS_ATTR_PARENT is used only for
>> parent pointer entries; it uses reserved blocks like XFS_ATTR_ROOT.
>>
>> [dchinner: forward ported and cleaned up]
>> [achender: rebased]
>>
>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
>> Signed-off-by: Allison Henderson<allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c      |  2 +-
>>   fs/xfs/libxfs/xfs_da_format.h | 12 ++++++++----
>>   fs/xfs/xfs_attr.h             |  2 ++
>>   3 files changed, 11 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 61e8343..9d4d883 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -408,7 +408,7 @@ xfs_attr_set(
>>   	struct xfs_da_args	args;
>>   	struct xfs_defer_ops	dfops;
>>   	xfs_fsblock_t		firstblock;
>> -	int			rsvd = (flags & ATTR_ROOT) != 0;
>> +	bool			rsvd = (flags & (ATTR_ROOT | ATTR_PARENT)) != 0;
>>   	int			error, local;
>>   
>>   	XFS_STATS_INC(mp, xs_attr_set);
>> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
>> index 3771edc..5f94c84 100644
>> --- a/fs/xfs/libxfs/xfs_da_format.h
>> +++ b/fs/xfs/libxfs/xfs_da_format.h
>> @@ -758,24 +758,28 @@ struct xfs_attr3_icleaf_hdr {
>>   #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
>>   #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
>>   #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
>> +#define XFS_ATTR_PARENT_BIT	3	/* parent pointer secure attrs */
> Please fix the indenting to be consistent with the previous line.
>
> Also, I think you can drop the word 'secure' from the comment.
>
> --D
Sure, will do
>>   #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle of create/delete */
>>   #define XFS_ATTR_LOCAL		(1 << XFS_ATTR_LOCAL_BIT)
>>   #define XFS_ATTR_ROOT		(1 << XFS_ATTR_ROOT_BIT)
>>   #define XFS_ATTR_SECURE		(1 << XFS_ATTR_SECURE_BIT)
>> +#define XFS_ATTR_PARENT		(1 << XFS_ATTR_PARENT_BIT)
>>   #define XFS_ATTR_INCOMPLETE	(1 << XFS_ATTR_INCOMPLETE_BIT)
>>   
>>   /*
>>    * Conversion macros for converting namespace bits from argument flags
>>    * to ondisk flags.
>>    */
>> -#define XFS_ATTR_NSP_ARGS_MASK		(ATTR_ROOT | ATTR_SECURE)
>> -#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
>> +#define XFS_ATTR_NSP_ARGS_MASK		(ATTR_ROOT | ATTR_SECURE | XFS_ATTR_PARENT)
>> +#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE | XFS_ATTR_PARENT)
>>   #define XFS_ATTR_NSP_ONDISK(flags)	((flags) & XFS_ATTR_NSP_ONDISK_MASK)
>>   #define XFS_ATTR_NSP_ARGS(flags)	((flags) & XFS_ATTR_NSP_ARGS_MASK)
>>   #define XFS_ATTR_NSP_ARGS_TO_ONDISK(x)	(((x) & ATTR_ROOT ? XFS_ATTR_ROOT : 0) |\
>> -					 ((x) & ATTR_SECURE ? XFS_ATTR_SECURE : 0))
>> +					 ((x) & ATTR_SECURE ? XFS_ATTR_SECURE : 0) | \
>> +					 ((x) & ATTR_PARENT ? XFS_ATTR_PARENT : 0))
>>   #define XFS_ATTR_NSP_ONDISK_TO_ARGS(x)	(((x) & XFS_ATTR_ROOT ? ATTR_ROOT : 0) |\
>> -					 ((x) & XFS_ATTR_SECURE ? ATTR_SECURE : 0))
>> +					 ((x) & XFS_ATTR_SECURE ? ATTR_SECURE : 0) | \
>> +					 ((x) & XFS_ATTR_PARENT ? ATTR_PARENT : 0))
>>   
>>   /*
>>    * Alignment for namelist and valuelist entries (since they are mixed
>> diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
>> index 10fc466..1f5c711 100644
>> --- a/fs/xfs/xfs_attr.h
>> +++ b/fs/xfs/xfs_attr.h
>> @@ -46,6 +46,7 @@ struct xfs_attr_list_context;
>>   #define ATTR_SECURE	0x0008	/* use attrs in security namespace */
>>   #define ATTR_CREATE	0x0010	/* pure create: fail if attr already exists */
>>   #define ATTR_REPLACE	0x0020	/* pure set: fail if attr does not exist */
>> +#define ATTR_PARENT	0x0040	/*  use attrs in parent namespace */
>>   
>>   #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
>>   #define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
>> @@ -57,6 +58,7 @@ struct xfs_attr_list_context;
>>   	{ ATTR_SECURE,		"SECURE" }, \
>>   	{ ATTR_CREATE,		"CREATE" }, \
>>   	{ ATTR_REPLACE,		"REPLACE" }, \
>> +	{ ATTR_PARENT,		"PARENT" }, \
>>   	{ ATTR_KERNOTIME,	"KERNOTIME" }, \
>>   	{ ATTR_KERNOVAL,	"KERNOVAL" }
>>   
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message tomajordomo@vger.kernel.org
>> More majordomo info athttps://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=cw4rl4ETYQ8y0D8yfJB2arjNQvUaE97_EYK7UNsCxbg&s=vn0vqNAj9GZS70-TE3qqHTrOdb_AKX0RTwcKODDodzQ&e=
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message tomajordomo@vger.kernel.org
> More majordomo info athttps://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=cw4rl4ETYQ8y0D8yfJB2arjNQvUaE97_EYK7UNsCxbg&s=vn0vqNAj9GZS70-TE3qqHTrOdb_AKX0RTwcKODDodzQ&e=

