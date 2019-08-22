Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95361C3A5A1
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 14:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6718E233A1
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 14:44:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GU0faB1J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731806AbfHVOoc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 10:44:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55590 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387660AbfHVOob (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 10:44:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7MEi6Jx064225;
        Thu, 22 Aug 2019 14:44:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=bFpI5rHDtLz3lgcz1IG9PenX9RIF5Yn8A7G/IX6p78E=;
 b=GU0faB1JYB79HJtlhAfWuI/gU1L8XbimI1LCUC7CCeMAUbRI9blyXZqllPWiZm677ZFY
 J4cIhjum9h8M6ggsyFXMiqUHVb3fW3UYwD+cRHwUVulr2s3JD0KtSG8hteKUqcvzH/iF
 S6Aj5x+ZLJfPU7z4CvCGWfx86Xu/Xwz2jIcomZVFe7AUBckbX7KD1iftvseIKBuZKCtA
 bBMUuKnCKeif+NHAUsfSW/eDPiFI5urT7gKN3SKhmkdUIdMUYiUvPg55ICtGQB0ReRBR
 /zi0oVmZygjV3MQKzJp5CzNWt4SHtjbTzcfCjz9pN4b60Kzl+CAitLDl8poALi4H3n6l 2Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ue90txan8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 14:44:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7MET8g2030393;
        Thu, 22 Aug 2019 14:44:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2uh83q5pyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 14:44:26 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7MEiPYh013946;
        Thu, 22 Aug 2019 14:44:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Aug 2019 07:44:25 -0700
Date:   Thu, 22 Aug 2019 07:44:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Austin Kim <austindh.kim@gmail.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: Use BUG_ON rather than BUG() to remove unreachable
 code
Message-ID: <20190822144424.GG1037350@magnolia>
References: <20190822062320.GA35267@LGEARND20B15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822062320.GA35267@LGEARND20B15>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9356 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908220148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9356 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908220149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 22, 2019 at 03:23:20PM +0900, Austin Kim wrote:
> Code after BUG is unreachable since system would be crashed
> after the call to BUG is made.
> So change BUG_ON instead of BUG() to remove unreachable code.
> ---
>  fs/xfs/xfs_mount.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 322da69..a681808 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -213,13 +213,7 @@ xfs_initialize_perag(
>  			goto out_hash_destroy;
>  
>  		spin_lock(&mp->m_perag_lock);
> -		if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
> -			BUG();
> -			spin_unlock(&mp->m_perag_lock);
> -			radix_tree_preload_end();
> -			error = -EEXIST;
> -			goto out_hash_destroy;
> -		}
> +		BUG_ON(radix_tree_insert(&mp->m_perag_tree, index, pag));

/me thinks this should WARN on the insertion error but otherwise
preserve the existing bailout behavior, since we can always fail the
mount or shutdown the fs and move on....

--D

>  		spin_unlock(&mp->m_perag_lock);
>  		radix_tree_preload_end();
>  		/* first new pag is fully initialized */
> -- 
> 2.6.2
> 
