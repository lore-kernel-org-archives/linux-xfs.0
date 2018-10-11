Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36794 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728015AbeJKVKO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 17:10:14 -0400
Date: Thu, 11 Oct 2018 06:42:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/25] vfs: check file ranges before cloning files
Message-ID: <20181011134256.GC23424@infradead.org>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
 <153923115968.5546.9927577186377570573.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153923115968.5546.9927577186377570573.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, ocfs2-devel@oss.oracle.com

> -EXPORT_SYMBOL(vfs_clone_file_prep_inodes);
> +EXPORT_SYMBOL(vfs_clone_file_prep);

Btw, why isn't this EXPORT_SYMBOL_GPL?  It is rather Linux internal
code, including some that I wrote which you lifted into the core
in "vfs: refactor clone/dedupe_file_range common functions".
