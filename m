Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF60C6FD1D
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Mar 2023 00:11:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjCRALw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 20:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjCRALv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 20:11:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7263CC1BC6
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 17:11:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D71360EF2
        for <linux-xfs@vger.kernel.org>; Sat, 18 Mar 2023 00:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D086FC433EF;
        Sat, 18 Mar 2023 00:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679098303;
        bh=28AqN6Yq+80YlCLHwZhwyFe2FT1gQYeo6mlgyeOOLB0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ijBcXsoNwM0LKq9mtwfjmIISRLtytCKgVSHOVNd8wVDQQnHNoH2aOX3d/XARTSbS6
         bgJTy6GybYId5BAM4bMb6V0X/qGMI0lJt8/XmK1/Lyv2a/4X9kPyUld5JSx5to1UU1
         HdZa0cNZ5i/GcI6alm6QDCfBBvcvSITsDRWDlBYUItCTW+Jhr8OrXnZOQuqHwSbt1J
         Z94q3P415oltWu5Ac1kY8SdKRkDpCaagdAg6jtz4pVDXt8QbeLjBFnuTo98X/0db8P
         B6C+mWdmpslJbzIpc9eYlpRqUGIxDTM2FIsIJogTdMHiwKfSkfeVbaix8LB3hJwj9C
         AsGkh8fJC6uiQ==
Date:   Fri, 17 Mar 2023 17:11:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 0/4] setting uuid of online filesystems
Message-ID: <20230318001143.GS11376@frogsfrogsfrogs>
References: <20230314042109.82161-1-catherine.hoang@oracle.com>
 <20230314062847.GQ360264@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314062847.GQ360264@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 14, 2023 at 05:28:47PM +1100, Dave Chinner wrote:
> On Mon, Mar 13, 2023 at 09:21:05PM -0700, Catherine Hoang wrote:
> > Hi all,
> > 
> > This series of patches implements a new ioctl to set the uuid of mounted
> > filesystems. Eventually this will be used by the 'xfs_io fsuuid' command
> > to allow userspace to update the uuid.
> > 
> > Comments and feedback appreciated!
> 
> What's the use case for this?
> 
> What are the pro's and cons of the implementation?
> 
> Some problems I see:
> 
> * How does this interact with pNFS exports (i.e.
> CONFIG_EXPORTFS_BLOCK_OPS). XFS hands the sb_uuid directly to pNFS
> server (and remote clients, I think) so that incoming mapping
> requests can be directed to the correct block device hosting the XFS
> filesystem the mapping information is for. IIRC, the pNFS data path
> is just given a byte offset into the device where the UUID in the
> superblock lives, and if it matches it allows the remote IO to go
> ahead - it doesn't actually know that there is a filesystem on that
> device at all...

I think we're going to have to detect the presence of pNFS exports and
EAGAIN if there are any active.  That probably involves incrementing a
counter during ->map_blocks and decreasing it during ->commit blocks.

That might still invite races between someone setting the fsuuid and
exporting via NFS.  

> * IIRC, the nfsd export table can also use the filesystem uuid to
> identify the filesystem being exported, and IIRC that gets encoded
> in the filehandle. Does changing the filesystem UUID then cause
> problems with export indentification and/or file handle
> creation/resolution?

I thought NFS (when not being used for block layouts and pnfs stuff)
still used the fsid that's also in the superblock?  Presumably we'd
leave the old m_fixedfsid unchanged while the fs is still mounted, and
document the caveat that handles will not work after a remount.

On some level, we might simply have to document that changing the
user-visible uuid will break file handles and pnfs exports, so sysadmins
had better get that done early.

OTOH that is an argument for leaving the xfs_db-based version that we
have now.

> * Is the VFS prepared for sb->s_uuid changing underneath running
> operations on mounted filesystems? I can see that this might cause
> problems with any sort of fscrypt implementation as it may encode
> the s_uuid into encryption keys held in xattrs, similarly IMA and
> EVM integrity protection keys.

I would hope it's not so hard to detect that EVM/fscrypt are active on a
given xfs mount.  EVM seems pretty hard to detect since it operates
above the fs.

fscrypt might not be so difficult, since we likely need to add support
in the ondisk metadata, which means xfs will know.

IMA seems to be using it for rule matching, so I'd say that if the
sysadmin changes the fsuuid, they had better update the IMA rulebook
too.

Come to think of it, perhaps reading a filesystem's uuid (whether via
handle export, direct read of s_uuid, nfs, evm, ima, or fscrypt) should
set a superblock flag that someone has accessed it; and only if nobody's
yet accessed it do we allow the fsuuid update?

> * Should the VFS superblock sb->s_uuid use the XFS
> sb->sb_meta_uuid value and never change because we can encode it
> into other objects stored in the active filesystem? What does that
> mean for tools that identify block devices or filesystems by the VFS
> uuid rather than the filesystem uuid?

I don't know of any other than the ones you found.

> There's a whole can-o-worms here - the ability to dynamically change
> the UUID of a filesystem while it is mounted mean we need to think
> about these things - it's no longer as simple as "can only do it
> offline" which is typically only used to relabel a writeable
> snapshot of a golden image file during new VM deployment
> preparation.....

Agreed.

> > 
> > Catherine
> > 
> > Catherine Hoang (4):
> >   xfs: refactor xfs_uuid_mount and xfs_uuid_unmount
> >   xfs: implement custom freeze/thaw functions
> 
> The "custom" parts that XFS requires need to be added to the VFS
> level freeze/thaw functions, not duplicate the VFS functionality
> within XFS and then slight modify it for this additional feature.
> Doing this results in unmaintainable code over the long term.

Yeah, I think for the next iteration we ought to try to pull in Luis's
kernel-initiated-exclusive-freeze patch.

> >   xfs: add XFS_IOC_SETFSUUID ioctl
> >   xfs: export meta uuid via xfs_fsop_geom
> 
> For what purpose does userspace ever need to know the sb_meta_uuid?

(No idea; once someone sets a fsuuid they usually don't want to go
back.)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
