Return-Path: <SRS0=UWJz=XS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C600C432C1
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Sep 2019 22:34:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 131E821D7A
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Sep 2019 22:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387989AbfIWWe6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Sep 2019 18:34:58 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:60467 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2503353AbfIWWe6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Sep 2019 18:34:58 -0400
Received: from dread.disaster.area (pa49-181-226-196.pa.nsw.optusnet.com.au [49.181.226.196])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 31B3843E5F2;
        Tue, 24 Sep 2019 08:34:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iCWuz-0005Mh-2w; Tue, 24 Sep 2019 08:34:53 +1000
Date:   Tue, 24 Sep 2019 08:34:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: log proper length of superblock
Message-ID: <20190923223453.GD16973@dread.disaster.area>
References: <93a080c7-5eb8-8ffe-ae5b-5152a7713828@redhat.com>
 <16c64c69-adbb-d9ec-7630-05cd44286744@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16c64c69-adbb-d9ec-7630-05cd44286744@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=dRuLqZ1tmBNts2YiI0zFQg==:117 a=dRuLqZ1tmBNts2YiI0zFQg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=zrTyLRBc9icR_MRU328A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 23, 2019 at 04:44:14PM -0500, Eric Sandeen wrote:
> On 9/23/19 4:18 PM, Eric Sandeen wrote:
> > xfs_trans_log_buf takes first byte, last byte as args.  In this
> > case, it should be from 0 to sizeof() - 1.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Well spotted!

> if you want, you could put a 
> 
> Fixes: 4d11a40239405 ("xfs: remove bitfield based superblock updates")
> 
> on this, I guess it was technically a regression in v4.0, even
> if it has no net effect like last time...

Yeah, it doesn't expose any issue at all. The buffer logging rounds
out to CHUNK_SIZE - 128 bytes - and when we look at the size of the
superblock w/ pahole:

struct xfs_dsb {
        __be32                     sb_magicnum;          /*     0     4 */
	__be32                     sb_blocksize;         /*     4     4 */
....
        uuid_t                     sb_meta_uuid;         /*   248    16 */

        /* size: 264, cachelines: 5, members: 55 */
        /* last cacheline: 8 bytes */
};

Well be logging the first three chunks in the sb regardless of
whether we pass 263 or 264 as the size of the modified area to
xfs_trans_log_buf() (i.e. first 384 bytes of the buffer get logged
either way).

So, yeah, the code is wrong, but it does not result in any
observable incorrect behaviour. That said, it still needs fixing.

> -Eric
> 
> > ---
> > 
> > I should have audited everything when I sent the last patch for
> > this type of error.  hch suggested changing the interface but it's
> > all pretty grotty and I'm hesitant for now.
> > 
> > I think maybe a new/separate function to take start, len might
> > make sense so that not every caller needs to be munged into a new
> > format, because some of the existing callers would then become more
> > complex...
> > 
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index a08dd8f40346..ac6cdca63e15 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -928,7 +928,7 @@ xfs_log_sb(
> >  
> >  	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
> >  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
> > -	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb));
> > +	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb) - 1);
> >  }
> >  
> >  /*

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-Dave.
-- 
Dave Chinner
david@fromorbit.com
