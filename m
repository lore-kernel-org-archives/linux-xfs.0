Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38923 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933152AbdCHAbo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Mar 2017 19:31:44 -0500
Subject: [PATCH 0/3] xfsprogs: 4.11 rollup
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 07 Mar 2017 16:30:04 -0800
Message-ID: <148893300446.23674.6348172768180643163.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here are a few patches I have for xfsprogs 4.11.  The first patch
changes the codebase to use the system-defined clone/dedupe ioctl
definitions; the second is Brian Foster's xfs_repair fix for zero length
symlinks; and the third enables the xfs_io shutdown command for non-XFS
filesystems, since ext4 and f2fs can now handle the ioctl.

--Darrick
