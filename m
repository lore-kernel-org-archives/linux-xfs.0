Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57072 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753792AbdERHNy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 May 2017 03:13:54 -0400
Date: Thu, 18 May 2017 09:13:52 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/23] uuid: remove uuid_be defintions from the uapi
        header
Message-ID: <20170518071352.GA515@lst.de>
References: <20170518062705.25902-1-hch@lst.de> <20170518062705.25902-4-hch@lst.de> <1495091565.31562.28.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1495091565.31562.28.camel@perches.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Joe Perches <joe@perches.com>
Cc: Christoph Hellwig <hch@lst.de>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

On Thu, May 18, 2017 at 12:12:45AM -0700, Joe Perches wrote:
> On Thu, 2017-05-18 at 08:26 +0200, Christoph Hellwig wrote:
> > We don't use uuid_be and the UUID_BE constants in any uapi headers, so make
> > them private to the kernel.
> 
> On the assumption that no user program uses them?
> Is that a safe assumption?

It's not a userspace ABI, so by defintion it does not break an
existing user program.  If someone was using it they should be using
uuid_t from libuuid instead, as that gives them the routines to deal
with it.
