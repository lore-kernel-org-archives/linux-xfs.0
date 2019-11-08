Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F98CC5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 19:52:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18F5F2067B
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 19:52:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ntNib/0i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732610AbfKHTwC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 14:52:02 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59586 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732607AbfKHTwC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 14:52:02 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8JmwHX098104
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 19:52:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=t0qNPAmYrJ7r5d9tI53VtapKeXrmQ1+ezMYid9QiFu0=;
 b=ntNib/0iwzGRBDuv6PO1R2VAAnb9y3WjsMKhC1A3L1JmSI+1VvPx1eKs79V8l65w1l+O
 6H/KKuzwOdy1ahrxcmUxqk/d1zQ+z5cwg9Kb2zc6J7wSrXqqyZrKFBuMZoHNi8GZfupZ
 J8JWefJA4GKYBOIgg4iJ6e0CloUoAeK4Mj0oxR0Mxghli9AoolokYuHbCs4PTSEMerHl
 Nd/Cy12v0JvkusuD9U+gxcKrOpz/PI2X0xWWwZ2D7+/ekqm0hvlcbs/sHLMtUbTcVqQS
 k2JV3T/bzyX0knL56S77hJoiqFR1M3ouNpAQokhdM87mp19KlNF+lVmeNX8inPXHDmbX MA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w41w17bkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 19:52:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8Jmxo3023751
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 19:52:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2w4k341un1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 19:52:00 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA8Jq093002462
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 19:52:00 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 11:52:00 -0800
Subject: Re: [PATCH v4 06/17] xfs: Factor out new helper functions
 xfs_attr_rmtval_set
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-7-allison.henderson@oracle.com>
 <20191108193445.GX6219@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <d7aa0b0e-e4ae-802e-afc5-28a008690bfb@oracle.com>
Date:   Fri, 8 Nov 2019 12:51:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108193445.GX6219@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080192
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080192
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/8/19 12:34 PM, Darrick J. Wong wrote:
> On Wed, Nov 06, 2019 at 06:27:50PM -0700, Allison Collins wrote:
>> Break xfs_attr_rmtval_set into two helper functions
>> xfs_attr_rmt_find_hole and xfs_attr_rmtval_set_value.
>> xfs_attr_rmtval_set rolls the transaction between the
>> helpers, but delayed operations cannot.  We will use
>> the helpers later when constructing new delayed
>> attribute routines.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> Looks good,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D

Alrighty, thanks for the reviews!
Allison

> 
>> ---
>>   fs/xfs/libxfs/xfs_attr_remote.c | 71 +++++++++++++++++++++++++++++++----------
>>   fs/xfs/libxfs/xfs_attr_remote.h |  3 +-
>>   2 files changed, 56 insertions(+), 18 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index db9247a..db51388 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -21,6 +21,7 @@
>>   #include "xfs_attr.h"
>>   #include "xfs_trace.h"
>>   #include "xfs_error.h"
>> +#include "xfs_attr_remote.h"
>>   
>>   #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
>>   
>> @@ -432,34 +433,20 @@ xfs_attr_rmtval_set(
>>   	struct xfs_da_args	*args)
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>> -	struct xfs_mount	*mp = dp->i_mount;
>>   	struct xfs_bmbt_irec	map;
>>   	xfs_dablk_t		lblkno;
>> -	xfs_fileoff_t		lfileoff = 0;
>> -	uint8_t			*src = args->value;
>>   	int			blkcnt;
>> -	int			valuelen;
>>   	int			nmap;
>>   	int			error;
>> -	int			offset = 0;
>>   
>>   	trace_xfs_attr_rmtval_set(args);
>>   
>> -	/*
>> -	 * Find a "hole" in the attribute address space large enough for
>> -	 * us to drop the new attribute's value into. Because CRC enable
>> -	 * attributes have headers, we can't just do a straight byte to FSB
>> -	 * conversion and have to take the header space into account.
>> -	 */
>> -	blkcnt = xfs_attr3_rmt_blocks(mp, args->rmtvaluelen);
>> -	error = xfs_bmap_first_unused(args->trans, args->dp, blkcnt, &lfileoff,
>> -						   XFS_ATTR_FORK);
>> +	error = xfs_attr_rmt_find_hole(args);
>>   	if (error)
>>   		return error;
>>   
>> -	args->rmtblkno = lblkno = (xfs_dablk_t)lfileoff;
>> -	args->rmtblkcnt = blkcnt;
>> -
>> +	blkcnt = args->rmtblkcnt;
>> +	lblkno = (xfs_dablk_t)args->rmtblkno;
>>   	/*
>>   	 * Roll through the "value", allocating blocks on disk as required.
>>   	 */
>> @@ -500,6 +487,56 @@ xfs_attr_rmtval_set(
>>   			return error;
>>   	}
>>   
>> +	return xfs_attr_rmtval_set_value(args);
>> +}
>> +
>> +
>> +/*
>> + * Find a "hole" in the attribute address space large enough for us to drop the
>> + * new attribute's value into
>> + */
>> +int
>> +xfs_attr_rmt_find_hole(
>> +	struct xfs_da_args	*args)
>> +{
>> +	struct xfs_inode        *dp = args->dp;
>> +	struct xfs_mount	*mp = dp->i_mount;
>> +	int			error;
>> +	int			blkcnt;
>> +	xfs_fileoff_t		lfileoff = 0;
>> +
>> +	/*
>> +	 * Because CRC enable attributes have headers, we can't just do a
>> +	 * straight byte to FSB conversion and have to take the header space
>> +	 * into account.
>> +	 */
>> +	blkcnt = xfs_attr3_rmt_blocks(mp, args->rmtvaluelen);
>> +	error = xfs_bmap_first_unused(args->trans, args->dp, blkcnt, &lfileoff,
>> +						   XFS_ATTR_FORK);
>> +	if (error)
>> +		return error;
>> +
>> +	args->rmtblkno = (xfs_dablk_t)lfileoff;
>> +	args->rmtblkcnt = blkcnt;
>> +
>> +	return 0;
>> +}
>> +
>> +int
>> +xfs_attr_rmtval_set_value(
>> +	struct xfs_da_args	*args)
>> +{
>> +	struct xfs_inode	*dp = args->dp;
>> +	struct xfs_mount	*mp = dp->i_mount;
>> +	struct xfs_bmbt_irec	map;
>> +	xfs_dablk_t		lblkno;
>> +	uint8_t			*src = args->value;
>> +	int			blkcnt;
>> +	int			valuelen;
>> +	int			nmap;
>> +	int			error;
>> +	int			offset = 0;
>> +
>>   	/*
>>   	 * Roll through the "value", copying the attribute value to the
>>   	 * already-allocated blocks.  Blocks are written synchronously
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>> index 9d20b66..cd7670d 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>> @@ -11,5 +11,6 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
>>   int xfs_attr_rmtval_get(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_set(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>> -
>> +int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
>> +int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
>>   #endif /* __XFS_ATTR_REMOTE_H__ */
>> -- 
>> 2.7.4
>>
