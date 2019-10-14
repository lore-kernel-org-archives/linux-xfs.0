Return-Path: <SRS0=3dSt=YH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF157C4CECE
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 17:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4DE521835
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 17:12:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FiimRFr/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387993AbfJNRMo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Oct 2019 13:12:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50466 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732046AbfJNRMn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Oct 2019 13:12:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9EH9TRq050261;
        Mon, 14 Oct 2019 17:12:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=vDfwWc6+jOeS86Dg1iiwSK0OgfRzyBRt4+oSbPytxXs=;
 b=FiimRFr/iK7wLkcpLMdw5aWKivXdPFZp8RS7lDzRUajFdbX/RyLivpjiSpVa4XVzraAx
 vhTxcZ29Y73//xJ9NA/Yjqf2zyJWR5Wep+uCEky0961ZyIBHRi8Gn41YaThnd2zHucOb
 F+Ggh07L0mFxhWVBco08BZOjgmaJvVQgElCGAHLPrYaAJWYDKJZn6C7WabUxKqKxv3BK
 oZpjW6keMba2mH3k3okhc3p6ATu7+kgmBEuWk2wB4nADf3gljub+PTSKc8wf8+r7YaJ+
 2x3AEdApryZNTYI8NdOIobM6QFpZzcsiMqmM1ACespx8rIpqfOa05AAMPhD+JmiySpOP qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vk68uac29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 17:12:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9EH8ZpA050823;
        Mon, 14 Oct 2019 17:10:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vks075nac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 17:10:38 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9EHAc78014927;
        Mon, 14 Oct 2019 17:10:38 GMT
Received: from localhost (/10.159.144.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Oct 2019 17:10:36 +0000
Date:   Mon, 14 Oct 2019 10:10:35 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: pass the correct flag to xlog_write_iclog
Message-ID: <20191014171035.GU13108@magnolia>
References: <20191009142748.18005-1-hch@lst.de>
 <20191009142748.18005-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009142748.18005-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910140145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910140145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 04:27:41PM +0200, Christoph Hellwig wrote:
> xlog_write_iclog expects a bool for the second argument.  While any
> non-0 value happens to work fine this makes all calls consistent.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index a2beee9f74da..cd90871c2101 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1735,7 +1735,7 @@ xlog_write_iclog(
>  		 * the buffer manually, the code needs to be kept in sync
>  		 * with the I/O completion path.
>  		 */
> -		xlog_state_done_syncing(iclog, XFS_LI_ABORTED);
> +		xlog_state_done_syncing(iclog, true);
>  		up(&iclog->ic_sema);
>  		return;
>  	}
> -- 
> 2.20.1
> 
