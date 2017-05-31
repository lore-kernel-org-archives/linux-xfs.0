Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:13969 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750898AbdEaSQj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 May 2017 14:16:39 -0400
Message-ID: <1496254594.28981.37.camel@linux.intel.com>
Subject: Re: [PATCH 15/24] block: remove blk_part_pack_uuid
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Wed, 31 May 2017 21:16:34 +0300
In-Reply-To: <20170531161826.23243-16-hch@lst.de>
References: <20170531161826.23243-1-hch@lst.de>
         <20170531161826.23243-16-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org

On Wed, 2017-05-31 at 18:18 +0200, Christoph Hellwig wrote:
> This helper was only used by IMA of all things, which would get
> spurious
> errors if CONFIG_BLOCK is disabled.  Just opencode the call there.

> -			result = blk_part_pack_uuid(args[0].from,
> -						    entry->fsuuid);
> +			result = uuid_to_bin(args[0].from, (uuid_t
> *)&entry->fsuuid);
> 

uuid_parse() ?

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
