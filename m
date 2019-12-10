Return-Path: <SRS0=hCPB=2A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66147C43603
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Dec 2019 20:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 292002073B
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Dec 2019 20:37:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XAE5K25l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbfLJUhj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Dec 2019 15:37:39 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48504 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfLJUhj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Dec 2019 15:37:39 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBAKYTDm040642;
        Tue, 10 Dec 2019 20:37:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2019-08-05;
 bh=D18XMrTcMT/KARWMgwuwmiMWPCXuZ18OoZJ6k5sy5Gg=;
 b=XAE5K25lDYguLwTHT5ShDUu3vPKq9LPf+1GpkewHbytvpPFhV7Ek2b/QBarqkRcL7AyH
 3NpmIUz1lUVzhr/BjVeHkCIiwf0gS4q9k011cPEN534ShfovaiM3UKbGqhdGVqOSubbB
 9Wh6M9FuKTHV190lmYV20BpQhRe2+65I3sA/xY9O5631T5SaXlzupq9ILDy0mhpvDQS2
 yj76wrQcQKftNIA1nSRgKIO3TAegSeRr9470uwLW38mVykFDHazDkqOVDCKDsY7lDgkW
 WG6W2xV5+N3V3yGG5Xa396PYUzOBlAuAxSjK9nt3Cp0EEBVTcjApX0YvRXXawZuPWr/T /A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wr4qrgj0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 20:37:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBAKXnj6036664;
        Tue, 10 Dec 2019 20:37:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2wt6bdp6qf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 20:37:34 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBAKbYjZ021879;
        Tue, 10 Dec 2019 20:37:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Dec 2019 12:37:34 -0800
Date:   Tue, 10 Dec 2019 12:37:33 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4] mkfs: Break block discard into chunks of 2 GB
Message-ID: <20191210203733.GB99875@magnolia>
References: <20191210114807.161927-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191210114807.161927-1-preichl@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9467 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912100170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9467 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912100170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 10, 2019 at 12:48:07PM +0100, Pavel Reichl wrote:
> Some users are not happy about the BLKDISCARD taking too long and at the same
> time not being informed about that - so they think that the command actually
> hung.
> 
> This commit changes code so that progress reporting is possible and also typing
> the ^C will cancel the ongoing BLKDISCARD.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
> Changelog:
> 	V4: Limit the reporting about discarding to a single line
> 
>  mkfs/xfs_mkfs.c | 50 ++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 37 insertions(+), 13 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 18338a61..4bfdebf6 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1240,17 +1240,40 @@ done:
>  }
>  
>  static void
> -discard_blocks(dev_t dev, uint64_t nsectors)
> +discard_blocks(dev_t dev, uint64_t nsectors, int quiet)

If you /do/ decide to make @quiet a global then please make it bool.
That's material for a separate patch though...

...this looks reasonable enough to me;
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


>  {
> -	int fd;
> +	int		fd;
> +	uint64_t	offset = 0;
> +	/* Discard the device 2G at a time */
> +	const uint64_t	step = 2ULL << 30;
> +	const uint64_t	count = BBTOB(nsectors);
>  
> -	/*
> -	 * We intentionally ignore errors from the discard ioctl.  It is
> -	 * not necessary for the mkfs functionality but just an optimization.
> -	 */
>  	fd = libxfs_device_to_fd(dev);
> -	if (fd > 0)
> -		platform_discard_blocks(fd, 0, nsectors << 9);
> +	if (fd <= 0)
> +		return;
> +	if (!quiet) {
> +		printf("Discarding blocks...");
> +		fflush(stdout);
> +	}
> +
> +	/* The block discarding happens in smaller batches so it can be
> +	 * interrupted prematurely
> +	 */
> +	while (offset < count) {
> +		uint64_t	tmp_step = min(step, count - offset);
> +
> +		/*
> +		 * We intentionally ignore errors from the discard ioctl. It is
> +		 * not necessary for the mkfs functionality but just an
> +		 * optimization. However we should stop on error.
> +		 */
> +		if (platform_discard_blocks(fd, offset, tmp_step))
> +			return;
> +
> +		offset += tmp_step;
> +	}
> +	if (!quiet)
> +		printf("Done.\n");
>  }
>  
>  static __attribute__((noreturn)) void
> @@ -2507,18 +2530,19 @@ open_devices(
>  
>  static void
>  discard_devices(
> -	struct libxfs_xinit	*xi)
> +	struct libxfs_xinit	*xi,
> +	int			quiet)
>  {
>  	/*
>  	 * This function has to be called after libxfs has been initialized.
>  	 */
>  
>  	if (!xi->disfile)
> -		discard_blocks(xi->ddev, xi->dsize);
> +		discard_blocks(xi->ddev, xi->dsize, quiet);
>  	if (xi->rtdev && !xi->risfile)
> -		discard_blocks(xi->rtdev, xi->rtsize);
> +		discard_blocks(xi->rtdev, xi->rtsize, quiet);
>  	if (xi->logdev && xi->logdev != xi->ddev && !xi->lisfile)
> -		discard_blocks(xi->logdev, xi->logBBsize);
> +		discard_blocks(xi->logdev, xi->logBBsize, quiet);
>  }
>  
>  static void
> @@ -3749,7 +3773,7 @@ main(
>  	 * All values have been validated, discard the old device layout.
>  	 */
>  	if (discard && !dry_run)
> -		discard_devices(&xi);
> +		discard_devices(&xi, quiet);
>  
>  	/*
>  	 * we need the libxfs buffer cache from here on in.
> -- 
> 2.23.0
> 
