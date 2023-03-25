Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 467DBC6FD1C
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Mar 2023 07:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjCYH7a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Mar 2023 03:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjCYH73 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Mar 2023 03:59:29 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982C713D77
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 00:59:28 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id e12so2970371uaa.3
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 00:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679731167;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z+TcPuWFbBidYFLZAcz5NXu48VJq5gos4PuChALq4ak=;
        b=FzQ/Q1H8SR4NBiOyRbT44MmUcYO1aOEJ5IWofsXzKrMw3Q5sfO2y54NB/ZeG2bPAOh
         FAl41ia/P0+mEK6bpWujvBiefnVweqceIEq6EvhmIHqhbWr4KZzsh3tazj1bfZMYElAd
         sIRQjxjvPowCKMta+BrTB+fnAk1cg1als4yP3SKdQB2rGy6ftdjVVAx17QU9J4hQJJx+
         aFI2wrNnxWDp98GAyiJz8QDzwHUtIiHIrcXs0ri3OFLMtLJMhqOPUW162ajbpPR9S3mH
         ur1uh3ToXRuiPghbG3P+/2JaYf2Q+W4524X15I1/1RIAQMFQ7DlPXXJQkR0gGWWkrGik
         gBGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679731167;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z+TcPuWFbBidYFLZAcz5NXu48VJq5gos4PuChALq4ak=;
        b=64enY21yHLDlOyekzwwfYDAWOvgReleiqk4Xo1UWDWwgk51UdPskVwJ6lNnZKmhWcL
         BacstrDHrK/kPPgh83V1C1TFgYyU4kb5hMl+IUwbVylPRB1X0w2a52QKlUAaWfz6Gjqc
         yr+KQJjuaGVkc5wXFoq8KLGSQvHEY8fJfQNiv6211UxyJeRIiSZpENfziXEbujphVzYd
         n7LhyXwnNidlpobfUmZ7JiPbrntbnHNhVSbZ7CHeHUR/GTZr7yYIIK1wyvv0cRVBMIQl
         ZJCJV6au5Ej/4feXDYJfdOPHqc3Pi9i54zJ4LnB/swToZKiErtXPOcXheaWBK3Z0oKPw
         q2LA==
X-Gm-Message-State: AAQBX9d8JnRwP92O/IT7WEO/G4ldQPSLAyniAUC4seBCNnH5ZgdNSwKO
        qkvn3ciZXLY9hLvWK6pnavRKrT1WZ0zYRXWDo8mthO9E
X-Google-Smtp-Source: AKy350bhQ7jc3FV090Rj90ieB61O7b2oWA8zY3Uv1Ue6CocOu6AeyVB9GkavMcXXyjKrA5xTRhV13P/kopWpA3U9p0M=
X-Received: by 2002:a1f:a788:0:b0:401:4daf:d581 with SMTP id
 q130-20020a1fa788000000b004014dafd581mr3075555vke.0.1679731167539; Sat, 25
 Mar 2023 00:59:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230316185414.GH11394@frogsfrogsfrogs> <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
 <6e6f7948dfdeac87accb8cd437f0c22d21a2e8e0.camel@oracle.com>
In-Reply-To: <6e6f7948dfdeac87accb8cd437f0c22d21a2e8e0.camel@oracle.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 25 Mar 2023 10:59:16 +0300
Message-ID: <CAOQ4uxhVgPt93Wi3Z577gncWSxOE8S0fq5aasLJbffk8Rkg-GQ@mail.gmail.com>
Subject: Re: [PATCHSET v10r1d2 00/17] xfs: encode parent pointer name in xattr key
To:     Allison Henderson <allison.henderson@oracle.com>,
        "djwong@kernel.org" <djwong@kernel.org>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 24, 2023 at 8:19=E2=80=AFPM Allison Henderson
<allison.henderson@oracle.com> wrote:
>
> On Thu, 2023-03-16 at 12:17 -0700, Darrick J. Wong wrote:
> > Hi all,
> >
> > As I've mentioned in past comments on the parent pointers patchset,
> > the
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
> > One approach would be to augment the directory addname function to
> > take
> > a diroffset and try to create the new entry at that offset.  This
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
> > replace function to rewrite parent pointers as necessary.  This is a
> > poor choice from a performance perspective because the logged xattr
> > updates must be committed in the same transaction that commits the
> > new
> > directory structure.  If there are a large number of diroffset
> > updates,
> > then the directory commit could take an even longer time.
> >
> > Worse yet, if the logged xattr updates fill up the transaction,
> > repair
> > will have no choice but to roll to a fresh transaction to continue
> > logging.  This breaks repair's policy that repairs should commit
> > atomically.  It may break the filesystem as well, since all files
> > involved are pinned until the delayed pptr xattr processing
> > completes.
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
> > The parent_gen field makes it easy to export parent handle
> > information,
> > so it can be retained:
> >
> >     (parent_ino, parent_gen, dirent_name) -> NULL
> >
> > Moving the ondisk format to this format is very advantageous for
> > repair
> > code.  Unfortunately, there is one hitch: xattr names cannot exceed
> > 255
> > bytes due to ondisk format limitations.  We don't want to constrain
> > the
> > length of dirent names, so instead we create a special VLOOKUP mode
> > for
> > extended attributes that allows parent pointers to require matching
> > on
> > both the name and the value.
> >
> > The ondisk format of a parent pointer can then become:
> >
> >     (parent_ino, parent_gen, dirent_name[0:242]) ->
> > (dirent_name[243:255])

With VLOOKUP in place, why is this better than
(parent_ino, parent_gen) -> (dirent_name)

Is it because the dabtree hash is calculated only on the key
and changing that would be way more intrusive?

Does that mean that user can create up to 2^12
parent pointers with the same hash and we are fine with it?

I don't think it is a problem, just wanted to understand and
ask that the reason for this part in the format be explained.

Thanks,
Amir.
