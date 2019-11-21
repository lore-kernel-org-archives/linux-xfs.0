Return-Path: <SRS0=udUw=ZN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A329C432C0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 21:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D88D52068E
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 21:59:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SV/QMo6o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfKUV7X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Nov 2019 16:59:23 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36824 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbfKUV7X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Nov 2019 16:59:23 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xALLx7X2168082;
        Thu, 21 Nov 2019 21:59:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=sODwFeGGEZc+CqRMKKSaJY3PwnIFHcW4p9aw64aqsy0=;
 b=SV/QMo6oLeevFskrCBL4PlsySTH+Exl4Zi61o5PXGDrCgPItuBQzXFvEUyb/Nb9R19lg
 sJqkyW0KdqX86LtvjUXV4Nwtg24CVLMSMVNh+WJfr9R1TCe2we7WKFX9JRQeO54EB3HH
 A/UNh7OOpxxfWAZMZljUOkSvSvV+ZEqGGeSdDnsdHB3SFtO44cj1aHjcsIyl/xh192Zd
 hkcwx/Gc38zlZhgROuN365B31mIcDNBCmFGTC90QKYNnMGh5gcwVLNPTZwZn5lflqQAm
 3/0d5QdxM1dhebahDB5yLA2wBLCwBU8QZxI9s/B6LQH7uTrcLjEv3AQxJOdgTGBWSIoc ow== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2wa8hu77ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 21:59:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xALLwLad076048;
        Thu, 21 Nov 2019 21:59:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2wda06sf76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 21:59:19 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xALLxI9D030148;
        Thu, 21 Nov 2019 21:59:18 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Nov 2019 13:59:18 -0800
Date:   Thu, 21 Nov 2019 13:59:17 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] mkfs: Show progress during block discard
Message-ID: <20191121215917.GA6219@magnolia>
References: <20191121214445.282160-1-preichl@redhat.com>
 <20191121214445.282160-3-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121214445.282160-3-preichl@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911210183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911210183
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 21, 2019 at 10:44:45PM +0100, Pavel Reichl wrote:
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index a02d6f66..07b8bd78 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1248,6 +1248,7 @@ discard_blocks(dev_t dev, uint64_t nsectors)
>  	const uint64_t	step		= (uint64_t)2<<30;
>  	/* Sector size is 512 bytes */
>  	const uint64_t	count		= nsectors << 9;
> +	uint64_t	prev_done	= (uint64_t) ~0;
>  
>  	fd = libxfs_device_to_fd(dev);
>  	if (fd <= 0)
> @@ -1255,6 +1256,7 @@ discard_blocks(dev_t dev, uint64_t nsectors)
>  
>  	while (offset < count) {
>  		uint64_t	tmp_step = step;
> +		uint64_t	done = offset * 100 / count;
>  
>  		if ((offset + step) > count)
>  			tmp_step = count - offset;
> @@ -1268,7 +1270,13 @@ discard_blocks(dev_t dev, uint64_t nsectors)
>  			return;
>  
>  		offset += tmp_step;
> +
> +		if (prev_done != done) {

Hmm... so this prints the status message every increase percentage
point, right?

> +			prev_done = done;
> +			fprintf(stderr, _("Discarding: %2lu%% done\n"), done);

This isn't an error, so why output to stderr?

FWIW if it's a tty you might consider ending that string with \r so the
status messages don't scroll off the screen.  Or possibly only reporting
status if stdout is a tty?

--D

> +		}
>  	}
> +	fprintf(stderr, _("Discarding is done.\n"));
>  }
>  
>  static __attribute__((noreturn)) void
> -- 
> 2.23.0
> 
