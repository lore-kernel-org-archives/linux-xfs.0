Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C502C61DA4
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Feb 2023 08:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjBRIMU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Feb 2023 03:12:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBRIMT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Feb 2023 03:12:19 -0500
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3262B29F
        for <linux-xfs@vger.kernel.org>; Sat, 18 Feb 2023 00:12:17 -0800 (PST)
Received: by mail-vk1-xa29.google.com with SMTP id t194so188574vkt.10
        for <linux-xfs@vger.kernel.org>; Sat, 18 Feb 2023 00:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MHQC6Di3dWAISAIR0iHTkFVDUIbhRf98Sx7wZtJdAlM=;
        b=JqiNxVPpw/pSo1OnBQNOefkWQjUFNMf9KZ+gQISWq+rODQqPtNX2fEIdiGynFIpvSe
         KSedrECHyz03kgkREj4FYxe6YR71pY45YF9hT8b2fduJrKnEOSYPBQKYSX8kwoIehHHP
         SB6KyZ1ykY+FYt/J1It8+w9g5DILG/PVZCiu+eQU4tk36EbHd+k5sD6jLoLCNE8yt+fJ
         R3/CKIWDWYzsZx32ycLFHOgsAFq3/xJcOQ94dkHtbaf0geO8N/1vF5/7P9XGDNcm0Gwf
         07vRO0WOf5HP7Vn0lv20lYhB2qVI6xWN3jULokFRB+B7bWLvlQzIwsOEcdwBgmB+htAd
         HYnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MHQC6Di3dWAISAIR0iHTkFVDUIbhRf98Sx7wZtJdAlM=;
        b=Q5ekCAhUTsSGaoKIimiFPfguF4ZymiYkBlbPYM5GUPWippj8y+4aXKN7OX87H0M9cr
         dxsRGbCPE6Yg8Nxow4UnXSTboJEWkyhFnYEj5PTZCBd9r2qyoDPLZC26hiv1zfJsRkob
         XJbm3NdPUUYUxWiMXgSsMt6J11tqwJSxw1X0gLby9QIjCj1JSUzFacN5xEx6ZAvz3Pen
         5C+hTFgorjo2RXYIKEX0hJ75LTSKHGHxpV5/1+mZj/9XXAyuNINaNr3RU7xDhGZ5rUId
         N5JkoFFz252nMwWkITM7jSnYo0S6YbaI4/foZ5rbZRPkKfHMZoHrHzBjST5dVC1+st7s
         F/QQ==
X-Gm-Message-State: AO0yUKWtEkCuREGHg2N+xtrVSTWn+l0zalnhVL8DvuTUdGzSWSTXEZvP
        Rt/S7/VRlkVQe6S5EF1HewPtGh0y0/buKGM4DV7McTN2
X-Google-Smtp-Source: AK7set/XxtKfKUtXg5fw5GjAOMC63yevf0G3NBdC652KJsnWX+WjlBTcXWzP6xivewiyJ9zHBrEAOF2NqhUmKocOi/0=
X-Received: by 2002:a1f:3881:0:b0:3d5:9b32:7ba4 with SMTP id
 f123-20020a1f3881000000b003d59b327ba4mr598125vka.15.1676707936703; Sat, 18
 Feb 2023 00:12:16 -0800 (PST)
MIME-Version: 1.0
References: <Y+6MxEgswrJMUNOI@magnolia> <167657875861.3475422.10929602650869169128.stgit@magnolia>
In-Reply-To: <167657875861.3475422.10929602650869169128.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 18 Feb 2023 10:12:05 +0200
Message-ID: <CAOQ4uxgH=npBRBtKZ3TsuLBfpTbDg0hM-DY=8j11+DiRnE0Rig@mail.gmail.com>
Subject: Re: [PATCHSET v9r2d1 0/5] xfs: encode parent pointer name in xattr key
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 16, 2023 at 10:33 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> Hi all,
>
> As I've mentioned in past comments on the parent pointers patchset, the
> proposed ondisk parent pointer format presents a major difficulty for
> online directory repair.  This difficulty derives from encoding the
> directory offset of the dirent that the parent pointer is mirroring.
> Recall that parent pointers are stored in extended attributes:
>
>     (parent_ino, parent_gen, diroffset) -> (dirent_name)
>
> If the directory is rebuilt, the offsets of the new directory entries
> must match the diroffset encoded in the parent pointer, or the
> filesystem becomes inconsistent.  There are a few ways to solve this
> problem.
>
> One approach would be to augment the directory addname function to take
> a diroffset and try to create the new entry at that offset.  This will
> not work if the original directory became corrupt and the parent
> pointers were written out with impossible diroffsets (e.g. overlapping).
> Requiring matching diroffsets also prevents reorganization and
> compaction of directories.
>
> This could be remedied by recording the parent pointer diroffset updates
> necessary to retain consistency, and using the logged parent pointer
> replace function to rewrite parent pointers as necessary.  This is a
> poor choice from a performance perspective because the logged xattr
> updates must be committed in the same transaction that commits the new
> directory structure.  If there are a large number of diroffset updates,
> then the directory commit could take an even longer time.
>
> Worse yet, if the logged xattr updates fill up the transaction, repair
> will have no choice but to roll to a fresh transaction to continue
> logging.  This breaks repair's policy that repairs should commit
> atomically.  It may break the filesystem as well, since all files
> involved are pinned until the delayed pptr xattr processing completes.
> This is a completely bad engineering choice.
>
> Note that the diroffset information is not used anywhere in the
> directory lookup code.  Observe that the only information that we
> require for a parent pointer is the inverse of an pre-ftype dirent,
> since this is all we need to reconstruct a directory entry:
>
>     (parent_ino, dirent_name) -> NULL
>
> The xattr code supports xattrs with zero-length values, surprisingly.
> The parent_gen field makes it easy to export parent handle information,
> so it can be retained:
>
>     (parent_ino, parent_gen, dirent_name) -> NULL
>
> Moving the ondisk format to this format is very advantageous for repair
> code.  Unfortunately, there is one hitch: xattr names cannot exceed 255
> bytes due to ondisk format limitations.  We don't want to constrain the
> length of dirent names, so instead we could use collision resistant
> hashes to handle dirents with very long names:
>
>     (parent_ino, parent_gen, sha512(dirent_name)) -> (dirent_name)
>
> The first two patches implement this schema.  However, this encoding is
> not maximally efficient, since many directory names are shorter than the
> length of a sha512 hash.  The last three patches in the series bifurcate
> the parent pointer ondisk format depending on context:
>
> For dirent names shorter than 243 bytes:
>
>     (parent_ino, parent_gen, dirent_name) -> NULL
>
> For dirent names longer than 243 bytes:
>
>     (parent_ino, parent_gen, dirent_name[0:178],
>      sha512(child_gen, dirent_name)) -> (dirent_name[179:255])
>
> The child file's generation number is mixed into the sha512 computation
> to make it a little more difficult for unprivileged userspace to attempt
> collisions.
>

Naive question:

Obviously, the spec of stradard xattrs does not allow duplicate keys,
but dabtree does allow duplicate keys, does it not?

So if you were to allow duplicate parent pointer records, e.g.:

(parent_ino, parent_gen) -> dirent_name1
(parent_ino, parent_gen) -> dirent_name2

Or to optimize performance for the case of large number of sibling hardlinks
of the same parent (if that case is worth optimizing):

(parent_ino, parent_gen, dirent_name[0:178]) -> (dirent_name1[179:255])
(parent_ino, parent_gen, dirent_name[0:178]) -> (dirent_name2[179:255])

Then pptr code should have no problem walking all the matching
parent pointer records to find the unique parent->child record that it
needs to operate on?

I am sure it would be more complicated than how I depicted it,
but having to deal with even remote possibility of hash collisions sounds
like a massive headache - having to maintain code that is really hard to
test and rarely exercised is not a recipe for peace of mind...

Thanks,
Amir.
