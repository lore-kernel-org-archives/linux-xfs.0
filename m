Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25948 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938814AbcKDScL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 14:32:11 -0400
Subject: [PATCH 0/6] xfs: miscellaneous libxfs cleanups
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 11:31:35 -0700
Message-ID: <147828429514.31793.3070284385118900515.stgit@birch.djwong.org>
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

The patches in this series port various libxfs changes into the kernel
codebase.  The penultimate patch refactors the directory freescan code
so that xfs_repair and kernel can use the same code without the macro
wrappers.  

--Darrick
