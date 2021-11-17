Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97861C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 12:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7778261B95
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 12:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhKQMe3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Nov 2021 07:34:29 -0500
Received: from verein.lst.de ([213.95.11.211]:50258 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229563AbhKQMe2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 17 Nov 2021 07:34:28 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 447FD68AFE; Wed, 17 Nov 2021 13:31:28 +0100 (CET)
Date:   Wed, 17 Nov 2021 13:31:27 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com
Subject: Re: [PATCH] iomap: iomap_read_inline_data cleanup
Message-ID: <20211117123127.GA21935@lst.de>
References: <20211117103202.44346-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117103202.44346-1-agruenba@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 17, 2021 at 11:32:02AM +0100, Andreas Gruenbacher wrote:
> Change iomap_read_inline_data to return 0 or an error code; this
> simplifies the callers.  Add a description.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
