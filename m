Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52606 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750898AbdE3KAM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 May 2017 06:00:12 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170528102008.30276-2-hch@lst.de>
References: <20170528102008.30276-2-hch@lst.de> <20170528102008.30276-1-hch@lst.de>
Subject: Re: [PATCH 01/22] Revert "afs: Move UUID struct to linux/uuid.h"
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9376.1496138404.1@warthog.procyon.org.uk>
Date: Tue, 30 May 2017 11:00:04 +0100
Message-ID: <9377.1496138404@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: dhowells@redhat.com, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> This reverts commit ff548773106ec7f8031bc6172e0234bd2a02c19c.
> 
> The V1 uuid intrepreatation in struct form isn't really useful to the
> rest of the kernel, and not really compatible to it either, so move it
> back to AFS instead of polluting the global uuid.h.

This isn't going to work.  You've effectively changed the types of the fields
in the UUID struct from BE to CPU-endian, but you're still calling
generate_random_uuid(), which produces a BE UUID.  You need to leave the
struct members as __beXX or stop using the core UUID routines.

Just move the struct uuid_v1 as-is to the afs headers and rename it to struct
afs_uuid.  You can then leave the (un)marshalling code alone.

David
