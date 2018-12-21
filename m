Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41082 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391592AbeLUTSz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Dec 2018 14:18:55 -0500
Received: by mail-lj1-f193.google.com with SMTP id k15-v6so5674046ljc.8
        for <linux-xfs@vger.kernel.org>; Fri, 21 Dec 2018 11:18:54 -0800 (PST)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id u65sm5311503lff.54.2018.12.21.11.18.51
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Dec 2018 11:18:51 -0800 (PST)
Received: by mail-lf1-f48.google.com with SMTP id n18so4641793lfh.6
        for <linux-xfs@vger.kernel.org>; Fri, 21 Dec 2018 11:18:51 -0800 (PST)
MIME-Version: 1.0
References: <20181220122324.17082-1-david@fromorbit.com> <20181220174130.GA21065@lst.de>
 <20181220205342.GC4205@dastard> <CAHk-=wgdbrbV+jNUmhJ7KZsR77CY+pUF7EmtxP2mWKnE8ZyFSQ@mail.gmail.com>
 <20181221093919.GA2337@lst.de>
In-Reply-To: <20181221093919.GA2337@lst.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 21 Dec 2018 11:18:35 -0800
Message-ID: <CAHk-=wjL7m3fLj1sVH91dcW51Qk4B9S7Q7OKf7dna6j+QoB5=w@mail.gmail.com>
Subject: Re: [PATCH] iomap: Revert "fs/iomap.c: get/put the page in iomap_page_create/release()"
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Piotr Jaroszynski <pjaroszynski@nvidia.com>, william.kucharski@oracle.com, stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

Dave,
 any chance you can validate Christoph's patch and we could re-apply the fix?

             Linus

On Fri, Dec 21, 2018 at 1:39 AM Christoph Hellwig <hch@lst.de> wrote:
>
> As far as I can tell the commit simply missed updating the recounts
> in the actual migrate callback for which it was added.  The fixed
> version looks something like this (still running xfstests):
