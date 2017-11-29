Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39445 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751709AbdK2Sr3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Nov 2017 13:47:29 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vATIlTmV025407
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 18:47:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vATIlSbE028064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 18:47:29 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vATIlSTj029053
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 18:47:28 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH v3 11/17] Add the extra space requirements for parent
 pointer attributes when calculating the minimum log size during mkfs
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
 <1510942905-12897-12-git-send-email-allison.henderson@oracle.com>
 <20171128185152.GN21412@magnolia>
Message-ID: <0dcd4f0c-bd35-58fa-a924-32c2a356942d@oracle.com>
Date: Wed, 29 Nov 2017 11:47:27 -0700
MIME-Version: 1.0
In-Reply-To: <20171128185152.GN21412@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 11/28/2017 11:51 AM, Darrick J. Wong wrote:

> On Fri, Nov 17, 2017 at 11:21:39AM -0700, Allison Henderson wrote:
>> Signed-off-by: Allison Henderson<allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_log_rlimit.c | 34 ++++++++++++++++++++++++++++++++++
>>   1 file changed, 34 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
>> index c105979..beec9bf 100644
>> --- a/fs/xfs/libxfs/xfs_log_rlimit.c
>> +++ b/fs/xfs/libxfs/xfs_log_rlimit.c
>> @@ -39,6 +39,40 @@ xfs_log_calc_max_attrsetm_res(
>>   {
>>   	int			size;
>>   	int			nblks;
>> +	struct xfs_trans_resv   *resp = M_RES(mp);
>> +
>> +	/* Calculate extra space needed for parent pointer attributes */
>> +	if (!xfs_sb_version_hasparent(&mp->m_sb)) {
> if (xfs_sb_version_hasparent()) ?
>
> --D
yeah I think you're right.   This means there's something wrong with the 
check then, because it appears to succeed.  I will debug that, it's 
probably the command line flag i added to mkfs.xfs to exercise it.
>> +
>> +		/* rename can add/remove/modify 2 parent attributes */
>> +		resp->tr_rename.tr_logres +=
>> +			2 * max(resp->tr_attrsetm.tr_logres,
>> +				resp->tr_attrrm.tr_logres);
>> +		resp->tr_rename.tr_logcount +=
>> +			2 * max(resp->tr_attrsetm.tr_logcount,
>> +				resp->tr_attrrm.tr_logcount);
>> +
>> +		/* create will add 1 parent attribute */
>> +		resp->tr_create.tr_logres += resp->tr_attrsetm.tr_logres;
>> +		resp->tr_create.tr_logcount += resp->tr_attrsetm.tr_logcount;
>> +
>> +		/* mkdir will add 1 parent attribute */
>> +		resp->tr_mkdir.tr_logres += resp->tr_attrsetm.tr_logres;
>> +		resp->tr_mkdir.tr_logcount += resp->tr_attrsetm.tr_logcount;
>> +
>> +		/* link will add 1 parent attribute */
>> +		resp->tr_link.tr_logres += resp->tr_attrsetm.tr_logres;
>> +		resp->tr_link.tr_logcount += resp->tr_attrsetm.tr_logcount;
>> +
>> +		/* symlink will add 1 parent attribute */
>> +		resp->tr_symlink.tr_logres += resp->tr_attrsetm.tr_logres;
>> +		resp->tr_symlink.tr_logcount += resp->tr_attrsetm.tr_logcount;
>> +
>> +		/* remove will remove 1 parent attribute */
>> +		resp->tr_remove.tr_logres += resp->tr_attrrm.tr_logres;
>> +		resp->tr_remove.tr_logcount = resp->tr_attrrm.tr_logcount;
>> +	}
>> +
>>   
>>   	size = xfs_attr_leaf_entsize_local_max(mp->m_attr_geo->blksize) -
>>   	       MAXNAMELEN - 1;
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message tomajordomo@vger.kernel.org
>> More majordomo info athttp://vger.kernel.org/majordomo-info.html

