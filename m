Return-Path: <SRS0=TFM3=YL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 163DECA9EA9
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Oct 2019 17:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCCCA21897
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Oct 2019 17:17:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SgSMf5ZR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393957AbfJRRRp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Oct 2019 13:17:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41450 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392037AbfJRRRp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Oct 2019 13:17:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9IHDmwr068848;
        Fri, 18 Oct 2019 17:17:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=paSHr/9BvPUzQLB9ZQtu71SOXlstNB4nJhrbDEukRHw=;
 b=SgSMf5ZRb8UNTisYbAJxCoP1KmKRRMiA0IZccPiTCdAsdegi1cJviRvH8csXgu/3XzCy
 1l16q6XSKpnKDR136LaSkGnzhE5hRJODJaIt4EDJy17UEj6VFwlzlffGdMGnAd+EUyo4
 2lpi60U1f6OWtTtP5bcKJG3P44L0kqU4MiGrxmdh3mHLSLFAruBF57QB4vcgdF6aUOL2
 2a/ajSSfV0NrL/3OM8CtfvdFmhBr8rhpWwRyHZLRHHnv6wOHjUhoIyVhu8LCw5tTheQr
 psQNXzSrnDR+rjs4u4/GLKiJfc7hBtYrtfkPmv04AbDAZlOKtmR0/0n6fEFwfRei40Bq 9w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vq0q4552k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 17:17:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9IHDBSa086950;
        Fri, 18 Oct 2019 17:17:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vq0dy7e3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 17:17:22 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9IHHMQR006706;
        Fri, 18 Oct 2019 17:17:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Oct 2019 17:17:22 +0000
Date:   Fri, 18 Oct 2019 10:17:20 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH REPOST 0/2] xfs: rely on minleft instead of total for
 bmbt res
Message-ID: <20191018171720.GB6719@magnolia>
References: <20190912143223.24194-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912143223.24194-1-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9414 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910180157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9414 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910180157
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 12, 2019 at 10:32:21AM -0400, Brian Foster wrote:
> Hi all,
> 
> This is a repost of a couple patches I posted a few months ago[1]. There
> are no changes other than a rebase to for-next. Any thoughts on these? I
> think Carlos had also run into some related generic/223 failures fairly
> recently...
> 
> Carlos,
> 
> Any chance you could give these a try?

Any progress on this in the last month?  I /think/ this is related to
the unaligned allocations that Dan's complaining about this morning.

--D

> Brian
> 
> [1] https://lore.kernel.org/linux-xfs/20190501140504.16435-1-bfoster@redhat.com/
> 
> Brian Foster (2):
>   xfs: drop minlen before tossing alignment on bmap allocs
>   xfs: don't set bmapi total block req where minleft is sufficient
> 
>  fs/xfs/libxfs/xfs_bmap.c | 13 +++++++++----
>  fs/xfs/xfs_bmap_util.c   |  4 ++--
>  fs/xfs/xfs_dquot.c       |  4 ++--
>  fs/xfs/xfs_iomap.c       |  4 ++--
>  fs/xfs/xfs_reflink.c     |  4 ++--
>  fs/xfs/xfs_rtalloc.c     |  3 +--
>  6 files changed, 18 insertions(+), 14 deletions(-)
> 
> -- 
> 2.20.1
> 
