Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7271C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 01:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9094C236F9
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 01:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729701AbhAHBdI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jan 2021 20:33:08 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:38096 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729637AbhAHBdH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jan 2021 20:33:07 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1081Iucj061564;
        Fri, 8 Jan 2021 01:31:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=pJaZWFykdlvJRZwrcMnybU3q+2S8+8HG/7/E67JzkyA=;
 b=hCUSupxi18wFTCVCYOlsWKgHuYmK62VG6DaeGg77Avz0FuofCi2VSyxBHrKZ53zlc7MY
 GKMMyOOoarQIi1Gabry+yyJ3yb926lkYaRKUXPBETG1IukOeiUe9XIzEJBArKp86Zqbl
 IljcySyE4Z+r2KRmIGLR9Cxf9cF1QfwqA8mykhHOlXGfX1SAo5jmcHJjnXvgJ+FgEsEf
 9bHbXex3WGsiODGMKt3wGliw7dy6fVkpzrhOC/2cewYz7SwR+HjoqLhvm9ujPzWup3u7
 +HyuttOb3rwQyktdXPXlXfcst2+VSwI9/L7B62ClKCjBz3UqjYevcdsax434KrzBLJOI YA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35wcuxyge0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 01:31:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1081Ku2M064640;
        Fri, 8 Jan 2021 01:29:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 35v1fby54n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 01:29:55 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1081TrjP018407;
        Fri, 8 Jan 2021 01:29:54 GMT
Received: from localhost (/10.159.138.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 17:29:53 -0800
Date:   Thu, 7 Jan 2021 17:29:52 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfs: do not allow reflinking inodes with the dax flag
 set
Message-ID: <20210108012952.GO6918@magnolia>
References: <862a665f-3f1b-64e0-70eb-00cc35eaa2df@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <862a665f-3f1b-64e0-70eb-00cc35eaa2df@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080004
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 07, 2021 at 03:36:34PM -0600, Eric Sandeen wrote:
> Today, xfs_reflink_remap_prep() will reject inodes which are in the CPU
> direct access state, i.e. IS_DAX() is true.  However, it is possible to
> have inodes with the XFS_DIFLAG2_DAX set, but which are not activated as
> dax, due to the flag being set after the inode was loaded.
> 
> To avoid confusion and make the lack of dax+reflink crystal clear for the
> user, reject reflink requests for both IS_DAX and XFS_DIFLAG2_DAX inodes
> unless DAX mode is impossible due to mounting with -o dax=never.

I thought we were allowing arbitrary combinations of DAX & REFLINK inode
flags now, since we're now officially ok with "you set the inode flag
but you don't get cpu direct access because $reasons"?

--D

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> V2: Allow reflinking dax-flagged inodes in "mount -o dax=never" mode
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 6fa05fb78189..e238a5b7b722 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1308,6 +1308,15 @@ xfs_reflink_remap_prep(
>  	if (IS_DAX(inode_in) || IS_DAX(inode_out))
>  		goto out_unlock;
>  
> +	/*
> +	 * Until we have dax+reflink, don't allow reflinking dax-flagged
> +	 * inodes unless we are in dax=never mode.
> +	 */
> +	if (!(mp->m_flags & XFS_MOUNT_DAX_NEVER) &&
> +	     (src->i_d.di_flags2 & XFS_DIFLAG2_DAX ||
> +	      dest->i_d.di_flags2 & XFS_DIFLAG2_DAX))
> +		goto out_unlock;
> +
>  	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
>  			len, remap_flags);
>  	if (ret || *len == 0)
> 
