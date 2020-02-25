Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 965B1C35E04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 15:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 697D320CC7
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 15:44:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ja9V7UPI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgBYPoI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 10:44:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:50692 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgBYPoH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 10:44:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PFhLDd146036;
        Tue, 25 Feb 2020 15:44:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=4Wl6toVwSlhLu6MPwxzK75ksxa4IcslNBgkeMiswcaY=;
 b=ja9V7UPIiGVBhN41YW/onNGP5HmjrQiPRm350V0hnPK0PzMiIHBu957Dg4PQned7sqU4
 gKMDvt4KGRUfjGggrckvJ4TC0LZBL9/TOa62VbYQbtlg+Fk2UaBSC3tUXaSvmvtMTc3M
 BeaLU1QKHOdRpyMxQZMvtRx0PCrgmybHnkzFSuK1QC3hF+U9gj/QsCRG7xotEYeOWhp4
 ZGuo3B2hxFaQxR+6CgJqGjHM5uiT0CDt3cfeCn8vHcEhF1U1C2e4Kekm6bHh1qtiaq93
 Ax0E3Y1tP83dvsHv+5jr/YuwfhgmR49vs4vZDIEk5YNRNQ3xureOeQ3ckTISu1M0dmTw Xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2yd0njj8cd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 15:44:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PFg8F7051671;
        Tue, 25 Feb 2020 15:44:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2yd09at6u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 15:44:04 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01PFi3AJ014085;
        Tue, 25 Feb 2020 15:44:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 07:44:03 -0800
Date:   Tue, 25 Feb 2020 07:44:02 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Jules Irenge <jbi.octave@gmail.com>
Cc:     boqun.feng@gmail.com, linux-kernel@vger.kernel.org,
        "supporter:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 03/30] xfs: Add missing annotation to xfs_ail_check()
Message-ID: <20200225154402.GD6748@magnolia>
References: <0/30>
 <20200223231711.157699-1-jbi.octave@gmail.com>
 <20200223231711.157699-4-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223231711.157699-4-jbi.octave@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250122
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 23, 2020 at 11:16:44PM +0000, Jules Irenge wrote:
> Sparse reports a warning at xfs_ail_check()
> 
> warning: context imbalance in xfs_ail_check() - unexpected unlock
> 
> The root cause is the missing annotation at xfs_ail_check()
> 
> Add the missing __must_hold(&ailp->ail_lock) annotation
> 
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>

Seems reasonable, though I'm wondering if this is a treewide change you
seek to apply yourself, or merely a large patch series to merge through
the individual subsystem maintainers?

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_trans_ail.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 00cc5b8734be..58d4ef1b4c05 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -32,6 +32,7 @@ STATIC void
>  xfs_ail_check(
>  	struct xfs_ail		*ailp,
>  	struct xfs_log_item	*lip)
> +	__must_hold(&ailp->ail_lock)
>  {
>  	struct xfs_log_item	*prev_lip;
>  	struct xfs_log_item	*next_lip;
> -- 
> 2.24.1
> 
