Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47492 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1045665AbdDXFd2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Apr 2017 01:33:28 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 87ED7C04BD2D
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2017 05:33:27 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-80.pek2.redhat.com [10.72.8.80])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9575F8D1C0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2017 05:33:26 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH v2 2/2] xfs_io: add missed quotation marks in man page
Date: Mon, 24 Apr 2017 13:33:20 +0800
Message-Id: <1493012000-9454-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The description about set_encpolicy command in xfs_io man page missed
some quotation marks. It's a little picky, but it really causes the
quotation marks can't match each other.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

Actually this's the first version for this patch, I hit this problem
when I tried to add "inode" command under "set_encpolicy" command.

That missed quotation marks always break the format which I used to
describe the "inode" command, so I have to do this change with that
inode command patch together.

Thanks,
Zorro

 man/man8/xfs_io.8 | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index a7c2a1e..a686ef5 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -949,7 +949,7 @@ was specified on the commandline, the maximum possible inode number in
 the system will be printed along with its size.
 .PD
 .TP
-.BI "set_encpolicy [ \-c " mode " ] [ \-n " mode " ] [ \-f " flags " ] [ \-v " version " ] [ " keydesc " ]
+.BI "set_encpolicy [ \-c " mode " ] [ \-n " mode " ] [ \-f " flags " ] [ \-v " version " ] [ " keydesc " ]"
 On filesystems that support encryption, assign an encryption policy to the
 current file.
 .I keydesc
@@ -958,16 +958,16 @@ If not specified, a "default" key descriptor of all 0's will be used.
 .RS 1.0i
 .PD 0
 .TP 0.4i
-.BI \-c " mode
+.BI \-c " mode"
 contents encryption mode (e.g. AES-256-XTS)
 .TP
-.BI \-n " mode
+.BI \-n " mode"
 filenames encryption mode (e.g. AES-256-CTS)
 .TP
-.BI \-f " flags
+.BI \-f " flags"
 policy flags (numeric)
 .TP
-.BI \-v " version
+.BI \-v " version"
 version of policy structure (numeric)
 .RE
 .PD
-- 
2.7.4

