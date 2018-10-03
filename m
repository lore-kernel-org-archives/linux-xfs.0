Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:33358 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbeJCKb5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Oct 2018 06:31:57 -0400
Received: by mail-yb1-f195.google.com with SMTP id u88-v6so1812579ybi.0
        for <linux-xfs@vger.kernel.org>; Tue, 02 Oct 2018 20:45:24 -0700 (PDT)
MIME-Version: 1.0
References: <20180907015155.32559-1-david@fromorbit.com> <CAOQ4uxjaAJ9WSo-rtvBq7bFsV4QXHhwqjFyCFO030U4qZ7ALKg@mail.gmail.com>
 <20181001010931.GO31060@dastard> <CAOQ4uxjo1nE38q=FL+EofoMz=1=D2eZYo9s3-TVBSEjbHH52kQ@mail.gmail.com>
 <20181001223244.GH18567@dastard> <CAOQ4uxhTJcEtUJkwO5UCyF1sCFQ=bPo0ragy5255aM30C9Z1Zw@mail.gmail.com>
 <20181002063952.GN18567@dastard> <CAJfpegvcmKiaU-oPfXk0ub6tdBKhDRcUKTkLd5_rAagv05R-EA@mail.gmail.com>
 <20181002231421.GQ18567@dastard>
In-Reply-To: <20181002231421.GQ18567@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 3 Oct 2018 06:45:13 +0300
Message-ID: <CAOQ4uxhrEm4uMhsw5G+_Bv87-zPenJ9gwvDJvCPSmRkQAWiszQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: avoid lockdep false positives in xfs_trans_alloc
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-xfs <linux-xfs@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>, Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

On Wed, Oct 3, 2018 at 2:14 AM Dave Chinner <david@fromorbit.com> wrote:
[...]
> > Seems like freezing any of the layers if overlay itself is not frozen
> > is not a good idea.
>
> That's something we can't directly control. e.g. lower filesystem is
> on a DM volume. DM can freeze the lower fileystem through the block
> device when a dm command is run. It may well be that the admins that
> set up the storage and filesystem layer have no idea that there are
> now overlay users on top of the filesystem they originally set up.
> Indeed, the admins may not even know that dm operations freeze
> filesystems because it happens completely transparently to them.
>

I don't think we should be binding the stacked filesystem issues with
the stacked block over fs issues. The latter is more complex to solve
generally and has by design non limited stack depth. The former has
limited stack depth (2) and each sb knows its own stack depth, which
is already used in overlay to annotate lockdep correctly.

If vfs stores a reverse tree of stacked fs dependencies, then individual
sb freeze can be solved.

Drawing the fire away from overlayfs.. I personally find the behavior that
a process that only has files open for read could block when filesystem is
frozen somewhat unexpected to users (even if I can expect it).

I wonder out loud if it wouldn't be friendlier for any filesystem to defer
"garbage collection" (e.g. truncate deleted inode blocks) to thawing time,
just as those operations are already run on mount (post crash) anyway.

Thanks,
Amir.
