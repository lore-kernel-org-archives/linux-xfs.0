Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50949 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbcI3I03 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 04:26:29 -0400
Date: Fri, 30 Sep 2016 01:26:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 57/63] xfs: check for invalid inode reflink flags
Message-ID: <20160930082628.GJ32335@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520511076.29434.10817761072405321509.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520511076.29434.10817761072405321509.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Sep 29, 2016 at 08:11:50PM -0700, Darrick J. Wong wrote:
> We don't support sharing blocks on the realtime device.  Flag inodes
> with the reflink or cowextsize flags set when the reflink feature is
> disabled.

Looks fine, but why didn't this go into the patches adding reflink
support earlier?

Reviewed-by: Christoph Hellwig <hch@lst.de>
