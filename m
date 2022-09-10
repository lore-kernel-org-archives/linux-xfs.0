Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84640C6FA82
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Sep 2022 09:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiIJJNe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 10 Sep 2022 05:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiIJJNc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Sep 2022 05:13:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB611A3AD
        for <linux-xfs@vger.kernel.org>; Sat, 10 Sep 2022 02:13:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD83AB80833
        for <linux-xfs@vger.kernel.org>; Sat, 10 Sep 2022 09:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124BFC433D6;
        Sat, 10 Sep 2022 09:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662801207;
        bh=MHqzpXs1bGVbHHcWbkID+W1720XFUhrioZ/8tlFh1mE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FS1oA+V3UwhcQz3hDzh5Y9VYfwGshwsC+PvNwiqWq9psufaKTSsdgkYFb0lBe6X1T
         3XrHWx6WzyvIipbaz75GrHvnKt+8bOp8SqQHZSRSlZLla7mUKt530oTNonrucHSM18
         HplAapnQzgPb8qbAW9F7mst64VkbIQAmZKPWbuUpeahsx5TAP93Sf988LRkdTqUQYd
         K5zE4ZhY6MSQCIoPSspRfW0anv/aiRUFGj7Rz/w7Ai1keGsWLcJMMm+WZvYHohGHDF
         +uAWjnd0xQMt6sInScCGEa0zm2gxiq44Mi+ymY5AaLxZbbw8MX6W1HyOxXSwiKybkg
         V22VaT1pcL0+w==
Date:   Sat, 10 Sep 2022 11:13:17 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Darrick J . Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Seth Forshee <sforshee@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: port to vfs{g,u}id_t and associated helpers
Message-ID: <20220910091317.rwqpdflsmc4lm47u@wittgenstein>
References: <20220909095659.944062-1-brauner@kernel.org>
 <20220909144047.GA10312@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220909144047.GA10312@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 09, 2022 at 04:40:47PM +0200, Christoph Hellwig wrote:
> On Fri, Sep 09, 2022 at 11:56:59AM +0200, Christian Brauner wrote:
> > A while ago we introduced a dedicated vfs{g,u}id_t type in commit
> > 1e5267cd0895 ("mnt_idmapping: add vfs{g,u}id_t"). We already switched
> > over a good part of the VFS. Ultimately we will remove all legacy
> > idmapped mount helpers that operate only on k{g,u}id_t in favor of the
> > new type safe helpers that operate on vfs{g,u}id_t.
> > 
> > Cc: Dave Chinner <dchinner@redhat.com>
> > Cc: Seth Forshee (Digital Ocean) <sforshee@kernel.org>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Darrick J. Wong <djwong@kernel.org>
> > Cc: linux-xfs@vger.kernel.org
> > Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> > ---
> >  fs/xfs/xfs_inode.c  | 5 ++---
> >  fs/xfs/xfs_iops.c   | 6 ++++--
> >  fs/xfs/xfs_itable.c | 8 ++++++--
> >  3 files changed, 12 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 28493c8e9bb2..bca204a5aecf 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -835,9 +835,8 @@ xfs_init_new_inode(
> >  	 * ID or one of the supplementary group IDs, the S_ISGID bit is cleared
> >  	 * (and only if the irix_sgid_inherit compatibility variable is set).
> >  	 */
> > -	if (irix_sgid_inherit &&
> > -	    (inode->i_mode & S_ISGID) &&
> > -	    !in_group_p(i_gid_into_mnt(mnt_userns, inode)))
> > +	if (irix_sgid_inherit && (inode->i_mode & S_ISGID) &&
> > +	    !vfsgid_in_group_p(i_gid_into_vfsgid(mnt_userns, inode)))
> >  		inode->i_mode &= ~S_ISGID;
> >  
> >  	ip->i_disk_size = 0;
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index 45518b8c613c..5d670c85dcc2 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -558,6 +558,8 @@ xfs_vn_getattr(
> >  	struct inode		*inode = d_inode(path->dentry);
> >  	struct xfs_inode	*ip = XFS_I(inode);
> >  	struct xfs_mount	*mp = ip->i_mount;
> > +	vfsuid_t		vfsuid = i_uid_into_vfsuid(mnt_userns, inode);
> > +	vfsgid_t		vfsgid = i_gid_into_vfsgid(mnt_userns, inode);
> >  
> >  	trace_xfs_getattr(ip);
> >  
> > @@ -568,8 +570,8 @@ xfs_vn_getattr(
> >  	stat->dev = inode->i_sb->s_dev;
> >  	stat->mode = inode->i_mode;
> >  	stat->nlink = inode->i_nlink;
> > -	stat->uid = i_uid_into_mnt(mnt_userns, inode);
> > -	stat->gid = i_gid_into_mnt(mnt_userns, inode);
> > +	stat->uid = vfsuid_into_kuid(vfsuid);
> > +	stat->gid = vfsgid_into_kgid(vfsgid);
> >  	stat->ino = ip->i_ino;
> >  	stat->atime = inode->i_atime;
> >  	stat->mtime = inode->i_mtime;
> > diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> > index 36312b00b164..a1c2bcf65d37 100644
> > --- a/fs/xfs/xfs_itable.c
> > +++ b/fs/xfs/xfs_itable.c
> > @@ -66,6 +66,8 @@ xfs_bulkstat_one_int(
> >  	struct xfs_bulkstat	*buf = bc->buf;
> >  	xfs_extnum_t		nextents;
> >  	int			error = -EINVAL;
> > +	vfsuid_t		vfsuid;
> > +	vfsgid_t		vfsgid;
> >  
> >  	if (xfs_internal_inum(mp, ino))
> >  		goto out_advance;
> > @@ -81,14 +83,16 @@ xfs_bulkstat_one_int(
> >  	ASSERT(ip != NULL);
> >  	ASSERT(ip->i_imap.im_blkno != 0);
> >  	inode = VFS_I(ip);
> > +	vfsuid = i_uid_into_vfsuid(mnt_userns, inode);
> > +	vfsgid = i_gid_into_vfsgid(mnt_userns, inode);
> >  
> >  	/* xfs_iget returns the following without needing
> >  	 * further change.
> >  	 */
> >  	buf->bs_projectid = ip->i_projid;
> >  	buf->bs_ino = ino;
> > -	buf->bs_uid = from_kuid(sb_userns, i_uid_into_mnt(mnt_userns, inode));
> > -	buf->bs_gid = from_kgid(sb_userns, i_gid_into_mnt(mnt_userns, inode));
> > +	buf->bs_uid = from_kuid(sb_userns, vfsuid_into_kuid(vfsuid));
> > +	buf->bs_gid = from_kgid(sb_userns, vfsgid_into_kgid(vfsgid));
> 
> So we convert i_uid into vfsguid into kuid into the user space visible
> one here.  I wonder if there is any good short cut, as reading this
> chaing feels odd.  But I guess that's what we get for a non-VFS
> ioctl interface exposint uids/gids.

We could add a tiny helper for this for sure but I think there's so
little need for it that it wouldn't make much sense. But if more cases
pop up during conversion of all direct users we should definitely add
one.
