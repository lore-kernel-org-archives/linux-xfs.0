Return-Path: <SRS0=b7mv=XQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C745C49ED7
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Sep 2019 07:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E249F20673
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Sep 2019 07:29:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hq4KTD1j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731096AbfIUH3Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Sep 2019 03:29:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56652 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729899AbfIUH3Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Sep 2019 03:29:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8L7TAxn124045;
        Sat, 21 Sep 2019 07:29:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Cy7mcNSbpWf8zeTGDnrDkqfilferdCeiFAOaig28uXE=;
 b=hq4KTD1jJgOGNZKTP7bRWJpezf4qEOODqpOkN1zLPsjFPSWhJkd3RnRauZff/uPgi5t0
 e1XMk7/N7+N+6hyy42kmHHNllqeJIfNWbRpE7RprtYHBzj8fqbBMXkrauCEV4LsRMifZ
 s/DKi4WE5ET+0uddm92v9lS5/C843vrLR65IuEGbHqGE8DiyyTbjiAKxT6lxarQLkZoN
 ehH5oJMxGXP33t5xlOFyhWKtldYSz6vsFYR8qS1DImMkUK0zeVkbK3It7vNOIhOYipp1
 /l4EzFjRDgyKAyAvzHlNDznIR2k6WuqQI3cnMzI9TTzJ6fmIC4bvBPlTOrrN87rS5v5M Gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v5btpgb2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 Sep 2019 07:29:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8L7S60s001604;
        Sat, 21 Sep 2019 07:29:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v5b74fwgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 Sep 2019 07:29:09 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8L7T8xC015442;
        Sat, 21 Sep 2019 07:29:08 GMT
Received: from [192.168.1.9] (/67.1.21.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 21 Sep 2019 00:29:08 -0700
Subject: Re: [PATCH v3 05/19] xfs: Factor out new helper functions
 xfs_attr_rmtval_set
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190905221837.17388-1-allison.henderson@oracle.com>
 <20190905221837.17388-6-allison.henderson@oracle.com>
 <20190920134933.GC40150@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <64e68695-0edd-0b0d-5004-471e59ae2e18@oracle.com>
Date:   Sat, 21 Sep 2019 00:29:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920134933.GC40150@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909210081
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909210081
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/20/19 6:49 AM, Brian Foster wrote:
> On Thu, Sep 05, 2019 at 03:18:23PM -0700, Allison Collins wrote:
>> Break xfs_attr_rmtval_set into two helper functions
>> xfs_attr_rmt_find_hole and xfs_attr_rmtval_set_value.
>> xfs_attr_rmtval_set rolls the transaction between the
>> helpers, but delayed operations cannot.  We will use
>> the helpers later when constructing new delayed
>> attribute routines.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr_remote.c | 72 +++++++++++++++++++++++++++++++----------
>>   fs/xfs/libxfs/xfs_attr_remote.h |  3 +-
>>   2 files changed, 57 insertions(+), 18 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index db9247a..080a284 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> ...
>> @@ -500,6 +487,57 @@ xfs_attr_rmtval_set(
>>   			return error;
>>   	}
>>   
>> +	error = xfs_attr_rmtval_set_value(args);
>> +	return error;
> 
> 	return xfs_attr_rmtval_set_value(args);
Ok, will fix

> 
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
>> +	xfs_fileoff_t		lfileoff = args->rmtblkno;
> 
> The init of lfileoff looks a little strange here. It was originally
> initialized to zero, passed into the call below and then assigned to
> ->rmtblkno. Is this change intentional?
> 
I see, no I probably mistakenly adopted the assignment, but it's likely 
not needed.  Will clean out.

Thanks again for all the reviews!
Allison

> With those nits fixed:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
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
