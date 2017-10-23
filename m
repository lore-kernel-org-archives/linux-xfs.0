Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:46713 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751113AbdJWIkv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2017 04:40:51 -0400
Date: Mon, 23 Oct 2017 19:40:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/17] Parent Pointers V3
Message-ID: <20171023084032.GW3666@dastard>
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
 <CAOQ4uxhzZT=5O6PM4Gp=uSwYPFdrO5X9D8UF54f3jEmM2LxK1Q@mail.gmail.com>
 <20171020224157.GS3666@dastard>
 <CAOQ4uxjQk_82RxzSKWT+UeepkKXtrXbVmNW2wz6Mngq=UX+XZg@mail.gmail.com>
 <20171022232741.GU3666@dastard>
 <CAOQ4uxhu0ModoKNUQPg03Bc=iTrqwX3xuPH=GuvedAHT-XvzXg@mail.gmail.com>
 <20171023053236.GV3666@dastard>
 <CAOQ4uxgH8oza283kL=cUvE7a0SA5wPsD1gyVApBqd2hWHE8y3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgH8oza283kL=cUvE7a0SA5wPsD1gyVApBqd2hWHE8y3w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Oct 23, 2017 at 09:48:24AM +0300, Amir Goldstein wrote:
> On Mon, Oct 23, 2017 at 8:32 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Oct 23, 2017 at 07:30:01AM +0300, Amir Goldstein wrote:
> >> If there is no such reason I would like to propose to store parent
> >> pointers of directory inodes with an xattr name that is diroffset agnostic,
> >> namely:
> >>
> >> struct xfs_dir_parent_name_rec {
> >>       __be64  p_ino;
> >>       __be32  p_gen;
> >> } __attribute__((packed));
> >>
> >> It makes sense for metadata consistency anyway, but the reason I am
> >> proposing this is so xfs_fs_get_name() could be implemented at O(1).

[...]

> But you missed my question completely. I understand why diroffset
> is needed for non-dir. But directories are not allowed to have 2 differnt
> parents nor 2 entries in the parent dir, so I was asking if we can
> special case parent pointer stored in *directory inodes*.

I did answer it - not directly, but the answers are there.

> Am I missing something?

Because you are just looking at it from a "reverse lookup"
perspective, I suspect you're not seeing the "detect and
reconstruct" broken directory structure side of the picture.

The directory offset is redundant information which needed to fully
cross-check and, if necessary, reconstruct broken direcotry
structures. E.g. if a directory is missing a block due to a bad
sector, we can reconstruct that block exactly from the parent
pointer information because we know exactly what inodes had dirents
in the block that was lost, and we know exactly what order they
appeared in the directory block...

If we don't have that info for all child inodes (directory or
regular file), we can't tell the difference between "lost/stale
child that we should ignore" and "child that was referenced by the
block we lost". So even directories need to have the diroffset in
their parent pointer....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
