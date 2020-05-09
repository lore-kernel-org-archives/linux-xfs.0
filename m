Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53AADC28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C2172184D
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:07:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yJywPtzv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgEIRHU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:07:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45412 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728410AbgEIRHT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:07:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049H4LaA128267;
        Sat, 9 May 2020 17:07:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=wbditLnoJcmGqg7GcN5lAB3V5aWuSTlK77inTEUt4pw=;
 b=yJywPtzv3lPaTGOrwbK4d3GsF4GHN3hnHSF+/ugq3VKm2HS8YNPGOtLh7UswUWZ8DQK3
 S/3uLp5qRgWRFqPPygUkKsEXpaXavFL2IpaM9XLvYhh8fLzIi1kO3pYR8cbkff3xX91U
 bRaLBwO2nSL1GEbFPQqDNvWlFDyMOzT043T15WDnZpzG+JNBdtO3WS8SMZVnn314BhyI
 kFbAKqY4ooQv6E/0tXSOiYKc5uIE3q/iJ2Ia1Uloi0mvZ/Uh5nSlRPuRhv/MVCYn7uYi
 zDb3aRsVne19G3k4VFnPkDMDZliZOo43ujQExRkrVjiRZpCMFxjZ4fOhGuOq1I2iBf7c TA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30x0gh80g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 17:07:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049H3ckD010000;
        Sat, 9 May 2020 17:07:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30wwxb6pxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 17:07:14 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 049H7Ekd027237;
        Sat, 9 May 2020 17:07:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 10:07:13 -0700
Date:   Sat, 9 May 2020 10:07:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] db: add a comment to agfl_crc_flds
Message-ID: <20200509170712.GQ6714@magnolia>
References: <20200509170125.952508-1-hch@lst.de>
 <20200509170125.952508-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509170125.952508-4-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=905 adultscore=0
 suspectscore=1 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 suspectscore=1 priorityscore=1501 malwarescore=0 clxscore=1015 mlxscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=952 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 07:01:20PM +0200, Christoph Hellwig wrote:
> Explain the bno field that is not actually part of the structure
> anymore.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  db/agfl.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/db/agfl.c b/db/agfl.c
> index 45e4d6f9..ce7a2548 100644
> --- a/db/agfl.c
> +++ b/db/agfl.c
> @@ -47,6 +47,7 @@ const field_t	agfl_crc_flds[] = {
>  	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
>  	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
>  	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
> +	/* the bno array really is behind the actual structure */

Er... the bno array comes /after/ the actual structure, right?

--D

>  	{ "bno", FLDT_AGBLOCKNZ, OI(bitize(sizeof(struct xfs_agfl))),
>  	  agfl_bno_size, FLD_ARRAY|FLD_COUNT, TYP_DATA },
>  	{ NULL }
> -- 
> 2.26.2
> 
