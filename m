Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63134C3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 00:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C44D20735
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 00:29:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hE7PROO5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgEEA3w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 20:29:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52870 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgEEA3w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 20:29:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0450HeKV079266
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 00:29:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+ibsk0dRIwAqA3owJWVUIgs/7bAO0/QHVTkSJT6UhHg=;
 b=hE7PROO5ibjQXFqmg89ZONIoBPH7gx2CaoHwVdbC850gBwzo4c3gEmnZVlwIn3NS2pRD
 ho4GVypaHYW26GEvqIWqAycxTiEfRazI6p9GViOPqBvrmyzUos2+9XYzs7dNtmQvI4lB
 9JmptYRYSMOVv0ayZ/Jwgl/a+KGMFmUxoIOsJWEEKPOlWaZIIYidimHebXh+3emwKcE2
 BjKpsgBH6DHprtbIwb2jFdKmPNcgBnpFySEEqSr2qYvdxT+ieXRiGrMMJyk5ea5j4Nk/
 mbH3cdNjHXChd88rWmmVB+vuyJaeAMTG0sjH1Ojfg2yWVXUB23KWVVjmKdgX3bL51ld8 cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30s09r20r0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 00:29:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0450Hc7p120364
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 00:29:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30t1r3n4uc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 00:29:50 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0450To0M031971
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 00:29:50 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 17:29:49 -0700
Subject: Re: [PATCH v9 14/24] xfs: Add helpers xfs_attr_is_shortform and
 xfs_attr_set_shortform
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-15-allison.henderson@oracle.com>
 <20200504184628.GA5703@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <a26680f1-e50c-dc9b-ae04-a099d784fd0d@oracle.com>
Date:   Mon, 4 May 2020 17:29:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504184628.GA5703@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 11:46 AM, Darrick J. Wong wrote:
> On Thu, Apr 30, 2020 at 03:50:06PM -0700, Allison Collins wrote:
>> In this patch, we hoist code from xfs_attr_set_args into two new helpers
>> xfs_attr_is_shortform and xfs_attr_set_shortform.  These two will help
>> to simplify xfs_attr_set_args when we get into delayed attrs later.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> 
> Looks ok to me,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
Thank yoU!

Allison
> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 107 +++++++++++++++++++++++++++++++----------------
>>   1 file changed, 72 insertions(+), 35 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index af47566..d112910 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -204,6 +204,66 @@ xfs_attr_try_sf_addname(
>>   }
>>   
>>   /*
>> + * Check to see if the attr should be upgraded from non-existent or shortform to
>> + * single-leaf-block attribute list.
>> + */
>> +static inline bool
>> +xfs_attr_is_shortform(
>> +	struct xfs_inode    *ip)
>> +{
>> +	return ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>> +	       (ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
>> +	        ip->i_d.di_anextents == 0);
>> +}
>> +
>> +/*
>> + * Attempts to set an attr in shortform, or converts short form to leaf form if
>> + * there is not enough room.  If the attr is set, the transaction is committed
>> + * and set to NULL.
>> + */
>> +STATIC int
>> +xfs_attr_set_shortform(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_buf		**leaf_bp)
>> +{
>> +	struct xfs_inode	*dp = args->dp;
>> +	int			error, error2 = 0;
>> +
>> +	/*
>> +	 * Try to add the attr to the attribute list in the inode.
>> +	 */
>> +	error = xfs_attr_try_sf_addname(dp, args);
>> +	if (error != -ENOSPC) {
>> +		error2 = xfs_trans_commit(args->trans);
>> +		args->trans = NULL;
>> +		return error ? error : error2;
>> +	}
>> +	/*
>> +	 * It won't fit in the shortform, transform to a leaf block.  GROT:
>> +	 * another possible req'mt for a double-split btree op.
>> +	 */
>> +	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
>> +	if (error)
>> +		return error;
>> +
>> +	/*
>> +	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
>> +	 * push cannot grab the half-baked leaf buffer and run into problems
>> +	 * with the write verifier. Once we're done rolling the transaction we
>> +	 * can release the hold and add the attr to the leaf.
>> +	 */
>> +	xfs_trans_bhold(args->trans, *leaf_bp);
>> +	error = xfs_defer_finish(&args->trans);
>> +	xfs_trans_bhold_release(args->trans, *leaf_bp);
>> +	if (error) {
>> +		xfs_trans_brelse(args->trans, *leaf_bp);
>> +		return error;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>>    * Set the attribute specified in @args.
>>    */
>>   int
>> @@ -212,48 +272,25 @@ xfs_attr_set_args(
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>>   	struct xfs_buf          *leaf_bp = NULL;
>> -	int			error, error2 = 0;
>> +	int			error = 0;
>>   
>>   	/*
>> -	 * If the attribute list is non-existent or a shortform list,
>> -	 * upgrade it to a single-leaf-block attribute list.
>> +	 * If the attribute list is already in leaf format, jump straight to
>> +	 * leaf handling.  Otherwise, try to add the attribute to the shortform
>> +	 * list; if there's no room then convert the list to leaf format and try
>> +	 * again.
>>   	 */
>> -	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>> -	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
>> -	     dp->i_d.di_anextents == 0)) {
>> +	if (xfs_attr_is_shortform(dp)) {
>>   
>>   		/*
>> -		 * Try to add the attr to the attribute list in the inode.
>> +		 * If the attr was successfully set in shortform, the
>> +		 * transaction is committed and set to NULL.  Otherwise, is it
>> +		 * converted from shortform to leaf, and the transaction is
>> +		 * retained.
>>   		 */
>> -		error = xfs_attr_try_sf_addname(dp, args);
>> -		if (error != -ENOSPC) {
>> -			error2 = xfs_trans_commit(args->trans);
>> -			args->trans = NULL;
>> -			return error ? error : error2;
>> -		}
>> -
>> -		/*
>> -		 * It won't fit in the shortform, transform to a leaf block.
>> -		 * GROT: another possible req'mt for a double-split btree op.
>> -		 */
>> -		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
>> -		if (error)
>> -			return error;
>> -
>> -		/*
>> -		 * Prevent the leaf buffer from being unlocked so that a
>> -		 * concurrent AIL push cannot grab the half-baked leaf
>> -		 * buffer and run into problems with the write verifier.
>> -		 * Once we're done rolling the transaction we can release
>> -		 * the hold and add the attr to the leaf.
>> -		 */
>> -		xfs_trans_bhold(args->trans, leaf_bp);
>> -		error = xfs_defer_finish(&args->trans);
>> -		xfs_trans_bhold_release(args->trans, leaf_bp);
>> -		if (error) {
>> -			xfs_trans_brelse(args->trans, leaf_bp);
>> +		error = xfs_attr_set_shortform(args, &leaf_bp);
>> +		if (error || !args->trans)
>>   			return error;
>> -		}
>>   	}
>>   
>>   	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> -- 
>> 2.7.4
>>
