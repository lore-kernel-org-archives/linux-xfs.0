Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35296 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752852AbdERB00 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 May 2017 21:26:26 -0400
Date: Wed, 17 May 2017 18:26:18 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFCRAP 0/3?] xfs: OH GOD MY EYES!
Message-ID: <20170518012618.GT4519@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>

Hi all,

This is a series of three eyewateringly awful patches.  The first two
are semantic patches that perform the long-delayed conversion of double
underscore integer types (e.g. __uint64_t) into the standard C99 types
(e.g. uint64_t) that are available in userspace and the kernel.  They
are both huge, terrifying, and might just piss off vger enough that they
don't come through, but that's fine because if it ever gets approved
I'll simply rerun the sed script:

s/typedef\t__uint8_t/typedef __uint8_t\t/g
s/typedef\t__uint/typedef __uint/g
s/typedef\t__int\([0-9]*\)_t/typedef int\1_t\t/g
s/__uint8_t\t/__uint8_t\t\t/g
s/__uint/uint/g
s/__int\([0-9]*\)_t\t/__int\1_t\t\t/g
s/__int/int/g
/^typedef.*int[0-9]*_t;$/d

against whatever's current in git.  Lines 1-4 and 6 fix whitespace and
indentation problems; lines 5 and 7 perform the actual transformation,
and line 8 removes the old typedefs.

The third patch in this series adds a reboot notifier that freezes any
rw xfs filesystems prior to a soft reboot to reduce the likelihood that
grub (and other deficient xfs drivers) go stumbling through a dirty
filesystem and make our users crazy.

Flame away! :)

--Darrick
