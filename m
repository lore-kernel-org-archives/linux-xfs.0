Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33778 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754068AbeBAAfX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jan 2018 19:35:23 -0500
Date: Wed, 31 Jan 2018 16:35:11 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: preserve i_rdev when recycling a reclaimable
 inode
Message-ID: <20180201003511.GK4849@magnolia>
References: <1516952669-14769-1-git-send-email-amir73il@gmail.com>
 <20180126214404.GE9068@magnolia>
 <CAOQ4uxgVaGgwio=538-PP4QuRbcny6q0_CAeV-9bQEWBaxv2gA@mail.gmail.com>
 <20180129155054.GJ9359@magnolia>
 <CAOQ4uxjMfZGMtbq2vRN8dL5QvgC0=UD-yWDbNib=dckDTFR0Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjMfZGMtbq2vRN8dL5QvgC0=UD-yWDbNib=dckDTFR0Nw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, stable@kernel.org

On Thu, Feb 01, 2018 at 02:27:23AM +0200, Amir Goldstein wrote:
> On Mon, Jan 29, 2018 at 5:50 PM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > On Mon, Jan 29, 2018 at 01:07:36PM +0200, Amir Goldstein wrote:
> >> On Fri, Jan 26, 2018 at 11:44 PM, Darrick J. Wong
> >> <darrick.wong@oracle.com> wrote:
> >> > On Fri, Jan 26, 2018 at 09:44:29AM +0200, Amir Goldstein wrote:
> >> >> Commit 66f364649d870 ("xfs: remove if_rdev") moved storing of rdev
> >> >> value for special inodes to VFS inodes, but forgot to preserve the
> >> >> value of i_rdev when recycling a reclaimable xfs_inode.
> >> >>
> >> >> This was detected by xfstest overlay/017 with inodex=on mount option
> >> >> and xfs base fs. The test does a lookup of overlay chardev and blockdev
> >> >> right after drop caches.
> >> >>
> >> >> Overlayfs inodes hold a reference on underlying xfs inodes when mount
> >> >> option index=on is configured. If drop caches reclaim xfs inodes, before
> >> >> it relclaims overlayfs inodes, that can sometimes leave a reclaimable xfs
> >> >> inode and that test hits that case quite often.
> >> >>
> >> >> When that happens, the xfs inode cache remains broken (zere i_rdev)
> >> >> until the next cycle mount or drop caches.
> >> >>
> >> >> Fixes: 66f364649d870 ("xfs: remove if_rdev")
> >> >> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >> >
> >> > Looks ok,
> >> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> >> >
> >>
> >> I recon that now we should now also strap:
> >> Cc: <stable@vger.kernel.org> #v4.15
> >>
> >> Can I assume, you'll add it on apply?
> >
> > I'll do a proper backport of this and a couple other critical cow
> > fixes after I get the 4.16 stuff merged.
> >
> 
> I am not sure what "proper backport" means in the context of
> this patch.
> This is a v4.15-rc1 regression fix that is based on v4.15-rc8.
> It applied cleanly on v4.15.

I meant the other things that went into 4.16, like the reflink quota
fixes, the directio corruption problems, etc.  Make a branch, add the
necessary fixes, run xfstests to make sure it all still works, etc.

--D

> CC'ing stable for attention.
> 
> This patch is now in master, but due to its timing it did not
> get the CC: stable tag.
> 
> Thanks,
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
