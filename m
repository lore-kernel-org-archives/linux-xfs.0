Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54409 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935148AbcI1CIp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:08:45 -0400
Date: Tue, 27 Sep 2016 19:08:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 00/11] re-enable DAX PMD support
Message-ID: <20160928020842.GA4428@infradead.org>
References: <1475009282-9818-1-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1475009282-9818-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@ml01.01.org, linux-xfs@vger.kernel.org

On Tue, Sep 27, 2016 at 02:47:51PM -0600, Ross Zwisler wrote:
> DAX PMDs have been disabled since Jan Kara introduced DAX radix tree based
> locking.  This series allows DAX PMDs to participate in the DAX radix tree
> based locking scheme so that they can be re-enabled.
> 
> Jan and Christoph, can you please help review these changes?

About to get on a plane, so it might take a bit to do a real review.
In general this looks fine, but I guess the first two ext4 patches
should just go straight to Ted independent of the rest?

Also Jan just posted a giant DAX patchbomb, we'll need to find a way
to integrate all that work, and maybe prioritize things if we want
to get bits into 4.9 still.
