Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:35143 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753440AbcKNHXx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2016 02:23:53 -0500
Received: by mail-lf0-f50.google.com with SMTP id b14so51565302lfg.2
        for <linux-xfs@vger.kernel.org>; Sun, 13 Nov 2016 23:23:53 -0800 (PST)
MIME-Version: 1.0
From: John Henderson <jhender982@gmail.com>
Date: Mon, 14 Nov 2016 01:23:50 -0600
Message-ID: <CA+sGqUv5X4JKQrMoOvVJupL4JadocZCd=AgzwfeR4iWjc_tG7w@mail.gmail.com>
Subject: Which version of xfs-progs to use on Debian?
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

I'm trying to determine the optimal combination of kernel version and
xfs-progs version to use on a Debian Jessie system (for amd64).

I've searched this mailing list, and noticed the following exchange:

  http://www.spinics.net/lists/xfs/msg36165.html

specifically, Dave's response:

  "As it is, in future the version of xfsprogs will tell you what
kernel has the same feature support. i.e. xfsprogs 4.2.0 has exactly
the same code/feature support as kernel 4.2.0. Similarly for
xfsprogs/kernel 4.3.0."

I'm also aware that prior to xfsprogs 4.2.0, userspace versioning did
not match kernel numbering, as noted:

  https://git.kernel.org/cgit/fs/xfs/xfsprogs-dev.git/refs/tags
  https://www.spinics.net/lists/xfs/msg33984.html

So, as I understand the situation, xfsprogs 3.2.x was associated with
a lot of different 3.x and 4.y (y<2) kernels.  Further, I want to make
sure to take advantage of all the (current and future) reliability
improvements of the new xfs v5 on-disk format, which means (from what
I follow) that I need at least kernel 3.15 and xfsprogs 3.2.0, as seen
here:

  https://www.spinics.net/lists/xfs/msg27961.html

My main concern focuses on the options currently available in Debian
(primarily Jessie + backports).  Here's the matchup of what Debian
ships (jessie, jessie-bpo, and stretch):

                      linux-kernel     xfs-progs
Jessie:               3.16.36          3.2.1
Jessie Backports:     4.7.8            4.3.0
Stretch:              4.8.5            4.3.0

So, at first pass, I could just use native jessie's kernel 3.16.36 and
xfsprogs 3.2.1 (and they seem to match well, as they were released
together).  However, I actually have to use a more recent kernel
anyway for some SkyLake support issues.  So, that takes us to at least
kernel 4.7.8.  I note, though, that jessie-backports is *not*
packaging xfsprogs 4.7 alongside its kernel (but instead xfsprogs
4.3.0); similar issues exist for the 4.8.5 kernel from stretch.

Assuming I stick to binary packages distributed through the official
Debian repos, what's the recommendation of the xfs experts: would I be
better off (in terms of reliability) with xfsprogs 3.2.1 or xfsprogs
4.3.0 used with kernel 4.7.8?  As an alternative, would it be even
better for me to use xfsprogs 4.7 (via compiling from source, even
though I'd rather not)?

Also, what are current best-practice parameters for 'mkfs.xfs' in
order to optimize reliability?  Filesystem size is ~10 TB on top of
LUKS-encrypted Software RAID-1 (using enterprise 512e drives).

I'd assume, we'd at least want the following:

  -m crc=1 finobt=1

Any pointers to a good write-up on optimizing such creation (and
later, mount-time) decisions?

Thanks so much (and for all your work on XFS, too).

-John
