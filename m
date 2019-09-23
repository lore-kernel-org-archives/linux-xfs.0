Return-Path: <SRS0=UWJz=XS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B31C432C1
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Sep 2019 23:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D28B21D56
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Sep 2019 23:49:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BkYIa1Ru"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391394AbfIWXtg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Sep 2019 19:49:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36356 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729276AbfIWXtg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Sep 2019 19:49:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8NNn72G189454;
        Mon, 23 Sep 2019 23:49:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=tXe/PBmavDBwavwGQejf5kjTq/a5EBa4fxPCqkp6jgA=;
 b=BkYIa1RuSVGb8zyoJsKvTD3awdJIut8uvImGQ0aBr1OjA5lKJxCqL3Ywp0BjFfNnCWYj
 zwg/tN79iD525pXyePekMn9HvTiRcqY34SwJx/zOpHMY0YmcbQqO1053tsi0vVuVR670
 CYnxhIMBhZ+bae0EpipcnA7aMgQGKkIRj3QWKzRWKvkwNU87IWRCwY6Q+yZCaEIZws8B
 pgrOZcAAarNRMpWgHBnPlpOxzVgrD+Mdy608VVf6+qyJprN8UmtaiRjvR0SfSqNG0qeH
 H0TNvm0J46Alj/LEdGn7Yg5QDzqpdrZ/dznhr22cU21jUATUn2n72XyO/zL0OC36v21Y Mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2v5b9tj69t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Sep 2019 23:49:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8NNnGRT071675;
        Mon, 23 Sep 2019 23:49:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2v6yvnw297-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Sep 2019 23:49:18 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8NNmaPZ004595;
        Mon, 23 Sep 2019 23:48:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Sep 2019 16:48:36 -0700
Date:   Mon, 23 Sep 2019 16:48:35 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: log proper length of superblock
Message-ID: <20190923234835.GU2229799@magnolia>
References: <93a080c7-5eb8-8ffe-ae5b-5152a7713828@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93a080c7-5eb8-8ffe-ae5b-5152a7713828@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909230204
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909230204
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 23, 2019 at 04:18:44PM -0500, Eric Sandeen wrote:
> xfs_trans_log_buf takes first byte, last byte as args.  In this
> case, it should be from 0 to sizeof() - 1.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> I should have audited everything when I sent the last patch for
> this type of error.  hch suggested changing the interface but it's
> all pretty grotty and I'm hesitant for now.
> 
> I think maybe a new/separate function to take start, len might
> make sense so that not every caller needs to be munged into a new
> format, because some of the existing callers would then become more
> complex...
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index a08dd8f40346..ac6cdca63e15 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -928,7 +928,7 @@ xfs_log_sb(
>  
>  	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
> -	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb));
> +	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb) - 1);
>  }
>  
>  /*
> 
