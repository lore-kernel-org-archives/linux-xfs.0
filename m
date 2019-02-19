Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52130 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbfBSXRv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Feb 2019 18:17:51 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4AA045D67E
        for <linux-xfs@vger.kernel.org>; Tue, 19 Feb 2019 23:17:51 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 148F1600C0
        for <linux-xfs@vger.kernel.org>; Tue, 19 Feb 2019 23:17:50 +0000 (UTC)
Subject: [PATCH 1/3] xfs_io: don't pass negative len to copy_file_range_cmd
References: <c4b7eff6-8395-3d01-eaaf-736e32e6e1dc@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <b48c8b5d-9ed3-c4b6-c7fc-2c13df211dd3@redhat.com>
Date: Tue, 19 Feb 2019 17:17:49 -0600
MIME-Version: 1.0
In-Reply-To: <c4b7eff6-8395-3d01-eaaf-736e32e6e1dc@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

If copy_src_filesize returns an error (-1) we should return that
error, and not pass it to copy_file_range_cmd().

Addresses-Coverity-ID: 1431684 ("Improper use of negative value")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index 4e2969c..bc891c9 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -121,6 +121,10 @@ copy_range_f(int argc, char **argv)
 
 	if (src == 0 && dst == 0 && len == 0) {
 		len = copy_src_filesize(fd);
+		if (len < 0) {
+			close(fd);
+			return 0;
+		}
 		copy_dst_truncate();
 	}
