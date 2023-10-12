Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D374CDB482
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 11:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378036AbjJLLGI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 07:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377653AbjJLLGH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 07:06:07 -0400
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456C5B7
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 04:06:03 -0700 (PDT)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4S5myr5pNFz4xPFv;
        Thu, 12 Oct 2023 19:05:56 +0800 (CST)
Received: from szxlzmapp06.zte.com.cn ([10.5.230.252])
        by mse-fl1.zte.com.cn with SMTP id 39CB5qsQ050389;
        Thu, 12 Oct 2023 19:05:52 +0800 (+08)
        (envelope-from cheng.lin130@zte.com.cn)
Received: from mapi (szxlzmapp02[null])
        by mapi (Zmail) with MAPI id mid14;
        Thu, 12 Oct 2023 19:05:55 +0800 (CST)
Date:   Thu, 12 Oct 2023 19:05:55 +0800 (CST)
X-Zmail-TransId: 2b046527d31364a-17363
X-Mailer: Zmail v1.0
Message-ID: <202310121905556034321@zte.com.cn>
In-Reply-To: <20231011214105.GA21298@frogsfrogsfrogs>
References: 20231011203350.GY21298@frogsfrogsfrogs,ZScOxEP5V/fQNDW8@dread.disaster.area,20231011214105.GA21298@frogsfrogsfrogs
Mime-Version: 1.0
From:   <cheng.lin130@zte.com.cn>
To:     <djwong@kernel.org>, <viro@zeniv.linux.org.uk>,
        <brauner@kernel.org>
Cc:     <david@fromorbit.com>, <hch@infradead.org>,
        <linux-xfs@vger.kernel.org>, <jiang.yong5@zte.com.cn>,
        <wang.liang82@zte.com.cn>, <liu.dong3@zte.com.cn>,
        <linux-fsdevel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0geGZzOiBwaW4gaW5vZGVzIHRoYXQgd291bGQgb3RoZXJ3aXNlIG92ZXJmbG93IGxpbmsgY291bnQ=?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 39CB5qsQ050389
X-Fangmail-Gw-Spam-Type: 0
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6527D314.000/4S5myr5pNFz4xPFv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Thu, Oct 12, 2023 at 08:08:20AM +1100, Dave Chinner wrote:
> > On Wed, Oct 11, 2023 at 01:33:50PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > >
> > > The VFS inc_nlink function does not explicitly check for integer
> > > overflows in the i_nlink field.  Instead, it checks the link count
> > > against s_max_links in the vfs_{link,create,rename} functions.  XFS
> > > sets the maximum link count to 2.1 billion, so integer overflows should
> > > not be a problem.
> > >
> > > However.  It's possible that online repair could find that a file has
> > > more than four billion links, particularly if the link count got
> > > corrupted while creating hardlinks to the file.  The di_nlinkv2 field is
> > > not large enough to store a value larger than 2^32, so we ought to
> > > define a magic pin value of ~0U which means that the inode never gets
> > > deleted.  This will prevent a UAF error if the repair finds this
> > > situation and users begin deleting links to the file.
> > >
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/libxfs/xfs_format.h |    6 ++++++
> > >  fs/xfs/scrub/nlinks.c      |    8 ++++----
> > >  fs/xfs/scrub/repair.c      |   12 ++++++------
> > >  fs/xfs/xfs_inode.c         |   28 +++++++++++++++++++++++-----
> > >  4 files changed, 39 insertions(+), 15 deletions(-)
> > >
> > > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > > index 6409dd22530f2..320522b887bb3 100644
> > > --- a/fs/xfs/libxfs/xfs_format.h
> > > +++ b/fs/xfs/libxfs/xfs_format.h
> > > @@ -896,6 +896,12 @@ static inline uint xfs_dinode_size(int version)
> > >   */
> > >  #define    XFS_MAXLINK        ((1U << 31) - 1U)
> > >
> > > +/*
> > > + * Any file that hits the maximum ondisk link count should be pinned to avoid
> > > + * a use-after-free situation.
> > > + */
> > > +#define XFS_NLINK_PINNED    (~0U)
> > > +
> > >  /*
> > >   * Values for di_format
> > >   *
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index 4db2c2a6538d6..30604e11182c4 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -910,15 +910,25 @@ xfs_init_new_inode(
> > >   */
> > >  static int            /* error */
> > >  xfs_droplink(
> > > -    xfs_trans_t *tp,
> > > -    xfs_inode_t *ip)
> > > +    struct xfs_trans    *tp,
> > > +    struct xfs_inode    *ip)
> > >  {
> > > +    struct inode        *inode = VFS_I(ip);
> > > +
> > >      xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
> > >
> > > -    drop_nlink(VFS_I(ip));
> > > +    if (inode->i_nlink == 0) {
> > > +        xfs_info_ratelimited(tp->t_mountp,
> > > + "Inode 0x%llx link count dropped below zero.  Pinning link count.",
> > > +                ip->i_ino);
> > > +        set_nlink(inode, XFS_NLINK_PINNED);
> > > +    }
> > > +    if (inode->i_nlink != XFS_NLINK_PINNED)
> > > +        drop_nlink(inode);
> > > +
> > >      xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> >
> > I think the di_nlink field now needs to be checked by verifiers to
> > ensure the value is in the range of:
> >
> >     (0 <= di_nlink <= XFS_MAXLINKS || di_nlink == XFS_NLINK_PINNED)
> >
> > And we need to ensure that in xfs_bumplink() - or earlier (top avoid
> > dirty xaction cancle shutdowns) - that adding a count to di_nlink is
> > not going to exceed XFS_MAXLINKS....
> I think the VFS needs to check that unlinking a nondirectory won't
> underflow its link count, and that rmdiring an (empty) subdirectory
> won't underflow the link counts of the parent or child.
> Cheng Lin, would you please fix all the filesystems at once instead of
> just XFS?
As FS infrastructure, its change may have a significant impact.
> --D
