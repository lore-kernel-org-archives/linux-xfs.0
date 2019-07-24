Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41067 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfGXGfB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 02:35:01 -0400
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 2/6] xfs: Move fs/xfs/xfs_attr.h to fs/xfs/libxfs/xfs_attr.h
Date: Wed, 24 Jul 2019 06:34:47 +0000
Message-Id: <20190724063451.26190-3-mcgrof@kernel.org>
In-Reply-To: <20190724063451.26190-1-mcgrof@kernel.org>
References: <20190724063451.26190-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, Alexander.Levin@microsoft.com
Cc: gregkh@linuxfoundation.org, stable@vger.kernel.org, amir73il@gmail.com, Allison Henderson <allison.henderson@oracle.com>, Dave Chinner <dchinner@redhat.com>, Dave Chinner <david@fromorbit.com>, Luis Chamberlain <mcgrof@kernel.org>

From: Allison Henderson <allison.henderson@oracle.com>

commit e2421f0b5ff3ce279573036f5cfcb0ce28b422a9 upstream.

This patch moves fs/xfs/xfs_attr.h to fs/xfs/libxfs/xfs_attr.h
since xfs_attr.c is in libxfs.  We will need these later in
xfsprogs.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/{ => libxfs}/xfs_attr.h | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename fs/xfs/{ => libxfs}/xfs_attr.h (100%)

diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
similarity index 100%
rename from fs/xfs/xfs_attr.h
rename to fs/xfs/libxfs/xfs_attr.h
-- 
2.18.0
