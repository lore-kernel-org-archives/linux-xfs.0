Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A13C433B4
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Apr 2021 15:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FB1E61245
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Apr 2021 15:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236426AbhDCPvT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 3 Apr 2021 11:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbhDCPvS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Apr 2021 11:51:18 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99075C0613E6
        for <linux-xfs@vger.kernel.org>; Sat,  3 Apr 2021 08:51:14 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id p12so1358853pgj.10
        for <linux-xfs@vger.kernel.org>; Sat, 03 Apr 2021 08:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=zfXTTchBhxb17sgVxUZJwqI4pTaadX89JZrranqOjDk=;
        b=bW31GhptrMPLJ2YMSf76qqDJJYe3OAtrN0dVeRZWBtC60c6vLVF0qPUoy6CwqsJgV8
         LocrgHa9KaymS9JCkYcAT/EPI7q1Q38uONyE4Xzg4YtYapeZkpsETWBGC4j1XlrkTg7M
         IYqtWn3hIC4ULAPdFWDHMtcFtsQ9s/8u7Rn86T7Vex5VvAiFruBBVyKLmsURwVJgqsMb
         FJD5wPiLPc3wShknOg6d6n1mNzDOCfvB/FI+qcYh5k8xoM1RqD60j21GLZpgMxu6MSVj
         T2WftzFleWBedjTFjkudno/r1uWKl4NBJg4tFb0QpLff/tlZqjuqMH3jKob7qvn78gq0
         Rgbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=zfXTTchBhxb17sgVxUZJwqI4pTaadX89JZrranqOjDk=;
        b=tKUXAJnkFvvpa+ND5T3voU/X9rFH6QDiCFJrUzuPEirQBsf2NDC73xQwysvHfuMl40
         LUsDoiFHkGhzPgrVnMUrx930b1RHzsAt2wYIWn71/xiSS0EOkHCBrrFT4DwB3I6+vzHc
         SjhiOqsqYLJJfiLicztGk58IIwbrNC4B/sNzZ2gBfCNO1HCuZiRZQEoI7AC4Ma681yaa
         PW0pTENSCpGzs5vpbbkh1TohJrfdaWtMogeKUd+xJxwmOBSKqlVxjGtLnobk8Gdz84rZ
         MofT4n86HRKTQiuCBVPnee5l0Rrxz0VNVCWxW3fvotHaAHl2TNVFLPkNleF3dTndaI2b
         OzIA==
X-Gm-Message-State: AOAM531R54/ik0pEvn7m9B126T/XKY7XbuKUW+l1DcZNr5TzNIaPpN10
        QDocYh4/nLzqqqm500GquA4=
X-Google-Smtp-Source: ABdhPJygaIQ5g3M7C0B4cHfbZHbHOWWFF5hsAeYYJMbE9YFmFWpWG/autQP4gNOeXGDIiMVWcCm1TA==
X-Received: by 2002:a05:6a00:b47:b029:20d:1c65:75f0 with SMTP id p7-20020a056a000b47b029020d1c6575f0mr16620422pfo.9.1617465074118;
        Sat, 03 Apr 2021 08:51:14 -0700 (PDT)
Received: from garuda ([122.179.103.45])
        by smtp.gmail.com with ESMTPSA id q14sm11418477pgt.54.2021.04.03.08.51.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 03 Apr 2021 08:51:13 -0700 (PDT)
References: <20210401164525.8638-1-chandanrlinux@gmail.com> <20210402115100.13478-1-chandanrlinux@gmail.com> <20210402153925.GH4090233@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V1.1] xfs: Use struct xfs_bmdr_block instead of struct xfs_btree_block to calculate root node size
In-reply-to: <20210402153925.GH4090233@magnolia>
Date:   Sat, 03 Apr 2021 21:21:10 +0530
Message-ID: <87lf9zbc41.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 02 Apr 2021 at 21:09, Darrick J. Wong wrote:
> On Fri, Apr 02, 2021 at 05:21:00PM +0530, Chandan Babu R wrote:
>> The incore data fork of an inode stores the bmap btree root node as 'struct
>> xfs_btree_block'. However, the ondisk version of the inode stores the bmap
>> btree root node as a 'struct xfs_bmdr_block'.
>> 
>> xfs_bmap_add_attrfork_btree() checks if the btree root node fits inside the
>> data fork of the inode. However, it incorrectly uses 'struct xfs_btree_block'
>> to compute the size of the bmap btree root node. Since size of 'struct
>> xfs_btree_block' is larger than that of 'struct xfs_bmdr_block',
>> xfs_bmap_add_attrfork_btree() could end up unnecessarily demoting the current
>> root node as the child of newly allocated root node.
>> 
>> This commit optimizes space usage by modifying xfs_bmap_add_attrfork_btree()
>> to use 'struct xfs_bmdr_block' to check if the bmap btree root node fits
>> inside the data fork of the inode.
>
> Hmm.  This introduces a (compatible) change in the ondisk format, since
> we no longer promote the data fork btree root block unnecessarily, right?

Yes, that is correct.

>
> We've been writing out filesystems in that state for years, so I think
> scrub is going to need patching to disable the "could the root block
> contents fit in the inode root?" check on the data fork if there's an
> attr fork.

You are right. I will post the corresponding patch soon.

>
> Meanwhile, this fix looks decent.
>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>
> By the way, have you tried running xfs/{529-538} on a realtime
> filesystem formatted with -d rtinherit=1 ?  There's something odd
> causing them to fail, but it's realtime so who knows what that's
> about. :)

Thanks for reporting the bug. I will see what is going on there.

-- 
chandan
