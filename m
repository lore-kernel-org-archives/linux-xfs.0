Return-Path: <SRS0=eBbo=5M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF1B6C43331
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 15:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD2E520578
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 15:32:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q57t8Pz2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgC0PcN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Mar 2020 11:32:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40972 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgC0PcN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Mar 2020 11:32:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02RFTkmK127617;
        Fri, 27 Mar 2020 15:32:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=aY6ijuHuvl1Beux9wB7W0D09OZduY4DoRbd9ZeRjNIo=;
 b=q57t8Pz2fDvoxVeq3pu4P38Mtn7FzzOjagfzJ3L4+OgoVMRohWp+o+xfuzmQgEzxnen3
 iGM6ADA2LJ+GTCJ+qb7NBL4CS91Zza90SzQu0pUPXEUNu1kHK4xCmXzMRoTbnkKsor3b
 J2CdqbjboNvoxyFhkEo9MXMCPenriA6fgIMfixMZIUxi21SM0rqi+DdVgIiDHQxAuDr9
 PBOwbW3H6tAAJJi6sccQuFs71S5F6hgTvXb/AMX7zYU2ifCV6A0iUOJBkvc1NrzOvjpl
 99RUkDf5DtEsLSrxz4Sn6+7QlU6DWFTARx29OmykUvGCZMHu8jRlZiNdfJaLENPRTQ2l Sw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 301459bsx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 15:32:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02RFQcdY015715;
        Fri, 27 Mar 2020 15:32:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2yxw4w2udg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 15:32:08 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02RFW7LP005665;
        Fri, 27 Mar 2020 15:32:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 27 Mar 2020 08:32:07 -0700
Date:   Fri, 27 Mar 2020 08:32:05 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] xfs: a couple AIL pushing trylock fixes
Message-ID: <20200327153205.GH29339@magnolia>
References: <20200326131703.23246-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326131703.23246-1-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9573 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9573 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 impostorscore=0 mlxscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 26, 2020 at 09:17:01AM -0400, Brian Foster wrote:
> Hi all,
> 
> Here's a couple more small fixes that fell out of the auto relog work.
> The dquot issue is actually a deadlock vector if we randomly relog dquot
> buffers (which is only done for test purposes), but I figure we should
> handle dquot buffers similar to how inode buffers are handled. Thoughts,
> reviews, flames appreciated.

Oops, I missed this one, will review now...

Do you think there needs to be an explicit testcase for this?  Or are
the current generic/{388,475} good enough?  I'm pretty sure I've seen
this exact deadlock on them every now and again, so we're probably
covered.

--D


> Brian
> 
> Brian Foster (2):
>   xfs: trylock underlying buffer on dquot flush
>   xfs: return locked status of inode buffer on xfsaild push
> 
>  fs/xfs/xfs_dquot.c      |  6 +++---
>  fs/xfs/xfs_dquot_item.c |  3 ++-
>  fs/xfs/xfs_inode_item.c |  3 ++-
>  fs/xfs/xfs_qm.c         | 14 +++++++++-----
>  4 files changed, 16 insertions(+), 10 deletions(-)
> 
> -- 
> 2.21.1
> 
