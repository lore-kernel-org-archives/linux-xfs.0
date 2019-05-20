Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49832 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbfETGD5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 02:03:57 -0400
Date: Mon, 20 May 2019 08:03:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/20] xfs: merge xfs_efd_init into xfs_trans_get_efd
Message-ID: <20190520060335.GB31977@lst.de>
References: <20190517073119.30178-1-hch@lst.de> <20190517073119.30178-14-hch@lst.de> <842291d4-74b5-71bd-5d61-ea513614a9cf@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <842291d4-74b5-71bd-5d61-ea513614a9cf@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 01:26:59PM -0500, Eric Sandeen wrote:
> 
> On 5/17/19 2:31 AM, Christoph Hellwig wrote:
> > There is no good reason to keep these two functions separate.
> 
> hm, do the thin ->create_done() wrappers make sense either?
> 
> /* Get an EFD so we can process all the free extents. */
> STATIC void *
> xfs_extent_free_create_done(
>         struct xfs_trans                *tp,
>         void                            *intent,
>         unsigned int                    count)
> {
>         return xfs_trans_get_efd(tp, intent, count);
> }
> 
> should we just hook xfs_trans_get_FOO() directly to ->create_done?

Well, we have another callers of those in the log recovery code.

I have some ideas how to clean some of this up, but that is too much
for this series.
