Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:44603 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752373AbeESRwq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 May 2018 13:52:46 -0400
Received: by mail-oi0-f65.google.com with SMTP id e80-v6so9816958oig.11
        for <linux-xfs@vger.kernel.org>; Sat, 19 May 2018 10:52:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180516090011.GA24959@router-fw-old.local.net-space.pl>
References: <ce584ae1-ee62-2dcb-9366-eb0a6df6e98e@sandeen.net> <20180516090011.GA24959@router-fw-old.local.net-space.pl>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 19 May 2018 11:52:44 -0600
Message-ID: <CAJCQCtQxE7W=M3fp6f=1MXKqgG8sZusMoL3KqNN0VM6cHbd5Vg@mail.gmail.com>
Subject: Re: [GRUB PATCH] xfs: accept filesystem with sparse inodes
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Daniel Kiper <dkiper@net-space.pl>
Cc: Eric Sandeen <sandeen@sandeen.net>, The development of GNU GRUB <grub-devel@gnu.org>, Peter Jones <pjones@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Chris Murphy <lists@colorremedies.com>

On Wed, May 16, 2018 at 3:00 AM, Daniel Kiper <dkiper@net-space.pl> wrote:
> On Tue, May 15, 2018 at 02:55:55PM -0500, Eric Sandeen wrote:
>> The sparse inode metadata format became a mkfs.xfs default in
>> xfsprogs-4.16.0, and such filesystems are now rejected by grub as
>> containing an incompatible feature.
>>
>> In essence, this feature allows xfs to allocate inodes into fragmented
>> freespace.  (Without this feature, if xfs could not allocate contiguous
>> space for 64 new inodes, inode creation would fail.)
>>
>> In practice, the disk format change is restricted to the inode btree,
>> which as far as I can tell is not used by grub.  If all you're doing
>> today is parsing a directory, reading an inode number, and converting
>> that inode number to a disk location, then ignoring this feature
>> should be fine, so I've added it to XFS_SB_FEAT_INCOMPAT_SUPPORTED
>>
>> I did some brief testing of this patch by hacking up the regression
>> tests to completely fragment freespace on the test xfs filesystem, and
>> then write a large-ish number of inodes to consume any existing
>> contiguous 64-inode chunk.  This way any files the grub tests add and
>> traverse would be in such a fragmented inode allocation.  Tests passed,
>> but I'm not sure how to cleanly integrate that into the test harness.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>
> Eric, thank you for posting the patch. LGTM.
>
> Chris, may I ask you to test it and add your "Tested-by:" if it works?

Fedora openQA (which caught the bug) now passes. I did a separate test
making sure sparse inode feature is enabled and grub-probe,
grub-install, grub-mkconfig report no problem. So yeah feel free to
Tested-by to me.

-- 
Chris Murphy
