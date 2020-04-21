Return-Path: <SRS0=MzXO=6F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A9A4C54FCC
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Apr 2020 15:26:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB7E02071C
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Apr 2020 15:26:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VfE5CocC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgDUP0t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 11:26:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56556 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgDUP0t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Apr 2020 11:26:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03LFIUe2023952;
        Tue, 21 Apr 2020 15:26:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=PTq0ksDSmckxGaf58UJYInnMG2VeCAbp4kw0yKbBUNo=;
 b=VfE5CocCrSGRUX2069kUfOJd4YCZYT/cZLrb1ZP78HKausj3tN0lgajCKCpxb2aeikh4
 XfQqBypda1ncRwBZ9k/3oxuTfP1OI5pp7ZrhNq1cvME8o0AhnniOhKG7wPRXhF3nW7eL
 pybyeJxbinC/DsSMZl5aX8TFxEhVZMjv3PXQUnABksn+3SVqLh4kX+SmEU0Femo1Nf+t
 6+72S6zvFSp0uGBtAc1g36g2aWRGqXqpcifUElD/YBJGMj6KvlgAXnCqnS67Lj/+sLr0
 nbbggkOgau/nF2BrYOhtSgPaFmP1NOgO8xDjSq96HgB9kUPZ1Xq/obLNicloq144Dux0 +Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30fsgkwp2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 15:26:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03LFDQH2059511;
        Tue, 21 Apr 2020 15:26:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30gb90a66h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 15:26:43 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03LFQgCU022859;
        Tue, 21 Apr 2020 15:26:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 08:26:41 -0700
Date:   Tue, 21 Apr 2020 08:26:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/126: make blocktrash work reliably on attrleaf blocks
Message-ID: <20200421152637.GX6742@magnolia>
References: <20200421113643.24224-2-ailiop@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421113643.24224-2-ailiop@suse.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004210120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004210120
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 21, 2020 at 01:36:43PM +0200, Anthony Iliopoulos wrote:
> Running xfs/126 sometimes fails due to output mismatch. Due to the
> randomized nature of the test, periodically the selected bits are not
> relevant to the test, or the selected bits are not flipped. Supply an
> offset that is close to the start of the metadata block, so that the
> test will reliably corrupt the header.
> 
> Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
> Link: https://lore.kernel.org/linux-xfs/20200116160323.GC2149943@magnolia
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>

Seems fine to me...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  tests/xfs/126 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/126 b/tests/xfs/126
> index 4f9f8cf9..d01338c9 100755
> --- a/tests/xfs/126
> +++ b/tests/xfs/126
> @@ -72,7 +72,7 @@ echo "+ corrupt xattr"
>  loff=1
>  while true; do
>  	_scratch_xfs_db -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" | grep -q 'file attr block is unmapped' && break
> -	_scratch_xfs_db -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
> +	_scratch_xfs_db -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" -c "blocktrash -o 4 -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
>  	loff="$((loff + 1))"
>  done
>  
> -- 
> 2.26.2
> 
