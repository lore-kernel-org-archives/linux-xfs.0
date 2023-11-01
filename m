Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4EEC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Nov 2023 22:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbjKAWai (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Nov 2023 18:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232848AbjKAWah (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2023 18:30:37 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91261119
        for <linux-xfs@vger.kernel.org>; Wed,  1 Nov 2023 15:30:31 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-53de8fc1ad8so469582a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 01 Nov 2023 15:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1698877830; x=1699482630; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mox8X1H7M1pwsHX7MvCw8LITDXcjbr+sDfYdWZtZU/s=;
        b=HQump0YSkb4INwm4muKUBvVnSo4XuB6rao1PgLjMjaLq5ow7qFuybnw5lwFSu5BA1N
         Bqm6Q1Xvtx6wAgysdL5Jmbwa2w538MRo/MH/6to1nl1g92NPabgIJj4YafxpJFSOeE55
         yJmfsR5yunkYpYlgYuOMPucJ8hbS/nl1c7qgg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698877830; x=1699482630;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mox8X1H7M1pwsHX7MvCw8LITDXcjbr+sDfYdWZtZU/s=;
        b=hXj6oi42N5BZcKtvnN43AepyLBrSTDkHXAwbWiRT1nCV/Z7aMDrmKiplLjA8lRnXUX
         MDil727b54Gv23bQ73HzOOar8INls0+iIXNv24L3Zbb1OuUE+PSgiDYgJkvBp/jyiuYX
         snX5uOXI9PWVwLf2IvTdCU6TJZiEdgMSvIG1XnIPN8Ep9ib0XfsrWlh/kPdxsRbyoJAc
         RNtJV5PwXbyYqvmWwypXVHqIk3E1YTKE2rImb0m3voXiMFoffzzMlUJroJ91efdxcWTl
         om7FQv5K4Xt1//trRGabhzW8pYzTkfEBPiTFYdYzM5QuO8e8Bw4NedmGRA62Uc22k5Cy
         Ii0w==
X-Gm-Message-State: AOJu0YxVG2vigC9N9hzIydYBsUv8H8eqYiBwsTXPXZLjs6yfzwq8azxQ
        LTWEbZqKIBa5RkdrLVK32fPsfZINyJp7Mi/OQuzRYFUS
X-Google-Smtp-Source: AGHT+IGAyNL7HSLUxLotAmiz+VQdhNi4YMEEif0s+mfJocW4D2pl6xtdkHYPtnMqpmITH6iYm7gpUw==
X-Received: by 2002:a50:935d:0:b0:543:9670:7ee8 with SMTP id n29-20020a50935d000000b0054396707ee8mr2523505eda.14.1698877829987;
        Wed, 01 Nov 2023 15:30:29 -0700 (PDT)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com. [209.85.128.42])
        by smtp.gmail.com with ESMTPSA id fj26-20020a0564022b9a00b005402a0c9784sm1554126edb.40.2023.11.01.15.30.29
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Nov 2023 15:30:29 -0700 (PDT)
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40837ebba42so1986285e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 01 Nov 2023 15:30:29 -0700 (PDT)
X-Received: by 2002:a17:906:ee8b:b0:9be:263b:e31e with SMTP id
 wt11-20020a170906ee8b00b009be263be31emr2561024ejb.33.1698877442973; Wed, 01
 Nov 2023 15:24:02 -0700 (PDT)
MIME-Version: 1.0
References: <ZTjMRRqmlJ+fTys2@dread.disaster.area> <2ef9ac6180e47bc9cc8edef20648a000367c4ed2.camel@kernel.org>
 <ZTnNCytHLGoJY9ds@dread.disaster.area> <6df5ea54463526a3d898ed2bd8a005166caa9381.camel@kernel.org>
 <ZUAwFkAizH1PrIZp@dread.disaster.area> <CAHk-=wg4jyTxO8WWUc1quqSETGaVsPHh8UeFUROYNwU-fEbkJg@mail.gmail.com>
 <ZUBbj8XsA6uW8ZDK@dread.disaster.area> <CAOQ4uxgSRw26J+MPK-zhysZX9wBkXFRNx+n1bwnQwykCJ1=F4Q@mail.gmail.com>
 <3d6a4c21626e6bbb86761a6d39e0fafaf30a4a4d.camel@kernel.org>
 <ZUF4NTxQXpkJADxf@dread.disaster.area> <20231101101648.zjloqo5su6bbxzff@quack3>
 <CAHk-=wj6wy6tNUQm6EtgxfE_J229y1DthpCguqQfTej71yiJXw@mail.gmail.com> <3ae88800184f03b152aba6e4a95ebf26e854dd63.camel@hammerspace.com>
In-Reply-To: <3ae88800184f03b152aba6e4a95ebf26e854dd63.camel@hammerspace.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 1 Nov 2023 12:23:44 -1000
X-Gmail-Original-Message-ID: <CAHk-=wi+cVOE3VmJzN3C6TFepszCkrXeAFJY6b7bK=vV493rzQ@mail.gmail.com>
Message-ID: <CAHk-=wi+cVOE3VmJzN3C6TFepszCkrXeAFJY6b7bK=vV493rzQ@mail.gmail.com>
Subject: Re: [PATCH RFC 2/9] timekeeping: new interfaces for multigrain
 timestamp handing
To:     Trond Myklebust <trondmy@hammerspace.com>
Cc:     Jan Kara <jack@suse.cz>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        John Stultz <jstultz@google.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Hugh Dickins <hughd@google.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>, dsterba@suse.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux-MM <linux-mm@kvack.org>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Stephen Boyd <sboyd@kernel.org>,
        David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 1, 2023, 11:35 Trond Myklebust <trondmy@hammerspace.com> wrote:
>
> My client writes to the file and immediately reads the ctime. A 3rd
> party client then writes immediately after my ctime read.
> A reboot occurs (maybe minutes later), then I re-read the ctime, and
> get the same value as before the 3rd party write.
>
> Yes, most of the time that is better than the naked ctime, but not
> across a reboot.

Ahh, I knew I was missing something.

But I think it's fixable, with an additional rule:

 - when generating STATX_CHANGE_COOKIE, if the ctime matches the
current time and the ctime counter is zero, set the ctime counter to
1.

That means that you will have *spurious* cache invalidations of such
cached data after a reboot, but only for reads that happened right
after the file was written.

Now, it's obviously not unheard of to finish writing a file, and then
immediately reading the results again.

But at least those caches should be somewhat limited (and the problem
then only happens when the nfs server is rebooted).

I *assume* that the whole thundering herd issue with lots of clients
tends to be for stable files, not files that were just written and
then immediately cached?

I dunno. I'm sure there's still some thinko here.

             Linus
