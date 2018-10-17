Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45876 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbeJQQXh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Oct 2018 12:23:37 -0400
Date: Wed, 17 Oct 2018 01:28:58 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/26] vfs: pass remap flags to
 generic_remap_file_range_prep
Message-ID: <20181017082858.GC16896@infradead.org>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
 <153965947208.1256.13169150057249233851.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153965947208.1256.13169150057249233851.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, Oct 15, 2018 at 08:11:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Plumb the remap flags through the filesystem from the vfs function
> dispatcher all the way to the prep function to prepare for behavior
> changes in subsequent patches.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
