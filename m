Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31417 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751213AbdH1RuP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Aug 2017 13:50:15 -0400
Date: Mon, 28 Aug 2017 11:50:14 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 2/3] xfs: consolidate the various page fault handlers
Message-ID: <20170828175014.GA17577@linux.intel.com>
References: <20170824152207.30729-1-hch@lst.de>
 <20170824152207.30729-3-hch@lst.de>
 <20170824212942.GB20489@linux.intel.com>
 <20170825071538.GB9191@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170825071538.GB9191@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

On Fri, Aug 25, 2017 at 09:15:38AM +0200, Christoph Hellwig wrote:
> On Thu, Aug 24, 2017 at 03:29:42PM -0600, Ross Zwisler wrote:
<>
> > I wonder if pe_size would be more readable as a string via __print_symbolic()
> > so we see "pe_size PMD" instead of "pe_size 1" from enum page_entry_size?
> 
> Probably.  I was just lazy :)  If I want to go all the way I could also
> use a __print_flags for the FAULT_FLAG_* flags.

Yep - I'm doing that in include/trace/events/fs_dax.h if you want to just copy
& paste.
