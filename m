Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E8CC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 07:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiF2HZy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiF2HZy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:25:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8253418E28
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tiNBu6X5Mls4H+JvCGQzuA6V+YXKW5w8iL+TMbQJ6kE=; b=4/zwXdMNUtl0wpOtbWQksRJWfb
        +w4NLhcrhUsk+He8a6cVb370HZRqeAR40gUg2ZUAcJRx3eZMRjI4JreK52Kx0FaZfXwlBo9l4d5kr
        qKh+ksLYadasm1YrjE8ERQBJHKIJBIBrbAimXmEUg6Srx7JOUC4WLYRjiMyX1msMG2mLNtWSdeivK
        jCyKdgn1RbI73yuFGYadI2gsuOqiCNiMs/0l7Tw/WIBdF6kTB6LANa2dkU5PBsny6leqzVN1e7lEj
        4hS5LU7aRrMZ6tM4HY7pjIbCNVclegXb0ZEFEbdE51LHL3Uk7sSGY3gjl/NdTXcqQi9EqNNGR4hIg
        lOzSzMfw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6S5B-00A5SX-4j; Wed, 29 Jun 2022 07:25:53 +0000
Date:   Wed, 29 Jun 2022 00:25:53 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: add in-memory iunlink log item
Message-ID: <Yrv+gfvrtIFOwami@infradead.org>
References: <20220627004336.217366-1-david@fromorbit.com>
 <20220627004336.217366-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627004336.217366-10-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 10:43:36AM +1000, Dave Chinner wrote:
> TO do this, we introduce a new in-memory log item to track the

s/To/To/

> This allows us to pass the xfs_inode to the transaction commit code
> along with the modification to be made, and then order the logged
> modifications via the ->iop_sort and ->iop_precommit operations
> for the new log item type. As this is an in-memory log item, it
> doesn't have formatting, CIL or AIL operational hooks - it exists
> purely to run the inode unlink modifications and is then removed
> from the transaction item list and freed once the precommit
> operation has run.

Do we need to document the fact that we now have purely in-memory log
items better somewhere?  I see how this works, but it its a little
non-obvious.
