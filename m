Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA55CDB483
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Oct 2023 19:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbjJRTTG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Oct 2023 15:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjJRTTF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 15:19:05 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30345109
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 12:19:03 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2b9c907bc68so94237411fa.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 12:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1697656741; x=1698261541; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5Ne6XlZkvrqbgYXFwibkwS6QVtHojWCVkTUV60CnBXA=;
        b=BunhL8vEinbtMzTobkYonStJky9F0F3H6gr/fGEhsF7xRMQV8NYr666XLtr22jPNbU
         J9pqRBLYmrFEs0bSbQfVJOe8VwBUFC676HMshHaKGBBNymcdZNEEuQwEN2R7+f51F3p9
         fXevfbvD2dqSNXU6J0CS+IeTc7Z3zrrUh9kTY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697656741; x=1698261541;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Ne6XlZkvrqbgYXFwibkwS6QVtHojWCVkTUV60CnBXA=;
        b=Umfxx+FYmXBCSahQDYRoisbVzPDktsDtT35d6aYb2rdvqRfFC3cbi4WGrP41d8POL2
         5Xacp1Bog1L0ouxqNkQbJz34X5Bdo4fuJlkMvlRtyVcV+Ab7FsHEfF/XuuDJ2pToLCTr
         9W0m+RRwD4Wr41TMG8mLOfplkFo633WUW0xZ9pHF1Dt+E57yEc35l3YxmpQ9S+CNKnG2
         7YdHInzuuyweP0QitoxprLPpdy8xTy8IUp/F7tS3hl76XhbixCnlRe9W9UZgA4VAfVjt
         qjpAGlWcFSKoIza5rD5TgZBS/uzWnxqendp01b2+NTkNi5WmXAqP2lxeEJqbre/Q+zAW
         XjBg==
X-Gm-Message-State: AOJu0Yy2qoJIEDJq5EZnWK2642W+Itidsz4yUB8eDLNOdjXaRg6scck7
        io/D5SwFVshbKFAAlnFMHRGL19hcEbDbe18gBFEUAYPC
X-Google-Smtp-Source: AGHT+IHW9nJAZf65L9v8sc47Tw8jtPYTBYpEZVlp49g+0zObPkdAsVHFJo3wyq5pfzr0KHDrwPpNtg==
X-Received: by 2002:a2e:9792:0:b0:2c5:2132:24f5 with SMTP id y18-20020a2e9792000000b002c5213224f5mr4032093lji.53.1697656741050;
        Wed, 18 Oct 2023 12:19:01 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id h17-20020a170906111100b009b94fe3fc47sm2196235eja.159.2023.10.18.12.19.00
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Oct 2023 12:19:00 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-522bd411679so11968061a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 12:19:00 -0700 (PDT)
X-Received: by 2002:a17:906:99c4:b0:9bd:a662:c066 with SMTP id
 s4-20020a17090699c400b009bda662c066mr149569ejn.76.1697656719721; Wed, 18 Oct
 2023 12:18:39 -0700 (PDT)
MIME-Version: 1.0
References: <20231018-mgtime-v1-0-4a7a97b1f482@kernel.org> <20231018-mgtime-v1-2-4a7a97b1f482@kernel.org>
In-Reply-To: <20231018-mgtime-v1-2-4a7a97b1f482@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 18 Oct 2023 12:18:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wixObEhBXM22JDopRdt7Z=tGGuizq66g4RnUmG9toA2DA@mail.gmail.com>
Message-ID: <CAHk-=wixObEhBXM22JDopRdt7Z=tGGuizq66g4RnUmG9toA2DA@mail.gmail.com>
Subject: Re: [PATCH RFC 2/9] timekeeping: new interfaces for multigrain
 timestamp handing
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        John Stultz <jstultz@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.de>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 18 Oct 2023 at 10:41, Jeff Layton <jlayton@kernel.org> wrote:
>
> One way to prevent this is to ensure that when we stamp a file with a
> fine-grained timestamp, that we use that value to establish a floor for
> any later timestamp update.

I'm very leery of this.

I don't like how it's using a global time - and a global fine-grained
offset - when different filesystems will very naturally have different
granularities. I also don't like how it's no using that global lock.

Yes, yes, since the use of this all is then gated by the 'is_mgtime()'
thing, any filesystem with big granularities will presumably never set
FS_MGTIME in the first time, and that hides the worst pointless cases.
But it still feels iffy to me.

Also, the whole current_ctime() logic seems wrong. Later (in 4/9), you do this:

 static struct timespec64 current_ctime(struct inode *inode)
 {
        if (is_mgtime(inode))
                return current_mgtime(inode);

and current_mgtime() does

        if (nsec & I_CTIME_QUERIED) {
                ktime_get_real_ts64(&now);
                return timestamp_truncate(now, inode);
        }

so once the code has set I_CTIME_QUERIED, it will now use the
expensive fine-grained time - even when it makes no sense.

As far as I can tell, there is *never* a reason to get the
fine-grained time if the old inode ctime is already sufficiently far
away.

IOW, my gut feel is that all this logic should always not only be
guarded by FS_MGTIME (like you do seem to do), *and* by "has anybody
even queried this time" - it should *also* always be guarded by "if I
get the coarse-grained time, is that sufficient?"

So I think the current_ctime() logic should be something along the lines of

    static struct timespec64 current_ctime(struct inode *inode)
    {
        struct timespec64 ts64 = current_time(inode);
        unsigned long old_ctime_sec = inode->i_ctime_sec;
        unsigned int old_ctime_nsec = inode->i_ctime_nsec;

        if (ts64.tv_sec != old_ctime_sec)
                return ts64;

        /*
         * No need to check is_mgtime(inode) - the I_CTIME_QUERIED
         * flag is only set for mgtime filesystems
         */
        if (!(old_ctime_nsec & I_CTIME_QUERIED))
                return ts64;
        old_ctime_nsec &= ~I_CTIME_QUERIED;
        if (ts64.tv_nsec > old_ctime_nsec + inode->i_sb->s_time_gran)
                return ts64;

        /* Ok, only *now* do we do a finegrained value */
        ktime_get_real_ts64(&ts64);
        return timestamp_truncate(ts64);
    }

or whatever. Make it *very* clear that the finegrained timestamp is
the absolute last option, after we have checked that the regular one
isn't possible.

I dunno.

            Linus
