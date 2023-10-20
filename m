Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3546EC25B43
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Oct 2023 20:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjJTUVn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Oct 2023 16:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjJTUVm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2023 16:21:42 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F63D65
        for <linux-xfs@vger.kernel.org>; Fri, 20 Oct 2023 13:21:40 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-507c5249d55so1699794e87.3
        for <linux-xfs@vger.kernel.org>; Fri, 20 Oct 2023 13:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1697833298; x=1698438098; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XP/w2rcRgohzEDCbF3zAswI8lw4+mMJo52iF5/bT45w=;
        b=hqc7ea0COAmFv5MZPwSBclL6NfgTYs+tcpUPSzzToCUZ/TwOo0hu4g8a7FGMseXNsd
         NyABRTQUYO3pBlR8m58SHKKix/tS2Kbetb/DHV2SUb1E2yfgMlnbb6fsD4tQ6kvq4agG
         rYfEk8Cp6+fRvYnrlk4hLH6JfDTVzKAvswqRg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697833298; x=1698438098;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XP/w2rcRgohzEDCbF3zAswI8lw4+mMJo52iF5/bT45w=;
        b=mKzIJL0a7djaoc0nJxszh3O0pbhHcmG1AApI/gHtpiseJMD5z+6RoDC9Zy9UwMeJdN
         ac4arDYUDzs8ZGohoXS95a84a20qhdS1sSVzd1ZQDFptUsCq/tQG1/GW+Z9aRcw35Mc0
         I20hXamy061bEly/WDN2o94Ep4oeiM4bzVMrTHky5i/4BYIlXtI+dJNItqU9ttHv9EN/
         1Lllv/S99LhAyoXAMy0zBvj3Tss+x2yBJM6f73VyyKBPZeHuKCf2Xl6ystLNJz6ygg8a
         6qQ4LxImK5g1mXFB/K45zTlZBSiFD2GUU4KNBdu+bVFjxW5/iWtcGxzKDUH7hjbTzNv6
         /n8w==
X-Gm-Message-State: AOJu0YwUOWs9rHTgC0LOlC8rlb72nREaQjZnaSmKBDLgM3tmY3lp29xN
        BzBUHn/WtHumCGCswI7GHws09tETo+6v51MQSRy8GiN6
X-Google-Smtp-Source: AGHT+IHyUJ3SnIODFUouo7ofUuavVetOMYEN3DqNg0b68DvQ2pIzc3ZoqnbxV3UFDMi5Az0P4kA8Yg==
X-Received: by 2002:ac2:546b:0:b0:503:34b8:20b with SMTP id e11-20020ac2546b000000b0050334b8020bmr2120831lfn.65.1697833298138;
        Fri, 20 Oct 2023 13:21:38 -0700 (PDT)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com. [209.85.128.42])
        by smtp.gmail.com with ESMTPSA id d23-20020aa7c1d7000000b0053e15aefb0fsm2046493edp.85.2023.10.20.13.21.37
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Oct 2023 13:21:37 -0700 (PDT)
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-405361bb94eso9891835e9.0
        for <linux-xfs@vger.kernel.org>; Fri, 20 Oct 2023 13:21:37 -0700 (PDT)
X-Received: by 2002:a17:907:7e9e:b0:9ae:50e3:7e40 with SMTP id
 qb30-20020a1709077e9e00b009ae50e37e40mr2195962ejc.52.1697833276793; Fri, 20
 Oct 2023 13:21:16 -0700 (PDT)
MIME-Version: 1.0
References: <20231018-mgtime-v1-0-4a7a97b1f482@kernel.org> <20231018-mgtime-v1-2-4a7a97b1f482@kernel.org>
 <CAHk-=wixObEhBXM22JDopRdt7Z=tGGuizq66g4RnUmG9toA2DA@mail.gmail.com>
 <d6162230b83359d3ed1ee706cc1cb6eacfb12a4f.camel@kernel.org>
 <CAHk-=wiKJgOg_3z21Sy9bu+3i_34S86r8fd6ngvJpZDwa-ww8Q@mail.gmail.com>
 <5f96e69d438ab96099bb67d16b77583c99911caa.camel@kernel.org>
 <20231019-fluor-skifahren-ec74ceb6c63e@brauner> <0a1a847af4372e62000b259e992850527f587205.camel@kernel.org>
 <ZTGncMVw19QVJzI6@dread.disaster.area> <eb3b9e71ee9c6d8e228b0927dec3ac9177b06ec6.camel@kernel.org>
 <CAHk-=wjma9_TSwXosG7GBXQaZ465VH1t4a4iQ8J=PFpE=4bhVA@mail.gmail.com>
In-Reply-To: <CAHk-=wjma9_TSwXosG7GBXQaZ465VH1t4a4iQ8J=PFpE=4bhVA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 20 Oct 2023 13:20:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=whrB++OBZ9nO72QjLnWuSQxee69JQp7mo3cwDiaS6tTLw@mail.gmail.com>
Message-ID: <CAHk-=whrB++OBZ9nO72QjLnWuSQxee69JQp7mo3cwDiaS6tTLw@mail.gmail.com>
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

On Fri, 20 Oct 2023 at 13:06, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So on reboot, the inode would count as "changed" as far any remote
> user is concerned. [..]

Obviously, not just reboot would do that. Any kind of "it's no longer
cached on the server and gets read back from disk" would do the same
thing.

Again, that may not work for the intended purpose, but if the use-case
is a "same version number means no changes", it might be acceptable?
Even if you then could get spurious version changes when the file
hasn't been accessed in a long time?

Maybe all this together with with some ctime filtering ("old ctime
clealy means that the version number is irrelevant"). After all, the
whole point of fine-grained timestamps was to distinguish *frequent*
changes. An in-memory counter certainly does that even without any
on-disk representation..

               Linus
