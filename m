Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:49017 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752539AbdKDQby (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 4 Nov 2017 12:31:54 -0400
Received: by mail-it0-f43.google.com with SMTP id c3so825625itc.3
        for <linux-xfs@vger.kernel.org>; Sat, 04 Nov 2017 09:31:53 -0700 (PDT)
Subject: Re: [PATCH 04/15] brd: remove dax support
References: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150949211688.24061.1197869674847507598.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <74de4b5f-eacd-9058-45e6-d7fcfb2f0d51@kernel.dk>
Date: Sat, 4 Nov 2017 10:31:51 -0600
MIME-Version: 1.0
In-Reply-To: <150949211688.24061.1197869674847507598.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: akpm@linux-foundation.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, hch@lst.de

On 10/31/2017 05:21 PM, Dan Williams wrote:
> DAX support in brd is awkward because its backing page frames are
> distinct from the ones provided by pmem, dcssblk, or axonram. We need
> pfn_t_devmap() entries to fully support DAX, and the limited DAX support
> for pfn_t_special() page frames is not interesting for brd when pmem is
> already a superset of brd.  Lastly, brd is the only dax capable driver
> that may sleep in its ->direct_access() implementation. So it causes a
> global burden with no net gain of kernel functionality.
> 
> For all these reasons, remove DAX support.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

