Return-Path: <SRS0=3dSt=YH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1085FECE587
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 17:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9CE3217D9
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 17:13:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JsDQLG4e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388253AbfJNRN1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Oct 2019 13:13:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49362 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387910AbfJNRN1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Oct 2019 13:13:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9EHA85S029637;
        Mon, 14 Oct 2019 17:13:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=PfcFSqTpuPhmivBcFkJGJT0aUKnL7oaKvSeo6NiE+A8=;
 b=JsDQLG4eLljHRQXQes4PtidqZGNbTCF1mH/KbL+ZNjijxWaKw70HAfNTO0FeRIg0kP3I
 gOevsyBZJEYNjw4KEw/p7hELA7wKuJSn94zkZ1M1VIxp9JoNqWLqAQKQQEQf8ZQ5WfDj
 oJlEXNgj29CG8d2F+hwKr3N5F57NUSChe6XMddXmvkdyIrcGwaRIBfZn3j/jAOvZQ6eq
 zhR2PiE804YoiqQcMGCaeKkgNvzKHyYrUyOhlNu66S8G9VLEcFBbT1ys+hsOIKvb1ImZ
 ljHpVcNdqmSs1gjZda8frH90wJy/MF94Cy5s5cXFeMIW1jUc+j50sDWzatg6DS36TXIZ yA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vk6sqabsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 17:13:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9EH7wa2149632;
        Mon, 14 Oct 2019 17:13:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2vkry6r67t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 17:13:23 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9EHDMur013121;
        Mon, 14 Oct 2019 17:13:22 GMT
Received: from localhost (/10.159.144.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Oct 2019 10:13:21 -0700
Date:   Mon, 14 Oct 2019 10:13:20 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: remove dead ifdef XFSERRORDEBUG code
Message-ID: <20191014171320.GW13108@magnolia>
References: <20191009142748.18005-1-hch@lst.de>
 <20191009142748.18005-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009142748.18005-6-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910140145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910140145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 04:27:45PM +0200, Christoph Hellwig wrote:
> XFSERRORDEBUG is never set and the code isn't all that useful, so remove
> it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 13 -------------
>  1 file changed, 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 67a767d90ebf..7a429e5dc27c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3996,19 +3996,6 @@ xfs_log_force_umount(
>  	spin_unlock(&log->l_cilp->xc_push_lock);
>  	xlog_state_do_callback(log, true, NULL);
>  
> -#ifdef XFSERRORDEBUG
> -	{
> -		xlog_in_core_t	*iclog;
> -
> -		spin_lock(&log->l_icloglock);
> -		iclog = log->l_iclog;
> -		do {
> -			ASSERT(iclog->ic_callback == 0);
> -			iclog = iclog->ic_next;
> -		} while (iclog != log->l_iclog);
> -		spin_unlock(&log->l_icloglock);
> -	}
> -#endif
>  	/* return non-zero if log IOERROR transition had already happened */
>  	return retval;
>  }
> -- 
> 2.20.1
> 
