Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756102AbdERScH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 May 2017 14:32:07 -0400
Date: Thu, 18 May 2017 11:32:04 -0700
From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 13/23] md: namespace private helper names
Message-ID: <20170518183204.adade5y4dcwpeslz@kernel.org>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170518062705.25902-14-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

On Thu, May 18, 2017 at 08:26:55AM +0200, Christoph Hellwig wrote:
> From: Amir Goldstein <amir73il@gmail.com>
> 
> The md private helper uuid_equal() collides with a generic helper
> of the same name.
> 
> Rename the md private helper to md_uuid_equal() and do the same for
> md_sb_equal().
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Shaohua Li <shli@kernel.org>
