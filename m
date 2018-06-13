Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34362 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934978AbeFMTcB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jun 2018 15:32:01 -0400
Subject: [PATCH 0/5] xfsprogs-4.17: mkfs config file enhancements
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 13 Jun 2018 12:31:39 -0700
Message-ID: <152891829964.3968.4760134019673731615.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This series refactors the build system so that we can generate a mkfs
configuration file template from the defaults hardwired into the source
code.  We can ship the template as /etc/xfs/mkfs/default.template and we
can also put it in the mkfs.xfs manpage.  The series is based off of
Eric's mkfs-config branch as of 12-June-2018.

--D
