Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54100 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753180AbcKNNvD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Nov 2016 08:51:03 -0500
Subject: Re: Which version of xfs-progs to use on Debian?
References: <CA+sGqUv5X4JKQrMoOvVJupL4JadocZCd=AgzwfeR4iWjc_tG7w@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <479fd03d-4850-ab17-9000-036c0e7e6c53@sandeen.net>
Date: Mon, 14 Nov 2016 07:51:01 -0600
MIME-Version: 1.0
In-Reply-To: <CA+sGqUv5X4JKQrMoOvVJupL4JadocZCd=AgzwfeR4iWjc_tG7w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: John Henderson <jhender982@gmail.com>, linux-xfs@vger.kernel.org

On 11/14/16 1:23 AM, John Henderson wrote:
> Hi,
> 
> I'm trying to determine the optimal combination of kernel version
> and xfs-progs version to use on a Debian Jessie system (for amd64).

Generally, the package version to use with a distribution are the
ones shipped by the distribution.

> I've searched this mailing list, and noticed the following exchange:
> 
> http://www.spinics.net/lists/xfs/msg36165.html
> 
> specifically, Dave's response:
> 
> "As it is, in future the version of xfsprogs will tell you what 
> kernel has the same feature support. i.e. xfsprogs 4.2.0 has exactly 
> the same code/feature support as kernel 4.2.0. Similarly for 
> xfsprogs/kernel 4.3.0."

Yes, but things stay compatible either way

> I'm also aware that prior to xfsprogs 4.2.0, userspace versioning
> did not match kernel numbering, as noted:
> 
> https://git.kernel.org/cgit/fs/xfs/xfsprogs-dev.git/refs/tags 
> https://www.spinics.net/lists/xfs/msg33984.html
> 
> So, as I understand the situation, xfsprogs 3.2.x was associated
> with a lot of different 3.x and 4.y (y<2) kernels.  Further, I want
> to make sure to take advantage of all the (current and future)
> reliability improvements of the new xfs v5 on-disk format, which
> means (from what I follow) that I need at least kernel 3.15 and
> xfsprogs 3.2.0, as seen here:
> 
> https://www.spinics.net/lists/xfs/msg27961.html

FWIW, crcs became /default/ in 3.2.3:

566ebd5 mkfs: default to CRC enabled filesystems
$ git describe --contains 566ebd5
v3.2.3-rc1~2
 
> My main concern focuses on the options currently available in Debian 
> (primarily Jessie + backports).  Here's the matchup of what Debian 
> ships (jessie, jessie-bpo, and stretch):
> 
> linux-kernel     xfs-progs Jessie:               3.16.36
> 3.2.1 Jessie Backports:     4.7.8            4.3.0 Stretch:
> 4.8.5            4.3.0
> 
> So, at first pass, I could just use native jessie's kernel 3.16.36
> and xfsprogs 3.2.1 (and they seem to match well, as they were
> released together).  However, I actually have to use a more recent
> kernel anyway for some SkyLake support issues.  So, that takes us to
> at least kernel 4.7.8.  I note, though, that jessie-backports is
> *not* packaging xfsprogs 4.7 alongside its kernel (but instead
> xfsprogs 4.3.0); similar issues exist for the 4.8.5 kernel from
> stretch.

that's not really a problem per se.  There is no hard requirement
for xfsprogs version to match.  Version tells you more about the time of
release, and so has a loose notion of "matching features" but it's
far from mandatory to match.

> Assuming I stick to binary packages distributed through the official 
> Debian repos, what's the recommendation of the xfs experts: would I
> be better off (in terms of reliability) with xfsprogs 3.2.1 or
> xfsprogs 4.3.0 used with kernel 4.7.8?  As an alternative, would it
> be even better for me to use xfsprogs 4.7 (via compiling from source,
> even though I'd rather not)?
> 
> Also, what are current best-practice parameters for 'mkfs.xfs' in 
> order to optimize reliability?  Filesystem size is ~10 TB on top of 
> LUKS-encrypted Software RAID-1 (using enterprise 512e drives).
> 
> I'd assume, we'd at least want the following:
> 
> -m crc=1 finobt=1
> 
> Any pointers to a good write-up on optimizing such creation (and 
> later, mount-time) decisions?

http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E
 
> Thanks so much (and for all your work on XFS, too).

Newer kernels and newer xfsprogs will /always/ have more features
and bugfixes than older ones (and, rarely, new regressions).

However, other than very rare deprecations, any userspace/kernelspace
pair will /work/ just fine and be compatible, though not all features
may be available.  (Newer userspace than kernelspace may result in
unmountable filesystems though, if you enable some feature at mkfs time
that isn't supported by your kernel.)

Generally, I'd defer to your distro.  It's presumably what they
test, and what they can support.  If you have specific needs not
met by your distro and need to grab something newer, then you're
largely on your own.  There is no "best" release.

-Eric
