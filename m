Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16408 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751258AbdEIBxa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 May 2017 21:53:30 -0400
Date: Mon, 8 May 2017 18:53:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ioctl_getfsmap.2: document the GETFSMAP ioctl
Message-ID: <20170509015324.GM5973@birch.djwong.org>
References: <20170507155855.GD5970@birch.djwong.org>
 <CAG48ez1AWewJRg8gySgihn0y15jRhC6C+5DNwGsDpAhtokB=Lw@mail.gmail.com>
 <20170508184112.GJ5973@birch.djwong.org>
 <CAG48ez3e+2VuvjtEfJuMujEo6PWBO3z8oM-otN2juq96jKdjCw@mail.gmail.com>
 <20170508204738.GL5973@birch.djwong.org>
 <CAG48ez0iLRazKvXty9CG8ENXvkG6b1xjO0Q75p+16HKNptFnow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez0iLRazKvXty9CG8ENXvkG6b1xjO0Q75p+16HKNptFnow@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jann Horn <jannh@google.com>
Cc: Michael Kerrisk-manpages <mtk.manpages@gmail.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, linux-man@vger.kernel.org

On Tue, May 09, 2017 at 12:54:57AM +0200, Jann Horn wrote:
> On Mon, May 8, 2017 at 10:47 PM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > On Mon, May 08, 2017 at 08:47:56PM +0200, Jann Horn wrote:
> >> On Mon, May 8, 2017 at 8:41 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >> > On Mon, May 08, 2017 at 12:17:53AM +0200, Jann Horn wrote:
> >> >> On Sun, May 7, 2017 at 5:58 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >> >> > Document the new GETFSMAP ioctl that returns the physical layout of a
> >> >> > (disk-based) filesystem.
> >> [...]
> >> >> Also: From a quick glance at the XFS implementation, I don't see any
> >> >> privilege checks. Am I missing something, or does this API permit an
> >> >> unprivileged user to determine the number of physical blocks allocated
> >> >> for any inode, even for inodes the user can't ordinarily see in any
> >> >> way?
> >> >
> >> > Correct.
> >>
> >> What's your reasoning for why this doesn't create any new potential
> >> security issues? For example, as far as I can tell, this would permit
> >
> > /Any/ ?  That is a huge request to be dropping on me after the vfs patch
> > gets merged, after a year-long review cycle, etc.
> 
> Fair point.
> 
> >> an unprivileged user to determine with high probability whether a set
> >> of large files with known sizes is stored anywhere in the filesystem, even
> >> across containers or so.
> >
> > How large?  How high?
> >
> > Do you have a tool that analyzes a set of st_blocks values and compares
> > the set to known profiles in order to guess what's on the filesystem?
> > With what accuracy can it do that, especially without explicit path or
> > stat data?  The maximum resolution provided by the ioctl is fs block
> > size, so it's not like you can guess that this 1268432 byte file is
> > libclangAnalysis.a; all you know is that there are four 310-block files
> > on this filesystem -- on this system that's the desktop wallpaper, a
> > file from each of libclang and libgimp, and libc6 from my aarch64 guest.
> 
> This would probably become more realistic for larger files, like
> conference recordings - with sizes like 200075, 48338, 155870, 134800
> blocks -, although admittedly I don't have a specific scenario in mind in
> which someone knowing what conference recordings I have on my disk
> would be problematic.

TBH, I /did/ build a (crappy) tool that tries to construct fingerprints
based on the fsmaps it finds for each inode number.  It works reasonably
well for identifying the existence (and number) of reflink clones of any
part of the file tree that you can stat and FIEMAP.  It also works (sort
of) if you have multiple separate filesystems with roughly the same fs
trees in them.  Mixing things into one big file produces a lot of noise,
and data files are harder to pick out unless they're deduped.

> You're probably right about this not being a particularly important
> concern, and I recognize that if I had wanted a different API, I should
> have said so a year ago.

I don't mind people bringing up specific concerns and making specific
requests for the rest of the 4.12 cycle since it's relatively easy to
make small changes to the interface (e.g. adding a capability check).

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
