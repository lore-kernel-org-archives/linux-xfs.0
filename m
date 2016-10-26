Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49899 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757318AbcJZOCw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Oct 2016 10:02:52 -0400
Date: Wed, 26 Oct 2016 16:02:30 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/6] iomap: implement direct I/O
Message-ID: <20161026140230.GA8215@lst.de>
References: <1477408098-10153-1-git-send-email-hch@lst.de> <1477408098-10153-6-git-send-email-hch@lst.de> <1700618561.12920142.1477490023642.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1700618561.12920142.1477490023642.JavaMail.zimbra@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bob Peterson <rpeterso@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, axboe@fb.com, kent overstreet <kent.overstreet@gmail.com>, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

On Wed, Oct 26, 2016 at 09:53:43AM -0400, Bob Peterson wrote:
> It's unlikely, but bio_alloc can return NULL; shouldn't the code be
> checking for that?

No, a sleeping bio_alloc can not return NULL.  If it did our I/O
code would break down badly - take a look at the implementation,
the bio_alloc_bioset documentation even explains this in detail.

> | +		if (dio->error)
> | +			return 0;
> | +
> | +		bio = bio_alloc(GFP_KERNEL, nr_pages);
> 
> Same here. Also: the code that follows is nearly identical; do you want to make
> it a macro or inline function or something?

I'll take a look, but having another helper needed to follow for a
trivial struct initialization doesn't seem all that useful.
