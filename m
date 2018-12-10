Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56384 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726687AbeLJRam (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Dec 2018 12:30:42 -0500
From: Luis Henriques <lhenriques@suse.com>
Subject: Re: [PATCH v2 00/10] xfstests: add copy/dedupe/clone to fsx/fsstress
References: <154275100143.8611.10235098565750994724.stgit@magnolia>
Date: Mon, 10 Dec 2018 17:30:54 +0000
In-Reply-To: <154275100143.8611.10235098565750994724.stgit@magnolia> (Darrick
        J. Wong's message of "Tue, 20 Nov 2018 13:56:41 -0800")
Message-ID: <874lblthkh.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

"Darrick J. Wong" <darrick.wong@oracle.com> writes:

> Hi all,
>
> This series adds to fsx and fsstress support for FICLONERANGE,
> FIDEDUPERANGE, and copy_file_range.
>
> First, I fix some gcc warnings in fsx.
>
> Then, I teach fsx to read the fsx file after every operation to compare
> it to the good buffer.  This made it easier for me to find corruption
> problem as soon as they happen, though I'm not sure it really makes
> sense to have this enabled by default because of the behavior change
> that it makes.
>
> Next come a couple of generic reworks to fsx that we need to support the
> new clone/dedupe/copy commands.
>
> Patches 5-6 add clone and dedupe to fsx.
>
> Patches 7-8 add copy_file_range support to fsstress and fsx.

An annoying side-effect of these changes is that I now see a couple of
new generic tests failing on cephfs (for example, generic/075).  That's
because fsx does use copy_file_range with the same fd both as source and
destination.  We currently return -EINVAL in that case (as nfs and cifs
seem to be doing as well btw).

At least for the cephfs, this check could eventually be changed but I
would need to spend some time trying and testing the effects of
offloading object copies on the same file.  Of course that another
(easy!) option would be to simply return -EOPNOTSUPP instead and
fallback to the VFS implementation.

Cheers,
-- 
Luis

>
> Dave Chinner contributed some cleanups to the fsx patches as the 9th
> patch.
>
> The last patch fixes the common/dump tests to disable the new commands
> so that the dump/restore tests continue to function exactly as they have
> for years.
>
> There are known failures in 4.20-rc3, particularly with copy_file_range,
> which hopefully have been fixed by the patch series that Dave Chinner
> posted to the xfs list yesterday.  Branch can be downloaded here[1].
>
> --D
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fsstress-clone
