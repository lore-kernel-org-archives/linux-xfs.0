Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:39437 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbfB0RLN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Feb 2019 12:11:13 -0500
MIME-Version: 1.0
References: <20190226181407.44612-1-bfoster@redhat.com> <CAOQ4uxg12SAKrSpX8_cdx4Cs56FVjdXiH5U1e8Y3yyCegNYDSw@mail.gmail.com>
 <20190227131838.GA49593@bfoster> <20190227141732.GA49946@bfoster> <20190227155419.qmjzfbviolg6cwht@MacBook-Pro-91.local>
In-Reply-To: <20190227155419.qmjzfbviolg6cwht@MacBook-Pro-91.local>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 27 Feb 2019 19:11:00 +0200
Message-ID: <CAOQ4uxg8c1HifyGaSxii6SD6bCBMyk2Riq98Co0E8o+OZ6yL3g@mail.gmail.com>
Subject: Re: [PATCH] generic: skip dm-log-writes tests on XFS v5 superblock filesystems
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>
Cc: Brian Foster <bfoster@redhat.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

> > FYI, I gave this a try and it didn't ultimately work because mkfs didn't
> > clear the device either. I ended up reproducing the problem, physically
> > zeroing the device, replaying the associated FUA and observing the
> > problem go away. From there, if I replay to the final FUA mark and go
> > back to the (originally) problematic FUA, the problem is reintroduced.
> >
>
> Sorry guys, whenever I run log-writes on xfs I use my helper script here
>
> https://github.com/josefbacik/log-writes
>
> specifically replay-individual-faster.sh.  This creates a snapshot at every
> replay point, mounts and checks the fs, and then destroys the snapshot and keeps
> going.  This way you don't end up with the "new" data still being on the device.
> It's not super fast, but this is usually a fire and forget sort of thing.  I
> could probably integrate this into xfstests for our log-writes tests, those tend
> to not generate large logs so wouldn't take super long.  Does this fix the
> problem for you Brian?
>

Chronicles of generic/482:
- [RFC] version used dm snapshot and reported that XFS survived the test:
https://marc.info/?l=fstests&m=152101818830823&w=1
- Alas, this RFC abused $TEST_DEV as the snapshot CoW device
During review and the need of the snapshot was questioned and
it was speculated that replay should be sufficient and faster.
- [v2] version dropped dm snapshots saying:
"Get rid of dm-snapshot which is pretty slow if we're creating and
 deleting snapshots repeatedly.
 (Maybe LVM thin provision would be much better, but current replay
 solution is good so far, and no slower than dm-snapshot)"
https://marc.info/?l=fstests&m=152221632920271&w=1
- This version already reported failures on XFS
- Dave has already identified the problem back then:
https://marc.info/?l=fstests&m=152228022208188&w=1
his conclusion was this "implies a write ordering problem".
What we have is:
- writing in the future
- going back to the past without wiping the future writes
I guess you can call that a write ordering problem ;-)

Qu,

Will you have time to fix the test to use dm thinp snapshots?

Thanks,
Amir.
