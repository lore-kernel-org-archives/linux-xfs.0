Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D85C004C0
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Oct 2023 20:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjJTUG4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Oct 2023 16:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjJTUGz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2023 16:06:55 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E09D52
        for <linux-xfs@vger.kernel.org>; Fri, 20 Oct 2023 13:06:53 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-507c5249d55so1682627e87.3
        for <linux-xfs@vger.kernel.org>; Fri, 20 Oct 2023 13:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1697832412; x=1698437212; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FJwcfh7XT4p/d8xdEQd3o4yb8QA8P7Clkcjdf6k/CEg=;
        b=EfK/H/GLHx0/aqNqd/ehf8SerD5bueKNAIIvBIi/aGQCOt1XlGC78879l7Zp7buCuL
         t2CV3kMlUg1OVKtRm9uNuIoRI+jylsojzmhVpdG7jt/RF28GUQkpJqfmQYQpuga5Npo8
         yLM/mZfrOpsTh504cehZyfwfrx15cTdPW5KAA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697832412; x=1698437212;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FJwcfh7XT4p/d8xdEQd3o4yb8QA8P7Clkcjdf6k/CEg=;
        b=pe82Wqq8E/BnZu2WlzpVnHrQn9dDSzwl8qiX4tML0/IFQJdTKAfFG1UypHVeevkoSt
         gVqaqz35FlzDNeUyil0g2oM/AaivO5qMH6JasxfBqFaBoFx+hANOgk7tMNEHBo48E5Xh
         AM1qZoLCExgz6dpDHlAruRfuC8PLzTMU+bRzIU9aRRK8NGgvHNeFEjAgfucbUubMM8iZ
         5brZ401Ecape76O86Xmwe2NJdm++knx0qkpscqrZi5+Zv8lOVKpTxnxm4eewqDcQuzkP
         1F8rozSpya3HN8Lpo/2ZAED2NYeTs/ytWNPquSaRlyGYDMdL69/U5oC4u4CD3F4tFOge
         sCIQ==
X-Gm-Message-State: AOJu0YxQ6FlamKyI1kdlpRrgFr/5oGcB8Zze57dS1ZxJ4WRu0GGj3RWt
        5DRd3F0ReWlSXt9Kkns4ul+ZTZ5LeMc6ORopv3e0aH1B
X-Google-Smtp-Source: AGHT+IE9/dcjN4kZI16CEjDaW8l+0gi6PbeQeO8gIP3y3PMlJMbW0gvBGabVa/Gf2gVmfjZtsnvXbw==
X-Received: by 2002:a05:6512:32b9:b0:507:9a06:7dbe with SMTP id q25-20020a05651232b900b005079a067dbemr2038828lfe.21.1697832411799;
        Fri, 20 Oct 2023 13:06:51 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id o7-20020a05651205c700b005056ccb222asm499713lfo.105.2023.10.20.13.06.51
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Oct 2023 13:06:51 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2bfed7c4e6dso18485721fa.1
        for <linux-xfs@vger.kernel.org>; Fri, 20 Oct 2023 13:06:51 -0700 (PDT)
X-Received: by 2002:a17:907:c1f:b0:9ba:65e:752b with SMTP id
 ga31-20020a1709070c1f00b009ba065e752bmr2061794ejc.39.1697832390868; Fri, 20
 Oct 2023 13:06:30 -0700 (PDT)
MIME-Version: 1.0
References: <20231018-mgtime-v1-0-4a7a97b1f482@kernel.org> <20231018-mgtime-v1-2-4a7a97b1f482@kernel.org>
 <CAHk-=wixObEhBXM22JDopRdt7Z=tGGuizq66g4RnUmG9toA2DA@mail.gmail.com>
 <d6162230b83359d3ed1ee706cc1cb6eacfb12a4f.camel@kernel.org>
 <CAHk-=wiKJgOg_3z21Sy9bu+3i_34S86r8fd6ngvJpZDwa-ww8Q@mail.gmail.com>
 <5f96e69d438ab96099bb67d16b77583c99911caa.camel@kernel.org>
 <20231019-fluor-skifahren-ec74ceb6c63e@brauner> <0a1a847af4372e62000b259e992850527f587205.camel@kernel.org>
 <ZTGncMVw19QVJzI6@dread.disaster.area> <eb3b9e71ee9c6d8e228b0927dec3ac9177b06ec6.camel@kernel.org>
In-Reply-To: <eb3b9e71ee9c6d8e228b0927dec3ac9177b06ec6.camel@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 20 Oct 2023 13:06:13 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjma9_TSwXosG7GBXQaZ465VH1t4a4iQ8J=PFpE=4bhVA@mail.gmail.com>
Message-ID: <CAHk-=wjma9_TSwXosG7GBXQaZ465VH1t4a4iQ8J=PFpE=4bhVA@mail.gmail.com>
Subject: Re: [PATCH RFC 2/9] timekeeping: new interfaces for multigrain
 timestamp handing
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        John Stultz <jstultz@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
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

On Fri, 20 Oct 2023 at 05:12, Jeff Layton <jlayton@kernel.org> wrote:.
>
> I'd _really_ like to see a proper change counter added before it's
> merged, or at least space in the on-disk inode reserved for one until we
> can get it plumbed in.

Hmm. Can we not perhaps just do an in-memory change counter, and try
to initialize it to a random value when instantiating an inode? Do we
even *require* on-disk format changes?

So on reboot, the inode would count as "changed" as far any remote
user is concerned. It would flush client caches, but isn't that what
you'd want anyway? I'd hate to waste lots of memory, but maybe people
would be ok with just a 32-bit random value. And if not...

But I actually came into this whole discussion purely through the
inode timestamp side, so I may *entirely* miss what the change counter
requirements for NFSd actually are. If it needs to be stable across
reboots, my idea is clearly complete garbage.

You can now all jump on me and point out my severe intellectual
limitations. Please use small words when you do ;)

              Linus
