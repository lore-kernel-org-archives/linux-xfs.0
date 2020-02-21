Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3509C35656
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 15:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C68882465D
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 15:29:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sdb3jKcv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbgBUP3R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 10:29:17 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55832 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728528AbgBUP3Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 10:29:16 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LFSjP9038016;
        Fri, 21 Feb 2020 15:29:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=2pnSHaafC0AP2k7H52NNB7xN0e/EVMwK9GPk+lg4mfk=;
 b=sdb3jKcvzNkv1NcBUNLvHgC0eeG59+6/HDZ7O/rna+WCh9MchKrkfRmhVzDZWuIvv7qy
 YPPQY1qqR4pOGFFO0heGfG9mUBXtn/N9b93VWCXYwTKgsZMG/RSb2SgZl9CWdCR6DCoZ
 MiJ0lJHYjcaEeAhiQnW2pIPFRY7hYMhHGpxC6krz6HnrKnitFdsn5eajETdUVVM+uXmf
 6b3gE5poFRUXTqschHwKQDbrPZidCIkdT6KKWpZTArxhFpW17ZxXkDjIw9FWrUnZGaIW
 Rse7pAKGCTmvT43WAb9V+BS/G52eHul8I+wCv2kwr+MkdtGtBJn6XaB6OBfygMzIxVzK rQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2y8ud1h5ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 15:29:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LFT8tT009649;
        Fri, 21 Feb 2020 15:29:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2y8udfc45r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 15:29:08 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01LFSwMm026251;
        Fri, 21 Feb 2020 15:28:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Feb 2020 07:28:58 -0800
Date:   Fri, 21 Feb 2020 07:28:57 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 31/31] xfs: clean up bufsize alignment in
 xfs_ioc_attr_list
Message-ID: <20200221152857.GO9506@magnolia>
References: <20200221141154.476496-1-hch@lst.de>
 <20200221141154.476496-32-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221141154.476496-32-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9537 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210118
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 21, 2020 at 06:11:54AM -0800, Christoph Hellwig wrote:
> Use the round_down macro, and use the size of the uint32 type we
> use in the callback that fills the buffer to make the code a little
> more clear - the size of it is always the same as int for platforms
> that Linux runs on.
> 
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 4b126f5e9bed..0690e1a8ef1a 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -414,7 +414,7 @@ xfs_ioc_attr_list(
>  	context.resynch = 1;
>  	context.attr_filter = xfs_attr_filter(flags);
>  	context.buffer = buffer;
> -	context.bufsize = (bufsize & ~(sizeof(int)-1));  /* align */
> +	context.bufsize = round_down(bufsize, sizeof(uint32_t));
>  	context.firstu = context.bufsize;
>  	context.put_listent = xfs_ioc_attr_put_listent;
>  
> -- 
> 2.24.1
> 
