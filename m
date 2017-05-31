Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38759 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750912AbdEaJmA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 May 2017 05:42:00 -0400
Date: Wed, 31 May 2017 11:41:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/22] Revert "afs: Move UUID struct to linux/uuid.h"
Message-ID: <20170531094157.GA10511@lst.de>
References: <20170528102008.30276-2-hch@lst.de> <20170528102008.30276-1-hch@lst.de> <9377.1496138404@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9377.1496138404@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>

On Tue, May 30, 2017 at 11:00:04AM +0100, David Howells wrote:
> This isn't going to work.  You've effectively changed the types of the fields
> in the UUID struct from BE to CPU-endian, but you're still calling
> generate_random_uuid(), which produces a BE UUID.  You need to leave the
> struct members as __beXX or stop using the core UUID routines.
> 
> Just move the struct uuid_v1 as-is to the afs headers and rename it to struct
> afs_uuid.  You can then leave the (un)marshalling code alone.

That's one option.  The other option would be to revert

"afs: Use core kernel UUID generation", as that also changed the
v1 UUID to a v4 uuid.  Does the afs protocol require a v1 uuid
or does it just use the formwat on the wire?
