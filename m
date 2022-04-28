Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53635C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 12:56:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346723AbiD1M76 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 08:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346740AbiD1M75 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 08:59:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F010767D26
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 05:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=WaWA/DOjh33rwEoqK/UjzSE71d
        Az3VdYzNwzbzdHi+71oAQWp6T4LJBoyVLPzSPid35hbar1fPXi4ALSVqJAisXa/x/6e4fS6qtc96B
        aMqfJ7oPSAOMdltO88OTlt1g+DvfWnTH6z86+J9s6hbQanW8voH1E1ntujybuCe+T0BC6OHZIavWm
        k3DYMXrmimDBG3KfEshppOoRvYT3hWb4Dhnj7oqWk8z0PW/Raa0Qu5NMzwBINHKfYgV+yJ09uOmG5
        SR7KzBV0W5TPWTdQHrhzQU/la3l40Ijl9lDsGPut7XX21UsNdSSrYBtyq07viVP/g750ZutXpxwDH
        2sb4Y+Kg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nk3hK-006v24-VT; Thu, 28 Apr 2022 12:56:42 +0000
Date:   Thu, 28 Apr 2022 05:56:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: rename xfs_*alloc*_log_count to _block_count
Message-ID: <YmqPCgxLhxwwdNOs@infradead.org>
References: <165102071223.3922658.5241787533081256670.stgit@magnolia>
 <165102076298.3922658.10000784148294313471.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165102076298.3922658.10000784148294313471.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
