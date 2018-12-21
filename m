Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41957 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbeLUT0j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Dec 2018 14:26:39 -0500
Received: by mail-lf1-f68.google.com with SMTP id c16so4654013lfj.8
        for <linux-xfs@vger.kernel.org>; Fri, 21 Dec 2018 11:26:37 -0800 (PST)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id 4-v6sm4717833ljw.84.2018.12.21.11.26.35
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Dec 2018 11:26:36 -0800 (PST)
Received: by mail-lj1-f173.google.com with SMTP id k15-v6so5691451ljc.8
        for <linux-xfs@vger.kernel.org>; Fri, 21 Dec 2018 11:26:35 -0800 (PST)
MIME-Version: 1.0
References: <20181220122324.17082-1-david@fromorbit.com> <20181220174130.GA21065@lst.de>
 <20181220205342.GC4205@dastard> <CAHk-=wgdbrbV+jNUmhJ7KZsR77CY+pUF7EmtxP2mWKnE8ZyFSQ@mail.gmail.com>
 <20181221093919.GA2337@lst.de> <CAHk-=wjL7m3fLj1sVH91dcW51Qk4B9S7Q7OKf7dna6j+QoB5=w@mail.gmail.com>
 <20181221192056.GA27640@lst.de>
In-Reply-To: <20181221192056.GA27640@lst.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 21 Dec 2018 11:26:18 -0800
Message-ID: <CAHk-=whn6Sxh+wUD+uXVwk+Jd+k5B2KmJAj-9QSzemiDLR4-jg@mail.gmail.com>
Subject: Re: [PATCH] iomap: Revert "fs/iomap.c: get/put the page in iomap_page_create/release()"
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Piotr Jaroszynski <pjaroszynski@nvidia.com>, william.kucharski@oracle.com, stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Fri, Dec 21, 2018 at 11:20 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Given that it took so long to find the original issue I think we should
> not worry about 4.20 and just get the fix into 4.21-rc early and add it
> to stable.

Fair enough, I'll stop worrying ;)

             Linus
