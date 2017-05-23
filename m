Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:33676 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760765AbdEWD4r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 May 2017 23:56:47 -0400
Received: by mail-yw0-f193.google.com with SMTP id y64so8744272ywe.0
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2017 20:56:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTj4it6o-Fop6vm3s_HFbRemF5o_H9w-tvS6wmFfVwKBA@mail.gmail.com>
References: <20170518012618.GT4519@birch.djwong.org> <20170518013242.GW4519@birch.djwong.org>
 <20170518083405.GQ17542@dastard> <20170518223053.GD4519@birch.djwong.org>
 <CAJCQCtTj-7BovZbXyZu9=Dhh4ROR-AJ6Dpsw1GKbM-a2fr+uVw@mail.gmail.com>
 <20170519210040.GL4519@birch.djwong.org> <20170522020112.GV17542@dastard> <CAJCQCtTj4it6o-Fop6vm3s_HFbRemF5o_H9w-tvS6wmFfVwKBA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 22 May 2017 21:56:45 -0600
Message-ID: <CAJCQCtT5riGri5d3cin9BipUso9mfQ-PBqoPzMZEEYm8RezJdA@mail.gmail.com>
Subject: Re: [PATCH 3/3] xfs: freeze rw filesystems just prior to reboot
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Mon, May 22, 2017 at 2:46 PM, Chris Murphy <lists@colorremedies.com> wrote:

> Second, I have only been able to reproduce this problem with grubby +
> XFS.

OK so this is just on Fedora/RH systems, which is the example case I
have. The kernel RPM is running a script called new-kernel-pkg which
is part of grubby. It's found here:

https://github.com/rhinstaller/grubby/blob/master/new-kernel-pkg

# make sure changes make it to the disk.
# if /boot is a mountpoint, force the meta data on disk
# to by-pass writeback delay.
# PPC64LE-only to deal with Petitboot issues
if [ "$ARCH" = "ppc64le" ]; then
    sync && mountpoint -q /boot && fsfreeze -f /boot && fsfreeze -u /boot
fi


So why only Petitboot on ppc64 is considered to need this?

Also I put zipl in the bootloader category that doesn't need to be totally
reinstalled, which is incorrect it's more like lilo. I guess I was thinking of
yaboot. In any case the main point remains that the common
bootloaders being used these days depend only on modification of a
bootloader configuration file via the file system that file is located
on.


-- 
Chris Murphy
