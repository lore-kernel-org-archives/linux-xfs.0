Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31215C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Feb 2022 21:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235103AbiBVVkf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Feb 2022 16:40:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235511AbiBVVkf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Feb 2022 16:40:35 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC2481390EE
        for <linux-xfs@vger.kernel.org>; Tue, 22 Feb 2022 13:40:08 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 47B0A53003B;
        Wed, 23 Feb 2022 08:40:04 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nMct8-00FDlE-MZ; Wed, 23 Feb 2022 08:40:02 +1100
Date:   Wed, 23 Feb 2022 08:40:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        djwong@kernel.org
Subject: Re: [PATCH] xfs: do not clear S_ISUID|S_ISGID for idmapped mounts
Message-ID: <20220222214002.GJ59715@dread.disaster.area>
References: <20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com>
 <20220222083340.GA5899@lst.de>
 <20220222102405.mmqlzimwabz7v67d@wittgenstein>
 <bdfa9081-1994-95f9-6feb-6710d34b33a1@virtuozzo.com>
 <20220222122331.ijeapomur76h7xf6@wittgenstein>
 <20220222123656.433l67bxhv3s2vbo@wittgenstein>
 <48bcd8ac-f9e5-a83c-604c-5af602cb362a@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48bcd8ac-f9e5-a83c-604c-5af602cb362a@virtuozzo.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62155836
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
        a=-j78cozfzvTfWKn_Ax0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 22, 2022 at 05:54:07PM +0300, Andrey Zhadchenko wrote:
> On 2/22/22 15:36, Christian Brauner wrote:
> > > > > Because as of right now the code seems to imply that the xfs code itself
> > > > > is responsible for stripping s{g,u}id bits for all files whereas it is
> > > > > the vfs that does it for any non-directory. So I'd propose to either try
> > > > > and switch that code to setattr_copy() or to do open-code the
> > > > > setattr_copy() check:
> 
> I did some more research on it and seems like modes are already stripped
> enough.
> 
> notify_change() -> inode->i_op->setattr() -> xfs_vn_setattr() ->
> xfs_vn_change_ok() -> prepare_setattr()
> which has the following:
>         if (!in_group_p((ia_valid & ATTR_GID) ? attr->ia_gid :
>                          i_gid_into_mnt(mnt_userns, inode)) &&
>              !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
>                  attr->ia_mode &= ~S_ISGID;
> 
> After xfs_vn_change_ok() xfs_setattr_nonsize() is finally called and
> additionally strips sgid and suid.
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 09211e1d08ad..7fda5ff3ef17 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -767,16 +767,6 @@ xfs_setattr_nonsize(
>                 gid = (mask & ATTR_GID) ? iattr->ia_gid : igid;
>                 uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
> 
> -               /*
> -                * CAP_FSETID overrides the following restrictions:
> -                *
> -                * The set-user-ID and set-group-ID bits of a file will be
> -                * cleared upon successful return from chown()
> -                */
> -               if ((inode->i_mode & (S_ISUID|S_ISGID)) &&
> -                   !capable(CAP_FSETID))
> -                       inode->i_mode &= ~(S_ISUID|S_ISGID);

THis code has been in XFS since 1997 - it addressed shortcomings in
the Irix chown implementation w.r.t. the requirements of CAP_CHOWN
and CAP_FSETID in _POSIX_CHOWN_RESTRICTED configurations.

If the VFS handles all this correctly these days then, yes, we can
just get rid of this code - it's legacy code and we should behave
consistently across all filesystems w.r.t. su/gid files.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
