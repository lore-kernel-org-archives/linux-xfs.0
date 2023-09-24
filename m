Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C14FCE7A8B
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Sep 2023 22:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjIXWS0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Sep 2023 18:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjIXWSZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Sep 2023 18:18:25 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11F2103
        for <linux-xfs@vger.kernel.org>; Sun, 24 Sep 2023 15:18:18 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-6910ea9cca1so3671500b3a.1
        for <linux-xfs@vger.kernel.org>; Sun, 24 Sep 2023 15:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695593898; x=1696198698; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RC3fTzW3rZT/6PIBgSkSMgoIPviq+yQKUFPzOmdRowk=;
        b=MGChy+GkV8go65C5DY1Z8najQNDteSWc/EHRz63Ai5NqWRz/F+fhrKYhDJLqhahwm0
         +zcfhsx/HkvaWpCEhIDmjS4RnCs9KR6ylXU0pz35iPq/HbvYSOg8RLE6MD6nVf4rjqp0
         DluDa0OKhTav1/1FkNvNskERy9iyffQqDFJ2KCQsK45lwobkMP4g6zbz6dbQHRf+VLLz
         3glziFf3BQ+bqwyIQ3lRRcNLpzg9tRz1g7N8iODLz9gFgdXdGTUc703lO8RuPbNU4hZp
         p3srIvl9IxCUsW1H45lIBvtYj1YOPoQh9z0wgoJXDe6DmLghs+vdquQoNS5nIR+jkSk2
         m+1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695593898; x=1696198698;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RC3fTzW3rZT/6PIBgSkSMgoIPviq+yQKUFPzOmdRowk=;
        b=BXSb+ytbsmatEnhCFm7hUsKBk2veUj5o0z+FN9/o0ffjDxqLsD8tKVblhXL+/mOMwb
         nfUsi8WPNs1d1eBnAX7hJTfll6QYJXRL44fnftCC9MyORTQyQecZL8KgR77IRxfNiSQt
         1umnBi/2fQUaXFWmhYMdKHX8eGGS7Olgbu2G2l537NuSNfl6j42Kr8HQ27qdL12gTBEs
         w+sJD8whJ2uYSG3lCnJykC0Sz1U5a320C12opl4bQMShbVtV5P8B8sFtffzcy/BKzVtG
         Q0m6lMOSm01slmXbyVtHp0aCV5bjpIDqaMxd2VW71gP/dSAKhlG8CWtZjt+u1J2GAkFK
         7awg==
X-Gm-Message-State: AOJu0YzCLUEjvXOXm8Kla2MsLQI/9sVKkVcW9Rca4lUKYq424AWvewU7
        ByWTPJ+RMc8+dAxDqAquq04h5A==
X-Google-Smtp-Source: AGHT+IFYb8qYgLqg3ME5eEmOSfvW95rgVG/vOb06h6o/SDjjxpRFUWhTPApjrGqayxXZ9w5grcuYTA==
X-Received: by 2002:a05:6a20:7346:b0:157:978c:5b74 with SMTP id v6-20020a056a20734600b00157978c5b74mr3641721pzc.0.1695593898124;
        Sun, 24 Sep 2023 15:18:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id i9-20020a170902c94900b001b9c960ffeasm7296094pla.47.2023.09.24.15.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Sep 2023 15:18:17 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qkXQc-0058uB-0f;
        Mon, 25 Sep 2023 08:18:14 +1000
Date:   Mon, 25 Sep 2023 08:18:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Neil Brown <neilb@suse.de>,
        Olga Kornievskaia <kolga@netapp.com>,
        Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 0/5] fs: multigrain timestamps for XFS's change_cookie
Message-ID: <ZRC1pjwKRzLiD6I3@dread.disaster.area>
References: <20230922-ctime-v8-0-45f0c236ede1@kernel.org>
 <CAOQ4uxiNfPoPiX0AERywqjaBH30MHQPxaZepnKeyEjJgTv8hYg@mail.gmail.com>
 <5e3b8a365160344f1188ff13afb0a26103121f99.camel@kernel.org>
 <CAOQ4uxjrt6ca4VDvPAL7USr6_SspCv0rkRkMJ4_W2S6vzV738g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjrt6ca4VDvPAL7USr6_SspCv0rkRkMJ4_W2S6vzV738g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 23, 2023 at 05:52:36PM +0300, Amir Goldstein wrote:
> On Sat, Sep 23, 2023 at 1:46 PM Jeff Layton <jlayton@kernel.org> wrote:
> >
> > On Sat, 2023-09-23 at 10:15 +0300, Amir Goldstein wrote:
> > > On Fri, Sep 22, 2023 at 8:15 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > >
> > > > My initial goal was to implement multigrain timestamps on most major
> > > > filesystems, so we could present them to userland, and use them for
> > > > NFSv3, etc.
> > > >
> > > > With the current implementation however, we can't guarantee that a file
> > > > with a coarse grained timestamp modified after one with a fine grained
> > > > timestamp will always appear to have a later value. This could confuse
> > > > some programs like make, rsync, find, etc. that depend on strict
> > > > ordering requirements for timestamps.
> > > >
> > > > The goal of this version is more modest: fix XFS' change attribute.
> > > > XFS's change attribute is bumped on atime updates in addition to other
> > > > deliberate changes. This makes it unsuitable for export via nfsd.
> > > >
> > > > Jan Kara suggested keeping this functionality internal-only for now and
> > > > plumbing the fine grained timestamps through getattr [1]. This set takes
> > > > a slightly different approach and has XFS use the fine-grained attr to
> > > > fake up STATX_CHANGE_COOKIE in its getattr routine itself.
> > > >
> > > > While we keep fine-grained timestamps in struct inode, when presenting
> > > > the timestamps via getattr, we truncate them at a granularity of number
> > > > of ns per jiffy,
> > >
> > > That's not good, because user explicitly set granular mtime would be
> > > truncated too and booting with different kernels (HZ) would change
> > > the observed timestamps of files.
> > >
> >
> > Thinking about this some more, I think the first problem is easily
> > addressable:
> >
> > The ctime isn't explicitly settable and with this set, we're already not
> > truncating the atime. We haven't used any of the extra bits in the mtime
> > yet, so we could just carve out a flag in there that says "this mtime
> > was explicitly set and shouldn't be truncated before presentation".
> >
> 
> I thought about this option too.
> But note that the "mtime was explicitly set" flag needs
> to be persisted to disk so you cannot store it in the high nsec bits.
> At least XFS won't store those bits if you use them - they have to
> be translated to an XFS inode flag and I don't know if changing
> XFS on-disk format was on your wish list.

Remember: this multi-grain timestamp thing was an idea to solve the
NFS change attribute problem without requiring *any* filesystem with
sub-jiffie timestamp capability to change their on-disk format to
implement a persistent change attribute that matches the new
requires of the kernel nfsd.

If we now need to change the on-disk format to support
some whacky new timestamp semantic to do this, then people have
completely lost sight of what problem the multi-grain timestamp idea
was supposed to address.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
