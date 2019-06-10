Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f193.google.com ([209.85.219.193]:42114 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388190AbfFJJIZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 05:08:25 -0400
MIME-Version: 1.0
References: <20190602124114.26810-1-amir73il@gmail.com> <20190602124114.26810-4-amir73il@gmail.com>
 <20190610035829.GA18429@mit.edu> <CAOQ4uxi-s6ncLGjh_u5x4DFK+dvcaobDCqup_ZV3mZOYDRuOEQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxi-s6ncLGjh_u5x4DFK+dvcaobDCqup_ZV3mZOYDRuOEQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 10 Jun 2019 12:08:12 +0300
Message-ID: <CAOQ4uxie1H+9VDO_UjyZXcotnFv+ybfcJdLxX8suP5gOvg_wrA@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] generic: copy_file_range swapfile test
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Eryu Guan <guaneryu@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jun 10, 2019 at 9:37 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Jun 10, 2019 at 6:58 AM Theodore Ts'o <tytso@mit.edu> wrote:
> >
> > On Sun, Jun 02, 2019 at 03:41:11PM +0300, Amir Goldstein wrote:
> > > This test case was split out of Dave Chinner's copy_file_range bounds
> > > check test to reduce the requirements for running the bounds check.
> > >
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >
> > I've just updated to the latest fstests, where this has landed as
> > generic/554.  This test is failing on ext4, and should fail on all
> > file systems which do not support copy_file_range (ext4, nfsv3, etc.),
> > since xfs_io will fall back to emulating this via reading and writing
>
> Why do you think this is xfs_io fall back and not kernel fall back to
> do_splice_direct()? Anyway, both cases allow read from swapfile
> on upstream.
>
> > the file, and this causes a test failure because:
> >
> > > +echo swap files return ETXTBUSY
> > > +_format_swapfile $testdir/swapfile 16m
> > > +swapon $testdir/swapfile
> > > +$XFS_IO_PROG -f -c "copy_range -l 32k $testdir/file" $testdir/swapfile
> > > +$XFS_IO_PROG -f -c "copy_range -l 32k $testdir/swapfile" $testdir/copy
> > > +swapoff $testdir/swapfile
> >
> > Currently, the VFS doesn't prevent us from reading a swap file.
> > Perhaps it shouldn't, for security (theatre) reasons, but root can
> > read the raw block device anyway, so it's really kind of pointless.
> >
>
> Hmm, my intention with the copy_file_range() behavior was that
> it mostly follows user copy limitations/semantics.
> I guess preventing copy *from* swapfile doesn't make much sense
> and we should relax this check in the new c_f_r bounds check in VFS.
>
> > I'm not sure what's the best way fix this, but I'm going to exclude
> > this test in my test appliance builds for now.
> >
>
> Trying to understand the desired flow of tests and fixes.
> I agree that generic/554 failure may be a test/interface bug that
> we should fix in a way that current upstream passes the test for
> ext4. Unless there is objection, I will send a patch to fix the test
> to only test copy *to* swapfile.

I made this change and test still failed on upstream ext4, because
kernel performs copy_file_range() to swapfile.
To me that seems like a real kernel bug, which is addressed by vfs
c_f_r patches, so I don't know if you should be excluding the test
from test appliance after all ?

Thanks,
Amir.

>
> generic/553, OTOH, is expected to fail on upstream kernel.
> Are you leaving 553 in appliance build in anticipation to upstream fix?
> I guess the answer is in the ext4 IS_IMMUTABLE patch that you
> posted and plan to push to upstream/stable sooner than VFS patches.
>
> In any case, the VFS c_f_r patches are aiming for v5.3 and
> I will make sure to promote them for stable as well.
>
> Do you think that should there be a different policy w.r.t timing of
> merging xfstests tests that fail on upstream kernel?
>
> Thanks,
> Amir.
