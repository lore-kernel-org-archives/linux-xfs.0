Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD3B6C3F2D1
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 17:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 869B32083E
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 17:07:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VFqXBDMs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729755AbgCCRHO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 12:07:14 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55564 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729235AbgCCRHO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 12:07:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023Gs9P5126904;
        Tue, 3 Mar 2020 17:07:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=qepxz3iIUf/WR03RWLfaHmBnLLs+/fcP1Usg1uyi/G4=;
 b=VFqXBDMs251RMqSfwYMwQRsBUkPWQ6OQasIi/78Ky9umNLJx2cp/86CemQ/ao1dvZ+aL
 K1JXpsTMmlvQ6enu37WtfvBWvoE/JkXbjQglC8JraUgrCRO3AAu9T4nQ+dJm9LGu1cld
 +zj/E2101Q1N3AwOAA1y7VS785t/EP6OCC9P76lykReQfcUNQgD4es1JCAZBN+Y7VkKR
 7mXbdzaWrYMkoO7+i2NNkp+0TjjZFmLmcy/8QRpamLYJrZF1Hajk22Exn4C7ALmsJphC
 ADMArlceNIptM6EcOeCKTyhviNEh1Jo++zMmccSAy4ZZ4OxsGzd5R7IZEPp0qCdEVDpz iA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2yffwqrngv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 17:07:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023GmfeD088263;
        Tue, 3 Mar 2020 17:07:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2yg1em75uc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 17:07:08 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 023H77lw028199;
        Tue, 3 Mar 2020 17:07:07 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 09:07:06 -0800
Subject: Re: [PATCH v7 14/19] xfs: Add delay ready attr set routines
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-15-allison.henderson@oracle.com>
 <6212160.4XXo0ysdIk@localhost.localdomain>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <7f0c5a2d-371b-6eca-ccab-9ec0947dee30@oracle.com>
Date:   Tue, 3 Mar 2020 10:07:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6212160.4XXo0ysdIk@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003030116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003030116
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/3/20 6:41 AM, Chandan Rajendra wrote:
> On Sunday, February 23, 2020 7:36 AM Allison Collins wrote:
>> This patch modifies the attr set routines to be delay ready. This means they no
>> longer roll or commit transactions, but instead return -EAGAIN to have the calling
>> routine roll and refresh the transaction.  In this series, xfs_attr_set_args has
>> become xfs_attr_set_iter, which uses a state machine like switch to keep track of
>> where it was when EAGAIN was returned.
>>
>> Part of xfs_attr_leaf_addname has been factored out into a new helper function
>> xfs_attr_leaf_try_add to allow transaction cycling between the two routines.
>>
>> Two new helper functions have been added: xfs_attr_rmtval_set_init and
>> xfs_attr_rmtval_set_blk.  They provide a subset of logic similar to
>> xfs_attr_rmtval_set, but they store the current block in the delay attr
>> context to allow the caller to roll the transaction between allocations. This helps
>> to simplify and consolidate code used by xfs_attr_leaf_addname and
>> xfs_attr_node_addname. Finally, xfs_attr_set_args has become a simple loop to
>> refresh the transaction until the operation is completed.
>>
>> Below is a state machine diagram for attr set operations. The XFS_DAS_* states
>> indicate places where the function would return -EAGAIN, and then immediately
>> resume from after being recalled by the calling function.  States marked as a
>> "subroutine state" indicate that they belong to a subroutine, and so the calling
>> function needs to pass them back to that subroutine to allow it to finish where it
>> left off.  But they otherwise do not have a role in the calling function other
>> than just passing through.
>>
>>   xfs_attr_set_iter()
>>                   â”‚
>>                   v
>>             need to upgrade
>>            from sf to leaf? â”€â”€nâ”€â”
>>                   â”‚             â”‚
>>                   y             â”‚
>>                   â”‚             â”‚
>>                   V             â”‚
>>            XFS_DAS_ADD_LEAF     â”‚
>>                   â”‚             â”‚
>>                   v             â”‚
>>    â”Œâ”€â”€â”€â”€â”€â”€nâ”€â”€ fork has   <â”€â”€â”€â”€â”€â”€â”˜
>>    â”‚         only 1 blk?
>>    â”‚              â”‚
>>    â”‚              y
>>    â”‚              â”‚
>>    â”‚              v
>>    â”‚     xfs_attr_leaf_try_add()
>>    â”‚              â”‚
>>    â”‚              v
>>    â”‚          had enough
>>    â”œâ”€â”€â”€â”€â”€â”€nâ”€â”€   space?
>>    â”‚              â”‚
>>    â”‚              y
>>    â”‚              â”‚
>>    â”‚              v
>>    â”‚      XFS_DAS_FOUND_LBLK  â”€â”€â”
>>    â”‚                            â”‚
>>    â”‚      XFS_DAS_FLIP_LFLAG  â”€â”€â”¤
>>    â”‚      (subroutine state)    â”‚
>>    â”‚                            â”‚
>>    â”‚      XFS_DAS_ALLOC_LEAF  â”€â”€â”¤
>>    â”‚      (subroutine state)    â”‚
>>    â”‚                            â””â”€>xfs_attr_leaf_addname()
>>    â”‚                                              â”‚
>>    â”‚                                              v
>>    â”‚                                â”Œâ”€â”€â”€â”€â”€nâ”€â”€  need to
>>    â”‚                                â”‚        alloc blks?
>>    â”‚                                â”‚             â”‚
>>    â”‚                                â”‚             y
>>    â”‚                                â”‚             â”‚
>>    â”‚                                â”‚             v
>>    â”‚                                â”‚  â”Œâ”€>XFS_DAS_ALLOC_LEAF
>>    â”‚                                â”‚  â”‚          â”‚
>>    â”‚                                â”‚  â”‚          v
>>    â”‚                                â”‚  â””â”€â”€yâ”€â”€ need to alloc
>>    â”‚                                â”‚         more blocks?
>>    â”‚                                â”‚             â”‚
>>    â”‚                                â”‚             n
>>    â”‚                                â”‚             â”‚
>>    â”‚                                â”‚             v
>>    â”‚                                â”‚          was this
>>    â”‚                                â””â”€â”€â”€â”€â”€â”€â”€â”€> a rename? â”€â”€nâ”€â”
>>    â”‚                                              â”‚          â”‚
>>    â”‚                                              y          â”‚
>>    â”‚                                              â”‚          â”‚
>>    â”‚                                              v          â”‚
>>    â”‚                                        flip incomplete  â”‚
>>    â”‚                                            flag         â”‚
>>    â”‚                                              â”‚          â”‚
>>    â”‚                                              v          â”‚
>>    â”‚                                   â”Œâ”€>XFS_DAS_FLIP_LFLAG â”‚
>>    â”‚                                   â”‚          â”‚          â”‚
>>    â”‚                                   â”‚          v          â”‚
>>    â”‚                                   â”‚        remove       â”‚
>>    â”‚                                   â”‚       old name      â”‚
>>    â”‚                                   â”‚          â”‚          â”‚
>>    â”‚                                   â”‚          v          â”‚
>>    â”‚                                   â””â”€â”€â”€â”€yâ”€â”€ more to      â”‚
>>    â”‚                                            remove       â”‚
>>    â”‚                                              â”‚          â”‚
>>    â”‚                                              n          â”‚
>>    â”‚                                              â”‚          â”‚
>>    â”‚                                              v          â”‚
>>    â”‚                                             done <â”€â”€â”€â”€â”€â”€â”˜
>>    â””â”€â”€â”€â”€> XFS_DAS_LEAF_TO_NODE â”€â”
>>                                 â”‚
>>           XFS_DAS_FOUND_NBLK  â”€â”€â”¤
>>           (subroutine state)    â”‚
>>                                 â”‚
>>           XFS_DAS_ALLOC_NODE  â”€â”€â”¤
>>           (subroutine state)    â”‚
>>                                 â”‚
>>           XFS_DAS_FLIP_NFLAG  â”€â”€â”¤
>>           (subroutine state)    â”‚
>>                                 â”‚
>>                                 â””â”€>xfs_attr_node_addname()
>>                                                   â”‚
>>                                                   v
>>                                           find space to store
>>                                          attr. Split if needed
>>                                                   â”‚
>>                                                   v
>>                                           XFS_DAS_FOUND_NBLK
>>                                                   â”‚
>>                                                   v
>>                                     â”Œâ”€â”€â”€â”€â”€nâ”€â”€  need to
>>                                     â”‚        alloc blks?
>>                                     â”‚             â”‚
>>                                     â”‚             y
>>                                     â”‚             â”‚
>>                                     â”‚             v
>>                                     â”‚  â”Œâ”€>XFS_DAS_ALLOC_NODE
>>                                     â”‚  â”‚          â”‚
>>                                     â”‚  â”‚          v
>>                                     â”‚  â””â”€â”€yâ”€â”€ need to alloc
>>                                     â”‚         more blocks?
>>                                     â”‚             â”‚
>>                                     â”‚             n
>>                                     â”‚             â”‚
>>                                     â”‚             v
>>                                     â”‚          was this
>>                                     â””â”€â”€â”€â”€â”€â”€â”€â”€> a rename? â”€â”€nâ”€â”
>>                                                   â”‚          â”‚
>>                                                   y          â”‚
>>                                                   â”‚          â”‚
>>                                                   v          â”‚
>>                                             flip incomplete  â”‚
>>                                                 flag         â”‚
>>                                                   â”‚          â”‚
>>                                                   v          â”‚
>>                                        â”Œâ”€>XFS_DAS_FLIP_NFLAG â”‚
>>                                        â”‚          â”‚          â”‚
>>                                        â”‚          v          â”‚
>>                                        â”‚        remove       â”‚
>>                                        â”‚       old name      â”‚
>>                                        â”‚          â”‚          â”‚
>>                                        â”‚          v          â”‚
>>                                        â””â”€â”€â”€â”€yâ”€â”€ more to      â”‚
>>                                                 remove       â”‚
>>                                                   â”‚          â”‚
>>                                                   n          â”‚
>>                                                   â”‚          â”‚
>>                                                   v          â”‚
>>                                                  done <â”€â”€â”€â”€â”€â”€â”˜
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c        | 368 ++++++++++++++++++++++++++--------------
>>   fs/xfs/libxfs/xfs_attr.h        |   1 +
>>   fs/xfs/libxfs/xfs_attr_remote.c |  67 +++++++-
>>   fs/xfs/libxfs/xfs_attr_remote.h |   4 +
>>   fs/xfs/libxfs/xfs_da_btree.h    |  13 ++
>>   5 files changed, 319 insertions(+), 134 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index cd3a3f7..4b788f2 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -58,6 +58,7 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>   				 struct xfs_da_state **state);
>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>> +STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
>>   
>>   
>>   STATIC int
>> @@ -259,9 +260,86 @@ int
>>   xfs_attr_set_args(
>>   	struct xfs_da_args	*args)
>>   {
>> +	int			error = 0;
>> +	int			err2 = 0;
>> +	struct xfs_buf		*leaf_bp = NULL;
>> +
>> +	do {
>> +		error = xfs_attr_set_iter(args, &leaf_bp);
>> +		if (error && error != -EAGAIN)
>> +			goto out;
>> +
>> +		if (args->dac.flags & XFS_DAC_FINISH_TRANS) {
>> +			args->dac.flags &= ~XFS_DAC_FINISH_TRANS;
>> +
>> +			err2 = xfs_defer_finish(&args->trans);
>> +			if (err2) {
>> +				error = err2;
>> +				goto out;
>> +			}
>> +		}
>> +
>> +		err2 = xfs_trans_roll_inode(&args->trans, args->dp);
>> +		if (err2) {
>> +			error = err2;
>> +			goto out;
>> +		}
>> +
>> +		if (leaf_bp) {
>> +			xfs_trans_bjoin(args->trans, leaf_bp);
>> +			xfs_trans_bhold(args->trans, leaf_bp);
>> +		}
>> +
>> +	} while (error == -EAGAIN);
>> +
>> +out:
>> +	return error;
>> +}
>> +
>> +/*
>> + * Set the attribute specified in @args.
>> + * This routine is meant to function as a delayed operation, and may return
>> + * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
>> + * to handle this, and recall the function until a successful error code is
>> + * returned.
>> + */
>> +int
>> +xfs_attr_set_iter(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_buf          **leaf_bp)
>> +{
>>   	struct xfs_inode	*dp = args->dp;
>> -	struct xfs_buf          *leaf_bp = NULL;
>> -	int			error, error2 = 0;
>> +	int			error = 0;
>> +	int			sf_size;
>> +
>> +	/* State machine switch */
>> +	switch (args->dac.dela_state) {
>> +	case XFS_DAS_ADD_LEAF:
>> +		goto add_leaf;
>> +	case XFS_DAS_ALLOC_LEAF:
>> +	case XFS_DAS_FLIP_LFLAG:
>> +	case XFS_DAS_FOUND_LBLK:
>> +		goto leaf;
>> +	case XFS_DAS_FOUND_NBLK:
>> +	case XFS_DAS_FLIP_NFLAG:
>> +	case XFS_DAS_ALLOC_NODE:
>> +	case XFS_DAS_LEAF_TO_NODE:
>> +		goto node;
>> +	default:
>> +		break;
>> +	}
>> +
>> +	/*
>> +	 * New inodes may not have an attribute fork yet. So set the attribute
>> +	 * fork appropriately
>> +	 */
>> +	if (XFS_IFORK_Q((args->dp)) == 0) {
>> +		sf_size = sizeof(struct xfs_attr_sf_hdr) +
>> +		     XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
>> +		xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
>> +		args->dp->i_afp = kmem_zone_zalloc(xfs_ifork_zone, 0);
>> +		args->dp->i_afp->if_flags = XFS_IFEXTENTS;
>> +	}
>>   
>>   	/*
>>   	 * If the attribute list is non-existent or a shortform list,
>> @@ -275,17 +353,16 @@ xfs_attr_set_args(
>>   		 * Try to add the attr to the attribute list in the inode.
>>   		 */
>>   		error = xfs_attr_try_sf_addname(dp, args);
>> -		if (error != -ENOSPC) {
>> -			error2 = xfs_trans_commit(args->trans);
>> -			args->trans = NULL;
>> -			return error ? error : error2;
>> -		}
>> +
>> +		/* Should only be 0, -EEXIST or ENOSPC */
>> +		if (error != -ENOSPC)
>> +			return error;
>>   
>>   		/*
>>   		 * It won't fit in the shortform, transform to a leaf block.
>>   		 * GROT: another possible req'mt for a double-split btree op.
>>   		 */
>> -		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
>> +		error = xfs_attr_shortform_to_leaf(args, leaf_bp);
>>   		if (error)
>>   			return error;
>>   
>> @@ -293,41 +370,48 @@ xfs_attr_set_args(
>>   		 * Prevent the leaf buffer from being unlocked so that a
>>   		 * concurrent AIL push cannot grab the half-baked leaf
>>   		 * buffer and run into problems with the write verifier.
>> -		 * Once we're done rolling the transaction we can release
>> -		 * the hold and add the attr to the leaf.
>>   		 */
>> -		xfs_trans_bhold(args->trans, leaf_bp);
>> -		error = xfs_defer_finish(&args->trans);
>> -		xfs_trans_bhold_release(args->trans, leaf_bp);
>> -		if (error) {
>> -			xfs_trans_brelse(args->trans, leaf_bp);
>> -			return error;
>> -		}
>> +		xfs_trans_bhold(args->trans, *leaf_bp);
>> +		args->dac.flags |= XFS_DAC_FINISH_TRANS;
>> +		args->dac.dela_state = XFS_DAS_ADD_LEAF;
>> +		return -EAGAIN;
>>   	}
>>   
>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> -		error = xfs_attr_leaf_addname(args);
>> -		if (error != -ENOSPC)
>> -			return error;
>> +add_leaf:
>>   
>> -		/*
>> -		 * Commit that transaction so that the node_addname()
>> -		 * call can manage its own transactions.
>> -		 */
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			return error;
>> +	/*
>> +	 * After a shortform to leaf conversion, we need to hold the leaf and
>> +	 * cylce out the transaction.  When we get back, we need to release
>> +	 * the leaf.
>> +	 */
>> +	if (*leaf_bp != NULL) {
>> +		xfs_trans_brelse(args->trans, *leaf_bp);
>> +		*leaf_bp = NULL;
>> +	}
>>   
>> -		/*
>> -		 * Commit the current trans (including the inode) and
>> -		 * start a new one.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> -		if (error)
>> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> +		error = xfs_attr_leaf_try_add(args, *leaf_bp);
>> +		switch (error) {
>> +		case -ENOSPC:
>> +			args->dac.flags |= XFS_DAC_FINISH_TRANS;
>> +			args->dac.dela_state = XFS_DAS_LEAF_TO_NODE;
>> +			return -EAGAIN;
>> +		case 0:
>> +			args->dac.dela_state = XFS_DAS_FOUND_LBLK;
>> +			return -EAGAIN;
>> +		default:
>>   			return error;
>> -
>> +		}
>> +leaf:
>> +		error = xfs_attr_leaf_addname(args);
>> +		if (error == -ENOSPC) {
>> +			args->dac.dela_state = XFS_DAS_LEAF_TO_NODE;
>> +			return -EAGAIN;
>> +		}
>> +		return error;
>>   	}
>> -
>> +	args->dac.dela_state = XFS_DAS_LEAF_TO_NODE;
>> +node:
>>   	error = xfs_attr_node_addname(args);
>>   	return error;
>>   }
>> @@ -766,28 +850,29 @@ xfs_attr_leaf_try_add(
>>    *
>>    * This leaf block cannot have a "remote" value, we only call this routine
>>    * if bmap_one_block() says there is only one block (ie: no remote blks).
>> + *
>> + * This routine is meant to function as a delayed operation, and may return
>> + * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
>> + * to handle this, and recall the function until a successful error code is
>> + * returned.
>>    */
>>   STATIC int
>>   xfs_attr_leaf_addname(
>>   	struct xfs_da_args	*args)
>>   {
>> -	int			error, forkoff;
>>   	struct xfs_buf		*bp = NULL;
>> +	int			error, forkoff;
>>   	struct xfs_inode	*dp = args->dp;
>>   
>> -	trace_xfs_attr_leaf_addname(args);
>> -
>> -	error = xfs_attr_leaf_try_add(args, bp);
>> -	if (error)
>> -		return error;
>> -
>> -	/*
>> -	 * Commit the transaction that added the attr name so that
>> -	 * later routines can manage their own transactions.
>> -	 */
>> -	error = xfs_trans_roll_inode(&args->trans, dp);
>> -	if (error)
>> -		return error;
>> +	/* State machine switch */
>> +	switch (args->dac.dela_state) {
>> +	case XFS_DAS_FLIP_LFLAG:
>> +		goto flip_flag;
>> +	case XFS_DAS_ALLOC_LEAF:
>> +		goto alloc_leaf;
>> +	default:
>> +		break;
>> +	}
>>   
>>   	/*
>>   	 * If there was an out-of-line value, allocate the blocks we
>> @@ -796,7 +881,28 @@ xfs_attr_leaf_addname(
>>   	 * maximum size of a transaction and/or hit a deadlock.
>>   	 */
>>   	if (args->rmtblkno > 0) {
>> -		error = xfs_attr_rmtval_set(args);
>> +
>> +		/* Open coded xfs_attr_rmtval_set without trans handling */
>> +		error = xfs_attr_rmtval_set_init(args);
>> +		if (error)
>> +			return error;
>> +
>> +		/*
>> +		 * Roll through the "value", allocating blocks on disk as
>> +		 * required.
>> +		 */
>> +alloc_leaf:
>> +		while (args->dac.blkcnt > 0) {
>> +			error = xfs_attr_rmtval_set_blk(args);
>> +			if (error)
>> +				return error;
>> +
>> +			args->dac.flags |= XFS_DAC_FINISH_TRANS;
>> +			args->dac.dela_state = XFS_DAS_ALLOC_LEAF;
>> +			return -EAGAIN;
>> +		}
>> +
>> +		error = xfs_attr_rmtval_set_value(args);
>>   		if (error)
>>   			return error;
>>   	}
>> @@ -815,13 +921,6 @@ xfs_attr_leaf_addname(
>>   		error = xfs_attr3_leaf_flipflags(args);
>>   		if (error)
>>   			return error;
>> -		/*
>> -		 * Commit the flag value change and start the next trans in
>> -		 * series.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -		if (error)
>> -			return error;
>>   
>>   		/*
>>   		 * Dismantle the "old" attribute/value pair by removing
>> @@ -832,8 +931,17 @@ xfs_attr_leaf_addname(
>>   		args->rmtblkno = args->rmtblkno2;
>>   		args->rmtblkcnt = args->rmtblkcnt2;
>>   		args->rmtvaluelen = args->rmtvaluelen2;
>> +
>> +		args->dac.dela_state = XFS_DAS_FLIP_LFLAG;
>> +		return -EAGAIN;
>> +flip_flag:
>>   		if (args->rmtblkno) {
>> -			error = xfs_attr_rmtval_remove(args);
>> +			error = xfs_attr_rmtval_unmap(args);
>> +
>> +			/*
>> +			 * if (error == -EAGAIN), we will repeat this until
>> +			 * args->rmtblkno is zero
>> +			 */
>>   			if (error)
>>   				return error;
>>   		}
> Hi Allison,
> 
> In the case where args->rmtblkno is non-zero, xfs_attr_rmtval_unmap() invokes
> xfs_bunmapi() for unmapping the file block range starting at
> args->rmtblkno. If xfs_bunmapi() frees a subset of the range of blocks, it
> returns with 'done' set to 0 and in turn xfs_attr_rmtval_unmap() returns with
> -EAGAIN error. This will cause xfs_attr_leaf_addname() to return -EAGAIN to
> its caller i.e. xfs_attr_set_iter(). In turn xfs_attr_set_iter() returns back
> to xfs_attr_set_args(). Here the loop is executed once again and hence
> xfs_attr_set_iter() is invoked with args->dac.dela_state set to
> XFS_DAS_FLIP_LFLAG. Hence xfs_attr_leaf_addname() is invoked once again with
> args->dac.dela_state set to XFS_DAS_FLIP_LFLAG. Here xfs_attr_rmtval_unmap()
> is invoked once again with an unmodified args->rmtblkno.
> 

Hi Chandan!

Thanks for the digging!  I think what I'm missing here is the 
xfs_attr_rmtval_invalidate, and an extra state for the remove.  Similar 
to how patch 13 handles xfs_attr_rmtval_unmap.  Will update!  Thank you!

Allison
