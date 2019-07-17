Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50582 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfGQFFD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jul 2019 01:05:03 -0400
Date: Tue, 16 Jul 2019 22:05:03 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/9] iomap: move the page migration code into a separate
 file
Message-ID: <20190717050503.GG7113@infradead.org>
References: <156321356040.148361.7463881761568794395.stgit@magnolia>
 <156321360519.148361.2779156857011152900.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156321360519.148361.2779156857011152900.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, agruenba@redhat.com

I wonder if this should go with the rest of the buffered I/O code into
buffered-io.c?  Yes, it would need an ifdef, but it is closely related
to it in how we use the page private information.

> diff --git a/fs/iomap/migrate.c b/fs/iomap/migrate.c
> new file mode 100644
> index 000000000000..d8116d35f819
> --- /dev/null
> +++ b/fs/iomap/migrate.c
> @@ -0,0 +1,39 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2010 Red Hat, Inc.
> + * Copyright (c) 2016-2018 Christoph Hellwig.
> + */

Bit if you don't want to move it, this is all new code from me from
2018.
