Return-Path: <SRS0=POS4=YF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB81ECE58D
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Oct 2019 00:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BDBB214E0
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Oct 2019 00:36:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TeznJVk0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfJLAgd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Oct 2019 20:36:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56912 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfJLAgd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Oct 2019 20:36:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9C0U6VZ084999;
        Sat, 12 Oct 2019 00:36:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=9lteoEp4UqzEYXPSZuS/M8n8Fd73O3A62cq1nBRzLTg=;
 b=TeznJVk0jeoBkjyl8V8I1cbcvD+OYqB0xDHUibZJMPASVoRM11wEGZM0cCiSnI9PdH7f
 XEdrrB8LYLfrMCAKA1KT8leowZKQ4FY1u/VNMz8Wj3z2jw4tyI6XZBZitY648QMyI2H9
 FKnaDOF9UYYJQ+KnlsjRpTh76MVTcTTtFbSxHhlqOIgqQv1SDlF5saHF2nPBSonovoSz
 kOmcwswLDjfM4hn0+uNpjM3gPnfCYyt6uNKCHSNLZLYPVGjO0Dmq0SJBsQNOkLctlAQF
 5KohkpyyilJgO8ZnY4ni4925xM8QhM83CPbrNGpcZBL7EbqykTPoGxrmXPHQS9rpxNTf sA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vek4r4kj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Oct 2019 00:36:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9C0TQRe152197;
        Sat, 12 Oct 2019 00:36:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vk3xvh3eg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Oct 2019 00:36:27 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9C0aQSo022717;
        Sat, 12 Oct 2019 00:36:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Oct 2019 17:36:26 -0700
Date:   Fri, 11 Oct 2019 17:36:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: remove the unused XLOG_STATE_ALL and
 XLOG_STATE_UNUSED flags
Message-ID: <20191012003625.GO13108@magnolia>
References: <20191009142748.18005-1-hch@lst.de>
 <20191009142748.18005-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009142748.18005-7-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9407 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910120001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9407 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910120001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The subject line should say "XLOG_STATE_NOTUSED", not "XLOG_STATE_UNUSED".

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


On Wed, Oct 09, 2019 at 04:27:46PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log_priv.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 90e210e433cf..66bd370ae60a 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -49,8 +49,6 @@ static inline uint xlog_get_client_id(__be32 i)
>  #define XLOG_STATE_CALLBACK  0x0020 /* Callback functions now */
>  #define XLOG_STATE_DIRTY     0x0040 /* Dirty IC log, not ready for ACTIVE status*/
>  #define XLOG_STATE_IOERROR   0x0080 /* IO error happened in sync'ing log */
> -#define XLOG_STATE_ALL	     0x7FFF /* All possible valid flags */
> -#define XLOG_STATE_NOTUSED   0x8000 /* This IC log not being used */
>  
>  /*
>   * Flags to log ticket
> -- 
> 2.20.1
> 
