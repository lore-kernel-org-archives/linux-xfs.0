Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B60FC33CB2
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 15:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBC36222C3
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 15:08:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nL2vP1tC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgAOPIF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 10:08:05 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38420 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbgAOPIF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 10:08:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Type:MIME-Version:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=796tKAbK6j2ghTsXjLBQJuDUm5b41Shs0TtRfi9nngY=; b=nL2vP1tCUdIM8lzWSFrK6/7sCE
        LvdNvaTpoDTK4jgnvLJ/qL6J0WKz1EVZXIeh/RW+1YlaxWyKOBJXNdjVbiGs9x1BFR2MwZy6CuHI1
        wMijvrqzuBpDK6wTMR5WIEnnKJZem5xwY8xw1asRhi8X7CupridhNeUFBFPbCF15NUZ0F2tb7GNJI
        1lZ0ccEtZ7+ccA2daeUr1SXIO+pcJ7qB2kyPcdtWxxad3kHHELiygk4UEx0mUov/JvltvR3N0uX5s
        orJ0M+xB+l4ZwATqUzHMpvAbWeS2LWGzZaV4M8mkFW/FpGpTuq82yMXdTmil6LkJMaTJGs6qgg3Ar
        w0JfdSLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1irkH4-0000NY-1V; Wed, 15 Jan 2020 15:08:02 +0000
Date:   Wed, 15 Jan 2020 07:08:02 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Tulak <jtulak@redhat.com>, Baihua Lu <lubaihua0331@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: xfs/191 failures?
Message-ID: <20200115150802.GA425@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Jan and Baihua,

the xfs/191 test case has been failing for me basically since it
was added.  Does it succeed for anyone with an upstream kernel
and xfsprogs?  Here is my diff between the golden and the actual
output:

--- /root/xfstests/tests/xfs/191-input-validation.out	2016-09-21 20:34:14.961574921 +0000
+++ /root/xfstests/results//xfs/191-input-validation.out.bad	2020-01-15 15:05:25.580935340 +0000
@@ -1,2 +1,13 @@
 QA output created by 191-input-validation
 silence is golden
+pass -n size=2b /dev/vdc
+pass -d agsize=8192b /dev/vdc
+pass -d agsize=65536s /dev/vdc
+pass -d su=0,sw=64 /dev/vdc
+pass -d su=4096s,sw=64 /dev/vdc
+pass -d su=4096b,sw=64 /dev/vdc
+pass -l su=10b /dev/vdc
+fail -n log=15 /dev/vdc
+fail -r rtdev=/mnt/test/191-input-validation.img /dev/vdc
+fail -r size=65536,rtdev=/mnt/test/191-input-validation.img /dev/vdc
+fail -i log=10 /dev/vdc
