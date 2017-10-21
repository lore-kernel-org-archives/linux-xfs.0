Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46764 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753166AbdJUBHR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 21:07:17 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9L17FwZ022434
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2017 01:07:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9L17FDe026840
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2017 01:07:15 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9L17Feq019726
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2017 01:07:15 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 11/17] Add the extra space requirements for parent pointer
 attributes when calculating the minimum log size during mkfs
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
 <1508367333-3237-12-git-send-email-allison.henderson@oracle.com>
 <20171019181303.GA4755@magnolia>
Message-ID: <3c19bbca-86dc-0836-32d0-95b720104dee@oracle.com>
Date: Fri, 20 Oct 2017 18:07:11 -0700
MIME-Version: 1.0
In-Reply-To: <20171019181303.GA4755@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: linux-xfs@vger.kernel.org

On 10/19/2017 11:13 AM, Darrick J. Wong wrote:

> On Wed, Oct 18, 2017 at 03:55:27PM -0700, Allison Henderson wrote:
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
> Aren't we supposed to be enlarging tr_log{res,count} if hasparent is true?
>
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
> += ?
>
> --D
I think you're right.  Initially I was having trouble getting it to 
mount because not enough log space was reserved during mkfs time, and I 
had borrowed this code from xfs_calc_namespace_reservations in the 
previous patch.  So we might need the same fix there too.  I will get it 
corrected.  Thx!


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

