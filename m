Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33750 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390280AbfFKCgv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 22:36:51 -0400
Date: Tue, 11 Jun 2019 10:36:47 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v3 3/6] generic: copy_file_range swapfile test
Message-ID: <20190611023647.GA15846@desktop>
References: <20190602124114.26810-1-amir73il@gmail.com>
 <20190602124114.26810-4-amir73il@gmail.com>
 <20190610035829.GA18429@mit.edu>
 <CAOQ4uxi-s6ncLGjh_u5x4DFK+dvcaobDCqup_ZV3mZOYDRuOEQ@mail.gmail.com>
 <20190610133131.GE15963@mit.edu>
 <20190611021222.GY15846@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611021222.GY15846@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Jun 11, 2019 at 10:12:22AM +0800, Eryu Guan wrote:
[snip]
> > 
> > > Do you think that should there be a different policy w.r.t timing of
> > > merging xfstests tests that fail on upstream kernel?
> > 
> > That's my opinion, and generic/484 is the best argument for why we
> > should wait.  Other people may have other opinions though, and I have
> > a workaround, so I don't feel super-strong about it.  (generic/454 is
> > now the second test in my global exclude file.  :-)
> 
> I don't see generic/454 failing with ext4 (I'm testing with default
> mkfs/mount options, kernel is 5.2-rc2). But IMHO, I think generic/454 is

Oh, I see, I think you meant generic/554 not generic/454 (thanks Darrick
for pointing that out :)

> different, it's not a targeted regression test, it's kind of generic
> test that should work for all filesystems.
> 
> > 
> > At the very *least* there should be a comment in the test that fix is
> > pending, and might not be applied yet, with a URL to the mailing list
> > discussion.  That will save effort when months (years?) go by, and the
> > fix still hasn't landed the upstream kernel....
> 
> Agreed, I've been making sure there's a comment referring to the fix or
> pending fix (e.g. only commit summary no hash ID) for such targeted
> regression tests.

And I took generic/55[34] as generic tests not targeted regression test.
But looks like it's better to reference the fixes anyway.

Amir, would you mind adding such references to generic/55[34] as well?

Thanks,
Eryu
