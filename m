Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36110 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751752AbdHaQYT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 12:24:19 -0400
Received: by mail-wm0-f50.google.com with SMTP id f127so788571wmf.1
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 09:24:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170830054420.GI10621@dastard>
References: <20170829235052.21050-1-david@fromorbit.com> <20170830041635.GK27873@wotan.suse.de>
 <20170830054420.GI10621@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 31 Aug 2017 18:23:57 +0200
Message-ID: <CACj3i73Bo22VQpkTL6gRuQ5Kit9UpQJwy0bWv7oysha_F3Y8Rw@mail.gmail.com>
Subject: Re: [PATCH 00/42] mkfs: factor the crap out of the code
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Aug 30, 2017 at 7:44 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Aug 30, 2017 at 06:16:35AM +0200, Luis R. Rodriguez wrote:
>>
>> However this still begs the question of what tests we should run
>> prior and after the full set, and if we had any missing test what
>> we should add, or if we've considered that.
>
> We have nothing that actually tests that the on-disk filesystem
> format values match what is specified on the command line, so
> testing/validation has all been completely manual. I'm not sure we
> can automate it, given the math needed to check that all the fields
> in the superblock are correct and sane for arbitrary mkfs
> configurations on arbitrary block devices.
>
> In the end I basically ran some configs with an old mkfs, dumped the
> superblock with xfs_db for each config, then did the same with the
> new mkfs. I then diffed the output to see if anything came out
> differently. I fixed all the things I found that were different.  I
> ran the checks on 4k and 512 byte sector devices, just to make sure
> nothing went wrong with using probed device sector sizes by default.
> Then I diffed logprint output for different log options (e.g. sector
> size, lsunit, etc) to make sure everything was correct, etc. I
> mounted each filesystem, ran repair on them, etc so that both the
> kernel and repair code could validate the format, too (the kernel
> found the first log formatting bug via CRC errors).  And, of course,
> I ran xfstests over a variety of configs - different block sizes,
> rmap, DAX, etc.
>
> Maybe you can come up with a way of automating this, but for a
> one-off piece of work that affects a point-in-time snapshot of mkfs
> functionality, I'm not sure it's worth the effort to try to make a
> generic test to do this sort of thing.
>

I actually tried to automate this kind of testing. Something similar
to xfs/191, but with testing if the physically written fs is valid and
expected. But I didn't find a way that would work with xfstests
without hacking it to use some other version of mkfs.xfs manually, and
without doing all the math craziness that would be so error-prone...

Anyway, I'm on the sea until 10th September. I might be able to
continue my review and write something tomorrow (Friday) in the
morning before I depart, but more likely I will keep all my comments
until after I return, and see what changes in the meantime. But so
far, it looks like a good job, Dave. :-)

Cheers,
Jan
