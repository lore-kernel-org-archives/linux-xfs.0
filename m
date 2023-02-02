Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9141BC636CD
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Feb 2023 00:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjBBA4f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Feb 2023 19:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjBBA4e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Feb 2023 19:56:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DF95C0DF
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 16:56:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BF50B82397
        for <linux-xfs@vger.kernel.org>; Thu,  2 Feb 2023 00:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC8EC433D2;
        Thu,  2 Feb 2023 00:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675299390;
        bh=IB8IaMA4lJcEEdjnaf3owaBMOEhDsbdZepq/uSGsJqg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OI+4001exq9BdC+4qlJXeOiuwyC+qg3wikOma4QFFSI7mEOo2pu842vuhVxneAh8C
         OhiF70yttpqShfS/K5B7Ma2sklzHuvpl2T1wlPTLdcngBntGbvdXMzcoD+frGIT3oH
         c853FQ7y/X6bRsOZw4JTIfHvToHdbJvs1TkHn70kyT7fT6Cqs/WSttsw0C6aBsmZ9y
         0jjuqX8XfbuXw/rqNc+Muvi+zXyKgXGM5jQmPbKzcROOupDou5O+s359JQyCbj26UR
         sM2ovn2Ljm/skrVf1C+zAN/iC6SN1hfClmhRycmJEG+XDE8i9RYkOmGN17vSUsuU9J
         w8xO2JQTUdY/g==
Date:   Wed, 1 Feb 2023 16:56:30 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Daan De Meyer <daan.j.demeyer@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: mkfs.xfs protofile and paths with spaces
Message-ID: <Y9sKPpxL4D4+AQaY@magnolia>
References: <CAO8sHc=t1nnLrQDL26zxFA5MwjYHNWTg16tN0Hi+5=s49m5Xxg@mail.gmail.com>
 <Y9CLq0vtmwIDUl92@magnolia>
 <CAO8sHckmTuVktyoB6fT42ohTt-L41Gt3=E2wGhpydBfWbrtJ0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO8sHckmTuVktyoB6fT42ohTt-L41Gt3=E2wGhpydBfWbrtJ0g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 25, 2023 at 12:09:28PM +0100, Daan De Meyer wrote:
> > ...
> 
> While a "-d" switch would be great to have, it'd also be great if we
> could make the protofile format work with escaped spaces. That way we
> can just add escaping for spaces in our tooling that calls mkfs.xfs
> and we don't have to do ugly version checks on the mkfs binary version
> to figure out which option to use.

...which comes at a cost of making *us* figure out some gross hack to
retrofit that into the protofile format.

The easiest hack I can think of is to amend the protofile parser to
change any slash in the name to a space before creating the directory
entry.  Slashes aren't allowed (and right now produce a corrupt
filesystem) so I guess that's the easy way out:

# cat /tmp/protofile
/
0 0
d--775 1000 1000
: Descending path /code/t/fstests
 get/isk.sh   ---775 1000 1000 /code/t/fstests/getdisk.sh
 ext4.ftrace  ---664 1000 1000 /code/t/fstests/ext4.ftrace
 ocfs2.ftrace ---664 1000 1000 /code/t/fstests/ocfs2.ftrace
 xfs.ftrace   ---644 1000 1000 /code/t/fstests/xfs.ftrace
$
# mkfs.xfs -p /tmp/protofile /dev/sda -f
meta-data=/dev/sda               isize=512    agcount=4, agsize=1298176
# xfs_db -c 'ls /' /dev/sda
/:
8          128                directory      0x0000002e   1 . (good)
10         128                directory      0x0000172e   2 .. (good)
12         131                regular        0xd8830694  10 get/isk.sh
(corrupt)
15         132                regular        0x3a30d3ae  11 ext4.ftrace
(good)
18         133                regular        0x3d313221  12 ocfs2.ftrace
(good)
21         134                regular        0x28becaee  10 xfs.ftrace
(good)
# xfs_repair -n /dev/sda
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
entry contains illegal character in shortform dir 128
would have junked entry "get/isk.sh" in directory inode 128
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
entry contains illegal character in shortform dir 128
would have junked entry "get/isk.sh" in directory inode 128
        - agno = 2
        - agno = 1
        - agno = 3
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.

Would that (replace slash with space) help?

--D

> On Wed, 25 Jan 2023 at 02:53, Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Mon, Jan 23, 2023 at 10:13:12PM +0100, Daan De Meyer wrote:
> > > Hi,
> > >
> > > We're trying to use mkfs.xfs's "-p" protofile option for unprivileged
> > > population of XFS filesystems. However, the man page does not specify
> > > how to encode filenames with spaces in them. Spaces are used as the
> > > token delimiter so I was wondering if there's some way to escape
> > > filenames with spaces in them?
> >
> > Spaces in filenames apparently weren't common when protofiles were
> > introduced in the Fourth Edition Unix in November 1973[1], so that
> > wasn't part of the specification for them:
> >
> >     "The prototype file contains tokens separated by spaces or new
> >      lines."
> >
> > The file format seems to have spread to other filesystems (minix, xenix,
> > afs, jfs, aix, etc.) without anybody adding support for spaces in
> > filenames.
> >
> > One could make the argument that the protofile parsing code should
> > implicitly 's/\// /g' in the filename token since no Unix supports
> > slashes in directory entries, but that's not what people have been
> > doing for the past several decades.
> >
> > At this point, 50 years later, it probably would make more sense to
> > clone the mke2fs -d functionality ("slurp up this directory tree") if
> > there's interest?  Admittedly, at this point it's so old that we ought
> > to rev the entire format.
> >
> > [1] https://dspinellis.github.io/unix-v4man/v4man.pdf (page 274)
> > or https://man.cat-v.org/unix-6th/8/mkfs
> >
> > --D
> >
> > > Cheers,
> > >
> > > Daan De Meyer
