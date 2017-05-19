Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52102 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750970AbdESK6p (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 May 2017 06:58:45 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170518071352.GA515@lst.de>
References: <20170518071352.GA515@lst.de> <20170518062705.25902-1-hch@lst.de> <20170518062705.25902-4-hch@lst.de> <1495091565.31562.28.camel@perches.com>
Subject: Re: [PATCH 03/23] uuid: remove uuid_be defintions from the uapi header
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <13040.1495191521.1@warthog.procyon.org.uk>
Date: Fri, 19 May 2017 11:58:41 +0100
Message-ID: <13041.1495191521@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: dhowells@redhat.com, Joe Perches <joe@perches.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> It's not a userspace ABI, so by defintion it does not break an
> existing user program.

That's an invalid assumption.  It is a de facto userspace ABI as it has been
exposed in /usr/include/linux/uuid.h for some time.

> If someone was using it they should be using uuid_t from libuuid instead, as
> that gives them the routines to deal with it.

Yes, they should - but that doesn't mean they do.

David
