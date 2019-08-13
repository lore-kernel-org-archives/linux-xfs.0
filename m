Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33010 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725903AbfHMFOZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Aug 2019 01:14:25 -0400
Received: from dread.disaster.area (pa49-181-167-148.pa.nsw.optusnet.com.au [49.181.167.148])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 0631043C386
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2019 15:14:22 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hxP7S-0005LI-Qo
        for linux-xfs@vger.kernel.org; Tue, 13 Aug 2019 15:13:14 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hxP8Z-0005aK-7A
        for linux-xfs@vger.kernel.org; Tue, 13 Aug 2019 15:14:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfsprogs: "Fix" --disable-static option
Date: Tue, 13 Aug 2019 15:14:18 +1000
Message-Id: <20190813051421.21137-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

These patches fix the build failures that come from trying
to prevent static xfsprogs libraries being built via the 
'configure --disable-static' option.

The internal libraries are statically linked to the xfsprogs
binaries, with external dependencies then dynamically linked. Not
building the internal libraries statically results in linking them
dynamically and so the pull in all their dependencies as well. for
example, libfrog has the blkid topology code in it, so when linked
as a shared library it always brings that dependency with it,
regardless of whether the binary actually uses the topology code
or not.

Linking the libraries statically allows dead code elimination to
remove the topology code if it is not used by the binary, hence
eliminating the need to link that binary against libblkid. This
makes the binaries smaller, they load faster, and we don't have to
ship public libraries for all the internal xfsprogs code.

Hence we need to force the internal libraries to build a staticly
linked archive even when a user says "--disable-static". We can do
this by passing libtool the "-static" option on the link link for
each of the internal libraries. Hence we always build static
libraries for the internel libs as the build needs them to be
static.

Doing this, however, exposes the fact taht mkfs has it's own version
of cvtnum and it links against libfrog which also has version of
cvtnum. The linker previously resolved this automatically by using
the local version, but with -static defined it errors out on
multiply-defined symbol errors. SO the first patch fixes the cvtnum
issue. Note i left xfs_estimate alone - it doesn't link against
libfrog, so I didn't remove it's simple cvtnum copy as it's not
necessary to fix the build issue and linking against libfrog might
introduce other issues.

Cheers,

Dave.
