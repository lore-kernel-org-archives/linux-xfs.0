Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20304 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753509AbdGUWE1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 18:04:27 -0400
Subject: [PATCH 0/5] miscellaneous tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 21 Jul 2017 15:04:19 -0700
Message-ID: <150067465981.30639.14801416171688538711.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

I decided to roll everything up into a patch series, though these
patches mostly address different things.

So... I've reposted the ext4 fsmap test, refactored the xfs error
injection helpers to work with the new interface in 4.13, and added
support for fuzzing xfs quota record fields.

--D
