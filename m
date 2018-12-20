Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37800 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390173AbeLTWmg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Dec 2018 17:42:36 -0500
Received: by mail-lj1-f194.google.com with SMTP id t18-v6so3027317ljd.4
        for <linux-xfs@vger.kernel.org>; Thu, 20 Dec 2018 14:42:34 -0800 (PST)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id o5-v6sm4264623ljh.75.2018.12.20.14.42.32
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Dec 2018 14:42:32 -0800 (PST)
Received: by mail-lf1-f44.google.com with SMTP id e26so2581508lfc.2
        for <linux-xfs@vger.kernel.org>; Thu, 20 Dec 2018 14:42:32 -0800 (PST)
MIME-Version: 1.0
References: <20181220122324.17082-1-david@fromorbit.com> <20181220174130.GA21065@lst.de>
 <20181220205342.GC4205@dastard>
In-Reply-To: <20181220205342.GC4205@dastard>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Dec 2018 14:42:15 -0800
Message-ID: <CAHk-=wgdbrbV+jNUmhJ7KZsR77CY+pUF7EmtxP2mWKnE8ZyFSQ@mail.gmail.com>
Subject: Re: [PATCH] iomap: Revert "fs/iomap.c: get/put the page in iomap_page_create/release()"
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, pjaroszynski@nvidia.com, william.kucharski@oracle.com, stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Thu, Dec 20, 2018 at 12:53 PM Dave Chinner <david@fromorbit.com> wrote:
>
> I'd say we still need to revert this for 4.20 which is due for
> release in a couple of days. Most of us are going to be on holidays
> and away from computers for the next week, so I don't think we
> have time to adequately review and test a new fix (which doesn't
> exist yet) before the release occurs.

Yeah. I already applied the revert. If somebody finds a "duh" moment,
and an alternate fix gets posted and tested we can revert the revert
and fix it properly, but for 4.20 (and for xmas) I do think that just
going back to the previous state is otherwise the right choice.

              Linus
