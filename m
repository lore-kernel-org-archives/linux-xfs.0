Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4692FC61DA4
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Feb 2023 02:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjBXC62 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Feb 2023 21:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBXC62 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Feb 2023 21:58:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1F4158A6
        for <linux-xfs@vger.kernel.org>; Thu, 23 Feb 2023 18:58:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F730B81B29
        for <linux-xfs@vger.kernel.org>; Fri, 24 Feb 2023 02:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174A0C433EF;
        Fri, 24 Feb 2023 02:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677207504;
        bh=qEgT3hBvVKU+LIIS8cJFJdrqC8r0RiZaYTx0hGYgV5M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C7lHL+d2JftsLpjO/0uC4bAW6XVK0PxrmtT7DIcamL4vsk3mb+9yPAm39k45mCuNn
         hu/WwnDY/vzuUqUfa1+xHQv8hwo+gJUr+1jS941XU9iN46zycHGQ3b0CLnuslWHN+R
         pMg/sZrUzjWDbWqLFJa7JPG+JkkAD+cZAOB2g7i9/CsmvqE3MhIHpOujKwrL18D9JZ
         tBpg/yRIGfHhog0yXJm9KAcrjOy6S2tGfwnGrU8ePenYrpbcI5T/67nLyQLefx6tg3
         6q6TMsFL9VKXIHzvBzy1mmzGNeO7mzcB7xESCNHAo1LD9DlB+b1U4spz9XhZYfBHe8
         MDqUYw3syBmgw==
Date:   Thu, 23 Feb 2023 18:58:23 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v9r2d1 0/5] xfs: encode parent pointer name in xattr
 key
Message-ID: <Y/gnz4BvHee3xcYg@magnolia>
References: <Y+6MxEgswrJMUNOI@magnolia>
 <167657875861.3475422.10929602650869169128.stgit@magnolia>
 <CAOQ4uxgH=npBRBtKZ3TsuLBfpTbDg0hM-DY=8j11+DiRnE0Rig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgH=npBRBtKZ3TsuLBfpTbDg0hM-DY=8j11+DiRnE0Rig@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 18, 2023 at 10:12:05AM +0200, Amir Goldstein wrote:
> On Thu, Feb 16, 2023 at 10:33 PM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > Hi all,
> >
> > As I've mentioned in past comments on the parent pointers patchset, the
> > proposed ondisk parent pointer format presents a major difficulty for
> > online directory repair.  This difficulty derives from encoding the
> > directory offset of the dirent that the parent pointer is mirroring.
> > Recall that parent pointers are stored in extended attributes:
> >
> >     (parent_ino, parent_gen, diroffset) -> (dirent_name)
> >
> > If the directory is rebuilt, the offsets of the new directory entries
> > must match the diroffset encoded in the parent pointer, or the
> > filesystem becomes inconsistent.  There are a few ways to solve this
> > problem.
> >
> > One approach would be to augment the directory addname function to take
> > a diroffset and try to create the new entry at that offset.  This will
> > not work if the original directory became corrupt and the parent
> > pointers were written out with impossible diroffsets (e.g. overlapping).
> > Requiring matching diroffsets also prevents reorganization and
> > compaction of directories.
> >
> > This could be remedied by recording the parent pointer diroffset updates
> > necessary to retain consistency, and using the logged parent pointer
> > replace function to rewrite parent pointers as necessary.  This is a
> > poor choice from a performance perspective because the logged xattr
> > updates must be committed in the same transaction that commits the new
> > directory structure.  If there are a large number of diroffset updates,
> > then the directory commit could take an even longer time.
> >
> > Worse yet, if the logged xattr updates fill up the transaction, repair
> > will have no choice but to roll to a fresh transaction to continue
> > logging.  This breaks repair's policy that repairs should commit
> > atomically.  It may break the filesystem as well, since all files
> > involved are pinned until the delayed pptr xattr processing completes.
> > This is a completely bad engineering choice.
> >
> > Note that the diroffset information is not used anywhere in the
> > directory lookup code.  Observe that the only information that we
> > require for a parent pointer is the inverse of an pre-ftype dirent,
> > since this is all we need to reconstruct a directory entry:
> >
> >     (parent_ino, dirent_name) -> NULL
> >
> > The xattr code supports xattrs with zero-length values, surprisingly.
> > The parent_gen field makes it easy to export parent handle information,
> > so it can be retained:
> >
> >     (parent_ino, parent_gen, dirent_name) -> NULL
> >
> > Moving the ondisk format to this format is very advantageous for repair
> > code.  Unfortunately, there is one hitch: xattr names cannot exceed 255
> > bytes due to ondisk format limitations.  We don't want to constrain the
> > length of dirent names, so instead we could use collision resistant
> > hashes to handle dirents with very long names:
> >
> >     (parent_ino, parent_gen, sha512(dirent_name)) -> (dirent_name)
> >
> > The first two patches implement this schema.  However, this encoding is
> > not maximally efficient, since many directory names are shorter than the
> > length of a sha512 hash.  The last three patches in the series bifurcate
> > the parent pointer ondisk format depending on context:
> >
> > For dirent names shorter than 243 bytes:
> >
> >     (parent_ino, parent_gen, dirent_name) -> NULL
> >
> > For dirent names longer than 243 bytes:
> >
> >     (parent_ino, parent_gen, dirent_name[0:178],
> >      sha512(child_gen, dirent_name)) -> (dirent_name[179:255])
> >
> > The child file's generation number is mixed into the sha512 computation
> > to make it a little more difficult for unprivileged userspace to attempt
> > collisions.
> >
> 
> Naive question:
> 
> Obviously, the spec of stradard xattrs does not allow duplicate keys,
> but dabtree does allow duplicate keys, does it not?

The dabtree allows duplicate hashes for a given name, yes.  It doesn't
allow for duplicate names, though.

(Also note that small xattr structures skip the dabtree and hashing.)

> So if you were to allow duplicate parent pointer records, e.g.:
> 
> (parent_ino, parent_gen) -> dirent_name1
> (parent_ino, parent_gen) -> dirent_name2
> 
> Or to optimize performance for the case of large number of sibling hardlinks
> of the same parent (if that case is worth optimizing):
> 
> (parent_ino, parent_gen, dirent_name[0:178]) -> (dirent_name1[179:255])
> (parent_ino, parent_gen, dirent_name[0:178]) -> (dirent_name2[179:255])
> 
> Then pptr code should have no problem walking all the matching
> parent pointer records to find the unique parent->child record that it
> needs to operate on?

Theoretically, yes, the parent pointer code could walk all the xattrs
that have the same attr name looking for the one with matching value.
But keep in mind that there could be min(2^32, 2^(8+76)) potential
matches.

The other difficulty is that the xattr lookup and removal code don't
have a means to return the dastate to callers or for callers to provide
a dastate to go back into the xattr code.  You'd need that to identify
the specific parent pointer xattr you want to operate on.

> I am sure it would be more complicated than how I depicted it,
> but having to deal with even remote possibility of hash collisions sounds
> like a massive headache - having to maintain code that is really hard to
> test and rarely exercised is not a recipe for peace of mind...

Yep.  Hash functions are definitely finger-crossing headhurting.

--D

> Thanks,
> Amir.
