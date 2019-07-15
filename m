Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41834 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731078AbfGOR7m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 13:59:42 -0400
Subject: [PATCH v2 0/9] iomap: regroup code by functional area
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 15 Jul 2019 10:59:20 -0700
Message-ID: <156321356040.148361.7463881761568794395.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@infradead.org, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, agruenba@redhat.com

Hi all,

This series breaks up fs/iomap.c by grouping the functions by major
functional area (swapfiles, fiemap, seek hole/data, directio, buffered
io, and page migration) in separate source code files under fs/iomap/.
No functional changes have been made.  Please check the copyrights to
make sure the attribution is correct.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D
