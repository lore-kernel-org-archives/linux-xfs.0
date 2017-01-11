Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34180 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753105AbdAKImF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Jan 2017 03:42:05 -0500
Date: Wed, 11 Jan 2017 09:42:03 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v8 5/6] xfs: sanity check inode mode when creating new
        dentry
Message-ID: <20170111084203.GC6744@lst.de>
References: <1484123050-11064-1-git-send-email-amir73il@gmail.com> <1484123050-11064-6-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484123050-11064-6-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although I wonder if we should simply pass down qstr ( + mode if needed)
and kill off struct xfs_name..
