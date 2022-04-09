Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 911BCC433EF
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Apr 2022 15:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiDIPyk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Apr 2022 11:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiDIPyb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Apr 2022 11:54:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030A5C7F
        for <linux-xfs@vger.kernel.org>; Sat,  9 Apr 2022 08:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=1grdnKfYuxtgQbaVyyPaw2Eoq/B1L5a+1QxbPi8I5IU=; b=OWHfYG02Pmk/db+dQA2Wz/lDRP
        AxCetV8ykIzxZkzdCD76kazYBpLCT/dfVkg7E6gsCBBiVsP8tKG3tbm0E9HPOdH77FbY5NDk4GdNR
        txXd/TBfKJrCmxKyh62CkxbjYSljOlIBARWIlttlsaFMV8nr1sJXLbJliyltxdtwQUvvFFsaELjqx
        EjDSVAPbhOn/M/VVVUgrETCesn1xFHXZOXJjF6mgqi82McaWigFYp3UVowCBSYOqt5TOL8CP/+RI2
        fXjsqafI9OmfdNZH1KFYpOrSBihAvac/bbae/OYFzWesFLN5PhYRKuLuvqXcfc1h17/fdqUVx/8jK
        w3T7BS9A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ndDNu-00AnZS-Cw; Sat, 09 Apr 2022 15:52:22 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-xfs@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH] xfs: Use generic_file_open()
Date:   Sat,  9 Apr 2022 16:52:20 +0100
Message-Id: <20220409155220.2573777-1-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove the open-coded check of O_LARGEFILE.  This changes the errno
to be the same as other filesystems; it was changed generically in
2.6.24 but that fix skipped XFS.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/xfs/xfs_file.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5bddb1e9e0b3..c5541d062d0d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1167,12 +1167,10 @@ xfs_file_open(
 	struct inode	*inode,
 	struct file	*file)
 {
-	if (!(file->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
-		return -EFBIG;
 	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
 		return -EIO;
 	file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
-	return 0;
+	return generic_file_open(inode, file);
 }
 
 STATIC int
-- 
2.34.1

