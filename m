Return-Path: <SRS0=tPAf=52=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF5DDC2BA2B
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Apr 2020 16:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 872242078E
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Apr 2020 16:56:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="t0Ej/ttN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgDJQ4B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Apr 2020 12:56:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59252 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgDJQ4B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Apr 2020 12:56:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03AGi8iq177728;
        Fri, 10 Apr 2020 16:55:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=vywpITYN/hIcElQ1gEMxOhjtmYTbFa+Kqpe94VbyFZI=;
 b=t0Ej/ttN+akyCW0mHmntInxbYtwXmYOFxPTvinEo2gHFRo584AEMabC5hzx8mIdE7Tvz
 3xTzSgHYONu3KAMDZZrc4Z4eBhHW47kPIJt4MXidTI9kd0UYzI6JFmDLsBmFzI8JlFzB
 YLO1igdFgoz0L5QYROwUMyUB0cCFwN1T2qnIsBRitrQhAzhMcpSJX49hYKbCLW54LtYU
 EbAQr5dNHTz25/QNMZbus8k/R+W4w3GN6JtGPaSi7fXVomZlSJmSsR4PW3xd+oNpdEZb
 Xi+1KIGBpmTrMHzNGQS7lCFwdguavuq4PhSXoyMRMEYwmzoAUA5zENHy3Xu3O4nwFhpy WA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3091m17885-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Apr 2020 16:55:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03AGhVNw089021;
        Fri, 10 Apr 2020 16:55:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3091m7ww66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Apr 2020 16:55:57 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03AGtuiT016011;
        Fri, 10 Apr 2020 16:55:56 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Apr 2020 09:55:56 -0700
Subject: Re: [PATCH v8 13/20] xfs: Add helpers xfs_attr_is_shortform and
 xfs_attr_set_shortform
From:   Allison Collins <allison.henderson@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-14-allison.henderson@oracle.com>
 <20200407152301.GE28936@bfoster>
 <00b93566-bb7d-544d-698a-c239e7c5f7b3@oracle.com>
Message-ID: <3c589d25-c931-6376-eefc-343b4828a820@oracle.com>
Date:   Fri, 10 Apr 2020 09:55:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <00b93566-bb7d-544d-698a-c239e7c5f7b3@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9587 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9587 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/7/20 2:53 PM, Allison Collins wrote:
> 
> 
> On 4/7/20 8:23 AM, Brian Foster wrote:
>> On Fri, Apr 03, 2020 at 03:12:22PM -0700, Allison Collins wrote:
>>> In this patch, we hoist code from xfs_attr_set_args into two new helpers
>>> xfs_attr_is_shortform and xfs_attr_set_shortform.  These two will help
>>> to simplify xfs_attr_set_args when we get into delayed attrs later.
>>>
>>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>>> ---
>>>   fs/xfs/libxfs/xfs_attr.c | 107 
>>> +++++++++++++++++++++++++++++++----------------
>>>   1 file changed, 72 insertions(+), 35 deletions(-)
>>>
>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>> index 4225a94..ba26ffe 100644
>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>> @@ -204,6 +204,66 @@ xfs_attr_try_sf_addname(
>>>   }
>>>   /*
>>> + * Check to see if the attr should be upgraded from non-existent or 
>>> shortform to
>>> + * single-leaf-block attribute list.
>>> + */
>>> +static inline bool
>>> +xfs_attr_is_shortform(
>>> +    struct xfs_inode    *ip)
>>> +{
>>> +    return ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>>> +          (ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
>>> +          ip->i_d.di_anextents == 0);
>>
>> Logic should be indented similar to the original:
>>
>>     return ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>>            (ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
>>         ip->i_d.di_anextents == 0);
Did you really mean to have the last line offset like this?  On second 
pass, it doesnt look similar to the original, and looks more like it may 
have been a typo in the review.  Just trying to avoid more cycles on 
spacing goofs.  Thx!

Allison

>>
>> Otherwise looks good:
>>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Alrighty, will fix.  Thanks!
> 
> Allison
> 
>>
>>> +}
>>> +
>>> +/*
>>> + * Attempts to set an attr in shortform, or converts the tree to 
>>> leaf form if
>>> + * there is not enough room.  If the attr is set, the transaction is 
>>> committed
>>> + * and set to NULL.
>>> + */
>>> +STATIC int
>>> +xfs_attr_set_shortform(
>>> +    struct xfs_da_args    *args,
>>> +    struct xfs_buf        **leaf_bp)
>>> +{
>>> +    struct xfs_inode    *dp = args->dp;
>>> +    int            error, error2 = 0;
>>> +
>>> +    /*
>>> +     * Try to add the attr to the attribute list in the inode.
>>> +     */
>>> +    error = xfs_attr_try_sf_addname(dp, args);
>>> +    if (error != -ENOSPC) {
>>> +        error2 = xfs_trans_commit(args->trans);
>>> +        args->trans = NULL;
>>> +        return error ? error : error2;
>>> +    }
>>> +    /*
>>> +     * It won't fit in the shortform, transform to a leaf block.  GROT:
>>> +     * another possible req'mt for a double-split btree op.
>>> +     */
>>> +    error = xfs_attr_shortform_to_leaf(args, leaf_bp);
>>> +    if (error)
>>> +        return error;
>>> +
>>> +    /*
>>> +     * Prevent the leaf buffer from being unlocked so that a 
>>> concurrent AIL
>>> +     * push cannot grab the half-baked leaf buffer and run into 
>>> problems
>>> +     * with the write verifier. Once we're done rolling the 
>>> transaction we
>>> +     * can release the hold and add the attr to the leaf.
>>> +     */
>>> +    xfs_trans_bhold(args->trans, *leaf_bp);
>>> +    error = xfs_defer_finish(&args->trans);
>>> +    xfs_trans_bhold_release(args->trans, *leaf_bp);
>>> +    if (error) {
>>> +        xfs_trans_brelse(args->trans, *leaf_bp);
>>> +        return error;
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +/*
>>>    * Set the attribute specified in @args.
>>>    */
>>>   int
>>> @@ -212,48 +272,25 @@ xfs_attr_set_args(
>>>   {
>>>       struct xfs_inode    *dp = args->dp;
>>>       struct xfs_buf          *leaf_bp = NULL;
>>> -    int            error, error2 = 0;
>>> +    int            error = 0;
>>>       /*
>>> -     * If the attribute list is non-existent or a shortform list,
>>> -     * upgrade it to a single-leaf-block attribute list.
>>> +     * If the attribute list is already in leaf format, jump 
>>> straight to
>>> +     * leaf handling.  Otherwise, try to add the attribute to the 
>>> shortform
>>> +     * list; if there's no room then convert the list to leaf format 
>>> and try
>>> +     * again.
>>>        */
>>> -    if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>>> -        (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
>>> -         dp->i_d.di_anextents == 0)) {
>>> -
>>> -        /*
>>> -         * Try to add the attr to the attribute list in the inode.
>>> -         */
>>> -        error = xfs_attr_try_sf_addname(dp, args);
>>> -        if (error != -ENOSPC) {
>>> -            error2 = xfs_trans_commit(args->trans);
>>> -            args->trans = NULL;
>>> -            return error ? error : error2;
>>> -        }
>>> -
>>> -        /*
>>> -         * It won't fit in the shortform, transform to a leaf block.
>>> -         * GROT: another possible req'mt for a double-split btree op.
>>> -         */
>>> -        error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
>>> -        if (error)
>>> -            return error;
>>> +    if (xfs_attr_is_shortform(dp)) {
>>>           /*
>>> -         * Prevent the leaf buffer from being unlocked so that a
>>> -         * concurrent AIL push cannot grab the half-baked leaf
>>> -         * buffer and run into problems with the write verifier.
>>> -         * Once we're done rolling the transaction we can release
>>> -         * the hold and add the attr to the leaf.
>>> +         * If the attr was successfully set in shortform, the
>>> +         * transaction is committed and set to NULL.  Otherwise, is it
>>> +         * converted from shortform to leaf, and the transaction is
>>> +         * retained.
>>>            */
>>> -        xfs_trans_bhold(args->trans, leaf_bp);
>>> -        error = xfs_defer_finish(&args->trans);
>>> -        xfs_trans_bhold_release(args->trans, leaf_bp);
>>> -        if (error) {
>>> -            xfs_trans_brelse(args->trans, leaf_bp);
>>> +        error = xfs_attr_set_shortform(args, &leaf_bp);
>>> +        if (error || !args->trans)
>>>               return error;
>>> -        }
>>>       }
>>>       if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>> -- 
>>> 2.7.4
>>>
>>
