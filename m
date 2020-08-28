Return-Path: <SRS0=eyVf=CG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D386C433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 18:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0C652098B
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Aug 2020 18:00:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DHMASDiG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgH1SAZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Aug 2020 14:00:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43866 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgH1SAY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Aug 2020 14:00:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07SHuUUB041787
        for <linux-xfs@vger.kernel.org>; Fri, 28 Aug 2020 18:00:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=U31q0OB/q6CYq9GCAvuB1s5+k6JITJ4gizNnVbKxy2c=;
 b=DHMASDiGyUnDQM4nHPI0AWrLR9enrIkyuf+pH6oFHKb/kgI6osGTA3xD2v6Z2qo6o8w8
 1Q9yQLWosLOu5I/YaTqFQPdSUDkQHZ8RBCL1Vq4Cr3KqjZVbd7juz3hX9MdGQwvYSlW/
 ea3JCWEOJRaYnag3qGuXFJdfAJ5E6bpq1LpEqOii414talaUz5F5p7khqmbh655wFswG
 dZSwAB838moc81dMwcPMAuAhbdNvopgEhDn5u+ashp0tOgjaikvqGvH692RnAgYsd6Oz
 tMIbsaRdnaWqO5YN0aofKIzoITf//pMc5cKdt3G7wB2LwWvl5pHzKMy4CIO2i7+4pHsU oA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 333w6ubvgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Aug 2020 18:00:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07SHsmgI118329
        for <linux-xfs@vger.kernel.org>; Fri, 28 Aug 2020 18:00:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 333ru33aky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Aug 2020 18:00:22 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07SI0MIQ013047
        for <linux-xfs@vger.kernel.org>; Fri, 28 Aug 2020 18:00:22 GMT
Received: from [192.168.1.226] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Aug 2020 11:00:22 -0700
Subject: Re: [PATCH v12 8/8] xfs_io: Add delayed attributes error tag
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200827003518.1231-1-allison.henderson@oracle.com>
 <20200827003518.1231-9-allison.henderson@oracle.com>
 <20200828160207.GY6096@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <90cc0a44-f6a3-d60e-7102-1d2e2613b36b@oracle.com>
Date:   Fri, 28 Aug 2020 11:00:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200828160207.GY6096@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9727 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9727 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008280130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/28/20 9:02 AM, Darrick J. Wong wrote:
> On Wed, Aug 26, 2020 at 05:35:18PM -0700, Allison Collins wrote:
>> This patch adds an error tag that we can use to test delayed attribute
>> recovery and replay
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> 
> FWIW the subject line for this patch ought to start with 'xfs:', not
> 'xfs_io:'.
> 
> --D
> 
Sure, I think some time a long time ago, someone had commented that it 
was supposed to be xfs_io, but I dont see that used very much.  Will put 
it back to xfs.  Thanks!

Allison
>> ---
>>   fs/xfs/libxfs/xfs_errortag.h | 4 +++-
>>   fs/xfs/xfs_attr_item.c       | 8 ++++++++
>>   fs/xfs/xfs_error.c           | 3 +++
>>   3 files changed, 14 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
>> index 53b305d..cb38cbf 100644
>> --- a/fs/xfs/libxfs/xfs_errortag.h
>> +++ b/fs/xfs/libxfs/xfs_errortag.h
>> @@ -56,7 +56,8 @@
>>   #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
>>   #define XFS_ERRTAG_IUNLINK_FALLBACK			34
>>   #define XFS_ERRTAG_BUF_IOERROR				35
>> -#define XFS_ERRTAG_MAX					36
>> +#define XFS_ERRTAG_DELAYED_ATTR				36
>> +#define XFS_ERRTAG_MAX					37
>>   
>>   /*
>>    * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
>> @@ -97,5 +98,6 @@
>>   #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
>>   #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
>>   #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
>> +#define XFS_RANDOM_DELAYED_ATTR				1
>>   
>>   #endif /* __XFS_ERRORTAG_H_ */
>> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
>> index 923c288..ed71003 100644
>> --- a/fs/xfs/xfs_attr_item.c
>> +++ b/fs/xfs/xfs_attr_item.c
>> @@ -35,6 +35,8 @@
>>   #include "xfs_quota.h"
>>   #include "xfs_log_priv.h"
>>   #include "xfs_log_recover.h"
>> +#include "xfs_error.h"
>> +#include "xfs_errortag.h"
>>   
>>   static const struct xfs_item_ops xfs_attri_item_ops;
>>   static const struct xfs_item_ops xfs_attrd_item_ops;
>> @@ -310,6 +312,11 @@ xfs_trans_attr(
>>   	if (error)
>>   		return error;
>>   
>> +	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_DELAYED_ATTR)) {
>> +		error = -EIO;
>> +		goto out;
>> +	}
>> +
>>   	switch (op_flags) {
>>   	case XFS_ATTR_OP_FLAGS_SET:
>>   		args->op_flags |= XFS_DA_OP_ADDNAME;
>> @@ -324,6 +331,7 @@ xfs_trans_attr(
>>   		break;
>>   	}
>>   
>> +out:
>>   	/*
>>   	 * Mark the transaction dirty, even on error. This ensures the
>>   	 * transaction is aborted, which:
>> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
>> index 7f6e208..fc551cb 100644
>> --- a/fs/xfs/xfs_error.c
>> +++ b/fs/xfs/xfs_error.c
>> @@ -54,6 +54,7 @@ static unsigned int xfs_errortag_random_default[] = {
>>   	XFS_RANDOM_FORCE_SUMMARY_RECALC,
>>   	XFS_RANDOM_IUNLINK_FALLBACK,
>>   	XFS_RANDOM_BUF_IOERROR,
>> +	XFS_RANDOM_DELAYED_ATTR,
>>   };
>>   
>>   struct xfs_errortag_attr {
>> @@ -164,6 +165,7 @@ XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
>>   XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
>>   XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
>>   XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
>> +XFS_ERRORTAG_ATTR_RW(delayed_attr,	XFS_ERRTAG_DELAYED_ATTR);
>>   
>>   static struct attribute *xfs_errortag_attrs[] = {
>>   	XFS_ERRORTAG_ATTR_LIST(noerror),
>> @@ -202,6 +204,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>>   	XFS_ERRORTAG_ATTR_LIST(bad_summary),
>>   	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
>>   	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
>> +	XFS_ERRORTAG_ATTR_LIST(delayed_attr),
>>   	NULL,
>>   };
>>   
>> -- 
>> 2.7.4
>>
