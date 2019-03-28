Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f48.google.com ([209.85.128.48]:53897 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfC1PcF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Mar 2019 11:32:05 -0400
MIME-Version: 1.0
References: <20190328035001.26276-1-ming.lei@redhat.com> <5258cad3-b324-660f-589f-73eb7fb8fa04@kernel.dk>
 <20190328150320.GB9265@infradead.org>
In-Reply-To: <20190328150320.GB9265@infradead.org>
From: Ming Lei <tom.leiming@gmail.com>
Date: Thu, 28 Mar 2019 23:31:52 +0800
Message-ID: <CACVXFVOOBerm38vmZjhvDi8OKdyX_sW0jU1tTr5Fp=qahY+Vhw@mail.gmail.com>
Subject: Re: [PATCH] block: clarify that bio_add_page() and related helpers
 can add multi pages
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, linux-block <linux-block@vger.kernel.org>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>

On Thu, Mar 28, 2019 at 11:04 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Mar 28, 2019 at 08:21:55AM -0600, Jens Axboe wrote:
> > This is going to create a needless conflict between 5.1 and the 5.2
> > block tree. I haven't pushed the 5.2 tree out yet, plan to do so
> > this week after I've pushed the current 5.1 patches. Can you respin
> > this one on top of for-5.2/block when it comes out?
>
> Can we also drop the parameter name rename and just add the comments?

OK, I will drop the name rename change and send it out after for-5.2 comes out.

Thanks,
Ming Lei
