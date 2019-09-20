Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE58C3A5A2
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 22:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1207B2173E
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 22:49:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BoiWwF1d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387917AbfITWtR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Sep 2019 18:49:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38116 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387598AbfITWtR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Sep 2019 18:49:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8KMn0wm064366;
        Fri, 20 Sep 2019 22:49:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=bXyPnxvnu9F2FgKAL40K7AB0rVpcwOhXvZivBNXx1qc=;
 b=BoiWwF1dATpaZLp+dh+gmdjXnq7EJ/UwOw8FCdqDhRBCiJck1WnNi2wY8e1BGmWPXckM
 3in+14TPBNZq9WVaQkJNjoY5Xi9YbkL/IZBMfZISB5dTjyB4gPMrRqUTR5EFMsjDaL5i
 Fj8hnakFFTccu9Pex2hHEPQirhHT7aWdL/WJWHmV90+uTk5scilEP7tR815liSPrkQyr
 th4JalmC3wh3KIr8hI3uLm0CzSXW12VU0sNX3wlwPbHH3ZOuZw+9NJ9680YsZXLRoKET
 AhEjLRSWSywvHnqEF2xKUNID/N6GgpwtvlyEqk3+TDpnNqKLwzCaWA4lDdQJno1hHpaS Jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2v3vb551s7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 22:49:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8KMn0J6009698;
        Fri, 20 Sep 2019 22:49:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2v51vr06d0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 22:48:59 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8KMmicx012268;
        Fri, 20 Sep 2019 22:48:44 GMT
Received: from [192.168.1.9] (/67.1.21.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 20 Sep 2019 15:48:43 -0700
Subject: Re: [PATCH v3 13/19] xfs: Add delay context to xfs_da_args
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190905221837.17388-1-allison.henderson@oracle.com>
 <20190905221837.17388-14-allison.henderson@oracle.com>
 <20190920135142.GK40150@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <87d44729-b77e-4ab2-ddb9-c9804bea7bf4@oracle.com>
Date:   Fri, 20 Sep 2019 15:48:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920135142.GK40150@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909200189
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909200189
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/20/19 6:51 AM, Brian Foster wrote:
> On Thu, Sep 05, 2019 at 03:18:31PM -0700, Allison Collins wrote:
>> This patch adds a new struct xfs_delay_context, which we
>> will use to keep track of the current state of a delayed
>> attribute operation.
>>
>> The flags member is used to track various operations that
>> are in progress so that we know not to repeat them, and
>> resume where we left off before EAGAIN was returned to
>> cycle out the transaction.  Other members take the place
>> of local variables that need to retain their values
>> across multiple function recalls.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
> 
> Ok, I'll have to get further along in the usage of these bits to fully
> grok this one. One quick note in the meantime...
Ok, yeah a lot of whats in here is dependent on what we decide in the 
next patch, but I will take a look through the pahole output.  Thanks!

Allison

> 
>>   fs/xfs/libxfs/xfs_da_btree.h | 23 +++++++++++++++++++++++
>>   fs/xfs/scrub/common.c        |  2 ++
>>   fs/xfs/xfs_acl.c             |  2 ++
>>   fs/xfs/xfs_attr_list.c       |  1 +
>>   fs/xfs/xfs_ioctl.c           |  2 ++
>>   fs/xfs/xfs_ioctl32.c         |  2 ++
>>   fs/xfs/xfs_iops.c            |  2 ++
>>   fs/xfs/xfs_xattr.c           |  1 +
>>   8 files changed, 35 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
>> index bed4f40..ebe1295 100644
>> --- a/fs/xfs/libxfs/xfs_da_btree.h
>> +++ b/fs/xfs/libxfs/xfs_da_btree.h
>> @@ -42,6 +42,28 @@ enum xfs_dacmp {
>>   	XFS_CMP_CASE		/* names are same but differ in case */
>>   };
>>   
>> +#define		XFS_DC_INIT		0x01 /* Init delay info */
>> +#define		XFS_DC_FOUND_LBLK	0x02 /* We found leaf blk for attr */
>> +#define		XFS_DC_FOUND_NBLK	0x04 /* We found node blk for attr */
>> +#define		XFS_DC_ALLOC_LEAF	0x08 /* We are allocating leaf blocks */
>> +#define		XFS_DC_ALLOC_NODE	0x10 /* We are allocating node blocks */
>> +#define		XFS_DC_RM_LEAF_BLKS	0x20 /* We are removing leaf blocks */
>> +#define		XFS_DC_RM_NODE_BLKS	0x40 /* We are removing node blocks */
>> +
>> +/*
>> + * Context used for keeping track of delayed attribute operations
>> + */
>> +struct xfs_delay_context {
>> +	unsigned int		flags;
>> +	struct xfs_buf		*leaf_bp;
>> +	struct xfs_bmbt_irec	map;
>> +	xfs_dablk_t		lblkno;
>> +	xfs_fileoff_t		lfileoff;
>> +	int			blkcnt;
>> +	struct xfs_da_state	*state;
>> +	struct xfs_da_state_blk *blk;
>> +};
>> +
> 
> The mixed size of the various fields leaves some holes in the structure.
> See 'pahole xfs.ko' output for how this struct could be reordered to
> reduce the overall size a bit..
> 
> Brian
> 
>>   /*
>>    * Structure to ease passing around component names.
>>    */
>> @@ -69,6 +91,7 @@ typedef struct xfs_da_args {
>>   	int		rmtvaluelen2;	/* remote attr value length in bytes */
>>   	int		op_flags;	/* operation flags */
>>   	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
>> +	struct xfs_delay_context  dc;	/* context used for delay attr ops */
>>   } xfs_da_args_t;
>>   
>>   /*
>> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
>> index 1887605..9a649d1 100644
>> --- a/fs/xfs/scrub/common.c
>> +++ b/fs/xfs/scrub/common.c
>> @@ -24,6 +24,8 @@
>>   #include "xfs_rmap_btree.h"
>>   #include "xfs_log.h"
>>   #include "xfs_trans_priv.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_reflink.h"
>>   #include "scrub/scrub.h"
>> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
>> index f8fb6e10..4e85b38 100644
>> --- a/fs/xfs/xfs_acl.c
>> +++ b/fs/xfs/xfs_acl.c
>> @@ -10,6 +10,8 @@
>>   #include "xfs_trans_resv.h"
>>   #include "xfs_mount.h"
>>   #include "xfs_inode.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_trace.h"
>>   #include <linux/posix_acl_xattr.h>
>> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
>> index 00758fd..467c53c 100644
>> --- a/fs/xfs/xfs_attr_list.c
>> +++ b/fs/xfs/xfs_attr_list.c
>> @@ -12,6 +12,7 @@
>>   #include "xfs_trans_resv.h"
>>   #include "xfs_mount.h"
>>   #include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_inode.h"
>>   #include "xfs_trans.h"
>>   #include "xfs_bmap.h"
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index 626420d..2cabdc2 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -15,6 +15,8 @@
>>   #include "xfs_iwalk.h"
>>   #include "xfs_itable.h"
>>   #include "xfs_error.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_bmap.h"
>>   #include "xfs_bmap_util.h"
>> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
>> index 1e08bf7..7153780 100644
>> --- a/fs/xfs/xfs_ioctl32.c
>> +++ b/fs/xfs/xfs_ioctl32.c
>> @@ -17,6 +17,8 @@
>>   #include "xfs_itable.h"
>>   #include "xfs_fsops.h"
>>   #include "xfs_rtalloc.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_ioctl.h"
>>   #include "xfs_ioctl32.h"
>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>> index 469e8e2..57de5f1 100644
>> --- a/fs/xfs/xfs_iops.c
>> +++ b/fs/xfs/xfs_iops.c
>> @@ -13,6 +13,8 @@
>>   #include "xfs_inode.h"
>>   #include "xfs_acl.h"
>>   #include "xfs_quota.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_trans.h"
>>   #include "xfs_trace.h"
>> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
>> index 6309da4..470e605 100644
>> --- a/fs/xfs/xfs_xattr.c
>> +++ b/fs/xfs/xfs_xattr.c
>> @@ -10,6 +10,7 @@
>>   #include "xfs_log_format.h"
>>   #include "xfs_da_format.h"
>>   #include "xfs_inode.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   
>>   #include <linux/posix_acl_xattr.h>
>> -- 
>> 2.7.4
>>
