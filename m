Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42162 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164033AbeBOSF5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Feb 2018 13:05:57 -0500
Date: Thu, 15 Feb 2018 10:05:54 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 1/3] fs: allow per-device dax status checking for
 filesystems
Message-ID: <20180215180554.GA6264@infradead.org>
References: <151871644696.27617.4390718895806529377.stgit@djiang5-desk3.ch.intel.com>
 <151871655228.27617.3514495396592472682.stgit@djiang5-desk3.ch.intel.com>
 <20180215175241.GA25223@infradead.org>
 <f5f93cd1-4d9e-c794-99fb-28daa0d1669d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5f93cd1-4d9e-c794-99fb-28daa0d1669d@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Jiang <dave.jiang@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, darrick.wong@oracle.com, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-xfs@vger.kernel.org, ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org, dan.j.williams@intel.com

On Thu, Feb 15, 2018 at 10:58:54AM -0700, Dave Jiang wrote:
> I think Darrick wanted to keep the API the same for non-XFS users. I'm
> ok with dropping the passed in sb if Darrick has no objections.

But the old API is gone - everyone either uses the new
sb_dax_supported, or the updated bdev_dax_supported.
