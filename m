Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53552 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755097AbdEKH61 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 May 2017 03:58:27 -0400
Date: Thu, 11 May 2017 09:58:25 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 16/16] fs: switch ->s_uuid to uuid_t
Message-ID: <20170511075825.GB19837@lst.de>
References: <20170510180214.16852-1-hch@lst.de> <20170510180214.16852-17-hch@lst.de> <CAOQ4uxga2U6OS8N5MnBoytyWP8Fbf8qQCS1cnsPqjoby=Mxc1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxga2U6OS8N5MnBoytyWP8Fbf8qQCS1cnsPqjoby=Mxc1w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel <linux-kernel@vger.kernel.org>

On Wed, May 10, 2017 at 10:08:25PM +0300, Amir Goldstein wrote:
> On Wed, May 10, 2017 at 9:02 PM, Christoph Hellwig <hch@lst.de> wrote:
> > For some file systems we still memcpy into it, but in various places this
> > already allows us to use the proper uuid helpers.  More to come..
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> 
> Series looks good!
> 
> My main concern is that filesystems with char uuid[16] are here to stay,
> or maybe, will be converted slowly.

I'll take a stab to convert them ASAP, and add s_uuid support for you
to more file systems once this initial series is done.

> 
> Considering this, perhaps we should have a helper/macro to copy from
> char[16] to *uuid_t and maybe  BUILD_BUG_ON the size comparison?
> #define bytes_to_uuid(dst, src) ...

If the mix of proper types and u8 arrays was to stay that'd be the way
to go, but I'd rather fix things up in a merge window or two instead
of leaving us in a transitionary state forever.
