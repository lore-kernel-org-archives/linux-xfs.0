Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48018 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750992AbdEaKdT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 May 2017 06:33:19 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170531094157.GA10511@lst.de>
References: <20170531094157.GA10511@lst.de> <20170528102008.30276-2-hch@lst.de> <20170528102008.30276-1-hch@lst.de> <9377.1496138404@warthog.procyon.org.uk>
Subject: Re: [PATCH 01/22] Revert "afs: Move UUID struct to linux/uuid.h"
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22156.1496226795.1@warthog.procyon.org.uk>
Date: Wed, 31 May 2017 11:33:15 +0100
Message-ID: <22157.1496226795@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: dhowells@redhat.com, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>

Christoph Hellwig <hch@lst.de> wrote:

> Does the afs protocol require a v1 uuid or does it just use the formwat on
> the wire?

The format it uses on the wire is separate XDR encoding of each of the fields
in the uuid_v1 struct, counting the elements of the node[] array separately.

I'm not sure that the servers actually parse the contents of the UUID, but I
can't be sure as I don't have access to the source for all of them.

OpenAFS and AuriStor will at least accept the version field being 4, however.

David
