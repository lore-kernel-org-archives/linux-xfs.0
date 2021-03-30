Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83523C433C1
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 22:27:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46D60619CD
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 22:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbhC3W1L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 18:27:11 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51899 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232924AbhC3W0o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 18:26:44 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1F724828CB8;
        Wed, 31 Mar 2021 09:26:43 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lRMos-008dj7-FY; Wed, 31 Mar 2021 09:26:42 +1100
Date:   Wed, 31 Mar 2021 09:26:42 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: Re: [PATCH v3 3/8] repair: Protect bad inode list with mutex
Message-ID: <20210330222642.GW63242@dread.disaster.area>
References: <20210330142531.19809-1-hsiangkao@aol.com>
 <20210330142531.19809-4-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330142531.19809-4-hsiangkao@aol.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=KKCP7FgTxQVHYeaZp9YA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 10:25:26PM +0800, Gao Xiang wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To enable phase 6 parallelisation, we need to protect the bad inode
> list from concurrent modification and/or access. Wrap it with a
> mutex and clean up the nasty typedefs.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  repair/dir2.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index b6a8a5c40ae4..c1d262fb1207 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -26,6 +26,7 @@ struct dir2_bad {
>  };
>  
>  static struct dir2_bad	dir2_bad;
> +pthread_mutex_t		dir2_bad_lock = PTHREAD_MUTEX_INITIALIZER;
>  
>  static void
>  dir2_add_badlist(
> @@ -33,6 +34,7 @@ dir2_add_badlist(
>  {
>  	xfs_ino_t	*itab;
>  
> +	pthread_mutex_lock(&dir2_bad_lock);
>  	itab = realloc(dir2_bad.itab, (dir2_bad.nr + 1) * sizeof(xfs_ino_t));
>  	if (!ino) {
>  		do_error(
> @@ -42,18 +44,25 @@ _("malloc failed (%zu bytes) dir2_add_badlist:ino %" PRIu64 "\n"),
>  	}
>  	itab[dir2_bad.nr++] = ino;
>  	dir2_bad.itab = itab;
> +	pthread_mutex_unlock(&dir2_bad_lock);

Putting a global mutex around a memory allocation like this will
really hurt concurrency. This turns the add operation into a very
complex operation instead of the critical section being just a few
instructions long.

The existing linked list code is far more efficient in this case
because the allocation of the structure tracking the bad inode is
done outside the global lock, and only the list_add() operation is
done within the critical section.

Again, an AVL or radix tree can do the tracking structure allocation
outside the add operation, and with an AVL tree there are no
allocations needed to do the insert operation. A radix tree will
amortise the allocations its needs over many inserts that don't need
allocation. However, I'd be tending towards using an AVL tree here
over a radix tree because bad inodes will be sparse and that's the
worst case for radix tree indexing w.r.t to requiring allocation
during insert...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
