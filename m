Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41778 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750898AbdEaTju (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 May 2017 15:39:50 -0400
Date: Wed, 31 May 2017 21:39:48 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 15/24] block: remove blk_part_pack_uuid
Message-ID: <20170531193948.GB6906@lst.de>
References: <20170531161826.23243-1-hch@lst.de> <20170531161826.23243-16-hch@lst.de> <1496254594.28981.37.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1496254594.28981.37.camel@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org

On Wed, May 31, 2017 at 09:16:34PM +0300, Andy Shevchenko wrote:
> On Wed, 2017-05-31 at 18:18 +0200, Christoph Hellwig wrote:
> > This helper was only used by IMA of all things, which would get
> > spurious
> > errors if CONFIG_BLOCK is disabled.  Just opencode the call there.
> 
> > -			result = blk_part_pack_uuid(args[0].from,
> > -						    entry->fsuuid);
> > +			result = uuid_to_bin(args[0].from, (uuid_t
> > *)&entry->fsuuid);
> > 
> 
> uuid_parse() ?

Yes.  I fixed this up, but it seems like I didn't squash it into
the right patch..
