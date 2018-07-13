Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:34017 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbeGMIxf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jul 2018 04:53:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6UjcBgQhoQvZoWKXnPWoHVNMbeYdyGfYsHdgeA=L1M4wQ@mail.gmail.com>
References: <CAB=NE6UjcBgQhoQvZoWKXnPWoHVNMbeYdyGfYsHdgeA=L1M4wQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 13 Jul 2018 11:39:55 +0300
Message-ID: <CAOQ4uxgd+Z2ADUXdLk3odP9F6KOsrE4HfRpg-1dpP9HS-zbi=Q@mail.gmail.com>
Subject: Re: [ANN] oscheck: wrapper for fstests check.sh - tracking and
 working with baselines
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Chamberlain" <mcgrof@kernel.org>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Sasha Levin <Alexander.Levin@microsoft.com>, Sasha Levin <levinsasha928@gmail.com>, Valentin Rothberg <valentinrothberg@gmail.com>

On Fri, Jul 13, 2018 at 5:43 AM, Luis R. Chamberlain <mcgrof@kernel.org> wrote:
> I had volunteered at the last LSF/MM to help with the stable work for
> XFS. To help with this, as part of this year's SUSE Hackweek, I've
> first generalized my own set of scripts to help track a baseline of
> results from fstests [0], and extended it to be able to easily ramp up
> with fstests on different distributions, and I've also created a
> respective baseline of results against these distributions as a
> further example of how these scripts and wrapper framework can be used

Hi Luis!

Thanks a lot for doing this work!

Will take me some time to try it out, but see some questions below...

> [1]. The distributions currently supported are:
>
>   * Debian testing
>   * OpenSUSE Leap 15.0
>   * Fedora 28
>
> The stable work starts with creating a baseline for v4.17.3. The
> results are visible as a result of expunge files which categorize the
> failures for the different sections tested.

So the only "bad" indication is a test failure?
How about indication about a test that started to pass since baseline?
Tested that started to notrun since baseline?
Are we interested in those?

> Other than careful manual
> inspection of each stable candidate patch, one of the goals will also
> be to ensure such stable patches do not regress the baseline. Work is
> currently underway to review the first set of stable candidate patches
> for v4.17.3, if they both pass review and do not regress the
> established baseline, I'll proceed to post the patches for further
> evaluation from the community.
>
> Note that while I used this for XFS, it should be easy to add support
> for other filesystems, should folks wish to do something similar for
> their filesystems. The current XFS sections being tested are as
> follows, please let me know if we should consider extending this
> further:
>
> # Matches what we expect to be default on the latests xfsprogs
> [xfs]
> MKFS_OPTIONS='-f -m crc=1,reflink=0,rmapbt=0, -i sparse=0'
> USE_EXTERNAL=no
> FSTYP=xfs

Please add a LOGWRITES_DEV to all "internal log" configs.
This is needed to utilize the (relatively) new crash consistency tests
(a.k.a. generic/replay) which caught a few nasty bugs.
Fun fact: the fix for stable 4.4 almost got missed, because your system
was not around ;-)
https://marc.info/?l=linux-xfs&m=152852844615666&w=2

I've used a 10GB LOGWRITES_DEV, which seems to be enough
for the current tests.
I don't think that the dmlogwrite tests play well with external logdev,
so we could probably reuse the same device for LOGWRITES_DEV
for configs that don't use SCRATCH_LOGDEV.

Thanks,
Amir.
