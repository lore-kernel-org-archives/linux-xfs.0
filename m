Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6057C43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 23:38:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78B7821925
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 23:38:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nUtVbwDF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfKKXim (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Nov 2019 18:38:42 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34054 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbfKKXik (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Nov 2019 18:38:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABNJKsQ110967;
        Mon, 11 Nov 2019 23:38:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=1DaN0AqjqTpzR2jNr8MJ162NtvgMVMOqM2QG+HtBM7o=;
 b=nUtVbwDFR+ckGJD+hR/zfSI8d+RDCz+6hcp3Jd2dAjnhz4XdBr4UywxYFOZZ+GxWPwRf
 gCFJulA4p39YYJt35UQfXfX3677OSw9NuvyWQ5DCPc2SeUUFHLmVmfu1O8UZxpoiA7fe
 avnR+g9jtFheD0FyYwOeO5ralOGRKZlx9vZnn9bTiPLix9JqUPrpowZuAZes9OGwvQOK
 x7bID1yMzkvRMiehKbJ+p6ajoU7EnT9cIgUARWHy4dy9jY1lN4S3u0OY7YZ9MRspkhuk
 ohzAtnLRGEs1ItkYLeH05TIoTDqYVXfmgLsqXzIE6e/Zznk98EScKhemLF0eHMbWHdYU CA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w5ndq19cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 23:38:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABNJJMK112830;
        Mon, 11 Nov 2019 23:36:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w66wmuuq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 23:36:34 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xABNaXUw002349;
        Mon, 11 Nov 2019 23:36:33 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 15:36:33 -0800
Subject: Re: [PATCH v4 05/17] xfs: Add xfs_has_attr and subroutines
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-6-allison.henderson@oracle.com>
 <20191111175346.GC28708@infradead.org>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <11e36bf9-d036-e304-261c-54056307d1e2@oracle.com>
Date:   Mon, 11 Nov 2019 16:36:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191111175346.GC28708@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110199
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110199
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/11/19 10:53 AM, Christoph Hellwig wrote:
>> +	if (!xfs_inode_hasattr(dp)) {
>> +		error = -ENOATTR;
>> +	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>> +		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>> +		error = xfs_attr_shortform_hasname(args, NULL, NULL);
>> +	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> +		error = xfs_attr_leaf_hasname(args, &bp);
>> +		if (error != -ENOATTR && error != -EEXIST)
>> +			goto out;
>> +		xfs_trans_brelse(args->trans, bp);
>> +	} else {
>> +		error = xfs_attr_node_hasname(args, NULL);
>> +	}
>> +out:
>> +	return error;
>> +}
> 
> I think a lot of this would be much simpler without the goto out, e.g.:
> 
> 	if (!xfs_inode_hasattr(dp))
> 		return -ENOATTR;
> 
> 	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> 		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> 		return xfs_attr_shortform_hasname(args, NULL, NULL);
> 	}
> 
> 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> 		struct xfs_buf	*bp;
> 		int		error = xfs_attr_leaf_hasname(args, &bp);
> 
> 		if (error == -ENOATTR || error == -EEXIST)
> 			xfs_trans_brelse(args->trans, bp);
> 		return error;
> 	}
> 
> 	return xfs_attr_node_hasname(args, NULL);
> 

Sure, will fix this along with Brians suggestions too.  Thanks!
Allison
