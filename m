Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4CC1C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 21:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4875622D74
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jan 2021 21:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729647AbhAEVu2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jan 2021 16:50:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53594 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729629AbhAEVu2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jan 2021 16:50:28 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105Lnd4Q046683
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jan 2021 21:49:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=OE4Cwgdg0rp250fYHVCAfp/fpLnJIk0eCgRzz1ynHjk=;
 b=Fm89HlZjwuhrNpGXOWRjwY3R3V5JFOjeFCrXKN+BSiG5CpxeTxm2CPluND+yT29QVo9x
 bqHhen2oD3e10Ps9aGXYxJlNnmPuEQaVPK9myqQDI7qGMbvd4LoQQfO3IZyxZIWag0dr
 X+exAhrtShx5hZFVEW4nIZD6dxQ6YNdBWAKvT42oKiMrGEF347NpBlehbHl1aYMPAzYc
 oP9Wo6qiPUcAe21RUoqUKY0aIU/IJsYu/QgKUEaz+kPEeksvNnWNUct0k04fGv91Qh/7
 aUwME6pj3vMRVjwf8/lWCsU6YijnCZUQTaDUleKAIXdJnZUjpCz7GoVqlKPpU0SJVcFG 4w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 35tg8r2y14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jan 2021 21:49:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105LjQd2084241
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jan 2021 21:49:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 35vct6ega8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jan 2021 21:49:46 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 105Lnkeu026157
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jan 2021 21:49:46 GMT
Received: from [192.168.1.226] (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Jan 2021 21:49:46 +0000
Subject: Re: [PATCH v14 14/15] xfs: Add delattr mount option
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201218072917.16805-1-allison.henderson@oracle.com>
 <20201218072917.16805-15-allison.henderson@oracle.com>
 <20210105054626.GV6918@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <18c7472c-598a-624a-7043-0a79ab017919@oracle.com>
Date:   Tue, 5 Jan 2021 14:49:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210105054626.GV6918@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/4/21 10:46 PM, Darrick J. Wong wrote:
> On Fri, Dec 18, 2020 at 12:29:16AM -0700, Allison Henderson wrote:
>> This patch adds a mount option to enable delayed attributes. Eventually
>> this can be removed when delayed attrs becomes permanent.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.h | 2 +-
>>   fs/xfs/xfs_mount.h       | 1 +
>>   fs/xfs/xfs_super.c       | 6 +++++-
>>   fs/xfs/xfs_xattr.c       | 2 ++
>>   4 files changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 4838094..edd008d 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -30,7 +30,7 @@ struct xfs_attr_list_context;
>>   
>>   static inline bool xfs_hasdelattr(struct xfs_mount *mp)
> 
> /me had a brain fart just now that ... since struct xfs_delattr_context
> is ultimately going to be absorbed into struct xfs_attr_item, we really
> should have called the control knob part of this 'logattr' instead of
> 'delattr', because that's (IMIO) a better explanation of what the mount
> option actually does for users.
That's fine, honestly I figured I'd just throw some name out there just 
to get it working initially, and if someone wants a different name, 
they'd say so.  It is a temporary option after all.  :-)

> 
> An even better name would have been "logged attributes replayable"
> because then you could use the prefix XFS_LARP for things. :P
Yeah, I think the name scheme was something we mulled about a while ago, 
though didn't really have a solid opinion on yet.  But we did feel that 
DAS and DAC are sort of close to DA and DAX.

I am ok with LARP.  I'll probably end up mistakenly referring to it as a 
"Log Action Re-Play", but I'm fine with that.  :-)  Just as long as 
everyone else is. Names seem to be something that everyone is really 
opinionated on, and it peppers little changes all over the set, so it 
would be nice to have a semi solid consensus  :-)

Thanks for the reviews!

Allison

> 
> Comments? :)
> 
> --D
> 
> 
>>   {
>> -	return false;
>> +	return mp->m_flags & XFS_MOUNT_DELATTR;
>>   }
>>   
>>   /*
>> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
>> index dfa429b..4794f27 100644
>> --- a/fs/xfs/xfs_mount.h
>> +++ b/fs/xfs/xfs_mount.h
>> @@ -254,6 +254,7 @@ typedef struct xfs_mount {
>>   #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
>>   #define XFS_MOUNT_DAX_ALWAYS	(1ULL << 26)
>>   #define XFS_MOUNT_DAX_NEVER	(1ULL << 27)
>> +#define XFS_MOUNT_DELATTR	(1ULL << 28)	/* enable delayed attributes */
>>   
>>   /*
>>    * Max and min values for mount-option defined I/O
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index 813be87..72169ee 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -92,7 +92,7 @@ enum {
>>   	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
>>   	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
>>   	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
>> -	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum,
>> +	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_delattr
>>   };
>>   
>>   static const struct fs_parameter_spec xfs_fs_parameters[] = {
>> @@ -137,6 +137,7 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
>>   	fsparam_flag("nodiscard",	Opt_nodiscard),
>>   	fsparam_flag("dax",		Opt_dax),
>>   	fsparam_enum("dax",		Opt_dax_enum, dax_param_enums),
>> +	fsparam_flag("delattr",		Opt_delattr),
>>   	{}
>>   };
>>   
>> @@ -1292,6 +1293,9 @@ xfs_fs_parse_param(
>>   		xfs_mount_set_dax_mode(mp, result.uint_32);
>>   		return 0;
>>   #endif
>> +	case Opt_delattr:
>> +		mp->m_flags |= XFS_MOUNT_DELATTR;
>> +		return 0;
>>   	/* Following mount options will be removed in September 2025 */
>>   	case Opt_ikeep:
>>   		xfs_warn(mp, "%s mount option is deprecated.", param->key);
>> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
>> index 9b0c790..8ec61df 100644
>> --- a/fs/xfs/xfs_xattr.c
>> +++ b/fs/xfs/xfs_xattr.c
>> @@ -8,6 +8,8 @@
>>   #include "xfs_shared.h"
>>   #include "xfs_format.h"
>>   #include "xfs_log_format.h"
>> +#include "xfs_trans_resv.h"
>> +#include "xfs_mount.h"
>>   #include "xfs_da_format.h"
>>   #include "xfs_inode.h"
>>   #include "xfs_da_btree.h"
>> -- 
>> 2.7.4
>>
