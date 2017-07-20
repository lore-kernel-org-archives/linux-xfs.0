Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47764 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964784AbdGTRHe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jul 2017 13:07:34 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C66E5C03BD7D
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2017 17:07:34 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A071717B64
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2017 17:07:34 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [ANNOUNCE] xfsprogs: v4.12.0 released!
Message-ID: <f216d8f6-d59b-2424-2ec4-d20f508d265b@redhat.com>
Date: Thu, 20 Jul 2017 12:07:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi Folks,

The xfsprogs repositories have just been updated and tagged with the
v4.12.0 release tag. It can be found here:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git v4.12.0

Release tarballs are hosted on kernel.org, and can be found here:

https://kernel.org/pub/linux/utils/fs/xfs/xfsprogs/

This release includes a new "xfs_spaceman" tool for space management
commands, and a new "fsmap" command for xfs_io.

Other somewhat user-visible changes include the tagging of xfs metadumps
with information about obfuscation and log state, and a modification
to xfs_info / xfs_growfs so that it will only work on actual mountpoints,
rather than files within a mountpoint, to avoid admin misfires.

Many thanks go to all the contributors to this release. The summary
of changes since v4.7.0 can be found listed in doc/CHANGES.  Changes
since -rc2 are shown below.

Onward to 4.13!  

Cheers,

Eric.

---

The new head of the master branch is commit:

0602fbe xfsprogs: Release v4.12.0

New Commits:

Darrick J. Wong (2):
      [4944def] xfs_db: redirect printfs when metadumping to stdout
      [68f7f68] libxfs: propagate transaction block reservations

Eric Sandeen (3):
      [746d40a] mkfs.xfs: allow specification of 0 data stripe width & unit
      [533d1d2] xfs_db: properly set inode type
      [0602fbe] xfsprogs: Release v4.12.0


Code Diffstat:

 VERSION          |  2 +-
 configure.ac     |  2 +-
 db/io.c          | 16 ++++++++++++++++
 db/metadump.c    | 15 +++++++++++++--
 debian/changelog |  6 ++++++
 doc/CHANGES      |  6 ++++++
 libxfs/trans.c   |  7 ++++++-
 mkfs/xfs_mkfs.c  | 11 ++++++++++-
