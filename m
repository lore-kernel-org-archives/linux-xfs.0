Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42BF1C001C7
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AFF564E59
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbhCDAST (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:18:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46850 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386895AbhCCTLY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Mar 2021 14:11:24 -0500
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1lHWsg-0006cl-IX; Wed, 03 Mar 2021 19:09:58 +0000
Date:   Wed, 3 Mar 2021 19:09:57 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com
Subject: Re: [PATCH 1/3] xfs: fix quota accounting when a mount is idmapped
Message-ID: <20210303190957.7kabt57lvc432j6x@wittgenstein>
References: <161472409643.3421449.2100229515469727212.stgit@magnolia>
 <161472410230.3421449.11155796770029064636.stgit@magnolia>
 <20210303144401.eqmsqm7y232gn6mu@wittgenstein>
 <20210303183352.GT7269@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210303183352.GT7269@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 03, 2021 at 10:33:52AM -0800, Darrick J. Wong wrote:
> On Wed, Mar 03, 2021 at 02:44:01PM +0000, Christian Brauner wrote:
> > On Tue, Mar 02, 2021 at 02:28:22PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Nowadays, we indirectly use the idmap-aware helper functions in the VFS
> > > to set the initial uid and gid of a file being created.  Unfortunately,
> > > we didn't convert the quota code, which means we attach the wrong dquots
> > > to files created on an idmapped mount.
> > > 
> > > Fixes: f736d93d76d3 ("xfs: support idmapped mounts")
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > 
> > This looks good but it misses one change, I think. The
> > xfs_ioctl_setattr() needs to take the mapping into account as well:
> > 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 99dfe89a8d08..067366bf9a59 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1460,8 +1460,8 @@ xfs_ioctl_setattr(
> >          * because the i_*dquot fields will get updated anyway.
> >          */
> >         if (XFS_IS_QUOTA_ON(mp)) {
> > -               error = xfs_qm_vop_dqalloc(ip, VFS_I(ip)->i_uid,
> > -                               VFS_I(ip)->i_gid, fa->fsx_projid,
> > +               error = xfs_qm_vop_dqalloc(ip, i_uid_into_mnt(mnt_userns, VFS_I(ip)),
> > +                               i_gid_into_mnt(mnt_userns, VFS_I(ip)), fa->fsx_projid,
> >                                 XFS_QMOPT_PQUOTA, NULL, NULL, &pdqp);
> 
> The uid/gid parameters here don't matter because the "XFS_QMOPT_PQUOTA"
> flag by itself here means that _dqalloc only looks at the project id
> argument.

Ah, thanks! (Maybe a comment would be good or just idmaped them anyway.)

Thanks!
Christian
