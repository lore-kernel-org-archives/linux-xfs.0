Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58084 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751210AbeEHTCc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 15:02:32 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w48J0gr5071123
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 19:02:32 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2hs24sj8dv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 19:02:31 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w48J2U1p012316
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 19:02:31 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w48J2UkV001543
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 19:02:30 GMT
Subject: Re: [PATCH 18/21] xfsprogs: Add parent pointer flag to cmd
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
 <1525754479-12177-19-git-send-email-allison.henderson@oracle.com>
 <20180508172521.GR11261@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <b43b6e95-ac94-d0f0-93cf-0eae3e46656e@oracle.com>
Date: Tue, 8 May 2018 12:02:29 -0700
MIME-Version: 1.0
In-Reply-To: <20180508172521.GR11261@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 05/08/2018 10:25 AM, Darrick J. Wong wrote:
> On Mon, May 07, 2018 at 09:41:16PM -0700, Allison Henderson wrote:
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Needs commit message:
>
> mkfs: enable formatting with parent pointers
>
> Wire up parent pointer support in mkfs via the '-m parent' parameter.
>
> Signed-off-by: <etc>
Ok, will update
>> ---
>>   mkfs/xfs_mkfs.c | 16 +++++++++++++++-
>>   1 file changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index 78d0ce5..554e1bf 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -129,6 +129,7 @@ enum {
>>   	M_UUID,
>>   	M_RMAPBT,
>>   	M_REFLINK,
>> +	M_PARENT,
> Hmm, is this better off in the naming section?
>
> e.g. "mkfs.xfs -n parent=1"
I suppose it could fit there too if that's preferred.  I wasnt really 
sure which section it fit best to :-)
>>   	M_MAX_OPTS,
>>   };
>>   
>> @@ -663,6 +664,7 @@ struct opt_params mopts = {
>>   		[M_UUID] = "uuid",
>>   		[M_RMAPBT] = "rmapbt",
>>   		[M_REFLINK] = "reflink",
>> +		[M_PARENT] = "parent",
>>   	},
>>   	.subopt_params = {
>>   		{ .index = M_CRC,
>> @@ -693,6 +695,13 @@ struct opt_params mopts = {
>>   		  .maxval = 1,
>>   		  .defaultval = 1,
>>   		},
>> +		{ .index = M_PARENT,
>> +		  .conflicts = { {NULL, LAST_CONFLICT } },
>> +		  .minval = 0,
>> +		  .maxval = 1,
>> +		  .defaultval = 0,
> This (misleadingly named) field is the default value if you pass the
> argument without explicitly assigning a value, i.e.
>
> # mkfs.xfs -m parent /dev/sda
>
> sets parent to whatever defaultval is.  In this case you'd get no parent
> pointers, which is a little surprising.
>
> And, uh, seeing as people keep getting this wrong maybe we should rename
> it?
Oh I see.  That is a little odd, is there really a better name though?  
Maybe just a comment or something might make it more clear.
>> +		},
>> +
>>   	},
>>   };
>>   
>> @@ -865,7 +874,7 @@ usage( void )
>>   {
>>   	fprintf(stderr, _("Usage: %s\n\
>>   /* blocksize */		[-b size=num]\n\
>> -/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1]\n\
>> +/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,parent=0|1]\n\
>>   /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
>>   			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
>>   			    sectsize=num\n\
>> @@ -1586,6 +1595,9 @@ meta_opts_parser(
>>   	case M_REFLINK:
>>   		cli->sb_feat.reflink = getnum(value, opts, subopt);
>>   		break;
>> +	case M_PARENT:
>> +		cli->sb_feat.parent_pointers = getnum(value, &mopts, M_PARENT);
>> +		break;
>>   	default:
>>   		return -EINVAL;
>>   	}
>> @@ -2887,6 +2899,8 @@ sb_set_features(
>>   		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
>>   	if (fp->reflink)
>>   		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
>> +	if (fp->parent_pointers)
>> +		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_PARENT;
> Otherwise looks ok to me....
>
> --D
Alrighty, thx!
>>   
>>   	/*
>>   	 * Sparse inode chunk support has two main inode alignment requirements.
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=2DFx03tmCKRPVndQLwf1P1u0PChkNowVFyXqzZ_arE8&s=JiwNEPlNO54aLxRtPd9mGL_lKU8dpX4T6ECMmDQhc70&e=
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=2DFx03tmCKRPVndQLwf1P1u0PChkNowVFyXqzZ_arE8&s=JiwNEPlNO54aLxRtPd9mGL_lKU8dpX4T6ECMmDQhc70&e=

