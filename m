Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34136 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936409AbdAKIjB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Jan 2017 03:39:01 -0500
Date: Wed, 11 Jan 2017 09:38:59 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v8 4/6] xfs: replace xfs_mode_to_ftype table with
        switch statement
Message-ID: <20170111083859.GB6744@lst.de>
References: <1484123050-11064-1-git-send-email-amir73il@gmail.com> <1484123050-11064-5-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484123050-11064-5-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Jan 11, 2017 at 10:24:08AM +0200, Amir Goldstein wrote:
> The size of the xfs_mode_to_ftype[] conversion table
> was too small to handle an invalid value of mode=S_IFMT.
> 
> Instead of fixing the table size, replace the conversion table
> with a conversion helper that uses a switch statement.
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
