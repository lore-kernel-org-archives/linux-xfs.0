Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50470 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfGQFBS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jul 2019 01:01:18 -0400
Date: Tue, 16 Jul 2019 22:01:18 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/9] iomap: move the SEEK_HOLE code into a separate file
Message-ID: <20190717050118.GD7113@infradead.org>
References: <156321356040.148361.7463881761568794395.stgit@magnolia>
 <156321358581.148361.8774330141606166898.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156321358581.148361.8774330141606166898.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, agruenba@redhat.com

> diff --git a/fs/iomap/seek.c b/fs/iomap/seek.c
> new file mode 100644
> index 000000000000..0c36bef46522
> --- /dev/null
> +++ b/fs/iomap/seek.c
> @@ -0,0 +1,214 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2010 Red Hat, Inc.
> + * Copyright (c) 2016-2018 Christoph Hellwig.
> + */

This looks a little odd.  There is nothing in here from Daves original
iomap prototype.  It did start out with code from Andreas though which
might or might not be RH copyright.  So we'll need Andreas and/or RH
legal to chime in.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
