Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50502 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfGQFCn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jul 2019 01:02:43 -0400
Date: Tue, 16 Jul 2019 22:02:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/9] iomap: move the direct IO code into a separate file
Message-ID: <20190717050242.GE7113@infradead.org>
References: <156321356040.148361.7463881761568794395.stgit@magnolia>
 <156321359210.148361.15859054191407967804.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156321359210.148361.15859054191407967804.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, agruenba@redhat.com

> @@ -0,0 +1,562 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2010 Red Hat, Inc.
> + * Copyright (c) 2016-2018 Christoph Hellwig.
> + */

While Dave did some significant improvements here they are much newer
than 2010, but we can probably just fix this up later.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
