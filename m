Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40324 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751232AbdH1Rw7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Aug 2017 13:52:59 -0400
Date: Mon, 28 Aug 2017 19:52:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: consolidate the various page fault handlers
Message-ID: <20170828175257.GA29190@lst.de>
References: <20170824152207.30729-1-hch@lst.de> <20170824152207.30729-3-hch@lst.de> <20170824212942.GB20489@linux.intel.com> <20170825071538.GB9191@lst.de> <20170828175014.GA17577@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170828175014.GA17577@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

On Mon, Aug 28, 2017 at 11:50:14AM -0600, Ross Zwisler wrote:
> Yep - I'm doing that in include/trace/events/fs_dax.h if you want to just copy
> & paste.

Oh, nice.  But maybe we need the trace point in the core MM instead
of in XFS and the DAX code? :)
