Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f173.google.com ([74.125.82.173]:44043 "EHLO
        mail-ot0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751497AbeCTJUs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 05:20:48 -0400
Received: by mail-ot0-f173.google.com with SMTP id 79-v6so931951oth.11
        for <linux-xfs@vger.kernel.org>; Tue, 20 Mar 2018 02:20:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3862e7b0-4136-b864-96f0-2880b05a8940@themaw.net>
References: <CAOQ4uxhubJhspfj+x7yRkTJ4rUXyhZoF0x3kjuFyv-0=Lxrctw@mail.gmail.com>
 <CAOQ4uxh0H8mbbAZt0MEdLGRY-8Aqg2c9UFM56-KL2b90fLYCFQ@mail.gmail.com>
 <20180317212814.GI7000@dastard> <CAOQ4uxit=nHvd2C080QeM27icSFra+0Anwu8vXqs4sd=8tCCNg@mail.gmail.com>
 <20180318230259.GJ7000@dastard> <CAOQ4uxiHkW41RB4LogWi8+rp_NhoC+SHGNY9_ShdQi7OyJTTVA@mail.gmail.com>
 <20180320014709.GC1150@dastard> <CAOQ4uxh+90vyCOqhLXtNi0U+YTsi6nCYuZFJMPhBWUaRwSBDvQ@mail.gmail.com>
 <3862e7b0-4136-b864-96f0-2880b05a8940@themaw.net>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 20 Mar 2018 10:20:47 +0100
Message-ID: <CAJfpeguvjT3271VxePPXm4+Ke6iKbWrMpNSz4Vm6mogXuHPpAw@mail.gmail.com>
Subject: Re: Question about XFS_MAXINUMBER
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ian Kent <raven@themaw.net>
Cc: Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Mar 20, 2018 at 9:04 AM, Ian Kent <raven@themaw.net> wrote:
> Hi Amir, Miklos,
>
> On 20/03/18 14:29, Amir Goldstein wrote:
>>
>> And I do appreciate the time you've put into understanding the overlayfs
>> problem and explaining the problems with my current proposal.
>>
>
> For a while now I've been wondering why overlayfs is keen to avoid using
> a local, persistent, inode number mapping cache?

Think of overlayfs as a normal filesystem, except it's not backed by a
block device, but instead one or more read-only directory tree and
optionally one writable directory tree. There's a twist, however: when
not mounted, you are allowed to change the backing directories.  This
is a really important feature of overlayfs.

So where does the initial mapping come from (overlay is never started
from scratch, like a newly formatted filesystem)?  And what happens
when layers are modified and we encounter unmapped inode numbers?

In both cases we must either create/update the mapping before mount,
or update the mapping on lookup.

Creating/updating the mapping up-front means a really high startup
cost, which can be amortized if the layers are guaranteed not to
change outside of the overlay.

Updating a persistent mapping on lookup means having to do sync writes
on lookup, which can be very detrimental to performance.  If all
layers are read-only, this scheme falls apart, since we've nowhere to
write the persistent mapping.

Or we can just say, screw the persistency and store the mapping on
e.g. tmpfs.  Performance-wise that's much better, but then we fail to
provide the guarantees about inode numbers (e.g. NFS export won't work
properly).

In my opinion it's much less about simplicity of implementation as
about quality of implementation.

Ideas for fixing the above issues are welcome.

Thanks,
Miklos
