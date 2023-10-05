Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D118CE92725
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Oct 2023 16:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239915AbjJEQN0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Oct 2023 12:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240942AbjJEQMT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 12:12:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C8B26186
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 05:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2VVSYUfSTyqWA3SimuOYIHpDyLzISDQLL7Qy3+hBJ18=; b=jiX6vrAgh+/3rHewG/xf/GzMzY
        sKwbeiKQL0Xn7qzZQlBhJ9vzYwO3uzFTh4hykclsslC/IiOpFv06rL0OROO6WBAqLsNMFgUnXxMjR
        jo48Gjy2VXuo/5bTTK6yY8mQHI3AzFJ6sCm22ft43ujFkEixP7b44+Va93NYSAWdeH4ECJGS0Dog0
        17wS9Hb6VhxHmt+tkcd4sNqrsAoV/zG0LBOdkjkwyO4dXE3k2pGCX3KU1zgFXM8H/U9h0DG2kyp9A
        eW1AKKVhiIn7Jbc/rUyBT+Ui8Q9t5XvRQxNPcrLmqN0jkJV+QZwYacc3Odq0nTsD1+mdsT9sjTRJm
        Ley/JeAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qoN4x-002ZR1-0S;
        Thu, 05 Oct 2023 12:03:43 +0000
Date:   Thu, 5 Oct 2023 05:03:43 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH 8/9] xfs: collapse near and exact bno allocation
Message-ID: <ZR6mH9a8V4Xhgyas@infradead.org>
References: <20231004001943.349265-1-david@fromorbit.com>
 <20231004001943.349265-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004001943.349265-9-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 04, 2023 at 11:19:42AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> As they are now identical functions exact for the allocation
> function they call.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although I'd be tempted to just nuke xfs_alloc_vextent_exact_bno
and xfs_alloc_vextent_near_bno and call xfs_alloc_vextent_bno directly.
