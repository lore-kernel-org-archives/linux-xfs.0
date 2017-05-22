Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51761 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760421AbdEVS7b (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 May 2017 14:59:31 -0400
Message-ID: <1495479565.6967.72.camel@linux.intel.com>
Subject: Re: [PATCH 23/23] uuid: remove uuid_be
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Mon, 22 May 2017 21:59:25 +0300
In-Reply-To: <20170518085629.GA6149@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
         <20170518062705.25902-24-hch@lst.de>
         <CAOQ4uxj+TH5vS5HoEFPJXUpneBqr+YwbVES0bsHzw9qmS8HzKg@mail.gmail.com>
         <20170518085629.GA6149@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>

On Thu, 2017-05-18 at 10:56 +0200, Christoph Hellwig wrote:
> On Thu, May 18, 2017 at 10:57:24AM +0300, Amir Goldstein wrote:
> > I reviewed the entire series. You may add
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > 
> > to any of the patches as you see fit.
> 
> Thanks, done!

Similar from my side, FWIW:
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> 
> > Now let's talk about how this is going to be merged.
> > Do you intend to send Linus a pull request?
> 
> Yes, that might be the best idea.  I'm also contemplating listing
> me plus anyone volunteering (you?, Andy) as maintaines for the uuid
> code.

I would agree to be a designated reviewer for now (too many stuff to
follow as a (co-)maintainer).

> > The reason I am asking is because this last removal patch should
> > probably
> > be applied near the end of the merge window (?).
> > Because maintainers cannot apply patches with code that uses the new
> > uuid_t to linux-next branches and we don't want linux-next build to
> > fail
> > with new code that uses uuid_be...
> 
> Yeah, we can probably defer that one for now.

I would also like to append some of patches from my side, though they
are WIP.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
