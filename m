Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51644 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752892AbdHXNiL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2017 09:38:11 -0400
Date: Thu, 24 Aug 2017 06:38:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/13] dax, iomap: Add support for synchronous faults
Message-ID: <20170824133809.GA29607@infradead.org>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-12-jack@suse.cz>
 <20170824122720.GA9961@infradead.org>
 <20170824123451.GA6187@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170824123451.GA6187@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boazh@netapp.com>

On Thu, Aug 24, 2017 at 02:34:51PM +0200, Jan Kara wrote:
> In a subtle but important way ;). The main difference is that if the extent
> has been already allocated by previous write, but the changing transaction
> is not yet committed, we will return IOMAP_F_NEEDDSYNC but not IOMAP_F_NEW.

Ok.  How about a IOMAP_F_DIRTY flag and a better explanation?
