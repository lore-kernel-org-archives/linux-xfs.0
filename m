Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF4BCC77B73
	for <linux-xfs@archiver.kernel.org>; Wed, 24 May 2023 19:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbjEXTdY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 May 2023 15:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjEXTdX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 May 2023 15:33:23 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05B613A
        for <linux-xfs@vger.kernel.org>; Wed, 24 May 2023 12:33:20 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-510b56724caso351072a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 24 May 2023 12:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1684956799; x=1687548799;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CwDVho0x8hP8z2k65o3S1KvmfKQbxXm6/vOaXJXgCjY=;
        b=HwsvLOr7CenJ1oGNNAPHf5paQ+iWMfkGTsrpsGhpkBA6ebR+AukUg1w9OvS7iOA+MO
         yxC0WI0XEMHSgti9ngZBQDz2n/eqFPPaZO4J9NqaKs9JmaSHlqCqYRyfXM9y7Ds75K5N
         pTmpXmxrXamH00/GiNzq90fHWzMqZEM8PgX+Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684956799; x=1687548799;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CwDVho0x8hP8z2k65o3S1KvmfKQbxXm6/vOaXJXgCjY=;
        b=PwIksSPNDhMuwe58fPdAeqKlFzj2fkkFZX9lBSbp1OVLsnrzF59Gi/BNwF54xyjeOH
         VxMmmppYupwnZK1Atq+sMelqL9/QPFAOaj+vDPl8zZwRz7gM85jkeXD7hq/7EqWrwZRF
         rWT09fZBvc4ss1mCiJL+dRtlKAgqejzwOcLKNvtiDziPdVKOB5bjz5h5fw6vqOh8OOnr
         jEkfgvHlXppFDK1FUpTHcZ9xbIizqtTuS64OkqeLB+ZYD47+Hrv0kdVd78JsMt4pHlqT
         tcaqA7vfbPj060lz9QvmxC4rOQF0SbfGW0CY+8k/saZsvP9VuOeASn5BgsD0O7Zpzrhx
         0Mmw==
X-Gm-Message-State: AC+VfDzAUVbtac3L4hBFe94TFWa4BfHyeDxA686t0E4hrMHqP+Cc9O+Y
        NSbJIygKNWTFnpJoDwATekvGT/vbN7N0X6ermCt36A==
X-Google-Smtp-Source: ACHHUZ605j8KHaIyadFT2wZMPXcyTXokPR+xtOG4jQMb95tKzI521erTzllWDUvvBUk95cbU1UL7qA4HI6FoFlOQZt0=
X-Received: by 2002:a17:907:3f9c:b0:953:834d:899b with SMTP id
 hr28-20020a1709073f9c00b00953834d899bmr424076ejc.29.1684956799095; Wed, 24
 May 2023 12:33:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230524163504.lugqgz2ibe5vdom2@quack3>
In-Reply-To: <20230524163504.lugqgz2ibe5vdom2@quack3>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 24 May 2023 21:33:07 +0200
Message-ID: <CAJfpegu8W9R9G8n+4n3U5Ba_bKpM1o_5_2dfTOoeGDAOFcyF1g@mail.gmail.com>
Subject: Re: Locking for RENAME_EXCHANGE
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>, Ted Tso <tytso@mit.edu>,
        Amir Goldstein <amir73il@gmail.com>,
        "'David Laight" <David.Laight@aculab.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 24 May 2023 at 18:35, Jan Kara <jack@suse.cz> wrote:
>
> Hello!
>
> This is again about the problem with directory renames I've already
> reported in [1]. To quickly sum it up some filesystems (so far we know at
> least about xfs, ext4, udf, reiserfs) need to lock the directory when it is
> being renamed into another directory. This is because we need to update the
> parent pointer in the directory in that case and if that races with other
> operation on the directory, bad things can happen.
>
> So far we've done the locking in the filesystem code but recently Darrick
> pointed out [2] that we've missed the RENAME_EXCHANGE case in our ext4 fix.
> That one is particularly nasty because RENAME_EXCHANGE can arbitrarily mix
> regular files and directories. Couple nasty arising cases:
>
> 1) We need to additionally lock two exchanged directories. Suppose a
> situation like:
>
> mkdir P; mkdir P/A; mkdir P/B; touch P/B/F
>
> CPU1                                            CPU2
> renameat2("P/A", "P/B", RENAME_EXCHANGE);       renameat2("P/B/F", "P/A", 0);

Not sure I get it.

CPU1 locks P then A then B
CPU2 locks P then B then A

Both start with P and after that ordering between A and B doesn't
matter as long as the topology stays the same, which is guaranteed.

Or did you mean renameat2("P/B/F", "P/A/F", 0);?

This indeed looks deadlocky.

>
> Both operations need to lock A and B directories which are unrelated in the
> tree. This means we must establish stable lock ordering on directory locks
> even for the case when they are not in ancestor relationship.
>
> 2) We may need to lock a directory and a non-directory and they can be in
> parent-child relationship when hardlinks are involved:
>
> mkdir A; mkdir B; touch A/F; ln A/F B/F
> renameat2("A/F", "B");
>
> And this is really nasty because we don't have a way to find out whether
> "A/F" and "B" are in any relationship - in particular whether B happens to
> be another parent of A/F or not.
>
> What I've decided to do is to make sure we always lock directory first in
> this mixed case and that *should* avoid all the deadlocks but I'm spelling
> this out here just in case people can think of some even more wicked case
> before I'll send patches.

Locking directories first has always been the case, described in
detail in Documentation/filesystems/directory-locking.rst

> Also I wanted to ask (Miklos in particular as RENAME_EXCHANGE author): Why
> do we lock non-directories in RENAME_EXCHANGE case? If we didn't have to do
> that things would be somewhat simpler...

I can't say I remember anything, but digging into
lock_two_nondirectories() this comes up quickly:

  6cedba8962f4 ("vfs: take i_mutex on renamed file")

So apparently NFS is relying on i_mutex to prevent delegations from
being broken without its knowledge.  Might be that is't NFS only, and
then the RENAME_EXCHANGE case doesn't need it (NFS doesn't support
RENAME_EXCHANGE), but I can't say for sure.

Also Al seems to have had some thoughts on this in d42b386834ee
("update D/f/directory-locking")

Thanks,
Miklos
