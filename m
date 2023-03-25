Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37AD9C6FD1F
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Mar 2023 17:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbjCYRBJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Mar 2023 13:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCYRBJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Mar 2023 13:01:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B54419A5
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 10:01:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AE9C60C83
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 17:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B30C433D2;
        Sat, 25 Mar 2023 17:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679763667;
        bh=8w8P+1m5pOOgr30eloOei9QIN2HeuyUfHV0Pmq1GjUY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A1GGT9Bsl9Xd/81AqhpnZH73devqeXpjN+cJkC5QJSwWkSq/Fi0wMOBfWRcjJrH5Z
         jv1daQiiiogTp7eb1XF7DjTELc2nhQkYgUaDAJ8o/yix/OHf+yBH4eRoruyJriOr68
         EGLh1YhGDBUeFziCANdkl5g68KOTrj46YgmJGa7emVLoGjNhnfQvrZ0fRATAfxwiT1
         v9aD2zz3rqdHDMYoZXZ7C91AzDu0chWbzvS1cMjms8S/OQgIpz8cPYL24vcSM1FkiO
         179YQ7CzY6XDXITUH9C+6BZFAvFxtK/Hx8D/40V5WSG8cdy7bCgt8m+F8VGYhu98Xw
         EDBF67FNG7+7g==
Date:   Sat, 25 Mar 2023 10:01:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCHSET v10r1d2 00/17] xfs: encode parent pointer name in
 xattr key
Message-ID: <20230325170106.GA16180@frogsfrogsfrogs>
References: <20230316185414.GH11394@frogsfrogsfrogs>
 <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
 <6e6f7948dfdeac87accb8cd437f0c22d21a2e8e0.camel@oracle.com>
 <CAOQ4uxhVgPt93Wi3Z577gncWSxOE8S0fq5aasLJbffk8Rkg-GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxhVgPt93Wi3Z577gncWSxOE8S0fq5aasLJbffk8Rkg-GQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Mar 25, 2023 at 10:59:16AM +0300, Amir Goldstein wrote:
> On Fri, Mar 24, 2023 at 8:19 PM Allison Henderson
> <allison.henderson@oracle.com> wrote:
> >
> > On Thu, 2023-03-16 at 12:17 -0700, Darrick J. Wong wrote:
> > > Hi all,
> > >
> > > As I've mentioned in past comments on the parent pointers patchset,
> > > the
> > > proposed ondisk parent pointer format presents a major difficulty for
> > > online directory repair.  This difficulty derives from encoding the
> > > directory offset of the dirent that the parent pointer is mirroring.
> > > Recall that parent pointers are stored in extended attributes:
> > >
> > >     (parent_ino, parent_gen, diroffset) -> (dirent_name)
> > >
> > > If the directory is rebuilt, the offsets of the new directory entries
> > > must match the diroffset encoded in the parent pointer, or the
> > > filesystem becomes inconsistent.  There are a few ways to solve this
> > > problem.
> > >
> > > One approach would be to augment the directory addname function to
> > > take
> > > a diroffset and try to create the new entry at that offset.  This
> > > will
> > > not work if the original directory became corrupt and the parent
> > > pointers were written out with impossible diroffsets (e.g.
> > > overlapping).
> > > Requiring matching diroffsets also prevents reorganization and
> > > compaction of directories.
> > >
> > > This could be remedied by recording the parent pointer diroffset
> > > updates
> > > necessary to retain consistency, and using the logged parent pointer
> > > replace function to rewrite parent pointers as necessary.  This is a
> > > poor choice from a performance perspective because the logged xattr
> > > updates must be committed in the same transaction that commits the
> > > new
> > > directory structure.  If there are a large number of diroffset
> > > updates,
> > > then the directory commit could take an even longer time.
> > >
> > > Worse yet, if the logged xattr updates fill up the transaction,
> > > repair
> > > will have no choice but to roll to a fresh transaction to continue
> > > logging.  This breaks repair's policy that repairs should commit
> > > atomically.  It may break the filesystem as well, since all files
> > > involved are pinned until the delayed pptr xattr processing
> > > completes.
> > > This is a completely bad engineering choice.
> > >
> > > Note that the diroffset information is not used anywhere in the
> > > directory lookup code.  Observe that the only information that we
> > > require for a parent pointer is the inverse of an pre-ftype dirent,
> > > since this is all we need to reconstruct a directory entry:
> > >
> > >     (parent_ino, dirent_name) -> NULL
> > >
> > > The xattr code supports xattrs with zero-length values, surprisingly.
> > > The parent_gen field makes it easy to export parent handle
> > > information,
> > > so it can be retained:
> > >
> > >     (parent_ino, parent_gen, dirent_name) -> NULL
> > >
> > > Moving the ondisk format to this format is very advantageous for
> > > repair
> > > code.  Unfortunately, there is one hitch: xattr names cannot exceed
> > > 255
> > > bytes due to ondisk format limitations.  We don't want to constrain
> > > the
> > > length of dirent names, so instead we create a special VLOOKUP mode
> > > for
> > > extended attributes that allows parent pointers to require matching
> > > on
> > > both the name and the value.
> > >
> > > The ondisk format of a parent pointer can then become:
> > >
> > >     (parent_ino, parent_gen, dirent_name[0:242]) ->
> > > (dirent_name[243:255])
> 
> With VLOOKUP in place, why is this better than
> (parent_ino, parent_gen) -> (dirent_name)
> 
> Is it because the dabtree hash is calculated only on the key
> and changing that would be way more intrusive?

Yes.  The dabtree hash is calculated on the full attr name, so this is
an attempt to reduce hash collisions during parent pointer lookups by
stuffing as many bytes in the attr name as possible.

It would be very easy to change the xfs_da_hashname calls inside
xfs_parent.c to use either the full dirent name (i.e. pptr hash matches
dirent hash) or use the full parent pointer and not just the attr key,
but that would be a major break from the tradition that the da hash is
computed against the attr name only.

(I'm not opposed to doing that too, but one breaking change at a time.
;))

> Does that mean that user can create up to 2^12
> parent pointers with the same hash and we are fine with it?

Yes.  The dabtree can handle an xattr structure where every name hashes
to the same value, though performance will be slow as it scans every
attr to find the one it wants.

The number of parent pointers with the same hash can be much higher
than 2^12 -- I wrote a dumb C program that creates an arbitrary number
of attr names with identical hashes.  It's not fast when you get past
100,000. :P

> I don't think it is a problem, just wanted to understand and
> ask that the reason for this part in the format be explained.

NP.  Thanks for asking!

--D

> Thanks,
> Amir.
