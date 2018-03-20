Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58722 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750888AbeCTDI0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Mar 2018 23:08:26 -0400
Subject: [PATCH 0/4] xfsprogs: more misc fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 19 Mar 2018 20:08:19 -0700
Message-ID: <152151529988.18312.2660325658864402943.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here's a bunch more patches for xfsprogs 4.16.

The first patch implements a custom ifork verifier for repair phase 6
so that we can mark directories with invalid parents and later _iget
them so that we can reattach them to whatever parent we find (or
lost+found).

The next couple of patches fix some mountpoint finding bugs so that
users can pass "/home" or "/home/" to programs that take file paths.

The fourth patch enables sparse inodes by default in mkfs.

This probably won't eat your data, and the branch[1] should apply
against for-next.  More patches tomorrow.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
