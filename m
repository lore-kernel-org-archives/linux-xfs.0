Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF91C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 07:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbiF2HlU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbiF2HlO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:41:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8881536B42
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=gQC70xaxoC6mIDrys4iGNdBY/8
        pxtx3N2arz8ORXo4VGCUBXwBfYtaCttcJcxbV/xV7hgbVZ8GFhhc30ekINf2FY7NrPjFTiCKJydPM
        d9HMXPfToCwvMjRQR1cO49cF1gOKORh7LgMXoUKAQKnjIMQY6u5z2uir2rS9LzgpRjqKqFcEiY0n/
        rEgCVS3DYdAw93L8ZMDAPRxc+svU0XRv65YOike2yhrINBpIuEkH2adARNgREkE6BeoqyavUU2W/8
        Vd7e6RuRB6/tIDDzTiFNDPdmrbsv+RJcrTfhUEkaedlfmISFZssYpU5HqqoEbApUSFIYgDwp02Pth
        OHFJG5AQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6SK1-00A9s2-4x; Wed, 29 Jun 2022 07:41:13 +0000
Date:   Wed, 29 Jun 2022 00:41:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: lockless buffer lookup
Message-ID: <YrwCGfu6U0klhfNY@infradead.org>
References: <20220627060841.244226-1-david@fromorbit.com>
 <20220627060841.244226-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627060841.244226-7-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
