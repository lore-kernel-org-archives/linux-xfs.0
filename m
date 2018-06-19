Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47182 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755280AbeFSUr3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jun 2018 16:47:29 -0400
Received: from [10.0.0.4] (erlite [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id AC76D8A
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jun 2018 15:47:28 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs mkfs-config branch updated to 4d181c6
Message-ID: <a43e3867-7d8b-4a65-5774-881c3b1e16ea@sandeen.net>
Date: Tue, 19 Jun 2018 15:47:27 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi folks,

The mkfs-config branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

****** NOTE ******
I plan to give this a regression test, merge it to for-next, and
push it out as -rc1.  There are cleanups etc that can be done to
the config parsing code, I think, but it's good enough to start
using and testing it.

If anything shows up that is badly broken, I may still yank it
from 4.17 plans.  I'd greatly appreciate some other testing and
feedback if anything looks problematic.
*******************

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the mkfs-config branch is commit:

4d181c6 mkfs: removed unused dft var from open_config_file

New Commits:

Eric Sandeen (3):
      [febdf6d] mkfs: check config realpath for errors
      [7eda100] mkfs: explicitly warn about unknown config token failures
      [4d181c6] mkfs: removed unused dft var from open_config_file


Code Diffstat:

 mkfs/config.c   | 22 ++++++++++++++--------
 mkfs/config.h   |  1 -
 mkfs/xfs_mkfs.c |  2 +-
 3 files changed, 15 insertions(+), 10 deletions(-)
