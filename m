Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB81AC432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 18:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 946A22071F
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 18:26:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XGhK4zrM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfKNS05 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Nov 2019 13:26:57 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52974 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbfKNS04 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 13:26:56 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAEIQQkJ106899;
        Thu, 14 Nov 2019 18:26:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=oQ9gYe5VszgNlNXKXRLGnc56kD6r36ezTW5KJ334AWM=;
 b=XGhK4zrMKmimor0dUfaOGf1grNwVFmV9+2rxNuK1oytJ03o7pFYk0rd+edFdds1WVmJe
 oY/D1HHd/3r6itB+T6bzYoyDKKvJztP9BTnovKlLEfuOLg3YOWkZ8IA4yfKsO634SxtN
 34UzkV/oC3MWWu6bu+snefMBo4dG8eVDZZcSdz3qln38XK+3ii6Vgj6w4mZbVDIKa+Qb
 gbHgq5JvCRmdJ+ExGe3Twj0mIUzPXRBKMsSZ4S+YilPdOgPXz+nD7MVxWOHVewV/35ah
 BlRryiIKtg4eToCoZnRyD72aeNurVywbitzrI4gYj4oMoZFf7HM92YQQCYTz5m1sS3Y2 cQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w5mvu52p4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 18:26:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAEINeTh171979;
        Thu, 14 Nov 2019 18:26:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w8nga5t84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 18:26:51 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAEIQmaU012432;
        Thu, 14 Nov 2019 18:26:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Nov 2019 10:26:48 -0800
Date:   Thu, 14 Nov 2019 10:26:47 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Frank Sorenson <sorenson@redhat.com>
Cc:     linux-xfs@vger.kernel.org, sandeen@sandeen.net
Subject: Re: [PATCH] xfs_restore: Return error if error occurs restoring
 extent
Message-ID: <20191114182647.GJ6219@magnolia>
References: <20191114074538.1220512-1-sorenson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191114074538.1220512-1-sorenson@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911140156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911140156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 14, 2019 at 01:45:38AM -0600, Frank Sorenson wrote:
> If an error occurs during write while restoring an extent,
> no error is currently propagated back to the caller, so
> xfsrestore can return SUCCESS on a failed restore.
> 
> Make restore_extent return an error code indicating the
> restore was incomplete.
> 
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
> ---
>  restore/content.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/restore/content.c b/restore/content.c
> index 6b22965..c267234 100644
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -8446,6 +8446,7 @@ restore_extent(filehdr_t *fhdrp,
>  	off64_t new_off;
>  	struct dioattr da;
>  	bool_t isrealtime = BOOL_FALSE;
> +	rv_t rv = RV_OK;
>  
>  	*bytesreadp = 0;
>  
> @@ -8496,7 +8497,6 @@ restore_extent(filehdr_t *fhdrp,
>  		req_bufsz = (size_t)min((off64_t)INTGENMAX, sz);
>  		bufp = (*dop->do_read)(drivep, req_bufsz, &sup_bufsz, &rval);
>  		if (rval) {
> -			rv_t rv;
>  			char *reasonstr;
>  			switch(rval) {
>  			case DRIVE_ERROR_EOF:
> @@ -8665,12 +8665,13 @@ restore_extent(filehdr_t *fhdrp,
>  			fd = -1;
>  			assert(ntowrite <= (size_t)INTGENMAX);
>  			nwritten = (int)ntowrite;
> +			rv = RV_INCOMPLETE;

							I think this is
							reasonable but
							it's very hard
							to understand
							what this
							function does
							when so much of
							the loop body is
							all jammed
							against the
							right margin.

							Reviewed-by:
							Darrick J. Wong
							<darrick.wong@oracle.com>

							--D

>  		}
>  		sz -= (off64_t)sup_bufsz;
>  		off += (off64_t)nwritten;
>  	}
>  
> -	return RV_OK;
> +	return rv;
>  }
>  
>  static char *extattrbufp = 0; /* ptr to start of all the extattr buffers */
> -- 
> 2.20.1
> 
