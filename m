Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34517 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750751AbeCNImC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Mar 2018 04:42:02 -0400
Date: Wed, 14 Mar 2018 09:42:00 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 7/8] xfs: mark xfs_reflink_clear_inode_flag static
Message-ID: <20180314084200.GB28480@lst.de>
References: <20180313143601.30028-1-hch@lst.de> <20180313143601.30028-8-hch@lst.de> <20180313205053.GI4865@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313205053.GI4865@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Mar 13, 2018 at 01:50:53PM -0700, Darrick J. Wong wrote:
> Online inode repair/optimization will call this function (see
> xfs_repair_inode in scrub/inode_repair.c in the online repair series),
> so I'd prefer not to add static only to have to pull it out later.

Ok, just skip this patch then.
