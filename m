Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39711 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728685AbfFKCNL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 22:13:11 -0400
Date: Tue, 11 Jun 2019 10:13:08 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v3 3/6] generic: copy_file_range swapfile test
Message-ID: <20190611021308.GZ15846@desktop>
References: <20190602124114.26810-1-amir73il@gmail.com>
 <20190602124114.26810-4-amir73il@gmail.com>
 <20190610035829.GA18429@mit.edu>
 <CAOQ4uxi-s6ncLGjh_u5x4DFK+dvcaobDCqup_ZV3mZOYDRuOEQ@mail.gmail.com>
 <20190610133131.GE15963@mit.edu>
 <20190610160616.GE1688126@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610160616.GE1688126@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jun 10, 2019 at 09:06:16AM -0700, Darrick J. Wong wrote:
> On Mon, Jun 10, 2019 at 09:31:31AM -0400, Theodore Ts'o wrote:
> > On Mon, Jun 10, 2019 at 09:37:32AM +0300, Amir Goldstein wrote:
> > >
> > >Why do you think thhis is xfs_io fall back and not kernel fall back to
> > >do_splice_direct()? Anyway, both cases allow read from swapfile
> > >on upstream.
> > 
> > Ah, I had assumed this was changed that was made because if you are
> > implementing copy_file_range in terms of some kind of reflink-like
> > mechanism, it becomes super-messy since you know have to break tons
> > and tons of COW sharing each time the kernel swaps to the swap file.
> > 
> > I didn't think we had (or maybe we did, and I missed it) a discussion
> > about whether reading from a swap file should be prohibited.
> > Personally, I think it's security theatre, and not worth the
> > effort/overhead, but whatever.... my main complaint was with the
> > unnecessary test failures with upstream kernels.
> > 
> > > Trying to understand the desired flow of tests and fixes. 
> > > I agree that generic/554 failure may be a test/interface bug that
> > > we should fix in a way that current upstream passes the test for
> > > ext4. Unless there is objection, I will send a patch to fix the test
> > > to only test copy *to* swapfile.
> > > 
> > > generic/553, OTOH, is expected to fail on upstream kernel.
> > > Are you leaving 553 in appliance build in anticipation to upstream fix?
> > > I guess the answer is in the ext4 IS_IMMUTABLE patch that you
> > > posted and plan to push to upstream/stable sooner than VFS patches.
> > 
> > So I find it kind of annoying when tests land before the fixes do
> > upstream.  I still have this in my global_exclude file:
> 
> Yeah, it's awkward for VFS fixes because on the one hand we don't want
> to have multiyear regressions like generic/484, but OTOH stuffing tests
> in before code goes upstream enables broader testing by the other fs
> maintainers.
> 
> In any case, the fixes are in the copy-range-fixes branch which I'm
> finally publishing...
> 
> > # The proposed fix for generic/484, "locks: change POSIX lock
> > # ownership on execve when files_struct is displaced" would break NFS
> > # Jeff Layton and Eric Biederman have some ideas for how to address it
> > # but fixing it is non-trivial
> 
> Also, uh, can we remove this from the auto and quick groups for now?

I'm fine with that :)

Thanks,
Eryu
