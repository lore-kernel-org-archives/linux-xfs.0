Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DBDCC77B7C
	for <linux-xfs@archiver.kernel.org>; Wed, 31 May 2023 06:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbjEaGGO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 May 2023 02:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbjEaGGN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 May 2023 02:06:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9877122
        for <linux-xfs@vger.kernel.org>; Tue, 30 May 2023 23:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=z+DwzCKCDMQtEzJ9d+oQouxJkV
        L3K92yOhNHgoXDBc0eh253ujWhOVPN3OzcaPc59+1J6jtlF/GKoX7UPDjgYt3OfMWD/D9/vt3lsnA
        fyL/6qrqKtZLogA437pXvkbVDhizT6Z3tRRWmbah74poKydQoSSV1rcMPQejvm+OXCue+/I3Xjp1i
        HSQJ1dMgbxv7jQsSPIoLL/55T6GEZw2ajUcJVfANzrPcQlUuz1KDkZks44b3RYGRt1tFVlz4UQ4F/
        uQkGFQTSYhq86WWoB7UPUyQG7pesstWBr74GSpuucbrvGBcDXOrtEhm2WUcaLZ9vOTE8zJ7rjtiB8
        8PSm3zWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1q4EyK-00GFDt-28;
        Wed, 31 May 2023 06:06:12 +0000
Date:   Tue, 30 May 2023 23:06:12 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: fix agf/agfl verification on v4 filesystems
Message-ID: <ZHbj1ADhIgjCwzST@infradead.org>
References: <20230529000825.2325477-1-david@fromorbit.com>
 <20230529000825.2325477-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529000825.2325477-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
