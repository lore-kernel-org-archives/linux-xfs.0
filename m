Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36082 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727653AbfEJUSn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 May 2019 16:18:43 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 00/11] libxfs: spring cleaning
Date: Fri, 10 May 2019 15:18:19 -0500
Message-Id: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The first 4 should be easy, just basic cleanups.

Patch 5 gets rid of some "libxfs-ification" of what I think are core libxfs
functions that don't need the prefix, but please correct me if I've got that
wrong.

Patches 6-10 are splitting out the misc functions we've accumulated over
time in various files, and tries to re-organize them to more or less
match their kernel counterparts.  This is just a first step toward being
able to see what we've got, and how we've diverged from kernelspace.
Hopefully it'll help guide us to sharing more files - but in some cases
it's only a couple shared functions, so maye splitting this way doesn't
make sense.

Patch 11 is just cosmetic changes to the resulting kernel-ish files,
to eliminate cosmetic differences and really start to show where things
diverge.  With all these patches applied, a graphical diff between
userspace and kernelspace starts to make a little sense.

If the spawning of new files doesn't seem prudent, I could keep them
all in 1 or 2 bigger files, but keep them in order to match the kernel,
and achieve similar purposes.  Curious to see what folks think.

My main goal with the 2nd half was to get things sliced, diced, and sorted
enough that I could even spot the differences.

Thanks,
-Eric
