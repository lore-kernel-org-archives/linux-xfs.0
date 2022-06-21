Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 112AAC43334
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jun 2022 22:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbiFUWXt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jun 2022 18:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231972AbiFUWXt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jun 2022 18:23:49 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9EA133122B
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jun 2022 15:23:48 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id D788AFB431;
        Tue, 21 Jun 2022 17:22:58 -0500 (CDT)
Message-ID: <990cd4b5-28c4-770b-6869-7218faf4c685@sandeen.net>
Date:   Tue, 21 Jun 2022 17:23:46 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Content-Language: en-US
To:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
References: <20220621065010.666439-1-chandan.babu@oracle.com>
Cc:     Dave Chinner <dchinner@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs_repair: Use xfs_extnum_t instead of basic data types
In-Reply-To: <20220621065010.666439-1-chandan.babu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/21/22 1:50 AM, Chandan Babu R wrote:
> xfs_extnum_t is the type to use to declare variables whose values have been
> obtained from per-inode extent counters. This commit replaces using basic
> types (e.g. uint64_t) with xfs_extnum_t when declaring such variables.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---

Thanks Chandan - I had rolled something like this into the merge of kernel
"xfs: Use xfs_extnum_t instead of basic data types"
because it seemed like it should maybe all be done at once.

And the tree Dave has already had (some of) these type changes in db/ and
repair/dinode.c as part of that patch.

On top of that, I added a lot more of these conversions, i.e. to
bmap(), bmap_one_extent(), and make_bbmap() in db/bmap.c, 
process_bmbt_reclist() in db/check.c, fa_cfileoffd() and
fa_dfiloffd() in db/faddr.c ... perhaps I should send you my net diff
on top of the tree dchinner assembled, and you can see what you think?

But at the highest level, does it make more sense to convert everything
in the utilities at the same time as "xfs: Use xfs_extnum_t instead of
basic data types" is applied to xfsprogs libxfs/ or would separate patches
be better?

Thanks,
-Eric
