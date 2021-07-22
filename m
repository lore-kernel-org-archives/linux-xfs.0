Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 171A8C63793
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 07:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD29261283
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 07:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhGVG6O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 02:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhGVG6O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jul 2021 02:58:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0461C061575;
        Thu, 22 Jul 2021 00:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=rRwKRa8aN7MSFCHqZaAB4yM6+r+wf7X7ml5EWGka36Y=; b=HC3mNUEsMayaPPAds0/SBNzb8i
        t73H/USWbukfRdT9j0aCzUSbwyTrs66rVeThD2LjKLxILdyEqWhU0iUjPoElT7W5apUehdUmYwKpc
        TD2GEy1ALD5c+zvHajosKrP55Jc5d4pso71Qx+ZQnVWaneSoe4DaifzVOTOpEBH+MdWW4tmdckiNL
        Fxye9sD1aW/6rPXVlXBaEMSbUiEvzZ2rTsxQ8Xe2yxBK2Qw/MG+noczHEtEjvJTqvHTNluYQ1xVmi
        Qs00fOnGH9lqr/TqnIWG+oze2y3OXH/+WafJsa+mrornRub2I/FZqVmRoMh6SGdJZKzbQuk1SQLQq
        DdMv1pFw==;
Received: from [2001:4bb8:193:7660:643c:9899:473:314a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6THs-00A0RW-VT; Thu, 22 Jul 2021 07:38:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: prepare for removing support to disable quota accounting v2
Date:   Thu, 22 Jul 2021 09:38:25 +0200
Message-Id: <20210722073832.976547-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series contains all the patches to make xfstests cope with a kernel
that does not support disabling quota accounting on a running XFS file
system.

Changes since v1:
 - keep a helper function in xfs/106
 - add a patch to use $XFS_QUOTA_PROG instead of xfs_quota
