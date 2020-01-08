Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB5FC282DD
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 22:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED19D2053B
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 22:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgAHWmV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 17:42:21 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50885 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726548AbgAHWmV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jan 2020 17:42:21 -0500
Received: from dread.disaster.area (pa49-180-68-255.pa.nsw.optusnet.com.au [49.180.68.255])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DB8C0821417;
        Thu,  9 Jan 2020 09:42:17 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ipK1o-0006Il-GX; Thu, 09 Jan 2020 09:42:16 +1100
Date:   Thu, 9 Jan 2020 09:42:16 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: introduce XFS_MAX_FILEOFF
Message-ID: <20200108224216.GH23128@dread.disaster.area>
References: <157845705246.82882.11480625967486872968.stgit@magnolia>
 <157845705884.82882.5003824524655587269.stgit@magnolia>
 <20200108204041.GF23128@dread.disaster.area>
 <20200108223238.GK5552@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108223238.GK5552@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=sbdTpStuSq8iNQE8viVliQ==:117 a=sbdTpStuSq8iNQE8viVliQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=ueTTxCAjp1a8ooercxkA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 08, 2020 at 02:32:38PM -0800, Darrick J. Wong wrote:
> On Thu, Jan 09, 2020 at 07:40:41AM +1100, Dave Chinner wrote:
> > On Tue, Jan 07, 2020 at 08:17:38PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Introduce a new #define for the maximum supported file block offset.
> > > We'll use this in the next patch to make it more obvious that we're
> > > doing some operation for all possible inode fork mappings after a given
> > > offset.  We can't use ULLONG_MAX here because bunmapi uses that to
> > > detect when it's done.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_format.h |    1 +
> > >  fs/xfs/xfs_reflink.c       |    3 ++-
> > >  2 files changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > > index 1b7dcbae051c..c2976e441d43 100644
> > > --- a/fs/xfs/libxfs/xfs_format.h
> > > +++ b/fs/xfs/libxfs/xfs_format.h
> > > @@ -1540,6 +1540,7 @@ typedef struct xfs_bmdr_block {
> > >  #define BMBT_BLOCKCOUNT_BITLEN	21
> > >  
> > >  #define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
> > > +#define XFS_MAX_FILEOFF		(BMBT_STARTOFF_MASK)
> > 
> > Isn't the maximum file offset in the BMBT the max start offset + the
> > max length of the extent that is located at BMBT_STARTOFF_MASK?
> 
> Apologies for responding to a question with another question, but has
> there ever been an XFS that supported an inode size of more than 8EB?

Doubt it.

> Linux supports at most a file offset of 8EB, which is 2^63-1, or
> 0x7FFF,FFFF,FFFF,FFFF.  On a filesystem with 512-byte blocks, the very
> last byte in the file would be in block 2^54-1, or 0x3F,FFFF,FFFF,FFFF.
> Larger blocksizes decrease that even further (e.g. 2^47-1, or
> 0x7FFF,FFFF,FFFF on 64k block filesystems).
>
> Therefore, on Linux I conclude that the largest file offset (block)
> possible is 2^54-1, which is BMBT_STARTOFF_MASK.  Unless there's an
> XFS port that actually supports 16EB files, BMBT_STARTOFF_MASK will
> suffice here.

Sure, but my point was that checks against the max file offset
as a block count are applied to the startoff field, not the
startoff + blockcount value, so we can potentially get extents on
disk beyond the above definition of XFS_MAX_FILEOFF...

i.e. startoff can be < XFS_MAX_FILEOFF, but startoff + blockcount
can be > XFS_MAX_FILEOFF, and there's nothing in the code that
prevents that from occurring...

e.g. what's preventing speculative delalloc from going beyond
XFS_MAX_FILEOFF, even though the actual file offset that is being
written is within XFS_MAX_FILEOFF?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
