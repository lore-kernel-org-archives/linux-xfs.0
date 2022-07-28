Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3D8EC19F2B
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jul 2022 20:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiG1UPX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jul 2022 16:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiG1UPV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jul 2022 16:15:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C6ABE16;
        Thu, 28 Jul 2022 13:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=NlqzSUnYdHgIckfZla91EITdv4
        eCvB1tu7B3is0+3KetEf9e/+uWzODrXoJgyRdgAV4jGOhmFKJi7eLGv9TFeans/DyIak+DmlZiFNI
        HySLlAGzvu6c6Ckd9HaJ9NlC+MFRax8xN8Bhe3NUXAKxWvoFVh7rHdquyVzL2F28PGk3vrodvBE2+
        68ZoUaWx3plNW+/nSyX2GZF43nyFvXgfN/03PNetPk7HsgD9Kq7g13vxJ3sCK6fjyEI775NVX8AE6
        BfbIGq5/LuCCm4DtYEj1cg5sONGGSOiaElqLhm3W2CPGz/4tkuri2XMw99WnnLxUTKjJeBvc9CKol
        GyJ8aI8g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oH9ua-00EWM1-4x; Thu, 28 Jul 2022 20:15:12 +0000
Date:   Thu, 28 Jul 2022 13:15:12 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/3] common/xfs: fix _reset_xfs_sysfs_error_handling
 reset to actual defaults
Message-ID: <YuLuUCmWQQxfIrsy@infradead.org>
References: <165886494905.1585306.15343417924888857310.stgit@magnolia>
 <165886495460.1585306.10074516195471640063.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165886495460.1585306.10074516195471640063.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
