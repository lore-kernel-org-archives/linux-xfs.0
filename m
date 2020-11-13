Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72BAFC2D0E4
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 01:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F18A21D7F
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 01:27:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hmkUXxmp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgKMB1X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Nov 2020 20:27:23 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:39840 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgKMB1X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Nov 2020 20:27:23 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AD1O1Bp177570
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:27:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4UAj4zvRBfIgVJRPs5QcW7Vp1CHDlGFu+oeOmsP7kHs=;
 b=hmkUXxmpMq0h2bmIPzDk4B+f/51WlhrpEM4Y05P04lDvz94OB0/voS7qntpiCe7RApXT
 PkTmkP8h9qEUeJ53PSPIR45J9RJpEyzS3QRFeATEWwc3HMSUFEnTVGaf5xsi+W4KnJXo
 DQV72fLjdkVko9In/VhkyxR4qbqEpn5t6QnbqcMMZtgZs29C7fv2gBqniU60DxB7WExi
 kVxdxQn7rAVKklGhr8AjceBib+dV4aQi/16nkz3167j8I2OWmWkHypwWp4LK5PKO0AJg
 W/kT0WmRH2r+btvwRZKWq4NJnnTw0sP4zMM7skILqlSMsiCdRKeaRMJ88rIxZjEDCT2r qA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34nh3b8mp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:27:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AD1PGTl057921
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:27:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34rt570c2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:27:21 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AD1RKCY010495
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:27:20 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 17:27:19 -0800
Subject: Re: [PATCH v13 07/10] xfs: Add feature bit
 XFS_SB_FEAT_INCOMPAT_LOG_DELATTR
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201023063435.7510-1-allison.henderson@oracle.com>
 <20201023063435.7510-8-allison.henderson@oracle.com>
 <20201110201002.GE9695@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <ad2c0aae-a7de-f230-a022-cb7a46aee35d@oracle.com>
Date:   Thu, 12 Nov 2020 18:27:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201110201002.GE9695@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130005
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/10/20 1:10 PM, Darrick J. Wong wrote:
> On Thu, Oct 22, 2020 at 11:34:32PM -0700, Allison Henderson wrote:
>> This patch adds a new feature bit XFS_SB_FEAT_INCOMPAT_LOG_DELATTR which
>> can be used to control turning on/off delayed attributes
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_format.h | 8 ++++++--
>>   fs/xfs/libxfs/xfs_fs.h     | 1 +
>>   fs/xfs/libxfs/xfs_sb.c     | 2 ++
>>   fs/xfs/xfs_super.c         | 3 +++
>>   4 files changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index d419c34..18b41a7 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -483,7 +483,9 @@ xfs_sb_has_incompat_feature(
>>   	return (sbp->sb_features_incompat & feature) != 0;
>>   }
>>   
>> -#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
>> +#define XFS_SB_FEAT_INCOMPAT_LOG_DELATTR   (1 << 0)	/* Delayed Attributes */
>> +#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
>> +	(XFS_SB_FEAT_INCOMPAT_LOG_DELATTR)
>>   #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
>>   static inline bool
>>   xfs_sb_has_incompat_log_feature(
>> @@ -586,7 +588,9 @@ static inline bool xfs_sb_version_hasinobtcounts(struct xfs_sb *sbp)
>>   
>>   static inline bool xfs_sb_version_hasdelattr(struct xfs_sb *sbp)
>>   {
>> -	return false;
>> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
>> +		(sbp->sb_features_log_incompat &
>> +		XFS_SB_FEAT_INCOMPAT_LOG_DELATTR));
> 
> This change and the EXPERIMENTAL warning should go in whichever patch
> defines xfs_sb_version_hasdelattr.

Sure, will move this to patch 5

> 
>>   }
>>   
>>   /*
>> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
>> index 2a2e3cf..f703d95 100644
>> --- a/fs/xfs/libxfs/xfs_fs.h
>> +++ b/fs/xfs/libxfs/xfs_fs.h
>> @@ -250,6 +250,7 @@ typedef struct xfs_fsop_resblks {
>>   #define XFS_FSOP_GEOM_FLAGS_RMAPBT	(1 << 19) /* reverse mapping btree */
>>   #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
>>   #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
>> +#define XFS_FSOP_GEOM_FLAGS_DELATTR	(1 << 22) /* delayed attributes	    */
>>   
>>   /*
>>    * Minimum and maximum sizes need for growth checks.
>> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
>> index 5aeafa5..a0ec327 100644
>> --- a/fs/xfs/libxfs/xfs_sb.c
>> +++ b/fs/xfs/libxfs/xfs_sb.c
>> @@ -1168,6 +1168,8 @@ xfs_fs_geometry(
>>   		geo->flags |= XFS_FSOP_GEOM_FLAGS_REFLINK;
>>   	if (xfs_sb_version_hasbigtime(sbp))
>>   		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
>> +	if (xfs_sb_version_hasdelattr(sbp))
>> +		geo->flags |= XFS_FSOP_GEOM_FLAGS_DELATTR;
> 
> These changes to the geometry ioctl should be a separate patch.
> 
> IOWs, the only change in this patch should be adding
> XFS_SB_FEAT_INCOMPAT_LOG_DELATTR to the _ALL #define.
Ok, will break out.

Allison

> 
> --D
> 
>>   	if (xfs_sb_version_hassector(sbp))
>>   		geo->logsectsize = sbp->sb_logsectsize;
>>   	else
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index d1b5f2d..bb85884 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -1580,6 +1580,9 @@ xfs_fc_fill_super(
>>   	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
>>   		xfs_warn(mp,
>>    "EXPERIMENTAL inode btree counters feature in use. Use at your own risk!");
>> +	if (xfs_sb_version_hasdelattr(&mp->m_sb))
>> +		xfs_alert(mp,
>> +	"EXPERIMENTAL delayed attrs feature enabled. Use at your own risk!");
>>   
>>   	error = xfs_mountfs(mp);
>>   	if (error)
>> -- 
>> 2.7.4
>>
