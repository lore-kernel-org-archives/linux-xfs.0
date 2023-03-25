Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F177EC6FD1C
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Mar 2023 17:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjCYRDo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Mar 2023 13:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCYRDn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Mar 2023 13:03:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23020A5E1
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 10:03:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF2D5B8074C
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 17:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FAFC433EF;
        Sat, 25 Mar 2023 17:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679763819;
        bh=sWlAmzU6z43LCOSR4iYU+rr21kyK9GEA5BpEklAUBXs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XFc9rTvefk2Io6yAwiJR1qpDTb/LEuP0Ih3q4VkxOZudrwi78jSnkdkQ3b5VZLSF5
         w8N6DaWBcy+7DYWZmg7oabpZw+cgjgVo5MZSPyzCAF1zEFBceII/oRMc+dKnM1LPp6
         UrYvmBmGm9aMcYgxoDIePOnZUjyyXqUvWGt+NgIbxKwfQPvlDCRvl3Zj5zuwiKNCO6
         J8EBhnnVk338BpIgq7Mq4WRVZMD4p5rApYyAe5+hRQe0t5Bu5v6lbq7qgRdychKbT3
         mrOhEjeLFjGeyWWIMQvkYJyC5h8eiQATXev3bp+36sla25naj4UbU5w0VbbC14kDVm
         IF0WeMGLFKxqw==
Date:   Sat, 25 Mar 2023 10:03:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCHSET v10r1d2 00/17] xfs: encode parent pointer name in
 xattr key
Message-ID: <20230325170339.GB16209@frogsfrogsfrogs>
References: <20230316185414.GH11394@frogsfrogsfrogs>
 <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
 <6e6f7948dfdeac87accb8cd437f0c22d21a2e8e0.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6e6f7948dfdeac87accb8cd437f0c22d21a2e8e0.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 24, 2023 at 05:10:19PM +0000, Allison Henderson wrote:
> On Thu, 2023-03-16 at 12:17 -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > As I've mentioned in past comments on the parent pointers patchset,
> > the
> > proposed ondisk parent pointer format presents a major difficulty for
> > online directory repair.  This difficulty derives from encoding the
> > directory offset of the dirent that the parent pointer is mirroring.
> > Recall that parent pointers are stored in extended attributes:
> > 
> >     (parent_ino, parent_gen, diroffset) -> (dirent_name)
> > 
> > If the directory is rebuilt, the offsets of the new directory entries
> > must match the diroffset encoded in the parent pointer, or the
> > filesystem becomes inconsistent.  There are a few ways to solve this
> > problem.
> > 
> > One approach would be to augment the directory addname function to
> > take
> > a diroffset and try to create the new entry at that offset.  This
> > will
> > not work if the original directory became corrupt and the parent
> > pointers were written out with impossible diroffsets (e.g.
> > overlapping).
> > Requiring matching diroffsets also prevents reorganization and
> > compaction of directories.
> > 
> > This could be remedied by recording the parent pointer diroffset
> > updates
> > necessary to retain consistency, and using the logged parent pointer
> > replace function to rewrite parent pointers as necessary.  This is a
> > poor choice from a performance perspective because the logged xattr
> > updates must be committed in the same transaction that commits the
> > new
> > directory structure.  If there are a large number of diroffset
> > updates,
> > then the directory commit could take an even longer time.
> > 
> > Worse yet, if the logged xattr updates fill up the transaction,
> > repair
> > will have no choice but to roll to a fresh transaction to continue
> > logging.  This breaks repair's policy that repairs should commit
> > atomically.  It may break the filesystem as well, since all files
> > involved are pinned until the delayed pptr xattr processing
> > completes.
> > This is a completely bad engineering choice.
> > 
> > Note that the diroffset information is not used anywhere in the
> > directory lookup code.  Observe that the only information that we
> > require for a parent pointer is the inverse of an pre-ftype dirent,
> > since this is all we need to reconstruct a directory entry:
> > 
> >     (parent_ino, dirent_name) -> NULL
> > 
> > The xattr code supports xattrs with zero-length values, surprisingly.
> > The parent_gen field makes it easy to export parent handle
> > information,
> > so it can be retained:
> > 
> >     (parent_ino, parent_gen, dirent_name) -> NULL
> > 
> > Moving the ondisk format to this format is very advantageous for
> > repair
> > code.  Unfortunately, there is one hitch: xattr names cannot exceed
> > 255
> > bytes due to ondisk format limitations.  We don't want to constrain
> > the
> > length of dirent names, so instead we create a special VLOOKUP mode
> > for
> > extended attributes that allows parent pointers to require matching
> > on
> > both the name and the value.
> > 
> > The ondisk format of a parent pointer can then become:
> > 
> >     (parent_ino, parent_gen, dirent_name[0:242]) ->
> > (dirent_name[243:255])
> > 
> > Because we can always look up a specific parent pointer.  Most of the
> > patches in this patchset prepare the high level xattr code and the
> > lower
> > level logging code to do this correctly, and the last patch switches
> > the
> > ondisk format.
> > 
> > If you're going to start using this mess, you probably ought to just
> > pull from my git trees, which are linked below.
> > 
> > This is an extraordinary way to destroy everything.  Enjoy!
> > Comments and questions are, as always, welcome.
> > kernel git tree:
> So I gave this set a look over and for the most part I think it's ok as
> long as folks agree on the new format?  It's a lot different from what
> folks originally articulated that they wanted, but for the most part
> the format change doesnt affect parent pointer mechanics as much as it
> will affect other features that may use it.  I havnt seen much
> complaints in response, so if it's all the same to everyone else, I am
> fine with moving forward with it?  Thanks all!

Yes, let's move forward.   As I mentioned on IRC last night I'll merge
my changes into parent pointers v11 and put that out next weekish.

--D

> Allison
> 
> 
> > https://urldefense.com/v3/__https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-name-in-attr-key__;!!ACWV5N9M2RV99hQ!NDopQXFVRjDfqgJvGMQRzS3fXyyd1SC4HfGl4dxSMWxNPsNKScecjp7bZYX-dDhL5tatk_xxJFdQwCj9YNGq$
> >  
> > 
> > xfsprogs git tree:
> > https://urldefense.com/v3/__https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-name-in-attr-key__;!!ACWV5N9M2RV99hQ!NDopQXFVRjDfqgJvGMQRzS3fXyyd1SC4HfGl4dxSMWxNPsNKScecjp7bZYX-dDhL5tatk_xxJFdQwILBe7jj$
> >  
> > 
> > fstests git tree:
> > https://urldefense.com/v3/__https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs-name-in-attr-key__;!!ACWV5N9M2RV99hQ!NDopQXFVRjDfqgJvGMQRzS3fXyyd1SC4HfGl4dxSMWxNPsNKScecjp7bZYX-dDhL5tatk_xxJFdQwI5iKKgk$
> >  
> > ---
> >  fs/xfs/libxfs/xfs_attr.c       |   66 +++++---
> >  fs/xfs/libxfs/xfs_attr.h       |    5 +
> >  fs/xfs/libxfs/xfs_attr_leaf.c  |   41 ++++-
> >  fs/xfs/libxfs/xfs_da_btree.h   |    6 +
> >  fs/xfs/libxfs/xfs_da_format.h  |   39 ++++-
> >  fs/xfs/libxfs/xfs_fs.h         |    2 
> >  fs/xfs/libxfs/xfs_log_format.h |   31 +++-
> >  fs/xfs/libxfs/xfs_parent.c     |  215 +++++++++++++++++----------
> >  fs/xfs/libxfs/xfs_parent.h     |   46 +++---
> >  fs/xfs/libxfs/xfs_trans_resv.c |    7 +
> >  fs/xfs/scrub/dir.c             |   34 +---
> >  fs/xfs/scrub/dir_repair.c      |   87 +++--------
> >  fs/xfs/scrub/parent.c          |   48 +-----
> >  fs/xfs/scrub/parent_repair.c   |   55 ++-----
> >  fs/xfs/scrub/trace.h           |   65 +-------
> >  fs/xfs/xfs_attr_item.c         |  318
> > +++++++++++++++++++++++++++++++---------
> >  fs/xfs/xfs_attr_item.h         |    3 
> >  fs/xfs/xfs_inode.c             |   30 ++--
> >  fs/xfs/xfs_ondisk.h            |    1 
> >  fs/xfs/xfs_parent_utils.c      |    8 +
> >  fs/xfs/xfs_symlink.c           |    3 
> >  fs/xfs/xfs_xattr.c             |    5 +
> >  22 files changed, 660 insertions(+), 455 deletions(-)
> > 
