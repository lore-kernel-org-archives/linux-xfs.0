Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34464 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbdJaWrb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 18:47:31 -0400
Date: Tue, 31 Oct 2017 15:47:26 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC] xfs: fix reporting supported extra file attributes for
 statx()
Message-ID: <20171031224726.GC4911@magnolia>
References: <20171031221305.12908-1-mcgrof@kernel.org>
 <20171031222723.GX4911@magnolia>
 <CAB=NE6X=ey2Uu1Uwm6CjU4CLqwUpkvAEHahmug0bci-f4nt8fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=NE6X=ey2Uu1Uwm6CjU4CLqwUpkvAEHahmug0bci-f4nt8fw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: David Howells <dhowells@redhat.com>, xfs <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Tue, Oct 31, 2017 at 03:38:32PM -0700, Luis R. Rodriguez wrote:
> On Tue, Oct 31, 2017 at 3:27 PM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > On Tue, Oct 31, 2017 at 03:13:05PM -0700, Luis R. Rodriguez wrote:
> >> statx(2) notes that any attribute that is not indicated as supported by
> >> stx_attributes_mask has no usable value. Commit 5f955f26f3d42d ("xfs: report
> >> crtime and attribute flags to statx") added support for informing userspace
> >> of extra file attributes but forgot to list these flags as supported
> >> making reporting them rather useless for the pedantic userspace author.
> >
> > Maybe the vfs should WARN_ON(stat->attributes & ~stat->attributes_mask); to
> > prevent us from screwing this up further?
> 
> Its unclear, what was the mask devised for then, was it envisioned
> that there will be filesystems that will set some values but yet
> purposely list them as unsupported?

It's for flags like ENCRYPTED so userspace can distinguish between the
bit being unset meaning that the file is plaintext vs. the filesystem
not knowing what encrypted files are at all.

(Well ok it'd probably be more useful for a NOCOW bit so that you can
distinguish a COW file vs. a filesystem that doesn't COW at all, but
evidently that isn't wired up.)

--D

> >> $ git describe --contains 5f955f26f3d42d04aba65590a32eb70eedb7f37d
> >> v4.11-rc6~5^2^2~2
> >>
> >> Fixes: 5f955f26f3d42d ("xfs: report crtime and attribute flags to statx")
> >> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> >> ---
> >>
> >> Its unclear why David left these out or if it was just a mistake, I checked
> >> the original patch thread [0] but it was not clear in the end. David?
> >>
> >> Also, I posted a patch to add support to clearing these flags through
> >> xfs_repair on symlinks [1] due to the pain this can cause as you have no option
> >> but to use xfs_db to fix these otherwise. Since we *didn't* list these extra
> >> file attributes as supported, it begs the question if instead we should only
> >> set them *and* this mask if !S_ISLNK(inode->i_mode)).
> >>
> >> If so, that also begs the question if we should add further sanity check
> >> on the xfs setattr to ensure these are never set on symbolic links, despite the
> >> fact that FS_IOC_FSSETXATTR ioctl won't be able to set them...
> >
> > Sure.
> 
> Alright, I'll let things wind down and if I don't hear otherwise back
> will make the change.
> 
>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
