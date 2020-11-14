Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A16C5519F
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 17:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 968F622254
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 17:58:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OZlO/Oy4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgKNR5q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Nov 2020 12:57:46 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59870 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgKNR5m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Nov 2020 12:57:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AEHnxK2100720;
        Sat, 14 Nov 2020 17:57:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ngWe9bkFYOPZCiLBPbVjQ40La7kysai2ALrFIof8jgU=;
 b=OZlO/Oy4bQhKZDCb/ctsJAhahF1aUXXAINlJfdPnyUK8/sZHV6SKyb35mUR2iIzgEfER
 PuImsnkqwg/LJjxV/gbMQjKo3IRtPerpU6d8QV+sh+GR/+cVmrpOVyCCaKyyESv31i0x
 PmOZGaKRQlVZNxOYBz764kEXiQJHUd9XaIOBxzmxGy6IEs2hsNinOHUkPjtFzn8U6Dyq
 /audEeMGCCqipPc4l64BUWy8ebbc2vZzhLMdeRS/Yu94MVRz1qNXqxI5AyucYMnC0mH5
 6NEeCDNwcJgeNGdbXK+/7kyjX0HwG80E8BN/PqekeOfeeIWTU14q5EYyBpEUGsZcoNYj qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34t76kh3cf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 14 Nov 2020 17:57:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AEHpI3h183244;
        Sat, 14 Nov 2020 17:57:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34t6jhcacv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Nov 2020 17:57:39 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AEHvcat008683;
        Sat, 14 Nov 2020 17:57:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 14 Nov 2020 09:57:38 -0800
Date:   Sat, 14 Nov 2020 09:57:38 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_io: fix up typos in manpage
Message-ID: <20201114175738.GP9695@magnolia>
References: <e72196ec-314e-5ba6-aeb9-4cf637f4c95e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e72196ec-314e-5ba6-aeb9-4cf637f4c95e@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9805 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 suspectscore=1 spamscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011140121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9805 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011140121
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 14, 2020 at 09:43:52AM -0600, Eric Sandeen wrote:
> We go in reverse direction, not reserve direction.
> We go in forward direction, not forwards direction.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reserve all forwards,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index caf3f15..1103dc4 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -219,10 +219,10 @@ dump the contents of the buffer after reading,
>  by default only the count of bytes actually read is dumped.
>  .TP
>  .B \-F
> -read the buffers in a forwards sequential direction.
> +read the buffers in a forward sequential direction.
>  .TP
>  .B \-B
> -read the buffers in a reserve sequential direction.
> +read the buffers in a reverse sequential direction.
>  .TP
>  .B \-R
>  read the buffers in the give range in a random order.
> @@ -305,10 +305,10 @@ is used when the data to write is not coming from a file.
>  The default buffer fill pattern value is 0xcdcdcdcd.
>  .TP
>  .B \-F
> -write the buffers in a forwards sequential direction.
> +write the buffers in a forward sequential direction.
>  .TP
>  .B \-B
> -write the buffers in a reserve sequential direction.
> +write the buffers in a reverse sequential direction.
>  .TP
>  .B \-R
>  write the buffers in the give range in a random order.
> 
