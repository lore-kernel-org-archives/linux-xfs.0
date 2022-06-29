Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58580C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 07:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiF2Hai (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbiF2Hah (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:30:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E979C2A263
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dYgHSzauo0VvRdnwjxq00crFvPmbyXRoaCSVS+GII7k=; b=TxZROuv03Dqb1AGAwb4vOCyEyn
        liIrXhvLSndBqTfYilrjBEdOtk5BVxtnZzphFc0E8OI2ToQpao1AV5QXX3S5c/FKJtHFnD3NoUukm
        wdQS+koJr7wGgQ1hv4cmGtpQCwbojb53w5Nr/zpCsCnyRjtNotOQ90C4BluobXgqcC9JwFntQPiZS
        UFXen+1rEMNyEBaa+G4x3VjRO3M5kz11toGWkXbh5XfFsbnRmuAKYbMlX3FYnLBEvKnSsgEQ1phBH
        K41OcVogm9anH6bxwIlZ5rkE/kZWh6UxqajotgdDHJ6MJjCb5CiToQ+B27NLz4P3e7UB//9ZaEnyB
        aFtx5dqg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6S9k-00A6iK-HV; Wed, 29 Jun 2022 07:30:36 +0000
Date:   Wed, 29 Jun 2022 00:30:36 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: rework xfs_buf_incore() API
Message-ID: <Yrv/nJyy4urPd98p@infradead.org>
References: <20220627060841.244226-1-david@fromorbit.com>
 <20220627060841.244226-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627060841.244226-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 04:08:36PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Make it consistent with the other buffer APIs to return a error and
> the buffer is placed in a parameter.

Looks good, although I'd just drop the xfs_buf_incore wrapper now
as well..
