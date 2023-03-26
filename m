Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE5F6C74A5B
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Mar 2023 03:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjCZDVc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Mar 2023 23:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjCZDVb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Mar 2023 23:21:31 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1772B455
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 20:21:29 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id c1so4744273vsk.2
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 20:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679800889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RQO9O4yUVHCiHtzNJNXV/lo4jxKwtkM4TKi4Y+M+klY=;
        b=N4WW14NFA2LK/1aw8eB58ThArYreumCxIvvi8OG7PENw+0GbFA6pkDdmBmvN0zna6M
         5e0aVrRUxF+j/w8d4D4Yjy1Pqt0j2XdKxkMzBPE7uThQgKIJwbzcX2p/bBsTrQbGeG7L
         qlEMUsOeMd0q6f4BrJg6W0L+EpE2+8lF/ifeMgy4Yjblr7a871pICEgjBicsPEEJJnCy
         RNN70lXA61Y/iqRMCuhUP2ALJpUYzfA9h7a1crAEONAblYC7NF6ehyQmKGLHhZGDsB11
         FXiYwRyWguzFb32aRULzcyq3y+adVh+nnMelnQjGdy11zCbO4B6SvTEFAICl+3IOfTRA
         JALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679800889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RQO9O4yUVHCiHtzNJNXV/lo4jxKwtkM4TKi4Y+M+klY=;
        b=W/Ro+TkrFOuVnehxdeOGllWTthaiG+CoSrKqQReO9hzfiGbpYqgZGeqwGXA0nGqKgj
         P1n2X6E72w33x9v3o3Ccwdl9AeDdMq/Ef1/sOm3mSIe532sRC3a1dW/u0wQaeGXux+Ir
         usYJ9XbUBlqmCLOdFXsiZQ0PR5rty8WVmy7nq4lKHXz/Jflzcl9GfbiVSISzv1jx4KIk
         JE8a2IIHuqXxXnG0w19azn4gIhveSt/8s0kqlOmbDMc/NgHVGRUIcis4Ukgt4T1UdVyU
         +ORIrL0PnJcyUtp1VUjPXJsBBC+SGMsDQBfmgmvVOVcWnCzyB4Q2hlGmLpe/cmgYAnv3
         haxA==
X-Gm-Message-State: AAQBX9eKqUFcAboNp7iVRRLCQGMIseZc7cgQar57V9yKZ6sVFoFUVd29
        Ps6YC2r1AYILt0WiorD+VWnRHyyeVvSC4FWGmqsTxRHjnfw=
X-Google-Smtp-Source: AKy350Z/G/9ceAdQbMLOLVVylBElfGj1ieKc4RBc8zvAoXH5he66CeA7O7zBc2m+2fvVS8xUThCIuy2n0G75n5BYOYY=
X-Received: by 2002:a67:d91a:0:b0:425:b61a:9c13 with SMTP id
 t26-20020a67d91a000000b00425b61a9c13mr3768623vsj.0.1679800888861; Sat, 25 Mar
 2023 20:21:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230316185414.GH11394@frogsfrogsfrogs> <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
 <6e6f7948dfdeac87accb8cd437f0c22d21a2e8e0.camel@oracle.com>
 <CAOQ4uxhVgPt93Wi3Z577gncWSxOE8S0fq5aasLJbffk8Rkg-GQ@mail.gmail.com> <20230325170106.GA16180@frogsfrogsfrogs>
In-Reply-To: <20230325170106.GA16180@frogsfrogsfrogs>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 26 Mar 2023 06:21:17 +0300
Message-ID: <CAOQ4uxj4ZwdCps2qFZCn9hTWcEaq1xUSJs=f1N5B4H4stayDPQ@mail.gmail.com>
Subject: Re: [PATCHSET v10r1d2 00/17] xfs: encode parent pointer name in xattr key
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Mar 25, 2023 at 8:01=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Sat, Mar 25, 2023 at 10:59:16AM +0300, Amir Goldstein wrote:
> > On Fri, Mar 24, 2023 at 8:19=E2=80=AFPM Allison Henderson
> > <allison.henderson@oracle.com> wrote:
> > >
> > > On Thu, 2023-03-16 at 12:17 -0700, Darrick J. Wong wrote:
> > > > Hi all,
> > > >
> > > > As I've mentioned in past comments on the parent pointers patchset,
> > > > the
> > > > proposed ondisk parent pointer format presents a major difficulty f=
or
> > > > online directory repair.  This difficulty derives from encoding the
> > > > directory offset of the dirent that the parent pointer is mirroring=
.
> > > > Recall that parent pointers are stored in extended attributes:
> > > >
> > > >     (parent_ino, parent_gen, diroffset) -> (dirent_name)
> > > >
> > > > If the directory is rebuilt, the offsets of the new directory entri=
es
> > > > must match the diroffset encoded in the parent pointer, or the
> > > > filesystem becomes inconsistent.  There are a few ways to solve thi=
s
> > > > problem.
> > > >
> > > > One approach would be to augment the directory addname function to
> > > > take
> > > > a diroffset and try to create the new entry at that offset.  This
> > > > will
> > > > not work if the original directory became corrupt and the parent
> > > > pointers were written out with impossible diroffsets (e.g.
> > > > overlapping).
> > > > Requiring matching diroffsets also prevents reorganization and
> > > > compaction of directories.
> > > >
> > > > This could be remedied by recording the parent pointer diroffset
> > > > updates
> > > > necessary to retain consistency, and using the logged parent pointe=
r
> > > > replace function to rewrite parent pointers as necessary.  This is =
a
> > > > poor choice from a performance perspective because the logged xattr
> > > > updates must be committed in the same transaction that commits the
> > > > new
> > > > directory structure.  If there are a large number of diroffset
> > > > updates,
> > > > then the directory commit could take an even longer time.
> > > >
> > > > Worse yet, if the logged xattr updates fill up the transaction,
> > > > repair
> > > > will have no choice but to roll to a fresh transaction to continue
> > > > logging.  This breaks repair's policy that repairs should commit
> > > > atomically.  It may break the filesystem as well, since all files
> > > > involved are pinned until the delayed pptr xattr processing
> > > > completes.
> > > > This is a completely bad engineering choice.
> > > >
> > > > Note that the diroffset information is not used anywhere in the
> > > > directory lookup code.  Observe that the only information that we
> > > > require for a parent pointer is the inverse of an pre-ftype dirent,
> > > > since this is all we need to reconstruct a directory entry:
> > > >
> > > >     (parent_ino, dirent_name) -> NULL
> > > >
> > > > The xattr code supports xattrs with zero-length values, surprisingl=
y.
> > > > The parent_gen field makes it easy to export parent handle
> > > > information,
> > > > so it can be retained:
> > > >
> > > >     (parent_ino, parent_gen, dirent_name) -> NULL
> > > >
> > > > Moving the ondisk format to this format is very advantageous for
> > > > repair
> > > > code.  Unfortunately, there is one hitch: xattr names cannot exceed
> > > > 255
> > > > bytes due to ondisk format limitations.  We don't want to constrain
> > > > the
> > > > length of dirent names, so instead we create a special VLOOKUP mode
> > > > for
> > > > extended attributes that allows parent pointers to require matching
> > > > on
> > > > both the name and the value.
> > > >
> > > > The ondisk format of a parent pointer can then become:
> > > >
> > > >     (parent_ino, parent_gen, dirent_name[0:242]) ->
> > > > (dirent_name[243:255])
> >
> > With VLOOKUP in place, why is this better than
> > (parent_ino, parent_gen) -> (dirent_name)
> >
> > Is it because the dabtree hash is calculated only on the key
> > and changing that would be way more intrusive?
>
> Yes.  The dabtree hash is calculated on the full attr name, so this is
> an attempt to reduce hash collisions during parent pointer lookups by
> stuffing as many bytes in the attr name as possible.
>
> It would be very easy to change the xfs_da_hashname calls inside
> xfs_parent.c to use either the full dirent name (i.e. pptr hash matches
> dirent hash) or use the full parent pointer and not just the attr key,
> but that would be a major break from the tradition that the da hash is
> computed against the attr name only.
>
> (I'm not opposed to doing that too, but one breaking change at a time.
> ;))
>
> > Does that mean that user can create up to 2^12
> > parent pointers with the same hash and we are fine with it?
>
> Yes.  The dabtree can handle an xattr structure where every name hashes
> to the same value, though performance will be slow as it scans every
> attr to find the one it wants.
>
> The number of parent pointers with the same hash can be much higher
> than 2^12 -- I wrote a dumb C program that creates an arbitrary number
> of attr names with identical hashes.  It's not fast when you get past
> 100,000. :P
>

Right.
So how about
(parent_ino, parent_gen, dirent_hash) -> (dirent_name)

This is not a breaking change and you won't need to do another
breaking change later.

This could also be internal to VLOOKUP: appended vhash to
attr name and limit VLOOKUP name size to  255 - vhashsize.

Thanks,
Amir.
