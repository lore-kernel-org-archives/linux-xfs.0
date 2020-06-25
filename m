Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02E01C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 18:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC95D206BE
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 18:51:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YPKqmMuC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405875AbgFYSvp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 14:51:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52386 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405853AbgFYSvp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 14:51:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PIftsV071319;
        Thu, 25 Jun 2020 18:50:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=9RCC71majlIfD6FawW7ZnshWLRSgVrlkvbgIdAMoVZw=;
 b=YPKqmMuCzSeibFuJ2EeAZ4gdRQIqyXiRa5KI72AzjCKtkQeRVrkm7D7mtr/XwXXk3sgG
 b4Kp/kXbfDmv3EJdk+QuOx1DrtiJLx+QNbR+/ld1Ahx4hAGSEQbn5IYiIjl5ROTMY/zX
 kPx9W79pH2gxgDfL4KWPIFMize8ZwgPIyPwgp6UCGn5aaVOWpV/JbZ/SNVAkzjHGHcjt
 d3NfydLfaKqpjd5N96cOMwrRJUMDrokhUmYa9M2IReA1QbonzF3j8W+iQGBvjmFlbhS/
 8rQh7vxZ4N/mhY39jOVxX64bt1qXZHRjnYn9fT0hdQMUT+/AaiUct6sMNFiu2ubohQAU pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31uustt77f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 25 Jun 2020 18:50:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PIi0fM071227;
        Thu, 25 Jun 2020 18:48:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31uur1n5ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 18:48:36 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05PImYeM018585;
        Thu, 25 Jun 2020 18:48:34 GMT
Received: from localhost (/10.159.246.176)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 18:48:34 +0000
Date:   Thu, 25 Jun 2020 11:48:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>,
        Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH 0/6] Overhaul memalloc_no*
Message-ID: <20200625184832.GP7606@magnolia>
References: <20200625113122.7540-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625113122.7540-1-willy@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=2 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006250112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 cotscore=-2147483648 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=2 priorityscore=1501 lowpriorityscore=0 clxscore=1011
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006250112
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 25, 2020 at 12:31:16PM +0100, Matthew Wilcox (Oracle) wrote:
> I want a memalloc_nowait like we have memalloc_noio and memalloc_nofs
> for an upcoming patch series, and Jens also wants it for non-blocking
> io_uring.  It turns out we already have dm-bufio which could benefit
> from memalloc_nowait, so it may as well go into the tree now.
> 
> The biggest problem is that we're basically out of PF_ flags, so we need
> to find somewhere else to store the PF_MEMALLOC_NOWAIT flag.  It turns
> out the PF_ flags are really supposed to be used for flags which are
> accessed from other tasks, and the MEMALLOC flags are only going to
> be used by this task.  So shuffling everything around frees up some PF
> flags and generally makes the world a better place.

So, uh, how does this intersect with the patch "xfs: reintroduce
PF_FSTRANS for transaction reservation recursion protection" that
re-adds PF_TRANS because uh I guess we lost some subtlety or another at
some point?

I don't have any strong opinion on this series one way or another, but
seeing as that patch was generating discussion about how PF_MEMALLOC_NO*
is not quite the same as PF_TRANS, I kinda want all these competing PF
tweaks and reworks to come together into a single series to review,
rather than the four(?) different people submitting conflicting changes.

[adding Yafang Shao to cc]

--D

> Patch series also available from
> http://git.infradead.org/users/willy/linux.git/shortlog/refs/heads/memalloc
> 
> Matthew Wilcox (Oracle) (6):
>   mm: Replace PF_MEMALLOC_NOIO with memalloc_noio
>   mm: Add become_kswapd and restore_kswapd
>   xfs: Convert to memalloc_nofs_save
>   mm: Replace PF_MEMALLOC_NOFS with memalloc_nofs
>   mm: Replace PF_MEMALLOC_NOIO with memalloc_nocma
>   mm: Add memalloc_nowait
> 
>  drivers/block/loop.c           |  3 +-
>  drivers/md/dm-bufio.c          | 30 ++++--------
>  drivers/md/dm-zoned-metadata.c |  5 +-
>  fs/iomap/buffered-io.c         |  2 +-
>  fs/xfs/kmem.c                  |  2 +-
>  fs/xfs/libxfs/xfs_btree.c      | 14 +++---
>  fs/xfs/xfs_aops.c              |  4 +-
>  fs/xfs/xfs_buf.c               |  2 +-
>  fs/xfs/xfs_linux.h             |  6 ---
>  fs/xfs/xfs_trans.c             | 14 +++---
>  fs/xfs/xfs_trans.h             |  2 +-
>  include/linux/sched.h          |  7 +--
>  include/linux/sched/mm.h       | 84 ++++++++++++++++++++++++++--------
>  kernel/sys.c                   |  8 ++--
>  mm/vmscan.c                    | 16 +------
>  15 files changed, 105 insertions(+), 94 deletions(-)
> 
> -- 
> 2.27.0
> 
