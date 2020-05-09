Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2A4C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:13:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 556732192A
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:13:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PBM/DLpS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbgEIRNa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:13:30 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50348 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgEIRN3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:13:29 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049H9f30131544;
        Sat, 9 May 2020 17:13:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=j7oA8ngQzgpc4U5rAk3CjsqRJUI/J5v/OqelR88h+PY=;
 b=PBM/DLpSABqkeGFfVQwd/SoY9rYyLYvXciG0zX88CQEc3u7dC4Tf+P5F4HI5bTFYpkIJ
 2qMJnuWusU8XFcaVMIyyQyc8X9/K2TBP7GroTPK8JIjLkus52VJl2LuTeNiMrNVvIyn7
 kwXQ+xWhBoJDG1cOwlrXsXxTRJL+mOP11G+5Uoq7sGeGx1SWzhm5x704SDMX2lyQASbB
 0ZGVWENDkPRGH7/9se59F/9zXNN3i/rpGR6Z/bewHA2IhCF971KyveRA2geJ0p5vWOri
 XKFUn8DUiMiyZ/nPaeRCFe+jGp8gReySM4N4gC+0E8rIB+UMpMacn2UkEx0cAZJ+Ji+2 Hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30x0gh80s3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 17:13:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049H7bXB015804;
        Sat, 9 May 2020 17:11:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30wwxb6tux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 17:11:25 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 049HBOjU001711;
        Sat, 9 May 2020 17:11:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 10:11:23 -0700
Date:   Sat, 9 May 2020 10:11:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] metadump: small cleanup for process_inode
Message-ID: <20200509171122.GV6714@magnolia>
References: <20200509170125.952508-1-hch@lst.de>
 <20200509170125.952508-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509170125.952508-9-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=1 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 suspectscore=1 priorityscore=1501 malwarescore=0 clxscore=1015 mlxscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 07:01:25PM +0200, Christoph Hellwig wrote:
> Shorten a conditional to a single line.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  db/metadump.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 14e7eaa7..e5cb3aa5 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2415,8 +2415,7 @@ process_inode(
>  	nametable_clear();
>  
>  	/* copy extended attributes if they exist and forkoff is valid */
> -	if (success &&
> -	    XFS_DFORK_DSIZE(dip, mp) < XFS_LITINO(mp)) {
> +	if (success && XFS_DFORK_DSIZE(dip, mp) < XFS_LITINO(mp)) {
>  		attr_data.remote_val_count = 0;
>  		switch (dip->di_aformat) {
>  			case XFS_DINODE_FMT_LOCAL:
> -- 
> 2.26.2
> 
