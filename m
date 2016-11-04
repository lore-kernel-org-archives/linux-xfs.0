Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46031 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932496AbcKDSaJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 14:30:09 -0400
Subject: [PATCH 00/11] xfsprogs: miscellaneous libxfs cleanups
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 11:30:05 -0700
Message-ID: <147828420554.31492.4173929442743951581.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is a patchset that aims to fix various discrepancies between the
kernel and xfsprogs' copies of libxfs/.  They shouldn't affect the
behavior of either codebase while bringing the benefit that libxfs-apply
will run more smoothly.

The first two patches fix some problems that Coverity found with the
initial commit of userspace support for reflink.  After that are nine
patches that fix a few places where the kernel and xfsprogs' copies of
libxfs have gotten out of sync.  The penultimate patch refactors the
directory freescan code so that xfs_repair and kernel can use the same
code without the macro wrappers.  The final patch is a script to show
the differences between any file that appears in both libxfs/
directories.

--Darrick
