Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB2EAC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Sep 2021 00:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D11DA61288
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Sep 2021 00:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347512AbhI3AmD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Sep 2021 20:42:03 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:60261 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244341AbhI3AmA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Sep 2021 20:42:00 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id CC4218846C2;
        Thu, 30 Sep 2021 10:40:16 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mVk7T-000fQh-25; Thu, 30 Sep 2021 10:40:15 +1000
Date:   Thu, 30 Sep 2021 10:40:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 07/12] xfs: Rename inode's extent counter fields based
 on their width
Message-ID: <20210930004015.GM2361455@dread.disaster.area>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-8-chandan.babu@oracle.com>
 <20210927234637.GM1756565@dread.disaster.area>
 <20210928040431.GP1756565@dread.disaster.area>
 <87czors49w.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87czors49w.fsf@debian-BULLSEYE-live-builder-AMD64>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61550771
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=PBnoTMuumf0sBhVUzcEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 29, 2021 at 10:33:23PM +0530, Chandan Babu R wrote:
> On 28 Sep 2021 at 09:34, Dave Chinner wrote:
> > On Tue, Sep 28, 2021 at 09:46:37AM +1000, Dave Chinner wrote:
> >> On Thu, Sep 16, 2021 at 03:36:42PM +0530, Chandan Babu R wrote:
> >> > This commit renames extent counter fields in "struct xfs_dinode" and "struct
> >> > xfs_log_dinode" based on the width of the fields. As of this commit, the
> >> > 32-bit field will be used to count data fork extents and the 16-bit field will
> >> > be used to count attr fork extents.
> >> > 
> >> > This change is done to enable a future commit to introduce a new 64-bit extent
> >> > counter field.
> >> > 
> >> > Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> >> > ---
> >> >  fs/xfs/libxfs/xfs_format.h      |  8 ++++----
> >> >  fs/xfs/libxfs/xfs_inode_buf.c   |  4 ++--
> >> >  fs/xfs/libxfs/xfs_log_format.h  |  4 ++--
> >> >  fs/xfs/scrub/inode_repair.c     |  4 ++--
> >> >  fs/xfs/scrub/trace.h            | 14 +++++++-------
> >> >  fs/xfs/xfs_inode_item.c         |  4 ++--
> >> >  fs/xfs/xfs_inode_item_recover.c |  8 ++++----
> >> >  7 files changed, 23 insertions(+), 23 deletions(-)
> >> > 
> >> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> >> > index dba868f2c3e3..87c927d912f6 100644
> >> > --- a/fs/xfs/libxfs/xfs_format.h
> >> > +++ b/fs/xfs/libxfs/xfs_format.h
> >> > @@ -802,8 +802,8 @@ typedef struct xfs_dinode {
> >> >  	__be64		di_size;	/* number of bytes in file */
> >> >  	__be64		di_nblocks;	/* # of direct & btree blocks used */
> >> >  	__be32		di_extsize;	/* basic/minimum extent size for file */
> >> > -	__be32		di_nextents;	/* number of extents in data fork */
> >> > -	__be16		di_anextents;	/* number of extents in attribute fork*/
> >> > +	__be32		di_nextents32;	/* number of extents in data fork */
> >> > +	__be16		di_nextents16;	/* number of extents in attribute fork*/
> >> 
> >> 
> >> Hmmm. Having the same field in the inode hold the extent count
> >> for different inode forks based on a bit in the superblock means the
> >> on-disk inode format is not self describing. i.e. we can't decode
> >> the on-disk contents of an inode correctly without knowing whether a
> >> specific feature bit is set in the superblock or not.
> >
> > Hmmmm - I just realised that there is an inode flag that indicates
> > the format is different. It's jsut that most of the code doing
> > conditional behaviour is using the superblock flag, not the inode
> > flag as the conditional.
> >
> > So it is self describing, but I still don't like the way the same
> > field is used for the different forks. It just feels like we are
> > placing a landmine that we are going to forget about and step
> > on in the future....
> >
> 
> Sorry, I missed this response from you.
> 
> I agree with your suggestion. I will use the inode version number to help in
> deciding which extent counter fields are valid for a specific inode.

No, don't do something I suggested with a flawed understanding of
the code.

Just because *I* suggest something, it means you have to make that
change. That is reacting to *who* said something, not *what was
said*.

So, I may have reservations about the way the storage definitions
are being redefined, but if I had a valid, technical argument I
could give right now I would have said so directly. I can't put my
finger on why this worries me in this case but didn't for something
like, say, the BIGTIME feature which redefined the contents of
various fields in the inode.

IOWs, I haven't really had time to think and go back over the rest
of the patchset since I realised my mistake and determine if that
changes what I think about this, so don't go turning the patchset
upside just because *I suggested something*.

Think critically about what is said and respond to that, not look
at who said it and respond based on their reputation.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
