Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43378 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751099AbeC2Pev (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Mar 2018 11:34:51 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 0/10] xfsprogs: remove old cruft
Date: Thu, 29 Mar 2018 10:34:12 -0500
Message-Id: <1522337662-26260-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This is mostly removing old hardcoded "feature" flags which were
settable via the commandline long, long ago but have been lingering
as hardcoded globals since.  Just get rid of them and all the
associated code.

The last 3 remove an option for 20-year-old irix filesystems,
a weirdly triplicated test, and finally adds some #warnings
followed by #error to get the attention of anyone building on
platforms we want to deprecate.

Thanks,
-Eric

