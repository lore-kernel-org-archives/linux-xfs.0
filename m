Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A96C43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 23:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A95A721655
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 23:42:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IEidRSX4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfKKXmi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Nov 2019 18:42:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37998 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbfKKXmh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Nov 2019 18:42:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABNdDIO123341;
        Mon, 11 Nov 2019 23:42:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=x7EU9c/oK0YYwgffaFcJDGXC18Rmzpsqbyk1P46OER4=;
 b=IEidRSX4DpGDDec5N+LsrkgPifsYTrxq39xM7rRI0+l8LlsQWzsj2Gow3o/dQWMaReu9
 OCYVuI4RrAH86zTvAwYWgG6BfZQ6bwu+sdAz0CaEuALmd3P9xX9bVJBARW9RDdAIkm1p
 xRuXmXk+sdQz74//Q/yizuTQ02VTvgTGJnILhM22rtwX/RjC5M5hjeikfVIKgcJa6xFQ
 0h9p8qZbosJ9tXRnYa0yEs15il6NjVxdOgUr5wscKnb+DIJxLVC1hGh+gJ2FfIr+TAes
 Jbqij2FVbPTFB5i8JiU7lrgTKCgOuBVHU6SmledCoMOuRUXIKGvDfC4f8H4qE13RXGcY lQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w5ndq19kv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 23:42:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABNcfBu012337;
        Mon, 11 Nov 2019 23:42:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w67kmr64p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 23:42:32 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xABNgW3o023073;
        Mon, 11 Nov 2019 23:42:32 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 15:42:31 -0800
Subject: Re: [PATCH v4 14/17] xfs: Add delay context to xfs_da_args
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-15-allison.henderson@oracle.com>
 <20191111182326.GE46312@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <642e7268-472d-81ef-a78e-51aa5f53076f@oracle.com>
Date:   Mon, 11 Nov 2019 16:42:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191111182326.GE46312@bfoster>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110200
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110200
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/11/19 11:23 AM, Brian Foster wrote:
> On Wed, Nov 06, 2019 at 06:27:58PM -0700, Allison Collins wrote:
>> This patch adds a new struct xfs_delay_context, which we
>> will use to keep track of the current state of a delayed
>> attribute operation.
>>
> 
> Technically, this should track delayed or non-delayed attr operations,
> right? IIRC, the goal is that the difference between the two is that the
> former is driven by the dfops mechanism while the latter executes the
> same code with a higher level hack to roll transactions and loop through
> the state machine...
> 
> Brian

Yep, I will update the commit message.  Thanks!
Allison

> 
>> The new enum is used to track various operations that
>> are in progress so that we know not to repeat them, and
>> resume where we left off before EAGAIN was returned to
>> cycle out the transaction.  Other members take the place
>> of local variables that need to retain their values
>> across multiple function recalls.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_da_btree.h | 28 ++++++++++++++++++++++++++++
>>   fs/xfs/scrub/common.c        |  2 ++
>>   fs/xfs/xfs_acl.c             |  2 ++
>>   fs/xfs/xfs_attr_list.c       |  1 +
>>   fs/xfs/xfs_ioctl.c           |  2 ++
>>   fs/xfs/xfs_ioctl32.c         |  2 ++
>>   fs/xfs/xfs_iops.c            |  2 ++
>>   fs/xfs/xfs_xattr.c           |  1 +
>>   8 files changed, 40 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
>> index bed4f40..ef23ed8 100644
>> --- a/fs/xfs/libxfs/xfs_da_btree.h
>> +++ b/fs/xfs/libxfs/xfs_da_btree.h
>> @@ -42,6 +42,33 @@ enum xfs_dacmp {
>>   	XFS_CMP_CASE		/* names are same but differ in case */
>>   };
>>   
>> +enum xfs_attr_state {
>> +	XFS_DC_INIT		= 1, /* Init delay info */
>> +	XFS_DC_SF_TO_LEAF	= 2, /* Converted short form to leaf */
>> +	XFS_DC_FOUND_LBLK	= 3, /* We found leaf blk for attr */
>> +	XFS_DC_LEAF_TO_NODE	= 4, /* Converted leaf to node */
>> +	XFS_DC_FOUND_NBLK	= 5, /* We found node blk for attr */
>> +	XFS_DC_ALLOC_LEAF	= 6, /* We are allocating leaf blocks */
>> +	XFS_DC_ALLOC_NODE	= 7, /* We are allocating node blocks */
>> +	XFS_DC_RM_INVALIDATE	= 8, /* We are invalidating blocks */
>> +	XFS_DC_RM_SHRINK	= 9, /* We are shrinking the tree */
>> +	XFS_DC_RM_NODE_BLKS	= 10,/* We are removing node blocks */
>> +};
>> +
>> +/*
>> + * Context used for keeping track of delayed attribute operations
>> + */
>> +struct xfs_delay_context {
>> +	enum xfs_attr_state	dc_state;
>> +	struct xfs_buf		*leaf_bp;
>> +	struct xfs_bmbt_irec	map;
>> +	xfs_dablk_t		lblkno;
>> +	xfs_fileoff_t		lfileoff;
>> +	int			blkcnt;
>> +	struct xfs_da_state	*da_state;
>> +	struct xfs_da_state_blk *blk;
>> +};
>> +
>>   /*
>>    * Structure to ease passing around component names.
>>    */
>> @@ -69,6 +96,7 @@ typedef struct xfs_da_args {
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
>> index e868755..1336477 100644
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
>> index fab416c..e395864 100644
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
>> index ae0ed88..23b0ca6 100644
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
>> index 3c0d518..e3278ac 100644
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
>> index aef346e..68b9cd0 100644
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
>> index 6c5321d..0f0ebab 100644
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
> 
