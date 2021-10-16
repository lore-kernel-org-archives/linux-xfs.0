Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80FC8C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Oct 2021 06:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F718610D2
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Oct 2021 06:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236973AbhJPGb4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Oct 2021 02:31:56 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53605 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233802AbhJPGb4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Oct 2021 02:31:56 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6C5B18879F6;
        Sat, 16 Oct 2021 17:29:44 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mbdCR-006oJ0-9d; Sat, 16 Oct 2021 17:29:43 +1100
Date:   Sat, 16 Oct 2021 17:29:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@sandeen.net>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] xfsprogs for-next rebased to b4c6731a
Message-ID: <20211016062943.GX2361455@dread.disaster.area>
References: <40ae0dd3-aeea-344c-ac6b-e76b42892e86@sandeen.net>
 <d162a7f8-4101-6021-684b-275f894454be@sandeen.net>
 <20211016041017.GS24307@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211016041017.GS24307@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=616a7159
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=8nJEP1OIZ-IA:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=66iv1fFjs96y70Du3V8A:9 a=wPNLvfGTeEIA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 15, 2021 at 09:10:17PM -0700, Darrick J. Wong wrote:
> On Fri, Oct 15, 2021 at 03:32:41PM -0500, Eric Sandeen wrote:
> > On 10/15/21 2:42 PM, Eric Sandeen wrote:
> > > Hi folks,
> > > 
> > > The for-next branch of the xfsprogs repository at:
> > > 
> > >      git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> > > 
> > > has just been updated.
> > > 
> > > Patches often get missed, so please check if your outstanding
> > > patches were in this update. If they have not been in this update,
> > > please resubmit them to linux-xfs@vger.kernel.org so they can be
> > > picked up in the next update.
> > > 
> > > This is really just the libxfs-5.14 sync (finally!).  Big thanks
> > > to chandan, djwong, dchinner who all helped significantly with what
> > > was a much more challenging libxfs sync this time.
> > > 
> > > Odds are this will be the bulk of the final 5.14 release. I will just
> > > add Darrick's deprecation warning, and anything else I get reminded
> > > of in the next week.  :)
> > 
> > I missed Derrick's "libxfs: fix crash on second attempt to initialize library"
> > because my old userspace rcu library did not exhibit the problem. :/
> > 
> > Rather than leave a few dozen commits with regressed behavior as a bisect bomb,
> > I have force-pushed and anybody who pulled in the last hour will need to rebase.
> > Sorry about that!
> 
> Er... /me notices the following discrepancy between the kernel and
> xfsprogs in libxfs/xfs_shared.h:
> 
> --- a/libxfs/xfs_shared.h
> +++ b/libxfs/xfs_shared.h
> @@ -174,24 +174,4 @@ struct xfs_ino_geometry {
>  
>  };
>  
> -/* Faked up kernel bits */
> -struct rb_root {
> -};
> -
> -#define RB_ROOT                (struct rb_root) { }
> -
> -typedef struct wait_queue_head {
> -} wait_queue_head_t;
> -
> -#define init_waitqueue_head(wqh)       do { } while(0)
> -
> -struct rhashtable {
> -};
> -
> -struct delayed_work {
> -};
> -
> -#define INIT_DELAYED_WORK(work, func)  do { } while(0)
> -#define cancel_delayed_work_sync(work) do { } while(0)
> -
>  #endif /* __XFS_SHARED_H__ */

Shouldn't those be libxfs/libxfs_priv.h along with all the other
faked up kernel bits?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
