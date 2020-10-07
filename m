Return-Path: <SRS0=AHt9=DO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E96EDC41604
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 15:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84603215A4
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 15:28:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DkRZT29w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgJGP2J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 11:28:09 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:52256 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgJGP2I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 11:28:08 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097FKG0O183391;
        Wed, 7 Oct 2020 15:28:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Sa7Tm0xv3vUgEC4YfYmjOtOnLZW4UIqj09WLCeGyu3o=;
 b=DkRZT29w3KM4J11skZgESxmT/XsH+sFztGCBwnqrdGGvu0Kzpuvtw4pRZbVPcoHiLwI+
 5ecoi3+PvIM17/iCCqZU3UmleLPL2etw9ls6Mope0A/RDPskuR3sh5F3LWiZKJseOrj5
 s6ezyvt4vX/klLnzqcGTqbNY2Bf+L/A7GJIeAOi6yHQCDZ7skzx2b7xF9KZhi3bNNL64
 F5b/9XgkY7wEAhANMBrkGXc8lyqdEPC5IcIUf2EoaLTBgIWgUPVW+CfCVRn9DFD/gSS6
 uccG0dWtFWlL+Khm4PtMJ9g2+iihYn9RpqL9bu7mXHikA3iKgTLBnpQfVf/hZp08Qpbt rg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33xetb2mmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 15:28:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097FFJQj116144;
        Wed, 7 Oct 2020 15:28:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33y2vpnayk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 15:28:02 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 097FS1Pc013602;
        Wed, 7 Oct 2020 15:28:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 08:28:00 -0700
Date:   Wed, 7 Oct 2020 08:28:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v4 1/3] xfsprogs: allow i18n to xfs printk
Message-ID: <20201007152800.GB49547@magnolia>
References: <20201007140402.14295-1-hsiangkao@aol.com>
 <20201007140402.14295-2-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007140402.14295-2-hsiangkao@aol.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=1 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070098
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070098
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 07, 2020 at 10:04:00PM +0800, Gao Xiang wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> In preparation to a common stripe validation helper,
> allow i18n to xfs_{notice,warn,err,alert} so that
> xfsprogs can share code with kernel.
> 
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  libxfs/libxfs_priv.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index 5688284deb4e..545a66dec9b8 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -121,10 +121,10 @@ extern char    *progname;
>  extern void cmn_err(int, char *, ...);
>  enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
>  
> -#define xfs_notice(mp,fmt,args...)		cmn_err(CE_NOTE,fmt, ## args)
> -#define xfs_warn(mp,fmt,args...)		cmn_err(CE_WARN,fmt, ## args)
> -#define xfs_err(mp,fmt,args...)			cmn_err(CE_ALERT,fmt, ## args)
> -#define xfs_alert(mp,fmt,args...)		cmn_err(CE_ALERT,fmt, ## args)
> +#define xfs_notice(mp,fmt,args...)	cmn_err(CE_NOTE, _(fmt), ## args)
> +#define xfs_warn(mp,fmt,args...)	cmn_err(CE_WARN, _(fmt), ## args)
> +#define xfs_err(mp,fmt,args...)		cmn_err(CE_ALERT, _(fmt), ## args)
> +#define xfs_alert(mp,fmt,args...)	cmn_err(CE_ALERT, _(fmt), ## args)

AFAICT there isn't anything that passes a _() string to
xfs_{alert,notice,warn,err} so this looks ok to me.  It'll be nice to
add the libxfs strings to the message catalogue at last...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  
>  #define xfs_buf_ioerror_alert(bp,f)	((void) 0);
>  
> -- 
> 2.24.0
> 
