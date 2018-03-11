Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36226 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932136AbeCKQYl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Mar 2018 12:24:41 -0400
Date: Sun, 11 Mar 2018 17:24:42 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] xfs: preserve i_rdev when recycling a reclaimable
 inode
Message-ID: <20180311162442.GB2013@kroah.com>
References: <1516952669-14769-1-git-send-email-amir73il@gmail.com>
 <20180126214404.GE9068@magnolia>
 <CAOQ4uxgVaGgwio=538-PP4QuRbcny6q0_CAeV-9bQEWBaxv2gA@mail.gmail.com>
 <20180129155054.GJ9359@magnolia>
 <CAOQ4uxjMfZGMtbq2vRN8dL5QvgC0=UD-yWDbNib=dckDTFR0Nw@mail.gmail.com>
 <20180201003511.GK4849@magnolia>
 <CAOQ4uxjE31j7XDpEGnnym7cgD_kqsPnio4KN2gphajsCNMrG1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjE31j7XDpEGnnym7cgD_kqsPnio4KN2gphajsCNMrG1g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, stable@kernel.org

On Sun, Mar 11, 2018 at 06:08:06PM +0200, Amir Goldstein wrote:
> On Thu, Feb 1, 2018 at 2:35 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > On Thu, Feb 01, 2018 at 02:27:23AM +0200, Amir Goldstein wrote:
> >> On Mon, Jan 29, 2018 at 5:50 PM, Darrick J. Wong
> >> <darrick.wong@oracle.com> wrote:
> >> > On Mon, Jan 29, 2018 at 01:07:36PM +0200, Amir Goldstein wrote:
> >> >> On Fri, Jan 26, 2018 at 11:44 PM, Darrick J. Wong
> >> >> <darrick.wong@oracle.com> wrote:
> >> >> > On Fri, Jan 26, 2018 at 09:44:29AM +0200, Amir Goldstein wrote:
> >> >> >> Commit 66f364649d870 ("xfs: remove if_rdev") moved storing of rdev
> >> >> >> value for special inodes to VFS inodes, but forgot to preserve the
> >> >> >> value of i_rdev when recycling a reclaimable xfs_inode.
> >> >> >>
> >> >> >> This was detected by xfstest overlay/017 with inodex=on mount option
> >> >> >> and xfs base fs. The test does a lookup of overlay chardev and blockdev
> >> >> >> right after drop caches.
> >> >> >>
> >> >> >> Overlayfs inodes hold a reference on underlying xfs inodes when mount
> >> >> >> option index=on is configured. If drop caches reclaim xfs inodes, before
> >> >> >> it relclaims overlayfs inodes, that can sometimes leave a reclaimable xfs
> >> >> >> inode and that test hits that case quite often.
> >> >> >>
> >> >> >> When that happens, the xfs inode cache remains broken (zere i_rdev)
> >> >> >> until the next cycle mount or drop caches.
> >> >> >>
> >> >> >> Fixes: 66f364649d870 ("xfs: remove if_rdev")
> >> >> >> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >> >> >
> >> >> > Looks ok,
> >> >> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> >> >> >
> >> >>
> >> >> I recon that now we should now also strap:
> >> >> Cc: <stable@vger.kernel.org> #v4.15
> >> >>
> >> >> Can I assume, you'll add it on apply?
> >> >
> >> > I'll do a proper backport of this and a couple other critical cow
> >> > fixes after I get the 4.16 stuff merged.
> >> >
> >>
> >> I am not sure what "proper backport" means in the context of
> >> this patch.
> >> This is a v4.15-rc1 regression fix that is based on v4.15-rc8.
> >> It applied cleanly on v4.15.
> >
> > I meant the other things that went into 4.16, like the reflink quota
> > fixes, the directio corruption problems, etc.  Make a branch, add the
> > necessary fixes, run xfstests to make sure it all still works, etc.
> >
> 
> Darrick,
> 
> I may be missing something in the process of stable kernel
> maintenance, but this patch fixes a reproducible v4.15 regression
> (xfstest overlay/017 fails on stable kernel v4.15).
> 
> Is Greg usually picking those stable patches himself or is he waiting
> for xfs maintainers (or xfs stable maintainers) to stage the
> stable patches?

I'm waiting for the patch to either be tagges with cc: stable, or for
someone to tell me to take the patch.

Sometimes I dig through the tree, but for xfs patches, I do not, as was
told not to :)

thanks,

greg k-h
