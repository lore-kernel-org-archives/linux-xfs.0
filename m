Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44698 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbeI0Bsx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 21:48:53 -0400
Subject: [RFC PATCH 00/24] xfs-4.20: major documentation surgery
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 26 Sep 2018 12:34:14 -0700
Message-ID: <153799045443.31202.17537455000771265705.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This series converts the existing in-kernel xfs documentation to rst
format, links it in with the rest of the kernel's rst documetation, and
then begins pulling in the contents of the Data Structures & Algorithms
book from the xfs-documentation git tree.  No changes are made to the
text during the import process except to fix things that the conversion
process (asciidoctor + pandoc) didn't do correctly.  The goal of this
series is to tie together the XFS code with the on-disk format
documentation for the features supported by the code.

I've built the docs and put them here, in case you hate reading rst:
https://djwong.org/docs/kdoc/filesystems/xfs/index.html

I've posted a branch here because the png import patch is huge:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=docs-4.20-merge

The patchset should apply cleanly against 4.19-rc5.  Comments and
questions are, as always, welcome.

--D
