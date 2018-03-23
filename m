Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44742 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751632AbeCWQy1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Mar 2018 12:54:27 -0400
Subject: [PATCH 0/4] misc. fstests changes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 23 Mar 2018 09:54:22 -0700
Message-ID: <152182406249.14523.2186010254497227366.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@linux.alibaba.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi all,

Here's a few test changes.  The first two fix some xfs_scrub call sites
to match the cli arguments that we've settled on for 4.15.  The third
patch is the latest revision of the agfl wrapping zapping fixer, and the
fourth patch teaches xfs/278 to deal with v5 inode field names when
constructing a disconnected directory.

--D
