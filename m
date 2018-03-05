Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:44499 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932600AbeCEKTr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Mar 2018 05:19:47 -0500
Received: by mail-qt0-f196.google.com with SMTP id g60so19673904qtd.11
        for <linux-xfs@vger.kernel.org>; Mon, 05 Mar 2018 02:19:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180302163603.GQ19312@magnolia>
References: <20180228154951.31714-1-vbendel@redhat.com> <20180301224800.GI12763@magnolia>
 <20180302163603.GQ19312@magnolia>
From: Vratislav Bendel <vbendel@redhat.com>
Date: Mon, 5 Mar 2018 11:19:46 +0100
Message-ID: <CAHrQN1w2DxYD_ZscBhsuGq2b6CKn41AnVCaH6_hSQ2tN8DkA1Q@mail.gmail.com>
Subject: Re: [PATCH] xfs: Correctly invert xfs_buftarg LRU isolation logic
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, djwong@kernel.org

(In response to Luis' comment:)
> Can you add a respective Fixes: tag?

It was apparently present since LRU was added to xfs buffer cache via:
commit 430cbeb86fdcbbdabea7d4aa65307de8de425350
[xfs: add a lru to the XFS buffer cache]

But I wouldn't say this patch "fixes" that commit.
What do you think? Should a fixes tag be added in this case?


> Also what effects are observed by
> the user when this happens on the kernel log?

I haven't spotted any differences visible to user, nor in the kernel log.

(In response to Brian's comment:)
>> However, as per documentation, atomic_add_unless() returns _zero_
>> if the atomic value was originally equal to the specified *unsless* value.
>>
> Nit:                                                         unless

Thanks very much for feedback. Since it's my very first upstream
commit-proposal,
I expected that some polish would be needed.


> It might be worth pointing out in the commit log that currently isolated
> buffers end up right back on the LRU once they are released, because
> ->b_lru_ref remains elevated. Therefore, this patch essentially fixes
> that circuitous route by leaving them on the LRU as originally intended.
> Otherwise this looks Ok to me:

So the final commit message could be:
~~~
Currently the xfs_buftarg_isolate() is causing an xfs_buffer
with zero b_lru_ref, to take another trip around LRU, while
isolating buffers with non-zero b_lru_ref.

Additionally those isolated buffers end up right back on the LRU
once they are released, because ->b_lru_ref remains elevated.

Fix that circuitous route by leaving them on the LRU
as originally intended.

>> Signed-off-by: Vratislav Bendel <vbendel@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
