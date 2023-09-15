Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0920EE644C
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Sep 2023 09:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbjIOJyG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Sep 2023 05:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbjIOJyD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Sep 2023 05:54:03 -0400
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3264E3C05;
        Fri, 15 Sep 2023 02:51:37 -0700 (PDT)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4Rn8bH0Gh7z4xPYf;
        Fri, 15 Sep 2023 17:51:23 +0800 (CST)
Received: from szxlzmapp01.zte.com.cn ([10.5.231.85])
        by mse-fl1.zte.com.cn with SMTP id 38F9or5h006739;
        Fri, 15 Sep 2023 17:50:53 +0800 (+08)
        (envelope-from cheng.lin130@zte.com.cn)
Received: from mapi (szxlzmapp01[null])
        by mapi (Zmail) with MAPI id mid14;
        Fri, 15 Sep 2023 17:50:56 +0800 (CST)
Date:   Fri, 15 Sep 2023 17:50:56 +0800 (CST)
X-Zmail-TransId: 2b0365042900227-d4888
X-Mailer: Zmail v1.0
Message-ID: <202309151750563356840@zte.com.cn>
In-Reply-To: <ZQJIyx419cw24ppF@dread.disaster.area>
References: 202309131744458239465@zte.com.cn,ZQJIyx419cw24ppF@dread.disaster.area
Mime-Version: 1.0
From:   <cheng.lin130@zte.com.cn>
To:     <david@fromorbit.com>
Cc:     <djwong@kernel.org>, <linux-xfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jiang.yong5@zte.com.cn>,
        <wang.liang82@zte.com.cn>, <liu.dong3@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2M10geGZzOiBpbnRyb2R1Y2UgcHJvdGVjdGlvbiBmb3IgZHJvcCBubGluaw==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 38F9or5h006739
X-Fangmail-Gw-Spam-Type: 0
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6504291B.000/4Rn8bH0Gh7z4xPYf
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Wed, Sep 13, 2023 at 05:44:45PM +0800, cheng.lin130@zte.com.cn wrote:
> > From: Cheng Lin <cheng.lin130@zte.com.cn>
> >
> > When abnormal drop_nlink are detected on the inode,
> > shutdown filesystem, to avoid corruption propagation.
> >
> > Signed-off-by: Cheng Lin <cheng.lin130@zte.com.cn>
> > ---
> >  fs/xfs/xfs_inode.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 9e62cc500..40cc106ae 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -919,6 +919,15 @@ xfs_droplink(
> >      xfs_trans_t *tp,
> >      xfs_inode_t *ip)
> >  {
> > +
> > +    if (VFS_I(ip)->i_nlink == 0) {
> > +        xfs_alert(ip->i_mount,
> > +              "%s: Deleting inode %llu with no links.",
> > +              __func__, ip->i_ino);
> > +        tp->t_flags |= XFS_TRANS_DIRTY;
> Marking the transaction dirty is not necessary.
> Otherwise this seems fine.
Another strategy: 
Set nlink to an invalid value(like XFS_NLINK_PINNED), and
Complete this transaction before shutdown fs. To make sure
nlink not be zero. If the nlink of a directory are zero, it may
be cleaned up.
Is that appropriate?
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
