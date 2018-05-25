Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48640 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967189AbeEYQw0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 May 2018 12:52:26 -0400
Date: Fri, 25 May 2018 09:52:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: mark sb_fname as nonstring
Message-ID: <20180525165222.GA7567@infradead.org>
References: <20180525151421.2317292-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180525151421.2317292-1-arnd@arndb.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>, Martin Sebor <msebor@gmail.com>, Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org

> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 84fbf164cbc3..eb79f2bc4dcc 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1819,12 +1819,12 @@ xfs_ioc_getlabel(
>  	BUILD_BUG_ON(sizeof(sbp->sb_fname) > FSLABEL_MAX);
>  
>  	spin_lock(&mp->m_sb_lock);
> -	strncpy(label, sbp->sb_fname, sizeof(sbp->sb_fname));
> +	strncpy(label, sbp->sb_fname, XFSLABEL_MAX);
>  	spin_unlock(&mp->m_sb_lock);

Hmm, shouldn't we just do a memcpy here?

Also given that the kernel never even looks at sb_fname maybe
we can turn into an array of unsigned chars to escape those string
warnings?
