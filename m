Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF8DC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 18:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjKHSZO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 13:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjKHSZN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 13:25:13 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D844172E
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 10:25:11 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1cc411be7e5so182065ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 08 Nov 2023 10:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699467911; x=1700072711; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PC/6qhrPU03mDp/kTli/yNT2tn8rEseETDX1nC6wox8=;
        b=EGw67X5MiD6H3JBdSATKzNavOXwLP4i2t9tP/rOF5jYHsTYK0TirhnySq5O27YAixd
         YkjPoeOUmDoVuAGBXAw44EXOxP6lqc8WdQP0T8eSK1EppWGFOXr5GwHJqxjNx8GDDTGm
         JyuuCpYj7cFUhU959QXI4CgWER/fw/KwdlB4DUr4qxD7clzsUXPATvVrFoLqyTEAEGmo
         gxluJGGAOHKvg9+u+5y87KTE5uy0Hw+DoB2WsuAAi5YMa5/WNJpuPLqF2e0dINjOPCYQ
         3yPgHLh8k4lqsMKYJWhf4v1CQx34kB26jrUgU7vBTYNGB4JCYm8YMtGmFUxnRgVCGb6M
         3R1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699467911; x=1700072711;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PC/6qhrPU03mDp/kTli/yNT2tn8rEseETDX1nC6wox8=;
        b=eyE5VKfkMxUGK/TKFBQvRxFcKqO1aAX2RhAukHPAPBcAsDPz5afCLvM2whPqm4n7Xk
         UE838XTBv3olhHch2fgJ8Ll4qD8zTujYR9qrAwwkBF+u8pF2PP3x71aG8MbTH5faspZB
         WU9a/vx2MsjfZA0J7KVJD1kddwV9CM5NxpDJJOWql1uTxpGhjicggMUT38IwXdWor4xX
         JJAcxY6AWPSDnIbSHsIGKQw0NXY0x8n/dE+gFEBGfmpX0fVHhNUIfM2FBb7iTyFO1saC
         aNv76JjGYGnGPPkPz2c+L7qTLws0tMHuEp2Td0rdMh8BHAdMPok3U9/yevfrufkTB84o
         VExw==
X-Gm-Message-State: AOJu0YyF8JD+zztLPOVKS9Ib5RC1iJsNnIY1pNfX+p6iHn+jcJFfCDhR
        tPYniXkxis5VNHvI5qrsldL3chTfvdimRfjiFFEm4g==
X-Google-Smtp-Source: AGHT+IHxrKjsunYtwCVlQDJt85desOtieZLQtrnV8TYRwbsiFMuy8DBOb0CrFp15j+2/TxH5dCjYOFdEPQBtv0jPj4Y=
X-Received: by 2002:a17:902:d4cc:b0:1c9:b5cf:6a78 with SMTP id
 o12-20020a170902d4cc00b001c9b5cf6a78mr8503plg.27.1699467910689; Wed, 08 Nov
 2023 10:25:10 -0800 (PST)
MIME-Version: 1.0
References: <20230704122727.17096-1-jack@suse.cz> <20230704125702.23180-1-jack@suse.cz>
 <20230822053523.GA8949@sol.localdomain> <20230822101154.7udsf4tdwtns2prj@quack3>
 <CANp29Y6uBuSzLXuCMGzVNZjT+xFqV4dtWKWb7GR7Opx__Diuzg@mail.gmail.com>
 <20231024111015.k4sbjpw5fa46k6il@quack3> <20231108101015.hj3w6a7sq5x7x2s4@quack3>
In-Reply-To: <20231108101015.hj3w6a7sq5x7x2s4@quack3>
From:   Aleksandr Nogikh <nogikh@google.com>
Date:   Wed, 8 Nov 2023 10:24:59 -0800
Message-ID: <CANp29Y7DuDDkVBwsU_xhBSAug7q7vTsrS6jogF61CYEi85jGcw@mail.gmail.com>
Subject: Re: [PATCH 1/6] block: Add config option to not allow writing to
 mounted devices
To:     Jan Kara <jack@suse.cz>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Kees Cook <keescook@google.com>,
        Ted Tso <tytso@mit.edu>,
        syzkaller <syzkaller@googlegroups.com>,
        Alexander Popov <alex.popov@linux.com>,
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi!

Thanks for letting me know!

I've sent a PR with new syzbot configs:
https://github.com/google/syzkaller/pull/4324

--=20
Aleksandr

On Wed, Nov 8, 2023 at 2:10=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> Hi!
>
> On Tue 24-10-23 13:10:15, Jan Kara wrote:
> > On Thu 19-10-23 11:16:55, Aleksandr Nogikh wrote:
> > > Thank you for the series!
> > >
> > > Have you already had a chance to push an updated version of it?
> > > I tried to search LKML, but didn't find anything.
> > >
> > > Or did you decide to put it off until later?
> >
> > So there is preliminary series sitting in VFS tree that changes how blo=
ck
> > devices are open. There are some conflicts with btrfs tree and bcachefs
> > merge that complicate all this (plus there was quite some churn in VFS
> > itself due to changing rules how block devices are open) so I didn't pu=
sh
> > out the series that actually forbids opening of mounted block devices
> > because that would cause a "merge from hell" issues. I plan to push out=
 the
> > remaining patches once the merge window closes and all the dependencies=
 are
> > hopefully in a stable state. Maybe I can push out the series earlier ba=
sed
> > on linux-next so that people can have a look at the current state.
>
> So patches are now in VFS tree [1] so they should be in linux-next as wel=
l.
> You should be able to start using the config option for syzbot runs :)
>
>                                                                 Honza
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/log/?h=3D=
vfs.super
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
