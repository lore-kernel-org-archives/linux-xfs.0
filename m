Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F02AC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Nov 2021 12:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 504AE611BF
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Nov 2021 12:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhKJM6R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Nov 2021 07:58:17 -0500
Received: from verein.lst.de ([213.95.11.211]:54384 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229653AbhKJM6R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Nov 2021 07:58:17 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9048967373; Wed, 10 Nov 2021 13:55:27 +0100 (CET)
Date:   Wed, 10 Nov 2021 13:55:27 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
        stable@vger.kernel.org
Subject: Re: [5.15 REGRESSION] iomap: Fix inline extent handling in
 iomap_readpage
Message-ID: <20211110125527.GA25465@lst.de>
References: <20211110113842.517426-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110113842.517426-1-agruenba@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 10, 2021 at 12:38:42PM +0100, Andreas Gruenbacher wrote:
> +	if (iomap->type == IOMAP_INLINE) {
> +		/*
> +		 * The filesystem sets iomap->length to the size of the inline
> +		 * data.  We're at the end of the file, so we know that the
> +		 * rest of the page needs to be zeroed out.
> +		 */
> +		iomap->length = iomap_read_inline_data(iter, page);
> +		return iomap->length;

You can't just change iomap->length here.  Fix the file system to
return the right length, please.
