Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C089AC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Jan 2022 00:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345030AbiA1AyG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jan 2022 19:54:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345063AbiA1Axy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jan 2022 19:53:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400A5C0613E5
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jan 2022 16:53:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5239B8241D
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jan 2022 00:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DBAC340E4;
        Fri, 28 Jan 2022 00:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643331221;
        bh=LdbdFT56KDhygCVkXpDkRzQJDevxpJqiiN8o20BX7Qg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oMyo5Z0QWj83FGXd1j4/uhueU23/iWTwO6qT1hp4qvW1uTQR9YbEZnXaetoZqBH03
         Qb1kuFv/7A8C+AtpYJQc41SJnIW74ZCChfAzQ2/vb+RzHXNARpJdcrCiBU9f8UNDE4
         e12hbpAZEDDeUt2UoUUPwRsktTmEyYZOv2Q7tOBjEvKp42QGWPk7S9FwMHz5mn52oH
         1EucmQtzP+RC5hQfcGhIhu2ENeGteknj/0AVp+hqpyLNFKf4rag+0G/HN6e+mPgi3B
         EES667ooiObE0R5EyDbGomIeClCI+VPIta//xcHl3ht4RY6f9y6Nf9TvPLQucAxLm/
         fTNa0XGnUQnRQ==
Date:   Thu, 27 Jan 2022 16:53:40 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 39/45] libxfs: remove pointless *XFS_MOUNT* flags
Message-ID: <20220128005340.GF13540@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
 <164263805814.860211.18062742237091017727.stgit@magnolia>
 <bfeb58f9-b55a-c208-b7b3-4986f1f8971a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfeb58f9-b55a-c208-b7b3-4986f1f8971a@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 27, 2022 at 05:03:22PM -0600, Eric Sandeen wrote:
> On 1/19/22 6:20 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Get rid of these flags and the m_flags field, since none of them do
> > anything anymore.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> ...
> 
> > diff --git a/libxfs/init.c b/libxfs/init.c
> > index e9235a35..093ce878 100644
> > --- a/libxfs/init.c
> > +++ b/libxfs/init.c
> > @@ -540,13 +540,10 @@ xfs_set_inode_alloc(
> >   	 * sufficiently large, set XFS_MOUNT_32BITINODES if we must alter
> >   	 * the allocator to accommodate the request.
> >   	 */
> > -	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) && ino > XFS_MAXINUMBER_32) {
> > +	if (ino > XFS_MAXINUMBER_32)
> >   		xfs_set_inode32(mp);
> > -		mp->m_flags |= XFS_MOUNT_32BITINODES;
> > -	} else {
> > +	else
> >   		xfs_clear_inode32(mp);
> > -		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
> > -	}
> 
> Hm, so this just removes the "XFS_MOUNT_SMALL_INUMS" test. In the last
> release, nothing ever set this flag in userspace, so the first part of
> the conditional was always false, so we always cleared the 32bitinode
> setting.
> 
> So I think this is a change in behavior, and if we get a request for a
> large inode, we'll enable inode32, at least for this session?
> 
> But maybe that's ok, since there is no "inode32 mount option" in
> userspace, and maybe we *shouldn't* be allocating 64-bit inodes in
> userspace?  <thinking>
> 
> <thinking some more>
> 
> I'll get back to this :)

Ooh, good catch.  MOUNT_SMALL_INUMS was zero, so the first part of the
if test was alway zero, which means that we always call the else clause.
IOWs, inode64 should always be enabled, not inode32.

Maybe there's an argument for only using inode32 mode in userspace
(though userspace never adds user-visible files) so that a system that
has inode32 in fstab will never ever have big inodes?

Dunno, but that's a separate patch if people really want that.

I'll respin this patch with fixed logic.  I'll also fix the comments.

--D

> -Eric
> 
> 
