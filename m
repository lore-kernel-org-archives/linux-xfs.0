Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:46246 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbeCNNbE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Mar 2018 09:31:04 -0400
Received: by mail-wr0-f182.google.com with SMTP id m12so4700646wrm.13
        for <linux-xfs@vger.kernel.org>; Wed, 14 Mar 2018 06:31:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e7a132d5-33de-736f-840a-8de45910846c@sandeen.net>
References: <20180305150546.32191-1-jtulak@redhat.com> <20180305215659.GE18129@dastard>
 <2d50aa97-a03b-128f-f4f6-4a6416fac69b@sandeen.net> <20180305223148.GG18129@dastard>
 <421d1afd-5af1-aef9-e6bb-3addcdeeff3f@sandeen.net> <CACj3i73y_ZWvgdv3aKTKaKGuo+6uhcfy1465T3CD2uQDLE3=xQ@mail.gmail.com>
 <20180306213915.GJ18129@dastard> <CACj3i71SHP90DOAhpS3kWyY_6gnx9OzTqgHy7=uxAZH0cfUKMw@mail.gmail.com>
 <e7a132d5-33de-736f-840a-8de45910846c@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 14 Mar 2018 14:30:42 +0100
Message-ID: <CACj3i73Zb04iHUSS7LNnvegGMe1xaTXwxBjCPnNQg9JmEwQQtQ@mail.gmail.com>
Subject: Re: [PATCH] fsck.xfs: allow forced repairs using xfs_repair
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 9, 2018 at 12:28 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
> If it's critical to report whether errors were fixed, it would be trivial
> to add a new option to xfs_repair which causes it to test fs_is_dirty for
> runs without "-n", and exit with a different value.

I have toyed with it a bit and this seems to be the best option. A
flag that changes the exit code on a successful run. Is exit code 3
ok? According to man page, only 1 and 2 are currently used and the
"everything is ok now, but an issue was there" should not be mixed
with the existing ones. I also thought about a flag that would change
all exit codes to fsck ones, but that seems too complicated and
completely unnecessary.

       [...] always return a  status  code
       of  0  if it completes without problems.  If a runtime error is encoun-
       tered during operation, it will return a status of 1.   In  this  case,
       xfs_repair should be restarted.  If xfs_repair is unable to proceed due
       to a dirty log, it will return a status of 2.

As for the flag, how about -e? It is not used yet and it makes some
sense as "e-exit code."

>
> The approach above looks ok in general.  The main motivation for this
> is to be able to use some config management tool to push out a config
> to a whole fleet of machines in a lab, and have them check/fix the
> root fs without interaction.  If a filesystem is failing to mount due
> to a dirty log, it's likely that the admin is in a more hands-on mode
> by then anyway.
>
> A dirty log could also be "operational error" if we decree that forcefsck
> and friends should only be used on a clean reboot - but I'm less certain
> about that.

I thought about it, but "errors left uncorrected" makes more sense here to me.
>
> Perhaps a guiding principal should be that we have no easy way to repair
> the root fs today in /any/ situation, so any correct/safe improvement
> to that situation is an improvement, even if not all cases are handled
> at this point.
>

Agreed.

Jan
