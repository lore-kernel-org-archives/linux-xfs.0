Return-Path: <SRS0=g8AD=65=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A729C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 20:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 016CF2070A
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 20:48:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R99qbwi4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgEOUsO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 May 2020 16:48:14 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41010 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgEOUsO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 May 2020 16:48:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04FKknou191824;
        Fri, 15 May 2020 20:48:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=qQdsCkglah6K1lUE5RKG4vBM1hsx+IsBmifO4/A/oZw=;
 b=R99qbwi4vzcAnYYcHExitoXGll/hcXZiyBMTF9iLJSDnl/ZIYyFcgqybNksrbxFMdxOO
 cFKPLVoRBb42TuSsZ/eCXwnpPIpUxop9nmPzrmys0pttsNbnqXhh83yX3qHTXucRgoXt
 C/ZxAHdS1ln6GJ1WGGplz4ZNsUZ2EOfcH/P8Cu5w5mdORUfmTm/iCbafHZlcMh4DHhIT
 jMh8HcmyK6UdMoFXk+u8C80XplkBWSBbd7L2yg0kCUAx4U0CvCcpGxpSA0w6wlEipVzw
 dNhJtIeGnFrSOfVSd9O8e7SgUeU1JyKCtBHd12AVlgAiLJqm06RNDAwZ7fPcBybZt1SR sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3100ygdqcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 May 2020 20:48:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04FKmA4r187959;
        Fri, 15 May 2020 20:48:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3100ykmawq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 20:48:10 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04FKm34U015929;
        Fri, 15 May 2020 20:48:03 GMT
Received: from localhost (/10.159.241.121)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 May 2020 13:48:03 -0700
Date:   Fri, 15 May 2020 13:48:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] mkfs.xfs: sanity check stripe geometry from blkid
Message-ID: <20200515204802.GO6714@magnolia>
References: <a673fbd3-5038-2dc8-8135-a58c24042734@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a673fbd3-5038-2dc8-8135-a58c24042734@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9622 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=1 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005150173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9622 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 cotscore=-2147483648 mlxscore=0 suspectscore=1 spamscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1015 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005150173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 15, 2020 at 02:14:17PM -0500, Eric Sandeen wrote:
> We validate commandline options for stripe unit and stripe width, and
> if a device returns nonsensical values via libblkid, the superbock write
> verifier will eventually catch it and fail (noisily and cryptically) but
> it seems a bit cleaner to just do a basic sanity check on the numbers
> as soon as we get them from blkid, and if they're bogus, ignore them from
> the start.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/libfrog/topology.c b/libfrog/topology.c
> index b1b470c9..38ed03b7 100644
> --- a/libfrog/topology.c
> +++ b/libfrog/topology.c
> @@ -213,6 +213,19 @@ static void blkid_get_topology(
>  	val = blkid_topology_get_optimal_io_size(tp);
>  	*swidth = val;
>  
> +        /*
> +	 * Occasionally, firmware is broken and returns optimal < minimum,
> +	 * or optimal which is not a multiple of minimum.
> +	 * In that case just give up and set both to zero, we can't trust
> +	 * information from this device. Similar to xfs_validate_sb_common().
> +	 */
> +        if (*sunit) {
> +                if ((*sunit > *swidth) || (*swidth % *sunit != 0)) {

I feel like we're copypasting this sunit/swidth checking logic all over
xfsprogs and yet we're still losing the stripe unit validation whackamole
game.

In the end, we want to check more or less the same things for each pair
of stripe unit and stripe width:

 * integer overflows of either value
 * sunit and swidth alignment wrt sector size
 * if either sunit or swidth are zero, both should be zero
 * swidth must be a multiple of sunit

All four of these rules apply to the blkid_get_toplogy answers for the
data device, the log device, and the realtime device; and any mkfs CLI
overrides of those values.

IOWs, is there some way to refactor those four rules into a single
validation function and call that in the six(ish) places we need it?
Especially since you're the one who played the last round of whackamole,
back in May 2018. :)

--D

> +                        *sunit = 0;
> +                        *swidth = 0;
> +                }
> +        }
> +
>  	/*
>  	 * If the reported values are the same as the physical sector size
>  	 * do not bother to report anything.  It will only cause warnings
> 
