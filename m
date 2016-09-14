Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:34352 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761905AbcINR0F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Sep 2016 13:26:05 -0400
Date: Wed, 14 Sep 2016 11:26:03 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 05/12] dax: provide an iomap based dax read/write path
Message-ID: <20160914172603.GA30852@linux.intel.com>
References: <1473847291-18913-1-git-send-email-hch@lst.de>
 <1473847291-18913-6-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1473847291-18913-6-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, ross.zwisler@linux.intel.com

On Wed, Sep 14, 2016 at 12:01:24PM +0200, Christoph Hellwig wrote:
> This is a much simpler implementation of the DAX read/write path that makes
> use of the iomap infrastructure.  It does not try to mirror the direct I/O
> calling conventions and thus doesn't have to deal with i_dio_count or the
> end_io handler, but instead leaves locking and filesystem-specific I/O
> completion to the caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
