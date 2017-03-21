Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:34378 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757058AbdCUTrO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Mar 2017 15:47:14 -0400
Received: by mail-yw0-f193.google.com with SMTP id d191so423993ywe.1
        for <linux-xfs@vger.kernel.org>; Tue, 21 Mar 2017 12:47:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRt7_WpEp0npF=k1JJHFLE2sfc9ktB4YakuCZ5CNfZTTg@mail.gmail.com>
References: <CAJCQCtQ8aZn5y7WjCC=PamChxSw9Fd=0D7o2+S_GEbifV1h+ig@mail.gmail.com>
 <20170315072349.GZ5280@birch.djwong.org> <CAJCQCtR8RLOBxK7S9Ck0ATT_5vVY6T9rmLtKrYGLPJTrsDRdNQ@mail.gmail.com>
 <20170315191355.GF5280@birch.djwong.org> <20170315193040.GG5280@birch.djwong.org>
 <CAJCQCtRt7_WpEp0npF=k1JJHFLE2sfc9ktB4YakuCZ5CNfZTTg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 21 Mar 2017 13:47:12 -0600
Message-ID: <CAJCQCtRVuKiOMdtGLb3QbR8uCTXbhFMnNQgPzzZWG7y6URawHQ@mail.gmail.com>
Subject: Re: boot failure after kernel update, imap claims in-use inode 661690
 is free, would correct imap
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs list <linux-xfs@vger.kernel.org>

On Thu, Mar 16, 2017 at 10:07 PM, Chris Murphy <lists@colorremedies.com> wrote:

> Yuck. I'll ask on systemd list if there's a way to get more verbose
> information about this without that. It really ought to be in
> systemd.log_level=debug anyway.

I've gotten one response so far, which did not answer the question how
to get more verbose debug information.
https://lists.freedesktop.org/archives/systemd-devel/2017-March/038502.html

The assertion there is that it's virtually certainly an EBUSY exit code.

Additionally:
a. Systemd only ever does a remount to read-only with root fs. It
never umounts it.
https://github.com/systemd/systemd/blob/master/src/core/umount.c line 413

b. The three messages suggests that it's retrying to remount ro.

c. The failure to remount ro is predicted by the plymouth message "It
is running from the root file system, and thus likely to block
re-mounting of the root file system to read-only."

d. All of this happens on ext4, XFS, and Btrfs. But only XFS manifests
by being unbootable.

Ostensibly all file system (volume formats) could be dirty. I didn't
previously check this. But repeating the test with ext4 I find this
after the offline update reboot

[root@f25h ~]# e2fsck -nfv /dev/mapper/vg-f25ext1
e2fsck 1.43.3 (04-Sep-2016)
Warning: skipping journal recovery because doing a read-only filesystem check.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (7195921, counted=7185813).
Fix? no

Free inodes count wrong (1961935, counted=1957897).
Fix? no

OK so what about mounting?

[25247.672099] EXT4-fs (dm-11): recovery complete
[25247.676051] EXT4-fs (dm-11): mounted filesystem with ordered data
mode. Opts: (null)

OK sure enough. ext4 is dirty too. It just doesn't manifest by being
unbootable. It boots after offline update, and gets fixed by journal
replay.


https://github.com/systemd/systemd/blob/master/src/core/shutdown.c
line 213 suggests a sync happens. This sync is after pk offline update
has finished, so why is this sync not syncing with XFS and ext4? Why
does the kernel permit a reboot before root fs has been cleanly
umounted?

Meanwhile, retesting on Btrfs, offline check reports no error after
the pk offline update reboot; nor when mounting the fs.



-- 
Chris Murphy
