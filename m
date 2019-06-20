Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55548 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfFTV3i (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jun 2019 17:29:38 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 00/11] xfsprogs: remove unneeded #includes
Date: Thu, 20 Jun 2019 16:29:23 -0500
Message-Id: <1561066174-13144-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This is the result of a mechanical process and ... may have a few
oddities, for example removing "init.h" from some utils made me
realize that we inherit it from libxfs and also have it in local
headers; libxfs has a global but so does scrub, etc.  So that stuff
can/should be fixed up, but in the meantime, this zaps out a ton
of header dependencies, and seems worthwhile.

I'll try to do the same thing for the kernel and hold off on
committing the libxfs/* patch here until I can "merge" it in.

-Eric
