Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51042 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750999AbdEaSZf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 May 2017 14:25:35 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170531161826.23243-2-hch@lst.de>
References: <20170531161826.23243-2-hch@lst.de> <20170531161826.23243-1-hch@lst.de>
Subject: Re: [PATCH 01/24] uuid,afs: move struct uuid_v1 back into afs
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <31364.1496255131.1@warthog.procyon.org.uk>
Date: Wed, 31 May 2017 19:25:31 +0100
Message-ID: <31365.1496255131@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: dhowells@redhat.com, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> This essentially is a partial revert of commit ff548773
> ("afs: Move UUID struct to linux/uuid.h") and moves struct uuid_v1 back into
> fs/afs as struct afs_uuid.  It however keeps it as big endian structure
> so that we can use the normal uuid generation helpers when casting to/from
> struct afs_uuid.
> 
> The V1 uuid intrepreatation in struct form isn't really useful to the
> rest of the kernel, and not really compatible to it either, so move it
> back to AFS instead of polluting the global uuid.h.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: David Howells <dhowells@redhat.com>
