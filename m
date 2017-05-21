Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42860 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750786AbdEUGz7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 21 May 2017 02:55:59 -0400
Date: Sun, 21 May 2017 08:55:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/23] uuid: remove uuid_be defintions from the uapi
        header
Message-ID: <20170521065557.GC13004@lst.de>
References: <20170518071352.GA515@lst.de> <20170518062705.25902-1-hch@lst.de> <20170518062705.25902-4-hch@lst.de> <1495091565.31562.28.camel@perches.com> <13041.1495191521@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13041.1495191521@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Joe Perches <joe@perches.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org

On Fri, May 19, 2017 at 11:58:41AM +0100, David Howells wrote:
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > It's not a userspace ABI, so by defintion it does not break an
> > existing user program.
> 
> That's an invalid assumption.  It is a de facto userspace ABI as it has been
> exposed in /usr/include/linux/uuid.h for some time.

It is never passed through any kernel interface, which by defintion does
not make it an ABI.  And even if it was we are not going to change the
ABI for a uuid_t ever.  We're just changing the internal name, and stop
exposing the old name which was never used in an ABI to userspace.
