Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:32837 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751874AbeDBAK1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Apr 2018 20:10:27 -0400
Received: by mail-ot0-f175.google.com with SMTP id 23-v6so14184790otj.0
        for <linux-xfs@vger.kernel.org>; Sun, 01 Apr 2018 17:10:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e0ada9ef-aafb-5179-2729-447d67bd6265@sandeen.net>
References: <e0ada9ef-aafb-5179-2729-447d67bd6265@sandeen.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 1 Apr 2018 18:10:26 -0600
Message-ID: <CAJCQCtTA4YPxYupZjeb41dYxJGjZm1=W30mtfMPDuusNp6XjLA@mail.gmail.com>
Subject: Re: xfs_scrub: call for testing
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Feb 2, 2018 at 2:36 PM, Eric Sandeen <sandeen@sandeen.net> wrote:


>
> I'd really value feedback on scrub as it stand at this point -
> Is the documentation clear?  Is the output correct?  Do the
> tool's arguments make sense?  Does it segfault?  Does it
> find real errors?  Does it crash your kernel? Does it
> eat your data?

xfsprogs-4.15.1-1.fc27.x86_64
I've built mainline 4.16.0-rc7 with CONFIG_XFS_ONLINE_SCRUB=y but I get this:

[chris@f27s ~]$ sudo xfs_scrub -T -v /mnt/fourth
EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
Phase 1: Find filesystem geometry.
/mnt/fourth: using 4 threads to scrub.
Info: /mnt/fourth: Kernel metadata repair facility not detected.
Info: /mnt/fourth: Kernel metadata repair facility is not available.
Use -n to scrub.
Info: /mnt/fourth: Scrub aborted after phase 1.
/mnt/fourth: errors found: 1
Memory used: 132k/0k (17k/116k), time:  0.40/ 0.00/ 0.01s
I/O: 84.0KiB in, 0.0B out, 84.0KiB tot
I/O rate: 211.4KiB/s in, 0.0B/s out, 211.4KiB/s tot

Kernel message

mount
[  329.930644] SGI XFS with ACLs, security attributes, scrub, no debug enabled
[  329.940197] XFS (dm-16): Mounting V5 Filesystem
[  330.553888] XFS (dm-16): Ending clean mount

scrub command
[  373.941951] XFS (dm-16): EXPERIMENTAL online scrub feature in use.
Use at your own risk!


[chris@f27s ~]$ grep XFS linux/.config
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_XFS_ONLINE_SCRUB=y
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
# CONFIG_VXFS_FS is not set
[chris@f27s ~]$


When I try it with just -n then I get entries

Info: AG 2 superblock: Optimization is possible.

that appears to be working but it's also a noop.

Also the -n output has many unicode complaints with full filenames in
the output. e.g.

Info: inode 1815560251 (27/3620923): Unicode name
"Chapter\xc2\xa02.\xc2\xa0Securing Your Network.webloc" in directory
should be normalized as "Chapter 2. Securing Your Network.webloc".

This should be less verbose by default. Perhaps something generic
like, "Some unicode filenames should be normalized, use -v for verbose
output."  I don't want to have to report a scrub with a bunch of
filenames interlaced in the output. Plus that's nothing I can or even
want to do anything about. That file likely came from a Mac using
netatalk or samba. Hopefully the repair mode for scrub doesn't
normalize these files, I don't really want to find out the hard way
that corrected files then can't be properly read over that same
network connection or otherwise have filenames apparently mangled.



-- 
Chris Murphy
