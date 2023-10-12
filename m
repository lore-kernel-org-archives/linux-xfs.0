Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 694D5CDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 08:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbjJLIyZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 04:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235493AbjJLIyY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 04:54:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E591091
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 01:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gNGMbdBxbEYV1zO0bKNzTiUNSAv+rIRG+yaf5kUspkA=; b=iCRZfwte8ZKKhC7QskTnHXzgYM
        0N1ISeWobm1621yvTh1Lg9Fsu9D/rAGIWfZMldpf4A5QT2amsgRBTG9/EMUQ1DVDPG0dKey7F2u0H
        +DX3DuacoJ7farp8muj65E0JhF8qojSeubQ4i0vtQ+s3Mp8g6LqR+q31lo/3bToKILY9XLJ2xsAPn
        kr57Xu3gbqWD70GZy+CpZa+9IrqcQ7FCpU4m9EgTsQtdI6dzKcbTqp4unMc8jWIFQj0dXUNWTGQoO
        LgVb3UnUwSqQzREe7HaEoi43XRB0Pt1yzTNDuLAy+Vg+zRM6dXxTeiSVWoaGtOz+VFeG2d6x2DH1h
        biZr3/ZQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qqrSW-000HIe-2U;
        Thu, 12 Oct 2023 08:54:20 +0000
Date:   Thu, 12 Oct 2023 01:54:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: move and xfs_trans_committed_bulk
Message-ID: <ZSe0PKrmcHqQCF4j@infradead.org>
References: <20230921014844.582667-1-david@fromorbit.com>
 <20230921014844.582667-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921014844.582667-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

s/move and/move and rename/ in the subject.
