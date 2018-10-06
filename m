Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33306 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbeJFRl1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 13:41:27 -0400
Date: Sat, 6 Oct 2018 03:38:41 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/15] vfs: check file ranges before cloning files
Message-ID: <20181006103841.GD25747@infradead.org>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870030868.29072.14603423813271148877.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153870030868.29072.14603423813271148877.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, sandeen@redhat.com

> +EXPORT_SYMBOL(generic_clone_checks);

There doesn't seem to be any need to export this function.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
