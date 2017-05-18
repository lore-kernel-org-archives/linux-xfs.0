Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57573 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751486AbdERI4b (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 May 2017 04:56:31 -0400
Date: Thu, 18 May 2017 10:56:29 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 23/23] uuid: remove uuid_be
Message-ID: <20170518085629.GA6149@lst.de>
References: <20170518062705.25902-1-hch@lst.de> <20170518062705.25902-24-hch@lst.de> <CAOQ4uxj+TH5vS5HoEFPJXUpneBqr+YwbVES0bsHzw9qmS8HzKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj+TH5vS5HoEFPJXUpneBqr+YwbVES0bsHzw9qmS8HzKg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>

On Thu, May 18, 2017 at 10:57:24AM +0300, Amir Goldstein wrote:
> I reviewed the entire series. You may add
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> to any of the patches as you see fit.

Thanks, done!

> Now let's talk about how this is going to be merged.
> Do you intend to send Linus a pull request?

Yes, that might be the best idea.  I'm also contemplating listing
me plus anyone volunteering (you?, Andy) as maintaines for the uuid
code.

But first I'll need a few more reviews, at least for the XFS bits.

> Get those patches merged via someone else's tree?
> Is this branch listed for linux-next build?

Not yet.

> The reason I am asking is because this last removal patch should probably
> be applied near the end of the merge window (?).
> Because maintainers cannot apply patches with code that uses the new
> uuid_t to linux-next branches and we don't want linux-next build to fail
> with new code that uses uuid_be...

Yeah, we can probably defer that one for now.

> More to the point, I would like to re-post the patch
> ("tmpfs: generate random sb->s_uuid") using uuid_gen()
> instead of generate_random_uuid() as you proposed.
> Hugh has already acked the intent "once fs is agreed on the way to go"
> When and how would I have this patch applied?
> Obvious solution.. can you apply this patch to your branch?

Yes.

> Do you need me to re-post it?

Please do.
