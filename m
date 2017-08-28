Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:41116 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751190AbdH1UJ0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Aug 2017 16:09:26 -0400
Date: Mon, 28 Aug 2017 14:09:24 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 2/3] xfs: consolidate the various page fault handlers
Message-ID: <20170828200924.GB17577@linux.intel.com>
References: <20170824152207.30729-1-hch@lst.de>
 <20170824152207.30729-3-hch@lst.de>
 <20170824212942.GB20489@linux.intel.com>
 <20170825071538.GB9191@lst.de>
 <20170828175014.GA17577@linux.intel.com>
 <20170828175257.GA29190@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170828175257.GA29190@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

On Mon, Aug 28, 2017 at 07:52:57PM +0200, Christoph Hellwig wrote:
> On Mon, Aug 28, 2017 at 11:50:14AM -0600, Ross Zwisler wrote:
> > Yep - I'm doing that in include/trace/events/fs_dax.h if you want to just copy
> > & paste.
> 
> Oh, nice.  But maybe we need the trace point in the core MM instead
> of in XFS and the DAX code? :)

Yea, there aren't any tracepoints at all in mm/memory.c.  I'm not sure if
that's because we just haven't gotten around to putting them in, or if for
some reason it was intentional to not trace that bit of code?
