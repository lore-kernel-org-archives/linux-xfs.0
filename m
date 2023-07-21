Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 960E4C001DC
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 06:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjGUGRt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 02:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbjGUGRY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 02:17:24 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DDB4C0F;
        Thu, 20 Jul 2023 23:14:40 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id EEA0468AA6; Fri, 21 Jul 2023 08:14:23 +0200 (CEST)
Date:   Fri, 21 Jul 2023 08:14:23 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
Subject: Re: [PATCH 2/8] iomap: add IOMAP_DIO_INLINE_COMP
Message-ID: <20230721061423.GB20600@lst.de>
References: <20230720181310.71589-1-axboe@kernel.dk> <20230720181310.71589-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230720181310.71589-3-axboe@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
