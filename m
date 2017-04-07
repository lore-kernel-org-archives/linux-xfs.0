Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37640 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932407AbdDGHRI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Apr 2017 03:17:08 -0400
Date: Fri, 7 Apr 2017 09:17:06 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH] iomap_dio_rw: Prevent reading file data beyond
        iomap_dio->i_size
Message-ID: <20170407071706.GA26602@lst.de>
References: <1491545509-27152-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1491545509-27152-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: hch@lst.de, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, sandeen@sandeen.net, linux-fsdevel@vger.kernel.org

On Fri, Apr 07, 2017 at 11:41:49AM +0530, Chandan Rajendra wrote:
> The above problem can also be recreated on a regular xfs filesystem
> using the command,
> 
> $ fsstress -d /mnt -l 1000 -n 1000 -p 1000

Can you add this to xfstests?

> +		if ((iov_iter_rw(iter) == READ) && (pos >= dio->i_size))
> +			break;

Please kill both sets of inner braces.

Otherwise this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
