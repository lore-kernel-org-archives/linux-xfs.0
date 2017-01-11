Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36038 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967786AbdAKSEL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2017 13:04:11 -0500
Received: by mail-oi0-f65.google.com with SMTP id u143so27393558oif.3
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2017 10:04:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170111173227.GS14038@birch.djwong.org>
References: <20170110194249.GK14038@birch.djwong.org> <CAOQ4uxggOoFJ_KR40XX2hU+bSr9zqXu9y_7HWqVxTfQ6ETC4hA@mail.gmail.com>
 <CAOQ4uxj+H4ZAXkPgob5ANJW=BDBzj6P2nKbb3aE9w1igGmcRfw@mail.gmail.com> <20170111173227.GS14038@birch.djwong.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 11 Jan 2017 20:04:05 +0200
Message-ID: <CAOQ4uxiQN9wBNoDMxuDWMfa9bi56XEsQrZTt7o2-tF_DvRBSww@mail.gmail.com>
Subject: Re: [RFC PATCH] xfs_db: sanitize geometry on load
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

On Wed, Jan 11, 2017 at 7:32 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Wed, Jan 11, 2017 at 12:01:22PM +0200, Amir Goldstein wrote:
...
> Ok well I definitely don't see /this/ happening.  I gather you built
> xfsprogs with the insane geometry patch; if so, against what git commit?

against djwon-devel from your tree:
75581a8 xfs_db: sanitize geometry on load
2efc292 xfs_scrub: create a script to scrub all xfs filesystems

xfstests head is:
1377e1e xfs: fuzz every field of every structure

> And, did the binary get installed as /usr/sbin/xfs_db, or is this just
> the system xfs_db?

/usr/sbin/xfs_db

I ran "make realclean; make; sudo make install;"

My system is ubuntu 16.4, in case it matters for shell or anything.

>
> In any case, all that extra output is supposed to end up in
> $seqres.full, not on stdout.  At most you should see admonishments about
> scrub or repair failing to detect/fix things; those messages look like:
>
> "offline repair failed (4) with $field = $fuzzverb"
>

Strange. Anyway it's late now and run has not completed yet.
Tomorrow I'll narrow down on 1301 and 1316 to see what's what.

Hopefully, we can get another test sample from Eryu by then,
to see if I'm the only one seeing these errors.

Amir.
