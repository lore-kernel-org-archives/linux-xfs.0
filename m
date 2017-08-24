Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39981 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751554AbdHXMey (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 08:34:54 -0400
Date: Thu, 24 Aug 2017 14:34:51 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 11/13] dax, iomap: Add support for synchronous faults
Message-ID: <20170824123451.GA6187@quack2.suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-12-jack@suse.cz>
 <20170824122720.GA9961@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170824122720.GA9961@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boazh@netapp.com>

On Thu 24-08-17 05:27:20, Christoph Hellwig wrote:
> Just curious:  how does IOMAP_F_NEEDDSYNC practically differ
> from IOMAP_F_NEW?

In a subtle but important way ;). The main difference is that if the extent
has been already allocated by previous write, but the changing transaction
is not yet committed, we will return IOMAP_F_NEEDDSYNC but not IOMAP_F_NEW.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
