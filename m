Return-Path: <SRS0=AY68=YU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCBCFCA9EAF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B160D214AF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:55:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cW/uJ1LE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfJ0Ozx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Oct 2019 10:55:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37540 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfJ0Ozx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Oct 2019 10:55:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fdPD0PJRrQ7GPmglGPg+Xo7p0yMadAzfdmncArnbhY0=; b=cW/uJ1LEL/WCnzV+SwY8flRqN+
        HZMZgA7fpOnXTctyNHvLPexg1SWUl5mUXZFafLd3I2pQMAh2h8xj5Op8WIhYrvksXd1XLGveH0Au6
        0G/QKeiBbIq9RBWrFJzL4Ds2Dn5Oyythy2Z5rZVSv7maXXBg7gf+wPoHIvP0nLCVJsZ12BbPhcNvn
        d3jBd4OF9/WzAtaNsKecNuen5R4DDTxjAlSQjNw7GLTRk48+rkdgn+rnEWgyEBsJlk7rQZuF/fPrh
        vTHIm3b4oWJVNVcEOAxB5famVSbpa6eavXAdHscHbyRonSsl6LhbK7hQW2JFxDJCDl8FVarlrft6k
        7KcL5hWg==;
Received: from [2001:4bb8:184:47ee:760d:fb4d:483e:6b79] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iOjxQ-0005LZ-Ja; Sun, 27 Oct 2019 14:55:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Ian Kent <raven@themaw.net>, Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/12] xfs: remove the biosize mount option
Date:   Sun, 27 Oct 2019 15:55:36 +0100
Message-Id: <20191027145547.25157-2-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191027145547.25157-1-hch@lst.de>
References: <20191027145547.25157-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Ian Kent <raven@themaw.net>

It appears the biosize mount option hasn't been documented as a valid
option since 2005, remove it.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0a8cf6b87a21..589c080cabfe 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -50,7 +50,7 @@ static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
  * Table driven mount option parser.
  */
 enum {
-	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev, Opt_biosize,
+	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev,
 	Opt_wsync, Opt_noalign, Opt_swalloc, Opt_sunit, Opt_swidth, Opt_nouuid,
 	Opt_grpid, Opt_nogrpid, Opt_bsdgroups, Opt_sysvgroups,
 	Opt_allocsize, Opt_norecovery, Opt_inode64, Opt_inode32, Opt_ikeep,
@@ -66,7 +66,6 @@ static const match_table_t tokens = {
 	{Opt_logbsize,	"logbsize=%s"},	/* size of XFS log buffers */
 	{Opt_logdev,	"logdev=%s"},	/* log device */
 	{Opt_rtdev,	"rtdev=%s"},	/* realtime I/O device */
-	{Opt_biosize,	"biosize=%u"},	/* log2 of preferred buffered io size */
 	{Opt_wsync,	"wsync"},	/* safe-mode nfs compatible mount */
 	{Opt_noalign,	"noalign"},	/* turn off stripe alignment */
 	{Opt_swalloc,	"swalloc"},	/* turn on stripe width allocation */
@@ -228,7 +227,6 @@ xfs_parseargs(
 				return -ENOMEM;
 			break;
 		case Opt_allocsize:
-		case Opt_biosize:
 			if (suffix_kstrtoint(args, 10, &iosize))
 				return -EINVAL;
 			iosizelog = ffs(iosize) - 1;
-- 
2.20.1

