Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 566D4C54EEB
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 17:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 322ED214D8
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 17:58:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YHNXeFGJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgD0R6e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 13:58:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48282 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgD0R6e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 13:58:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RHtPnn097329;
        Mon, 27 Apr 2020 17:58:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=WPcFezZzZSErkUsq7mRth/EeqoSsONtvTp9wZ0qUVwc=;
 b=YHNXeFGJbb+HAHWlQspoIhsr5JxwpVwDUquRx68plkU9TS1IgJrMJu3BoXFITi/P/j5M
 V8PRJmadEDGuymvAlib6vVqBw2WkBxVG+VSIbCLq11A9Y0Gcpgkj1D3WoZ/TKPLSZl2f
 ZrcObXGp0RmFoz7CGxvNdME2qxxZbXZqIpXj2Hu2XjyM0optQSNRsdAuyCennwhQdXet
 rnlNDD0KUNquhwTr9E94WHymGdEiFZ0hvk1YG6EpNtVxgjP+OC5jtm6VM6gz0ni37uKD
 rI1x+yRVuBdUzv9rSEqJrSktxuudqS7SpKCcyo0cXFW71ltxo/S0RTwf8p/kG45JytNQ 4A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30p01nhpft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 17:58:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RHuune046925;
        Mon, 27 Apr 2020 17:58:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30my0a4shq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 17:58:30 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03RHwTBZ002247;
        Mon, 27 Apr 2020 17:58:29 GMT
Received: from localhost (/10.159.145.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 10:58:29 -0700
Date:   Mon, 27 Apr 2020 10:58:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs/126: make sure we corrupt the attr leaf in a
 detectable way
Message-ID: <20200427175828.GN6740@magnolia>
References: <158768467175.3019327.8681440148230401150.stgit@magnolia>
 <158768468419.3019327.7338437062843317243.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158768468419.3019327.7338437062843317243.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=1 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=1 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 23, 2020 at 04:31:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Try harder to fuzz the attr leaf so this consistently trips a verifier.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

DOH, NAK on this one, you might as well take "xfs/126: make blocktrash
work reliably on attrleaf blocks" from Anthony Iliopoulos.

--D

> ---
>  tests/xfs/126 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/126 b/tests/xfs/126
> index 4f9f8cf9..0d497779 100755
> --- a/tests/xfs/126
> +++ b/tests/xfs/126
> @@ -72,7 +72,7 @@ echo "+ corrupt xattr"
>  loff=1
>  while true; do
>  	_scratch_xfs_db -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" | grep -q 'file attr block is unmapped' && break
> -	_scratch_xfs_db -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
> +	_scratch_xfs_db -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" -c "blocktrash -x 4096 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
>  	loff="$((loff + 1))"
>  done
>  
> 
