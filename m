Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D62C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Feb 2023 08:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjBBIrK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Feb 2023 03:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbjBBIrJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2023 03:47:09 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B91583966
        for <linux-xfs@vger.kernel.org>; Thu,  2 Feb 2023 00:47:02 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id u5so666995pfm.10
        for <linux-xfs@vger.kernel.org>; Thu, 02 Feb 2023 00:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8dNEO1T4iqw5qiVr47icm8cKXLd4k9zsvJxzKeJhSsg=;
        b=lSIzVXiapYUpUfq5PzdEgsQpjYGybFYu6jGMZT+KesCIypU2RYAUJtsGjn+Z5MEosP
         LdBPY7RyugKfZeUnr2jWbhnvyebPNtbu/p+NlBLYgbcN55XWuoZADnzzMLkQP4v0siNr
         D63KKrL+ZOrq8aScEMXoZPuVCk6WtXI4VojbtGknafZyVRLj/W3EiPeS+iXLprj7jH6A
         Kws+7dUH/4+bVvQIJF7Yzf5igEX5T23IyIPUoZ4DstTHeIN5+8E3i2tXtPmbThsltOM4
         CQMH0urbZalEd+6P6iAdnzb96P3ASmpn4116DFYbIyLWu5+X5pKnjClNYKPLmCa6ys9w
         eGVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8dNEO1T4iqw5qiVr47icm8cKXLd4k9zsvJxzKeJhSsg=;
        b=cJTbz4Mi3eyVsAbartO6ntK2XOmN9EEqQFvIsB1HkI6QLbJgEHnTMS5/4zo5k05Xk/
         0G+ybbrJBzx6Su9RQSSI1rCtxRbz1Ds7OTa7H/2Q29JgIimAzoi2FXldsw06gqGsTlm1
         W0+b44CqXV056SoyVyAIDHyusVI+I0w3ir4vMG2aGPKMuzo9WVkNhbYsHnTCHiAqMrdl
         h9mVMy6UYhCszZVlDNxi5VVzYXqp/OGyEexl7EmPbduaw9DskD5UrEZV88oS2Nm7UpuZ
         rrcqBdHA03mizpkRGmvQBA8DPwOcz9Bpz/MOl0tqea915cXUiY9Re++/xrumYh2oYURb
         uk3A==
X-Gm-Message-State: AO0yUKVufMAYLCzFmz7Drymvy7SX0H9WVA1NKpUZ0i4Vo3y53rO8cPfG
        qm9+IwTL4zq5GNx3HcuVeFB6MFWMyOcLS5hM9bhntETDLe2ECaqN
X-Google-Smtp-Source: AK7set9y6GWeKMEWK+AYBzEh1swk/PH76tWGRvPMAPPmk0WWsOgORrcXXi/rPZTcQ1YwmsbUzkQDU1qO5AGB8ljDT7M=
X-Received: by 2002:aa7:938e:0:b0:593:d7d7:17cb with SMTP id
 t14-20020aa7938e000000b00593d7d717cbmr1125091pfe.5.1675327621640; Thu, 02 Feb
 2023 00:47:01 -0800 (PST)
MIME-Version: 1.0
References: <CAO8sHc=t1nnLrQDL26zxFA5MwjYHNWTg16tN0Hi+5=s49m5Xxg@mail.gmail.com>
 <Y9CLq0vtmwIDUl92@magnolia> <CAO8sHckmTuVktyoB6fT42ohTt-L41Gt3=E2wGhpydBfWbrtJ0g@mail.gmail.com>
 <Y9sKPpxL4D4+AQaY@magnolia>
In-Reply-To: <Y9sKPpxL4D4+AQaY@magnolia>
From:   Daan De Meyer <daan.j.demeyer@gmail.com>
Date:   Thu, 2 Feb 2023 09:46:50 +0100
Message-ID: <CAO8sHcnphXg4OY8D_XUP_3iPeE_qpVM1VwcPYScB6SM45u2qcw@mail.gmail.com>
Subject: Re: mkfs.xfs protofile and paths with spaces
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> ...

> Would that (replace slash with space) help?

That sounds perfect. I can change our tooling to replace spaces with
slashes in the protofile. Theoretically you could also have newlines
and tabs and such in filenames but I don't think we need to support
that since it's pretty insane to do in the first place.

On Thu, 2 Feb 2023 at 01:56, Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Wed, Jan 25, 2023 at 12:09:28PM +0100, Daan De Meyer wrote:
> > > ...
> >
> > While a "-d" switch would be great to have, it'd also be great if we
> > could make the protofile format work with escaped spaces. That way we
> > can just add escaping for spaces in our tooling that calls mkfs.xfs
> > and we don't have to do ugly version checks on the mkfs binary version
> > to figure out which option to use.
>
> ...which comes at a cost of making *us* figure out some gross hack to
> retrofit that into the protofile format.
>
> The easiest hack I can think of is to amend the protofile parser to
> change any slash in the name to a space before creating the directory
> entry.  Slashes aren't allowed (and right now produce a corrupt
> filesystem) so I guess that's the easy way out:
>
> # cat /tmp/protofile
> /
> 0 0
> d--775 1000 1000
> : Descending path /code/t/fstests
>  get/isk.sh   ---775 1000 1000 /code/t/fstests/getdisk.sh
>  ext4.ftrace  ---664 1000 1000 /code/t/fstests/ext4.ftrace
>  ocfs2.ftrace ---664 1000 1000 /code/t/fstests/ocfs2.ftrace
>  xfs.ftrace   ---644 1000 1000 /code/t/fstests/xfs.ftrace
> $
> # mkfs.xfs -p /tmp/protofile /dev/sda -f
> meta-data=/dev/sda               isize=512    agcount=4, agsize=1298176
> # xfs_db -c 'ls /' /dev/sda
> /:
> 8          128                directory      0x0000002e   1 . (good)
> 10         128                directory      0x0000172e   2 .. (good)
> 12         131                regular        0xd8830694  10 get/isk.sh
> (corrupt)
> 15         132                regular        0x3a30d3ae  11 ext4.ftrace
> (good)
> 18         133                regular        0x3d313221  12 ocfs2.ftrace
> (good)
> 21         134                regular        0x28becaee  10 xfs.ftrace
> (good)
> # xfs_repair -n /dev/sda
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
> entry contains illegal character in shortform dir 128
> would have junked entry "get/isk.sh" in directory inode 128
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
> entry contains illegal character in shortform dir 128
> would have junked entry "get/isk.sh" in directory inode 128
>         - agno = 2
>         - agno = 1
>         - agno = 3
> No modify flag set, skipping phase 5
> Phase 6 - check inode connectivity...
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify link counts...
> No modify flag set, skipping filesystem flush and exiting.
>
> Would that (replace slash with space) help?
>
> --D
>
> > On Wed, 25 Jan 2023 at 02:53, Darrick J. Wong <djwong@kernel.org> wrote:
> > >
> > > On Mon, Jan 23, 2023 at 10:13:12PM +0100, Daan De Meyer wrote:
> > > > Hi,
> > > >
> > > > We're trying to use mkfs.xfs's "-p" protofile option for unprivileged
> > > > population of XFS filesystems. However, the man page does not specify
> > > > how to encode filenames with spaces in them. Spaces are used as the
> > > > token delimiter so I was wondering if there's some way to escape
> > > > filenames with spaces in them?
> > >
> > > Spaces in filenames apparently weren't common when protofiles were
> > > introduced in the Fourth Edition Unix in November 1973[1], so that
> > > wasn't part of the specification for them:
> > >
> > >     "The prototype file contains tokens separated by spaces or new
> > >      lines."
> > >
> > > The file format seems to have spread to other filesystems (minix, xenix,
> > > afs, jfs, aix, etc.) without anybody adding support for spaces in
> > > filenames.
> > >
> > > One could make the argument that the protofile parsing code should
> > > implicitly 's/\// /g' in the filename token since no Unix supports
> > > slashes in directory entries, but that's not what people have been
> > > doing for the past several decades.
> > >
> > > At this point, 50 years later, it probably would make more sense to
> > > clone the mke2fs -d functionality ("slurp up this directory tree") if
> > > there's interest?  Admittedly, at this point it's so old that we ought
> > > to rev the entire format.
> > >
> > > [1] https://dspinellis.github.io/unix-v4man/v4man.pdf (page 274)
> > > or https://man.cat-v.org/unix-6th/8/mkfs
> > >
> > > --D
> > >
> > > > Cheers,
> > > >
> > > > Daan De Meyer
