Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85591C4CEC4
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 18:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57888208C0
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 18:11:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nJ/IQz+4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfIRSLN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 14:11:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39490 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbfIRSLM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 14:11:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IHxCEN064943;
        Wed, 18 Sep 2019 18:11:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=VywXxMljxlV4LLP7wQsbN4qIINRvfupqOV+AKTUjJdQ=;
 b=nJ/IQz+4Ugkmtr+nbHRObY0+D5/aR148D7CxGEX+yAO38ZhKIMtJ1O7lonbxvvSaDyCY
 36f3KRQVdMwJuLnv71uKKBiZF2AJ3csDEVlw7FYD9qOWypIh5mmKKKMT5fOvwsc9o/ih
 Iv7/tQhVVM2GESYI8eTZLvMzSYELu8ow1RnFUqLDfJ9VcnWpx7iZdrHt01XU4HmzdXTe
 XxayRb5Hhlq60/epq/YFj+5EdEZHTpm+ClbLPxocpIqyPOn5X5vRVxwMB3jv7wQi3xiC
 C0RepIvynU3E5mA8krHKPfSQZ7qVBw+wFzxOE/H1G7+EinpBQprfonPdsGXQXltvDEzj NA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v385e5nmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 18:11:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8II4K9P117025;
        Wed, 18 Sep 2019 18:11:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2v37mb04fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 18:11:00 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8IIAxOI016980;
        Wed, 18 Sep 2019 18:10:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 11:10:59 -0700
Date:   Wed, 18 Sep 2019 11:10:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: convert inode to extent format after extent merge
 due to shift
Message-ID: <20190918181058.GM2229799@magnolia>
References: <20190918145538.30376-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918145538.30376-1-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909180161
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 10:55:38AM -0400, Brian Foster wrote:
> The collapse range operation can merge extents if two newly adjacent
> extents are physically contiguous. If the extent count is reduced on
> a btree format inode, a change to extent format might be necessary.
> This format change currently occurs as a side effect of the file
> size update after extents have been shifted for the collapse. This
> codepath ultimately calls xfs_bunmapi(), which happens to check for
> and execute the format conversion even if there were no blocks
> removed from the mapping.
> 
> While this ultimately puts the inode into the correct state, the
> fact the format conversion occurs in a separate transaction from the
> change that called for it is a problem. If an extent shift
> transaction commits and the filesystem happens to crash before the
> format conversion, the inode fork is left in a corrupted state after
> log recovery. The inode fork verifier fails and xfs_repair
> ultimately nukes the inode. This problem was originally reproduced
> by generic/388.
> 
> Similar to how the insert range extent split code handles extent to
> btree conversion, update the collapse range extent merge code to
> handle btree to extent format conversion in the same transaction
> that merges the extents. This ensures that the inode fork format
> remains consistent if the filesystem happens to crash in the middle
> of a collapse range operation that changes the inode fork format.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Seems sensible to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 054b4ce30033..eaf2d4250a26 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5621,6 +5621,11 @@ xfs_bmse_merge(
>  	if (error)
>  		return error;
>  
> +	/* change to extent format if required after extent removal */
> +	error = xfs_bmap_btree_to_extents(tp, ip, cur, logflags, whichfork);
> +	if (error)
> +		return error;
> +
>  done:
>  	xfs_iext_remove(ip, icur, 0);
>  	xfs_iext_prev(XFS_IFORK_PTR(ip, whichfork), icur);
> -- 
> 2.20.1
> 
