Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34346 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753673AbdERH5Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 May 2017 03:57:25 -0400
MIME-Version: 1.0
In-Reply-To: <20170518062705.25902-24-hch@lst.de>
References: <20170518062705.25902-1-hch@lst.de> <20170518062705.25902-24-hch@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 18 May 2017 10:57:24 +0300
Message-ID: <CAOQ4uxj+TH5vS5HoEFPJXUpneBqr+YwbVES0bsHzw9qmS8HzKg@mail.gmail.com>
Subject: Re: [PATCH 23/23] uuid: remove uuid_be
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>

On Thu, May 18, 2017 at 9:27 AM, Christoph Hellwig <hch@lst.de> wrote:
> Everything uses uuid_t now.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Excellent!
I reviewed the entire series. You may add
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

to any of the patches as you see fit.

Now let's talk about how this is going to be merged.
Do you intend to send Linus a pull request?
Get those patches merged via someone else's tree?
Is this branch listed for linux-next build?

The reason I am asking is because this last removal patch should probably
be applied near the end of the merge window (?).
Because maintainers cannot apply patches with code that uses the new
uuid_t to linux-next branches and we don't want linux-next build to fail
with new code that uses uuid_be...

More to the point, I would like to re-post the patch
("tmpfs: generate random sb->s_uuid") using uuid_gen()
instead of generate_random_uuid() as you proposed.
Hugh has already acked the intent "once fs is agreed on the way to go"
When and how would I have this patch applied?
Obvious solution.. can you apply this patch to your branch?
Do you need me to re-post it?

Thanks for working on this!
Amir.
