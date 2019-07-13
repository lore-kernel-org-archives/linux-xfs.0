Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f53.google.com ([209.85.167.53]:36379 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727525AbfGMA1f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Jul 2019 20:27:35 -0400
Received: by mail-lf1-f53.google.com with SMTP id q26so7550316lfc.3
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2019 17:27:34 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id p76sm1684558ljb.49.2019.07.12.17.27.31
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 17:27:31 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id q26so7550290lfc.3
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2019 17:27:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190712180205.GA5347@magnolia>
In-Reply-To: <20190712180205.GA5347@magnolia>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 12 Jul 2019 17:27:15 -0700
Message-ID: <CAHk-=wiK8_nYEM2B8uvPELdUziFhp_+DqPN=cNSharQqpBZ6qg@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: new features for 5.3
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@lst.de>

On Fri, Jul 12, 2019 at 11:02 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> The branch merges cleanly against this morning's HEAD and survived an
> overnight run of xfstests.  The merge was completely straightforward, so
> please let me know if you run into anything weird.

Hmm. I don't know what you merged against, but it got a (fairly
trivial) conflict for me due to

  79d08f89bb1b ("block: fix .bi_size overflow")

from the block merge (from Tuesday) touching a line next to one changed by

  a24737359667 ("xfs: simplify xfs_chain_bio")

from this pull.

So it wasn't an entirely clean merge for me.

Was it a complex merge conflict? No. I'm just confused by the "merges
cleanly against this morning's HEAD", which makes me wonder what you
tried to merge against..

            Linus
