Return-Path: <SRS0=4VMi=2H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43CDBC43603
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 15:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FFC12146E
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 15:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbfLQPGe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 10:06:34 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:39309 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbfLQPGe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Dec 2019 10:06:34 -0500
Received: from mail-qk1-f178.google.com ([209.85.222.178]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MVe9i-1iHpFM2wIm-00RcpJ; Tue, 17 Dec 2019 16:06:32 +0100
Received: by mail-qk1-f178.google.com with SMTP id x129so1020779qke.8;
        Tue, 17 Dec 2019 07:06:32 -0800 (PST)
X-Gm-Message-State: APjAAAVBgU7uFQJGUqi7IwALzFsIB7WdArnGMtICwpFGj8E/JO8dQXTQ
        THySG15TlZ7h1QguRuA6YHR16HBMVkj4meNjkAQ=
X-Google-Smtp-Source: APXvYqziF19ZAqnd0AyybWZhW49yyhOqBWcN5hszB6q/mh3kir/pIFEc/G5EPlpPSu67v73QrpyGEFJgFYw6DDLxG+8=
X-Received: by 2002:a05:620a:a5b:: with SMTP id j27mr5537510qka.286.1576595191483;
 Tue, 17 Dec 2019 07:06:31 -0800 (PST)
MIME-Version: 1.0
References: <20191213204936.3643476-1-arnd@arndb.de> <20191213205417.3871055-11-arnd@arndb.de>
 <20191213210509.GK99875@magnolia> <CAK8P3a10wQuHGV3c2JYSkLsKLFK8t9fOmpE=fwULe8Aj41Kshg@mail.gmail.com>
 <20191216165249.GG99884@magnolia>
In-Reply-To: <20191216165249.GG99884@magnolia>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 17 Dec 2019 16:06:15 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1X85Px8N=xh6noF4zUU++ENJxscehCJx75xQVmHFpCOQ@mail.gmail.com>
Message-ID: <CAK8P3a1X85Px8N=xh6noF4zUU++ENJxscehCJx75xQVmHFpCOQ@mail.gmail.com>
Subject: Re: [PATCH v2 20/24] xfs: disallow broken ioctls without compat-32-bit-time
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     y2038 Mailman List <y2038@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:NRAxyPhD1tgLi05DsoJ+mSx87j5syuCAnzQ9GWOzLnxkKq6x4oM
 VZdc7LiUNRICj38YCL/dXNVNfnKvlnDbjPmHKjJsGQ6znzj4QEIlQz3ID1nC7YiKEdGpxQ7
 ip0x4kuu/39eWL6LSaqH82qxmJP9/LNunI1l83Axd5G/Afz2NYRddqSpxHk9Zzw6EtxQNPS
 TNTiSykDTmdlijQ22Ub2g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:JR02auZ+vHE=:kNgx1s0bFSVyOIrJ1FqB3Z
 cM8q6YvTTU0DnznjMu9NhZp0e5agcii+rFngKiSexgR7c8MLcFilwBaaQvSP9gmgbLjKSqCGD
 HDCqWJkuGROk7plAfWTaVtPQZ+SiMsV1qJkOoK43iJdERcGjA2UZ5/4Hvdgqf1yEQW31lnyYq
 6WOUJvMVQUS4RO/sYsncG1PjGsyz2tlBWWcEsl4jU0ULsnv+n8xJWS7pIetrm2cTxzv6SSael
 YyftiSrlsaTiWsdIoAucLDbnhZ2E8G0BOphCXYASI8G9gauAmMHoSumL+6VRbbjhf7ODnbwaT
 fNw4Q92ouippDaLAmZiK2ifQecBVEqlQpg8APbdTH/AqCajwY88EzZn0GNmT0ltG8FZnz1WXB
 ifRK4xZOu3lGYZTBqweMNKaZyrYFFLfqCKMldgWgLjYhg52BI5Hc9YxgQV5MXRWh5aiRP2Ypq
 g1Y2uJJurDKrp/7MStIen5HZtYo/w9q0KBfe5Q1i+2xWs5YIc/g86H0UxAHfe7skFSa5+xAfE
 sjZhp9AINg8Mf87WpQuzEv+kcf88/w6UVms6jwqsKIS8LNvfBMweEHHDObW0Crqv/GmmAzNsW
 QuxmCk9oUl0dzM2BqixlHHAr1EN6Zxc7AlJfiEHJTgeg798RJYGHUYXd8LKfuboy/fx2zaVrR
 s4zMSKKD4abIOWUeU+59M9NTzK2bnS5EKLd9INYUmJpRX1rlpTRt3ENyGWm2ZlJ9lqDX6uY1K
 lha+D+k6aAXFMDX4oYxr1u/Oq4+uwHCVUZFB9Ba6j4eMtuu0pVcy+/n4sh7DjZKrcBJHAtiyb
 SbULWdZ8toxjZ+oUSXDJijk0JaH1w+BkN8bRJNtqurkI1ZriQaf2R62JBquX3wzwHOLPXrPhV
 i6JMShWpRtPN4PkrC5Ww==
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 16, 2019 at 5:52 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Mon, Dec 16, 2019 at 05:45:29PM +0100, Arnd Bergmann wrote:
> > On Fri, Dec 13, 2019 at 10:05 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > What is the timeline for that work now? I'm mainly interested in
> > getting the removal of 'time_t/timeval/timespec' and 'get_seconds()'
> > from the kernel done for v5.6, but it would be good to also have
> > this patch and the extended timestamps in the same version
> > just so we can claim that "all known y2038 issues" are addressed
> > in that release (I'm sure we will run into bugs we don't know yet).
>
> Personally, I think you should push this whenever it's ready.  Are you
> aiming to send all 24 patches as a treewide pull request directly to
> Linus, or would you rather the 2-3 xfs patches go through the xfs tree?

My plan is get as much of the remaining 60 patches into maintainer
trees for v5.6 and then send a pull request for whatever remains that
has not been picked up by anyone.

The 24 patches are the ones that didn't seem worth splitting into a
separate series, aside from these I also have v4l2, alsa and nfsd
pending, plus a final cleanup that removes the then-unused
interfaces.

So if you can pick up the xfs patches, that would help me.

> The y2038 format changes are going to take a while to push through
> review.  If somehow it all gets through review for 5.6 I can always
> apply both and fix the merge damage, but more likely y2038 timestamps is
> a <cough> 5.8 EXPERIMENTAL thing.
>
> Or later, given that Dave and I both have years worth of unreviewed
> patch backlog. :(

Ok, I see.

        Arnd
