Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81FC5C433EF
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Nov 2021 22:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58EBC613A6
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Nov 2021 22:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhKGXAv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Nov 2021 18:00:51 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:43732 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231618AbhKGXAv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Nov 2021 18:00:51 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 705FE865486;
        Mon,  8 Nov 2021 09:58:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mjr6z-0068HA-OM; Mon, 08 Nov 2021 09:58:05 +1100
Date:   Mon, 8 Nov 2021 09:58:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     sandeen@redhat.com, xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH V3 RFC] xfsprogs: remove stubbed-out kernel functions out
 from xfs_shared.h
Message-ID: <20211107225805.GI449541@dread.disaster.area>
References: <389722a5-4b02-c76d-a5ac-d92d1e642b21@redhat.com>
 <fa2fe2c5-645b-6263-3493-b59b4d096488@redhat.com>
 <20211104223823.GF449541@dread.disaster.area>
 <0123f094-a073-0ba8-7cac-27394193d277@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0123f094-a073-0ba8-7cac-27394193d277@sandeen.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=618859fe
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=kj9zAlcOel0A:10 a=vIxV3rELxO4A:10 a=7-415B0cAAAA:8
        a=SWQqYkDptuFE033Nv2UA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 05, 2021 at 11:40:57AM -0500, Eric Sandeen wrote:
> On 11/4/21 5:38 PM, Dave Chinner wrote:
> 
> > With those changes, we end up with some new stubs in libxfs_priv.h
> > and two places where we need #ifdef __KERNEL__ in xfs_ag.[ch]. Most
> > of the mess in this patch goes away....
> > 
> > Cheers,
> > 
> > Dave.
> Ok.
> 
> I will split this up into the right patch granularity, but is this the
> endpoint you're looking for?  One #ifdef in each of xfs_ag.[ch], two total.

Yup.

> The delayed work init/cancel assymmetry is a little odd, but I'll
> get over it.
> 
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index 15bae1ff..2ca3b9b2 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -673,6 +673,9 @@ static inline void xfs_iunlink_destroy(struct xfs_perag *pag) { }
>  xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *mp,
>  		xfs_agnumber_t agcount);
> +/* Faked up kernel bits */
> +#define cancel_delayed_work_sync(work) do { } while(0)

Comment is completely redundant. libxfs_priv.h is entirely for
"faked up kernel bits".

I'd also put this up near the top of the file near the definition of
struct iomap, not place it randomly in amongst a bunch of XFS
definitions.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
