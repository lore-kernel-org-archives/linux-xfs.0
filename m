Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A69EC4BA09
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 02:20:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EC9C21744
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 02:20:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zwr6EQi2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbgBZCUg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 21:20:36 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37726 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729395AbgBZCUg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 21:20:36 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q2FpQP120719;
        Wed, 26 Feb 2020 02:20:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=roVXYxvTDuQFV2Q57xyp/CCGAXXypiNayWAA/HylPNw=;
 b=zwr6EQi2M9/125P7R/mtkH1bqJipcNDrB40p2TrUP5mDIqrAzSjlsWps5FiTr84gM70Z
 ZecY68PcLsH4JeAWPxKW7PuXctwojv0PrV9jo/DXWIIINaRJ4KUV55dVoclDVNpzbieR
 JvWA86r7GZKMGkA2qdoRVrYQL4zyPB0JdC1Dq0uexRJAa5mht4edHViqsz5rLwRcHAxk
 5ZmGq88kEZzwXMP+O3ExFa2YG0pU8gkLKA5eLEGo2EItXXXHFTEMoUWcdADU+dUip1u2
 yefalTRkIPZ52ZD0FvNNlhDX40oQLGFH4M7rCWCT+rpqx0sIFmQHX0L5jlVqeLx74AKI Ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ydcsrgjen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 02:20:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q2EGL0019816;
        Wed, 26 Feb 2020 02:20:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2ydcs2pbma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 02:20:33 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01Q2KV11022995;
        Wed, 26 Feb 2020 02:20:31 GMT
Received: from [192.168.1.9] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 18:20:31 -0800
Subject: Re: [PATCH v7 05/19] xfs: Factor out new helper functions
 xfs_attr_rmtval_set
To:     Chandan Rajendra <chandan@linux.ibm.com>, linux-xfs@vger.kernel.org
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-6-allison.henderson@oracle.com>
 <2068968.RKExeAfMjv@localhost.localdomain>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <76748faf-e036-4243-03cf-775196d263b4@oracle.com>
Date:   Tue, 25 Feb 2020 19:20:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <2068968.RKExeAfMjv@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 spamscore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260015
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/25/20 5:53 AM, Chandan Rajendra wrote:
> On Sunday, February 23, 2020 7:35 AM Allison Collins wrote:
>> Break xfs_attr_rmtval_set into two helper functions xfs_attr_rmt_find_hole
>> and xfs_attr_rmtval_set_value. xfs_attr_rmtval_set rolls the transaction between the
>> helpers, but delayed operations cannot.  We will use the helpers later when
>> constructing new delayed attribute routines.
> 
> I don't see any logical errors.
> 
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Great!  Thank you!

Allison
> 
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr_remote.c | 149 +++++++++++++++++++++++++---------------
>>   1 file changed, 92 insertions(+), 57 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index df8aca5..d1eee24 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -440,32 +440,23 @@ xfs_attr_rmtval_get(
>>   }
>>   
>>   /*
>> - * Write the value associated with an attribute into the out-of-line buffer
>> - * that we have defined for it.
>> + * Find a "hole" in the attribute address space large enough for us to drop the
>> + * new attribute's value into
>>    */
>> -int
>> -xfs_attr_rmtval_set(
>> +STATIC int
>> +xfs_attr_rmt_find_hole(
>>   	struct xfs_da_args	*args)
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>>   	struct xfs_mount	*mp = dp->i_mount;
>> -	struct xfs_bmbt_irec	map;
>> -	xfs_dablk_t		lblkno;
>> -	xfs_fileoff_t		lfileoff = 0;
>> -	uint8_t			*src = args->value;
>> -	int			blkcnt;
>> -	int			valuelen;
>> -	int			nmap;
>>   	int			error;
>> -	int			offset = 0;
>> -
>> -	trace_xfs_attr_rmtval_set(args);
>> +	int			blkcnt;
>> +	xfs_fileoff_t		lfileoff = 0;
>>   
>>   	/*
>> -	 * Find a "hole" in the attribute address space large enough for
>> -	 * us to drop the new attribute's value into. Because CRC enable
>> -	 * attributes have headers, we can't just do a straight byte to FSB
>> -	 * conversion and have to take the header space into account.
>> +	 * Because CRC enable attributes have headers, we can't just do a
>> +	 * straight byte to FSB conversion and have to take the header space
>> +	 * into account.
>>   	 */
>>   	blkcnt = xfs_attr3_rmt_blocks(mp, args->rmtvaluelen);
>>   	error = xfs_bmap_first_unused(args->trans, args->dp, blkcnt, &lfileoff,
>> @@ -473,48 +464,26 @@ xfs_attr_rmtval_set(
>>   	if (error)
>>   		return error;
>>   
>> -	args->rmtblkno = lblkno = (xfs_dablk_t)lfileoff;
>> +	args->rmtblkno = (xfs_dablk_t)lfileoff;
>>   	args->rmtblkcnt = blkcnt;
>>   
>> -	/*
>> -	 * Roll through the "value", allocating blocks on disk as required.
>> -	 */
>> -	while (blkcnt > 0) {
>> -		/*
>> -		 * Allocate a single extent, up to the size of the value.
>> -		 *
>> -		 * Note that we have to consider this a data allocation as we
>> -		 * write the remote attribute without logging the contents.
>> -		 * Hence we must ensure that we aren't using blocks that are on
>> -		 * the busy list so that we don't overwrite blocks which have
>> -		 * recently been freed but their transactions are not yet
>> -		 * committed to disk. If we overwrite the contents of a busy
>> -		 * extent and then crash then the block may not contain the
>> -		 * correct metadata after log recovery occurs.
>> -		 */
>> -		nmap = 1;
>> -		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
>> -				  blkcnt, XFS_BMAPI_ATTRFORK, args->total, &map,
>> -				  &nmap);
>> -		if (error)
>> -			return error;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			return error;
>> -
>> -		ASSERT(nmap == 1);
>> -		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
>> -		       (map.br_startblock != HOLESTARTBLOCK));
>> -		lblkno += map.br_blockcount;
>> -		blkcnt -= map.br_blockcount;
>> +	return 0;
>> +}
>>   
>> -		/*
>> -		 * Start the next trans in the chain.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> -		if (error)
>> -			return error;
>> -	}
>> +STATIC int
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
>>   
>>   	/*
>>   	 * Roll through the "value", copying the attribute value to the
>> @@ -595,6 +564,72 @@ xfs_attr_rmtval_stale(
>>   }
>>   
>>   /*
>> + * Write the value associated with an attribute into the out-of-line buffer
>> + * that we have defined for it.
>> + */
>> +int
>> +xfs_attr_rmtval_set(
>> +	struct xfs_da_args	*args)
>> +{
>> +	struct xfs_inode	*dp = args->dp;
>> +	struct xfs_bmbt_irec	map;
>> +	xfs_dablk_t		lblkno;
>> +	int			blkcnt;
>> +	int			nmap;
>> +	int			error;
>> +
>> +	trace_xfs_attr_rmtval_set(args);
>> +
>> +	error = xfs_attr_rmt_find_hole(args);
>> +	if (error)
>> +		return error;
>> +
>> +	blkcnt = args->rmtblkcnt;
>> +	lblkno = (xfs_dablk_t)args->rmtblkno;
>> +	/*
>> +	 * Roll through the "value", allocating blocks on disk as required.
>> +	 */
>> +	while (blkcnt > 0) {
>> +		/*
>> +		 * Allocate a single extent, up to the size of the value.
>> +		 *
>> +		 * Note that we have to consider this a data allocation as we
>> +		 * write the remote attribute without logging the contents.
>> +		 * Hence we must ensure that we aren't using blocks that are on
>> +		 * the busy list so that we don't overwrite blocks which have
>> +		 * recently been freed but their transactions are not yet
>> +		 * committed to disk. If we overwrite the contents of a busy
>> +		 * extent and then crash then the block may not contain the
>> +		 * correct metadata after log recovery occurs.
>> +		 */
>> +		nmap = 1;
>> +		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
>> +				  blkcnt, XFS_BMAPI_ATTRFORK, args->total, &map,
>> +				  &nmap);
>> +		if (error)
>> +			return error;
>> +		error = xfs_defer_finish(&args->trans);
>> +		if (error)
>> +			return error;
>> +
>> +		ASSERT(nmap == 1);
>> +		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
>> +		       (map.br_startblock != HOLESTARTBLOCK));
>> +		lblkno += map.br_blockcount;
>> +		blkcnt -= map.br_blockcount;
>> +
>> +		/*
>> +		 * Start the next trans in the chain.
>> +		 */
>> +		error = xfs_trans_roll_inode(&args->trans, dp);
>> +		if (error)
>> +			return error;
>> +	}
>> +
>> +	return xfs_attr_rmtval_set_value(args);
>> +}
>> +
>> +/*
>>    * Remove the value associated with an attribute by deleting the
>>    * out-of-line buffer that it is stored on.
>>    */
>>
> 
> 
