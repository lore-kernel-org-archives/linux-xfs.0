Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F779EB64DC
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jul 2023 22:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjGKWtP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jul 2023 18:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjGKWtO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jul 2023 18:49:14 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34848E75
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 15:49:13 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 99DB65C0089;
        Tue, 11 Jul 2023 18:49:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 11 Jul 2023 18:49:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-transfer-encoding:content-type:content-type:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1689115752; x=1689202152; bh=6q3mkjdlhNeUpQCi1D6Kl0vFXpupEUv1k7n
        u47Yrilg=; b=JM/5o9ntd5hfG73U6s0u+9k+qyqN9xe9dCIzb+OP7J+XOSvaN41
        8PehkyzHw+oRWA3y6udaFBN3Gq8OJHAIWSUImE9JwWOTtKcdGG10d4oE0Jrk3fxa
        gO6loMVhE95bAoErsnpOOHOaU6aoIh0csTZ5oWoKhCTe8LvhtDfsh3SMi/ECGEnN
        6tJu/YtwO4i2LPV10ynkdA3rrzUpqTYwHWdGgLyNyf9GMjkG2e/+0yCTlDM330hG
        /4MQXz4IyELZCVZFRJunYogyGNI1mxbXYmrkxQbrGSaMbUrMdqngIt6C31I/a0RJ
        mPa6dnlAevBiKObi9tvLgI+i3neN6rBYKWQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:date:feedback-id:feedback-id
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1689115752; x=1689202152; bh=6q3mkjdlhNeUpQCi1D6Kl0vFXpupEUv1k7n
        u47Yrilg=; b=bp7OeQII7hps0PQhuHjqD7wNyvbrdCNA/rbuygObsQSu13yI8SQ
        +kd1S6MJE3uifLM6uArFoWXMKGP6V/Dw3RlbYr8hDbl8nKGn49JCFN05DQfzIXxk
        BbpVCP+V6R0zZsuj2BT5G9Xb+QnwoKUUAjjfZ5xXy5ASr/3DADceUHujsyVg54oR
        G8ltvrjrxQjyzLS7XkXaGvAw679harFCXo4bYN+k16fmAfQpJUISTefju5/bgfMY
        Cg9jauVCGiElWVR8MVoZ2Q2mu5H0ozyH/IFBRJEeeBt+LLYPdSjjUc9dnBasJ7m1
        HqHaqybhgHTVvFCkUKFRa6Q4fvAxTI5rMUw==
X-ME-Sender: <xms:aNytZP_w2H_mdRH8LPRH4p1Jy9OYUIiQcqP2uk6XT_-wfNsI50uWbQ>
    <xme:aNytZLvS7ez4gJS4RX8uvc1J5ABhe27ZvMkPvSVB99s6EL3zipirvtEcGWX1M3TgT
    yd38vFJJlR2ExLjrA>
X-ME-Received: <xmr:aNytZNATW_I_fZSUOL2uCFhEO-bNBozbQfJqbFcj1vQc8SrHWF2WhWC2e_OtWh0QzI9BwUVDjDn9WKaebGCXnzPaut1veOr9gHVnDR5pvNeCderDinPgokrsLRJC>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrfedugddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtugfgjgesthekredttddtjeenucfhrhhomheptehnughr
    vghsucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrf
    grthhtvghrnhephfeitefgleevtedtffejvedujeekjedugfdtveffjeelvddtfeekgefg
    jefhgfegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:aNytZLe7N-3X-sMcsd4mzqLedAtxmFDzFZov7VCMFDhD_65U03lLcA>
    <xmx:aNytZEMbWQ6EXhE5gzqRxylGY8829hHY-US1KcVQidBHoNnaid9QbQ>
    <xmx:aNytZNlpGed2SaBalmSIMnTgSAtryv4nyTe30ok7yTnPuW60HGlXlw>
    <xmx:aNytZNYt5XvFhQHYSSKJPIZW07QqG6hek66PTmHCRrekI2z5_F8I9w>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Jul 2023 18:49:12 -0400 (EDT)
Date:   Tue, 11 Jul 2023 15:49:11 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Masahiko Sawada <sawada.mshk@gmail.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: Question on slow fallocate
Message-ID: <20230711224911.yd3ns6qcrlepbptq@awork3.anarazel.de>
References: <CAD21AoCWW20ga6GKR+7RwRtvPU0VyFt3_acut_y+Fg7E-4nzWw@mail.gmail.com>
 <ZJTrrwirZqykiVxn@dread.disaster.area>
 <CAD21AoC9=8Q2o3-+ueuP05+8298z--5vgBWtvSxMHHF2jdyr_w@mail.gmail.com>
 <3f604849-877b-f519-8cae-4694c82ac7e4@sandeen.net>
 <CAD21AoBHd35HhFpbh9YBHPsLN+F_TZX5b47iy+-s44jPT+fyZQ@mail.gmail.com>
 <82b74cbc-8a1d-6b6f-fa2f-5f120d958dad@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <82b74cbc-8a1d-6b6f-fa2f-5f120d958dad@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

On 2023-06-27 11:12:01 -0500, Eric Sandeen wrote:
> On 6/27/23 10:50 AM, Masahiko Sawada wrote:
> > On Tue, Jun 27, 2023 at 12:32 AM Eric Sandeen <sandeen@sandeen.net> wrote:
> > > 
> > > On 6/25/23 10:17 PM, Masahiko Sawada wrote:
> > > > FYI, to share the background of what PostgreSQL does, when
> > > > bulk-insertions into one table are running concurrently, one process
> > > > extends the underlying files depending on how many concurrent
> > > > processes are waiting to extend. The more processes wait, the more 8kB
> > > > blocks are appended. As the current implementation, if the process
> > > > needs to extend the table by more than 8 blocks (i.e. 64kB) it uses
> > > > posix_fallocate(), otherwise it uses pwrites() (see the code[1] for
> > > > details). We don't use fallocate() for small extensions as it's slow
> > > > on some filesystems. Therefore, if a bulk-insertion process tries to
> > > > extend the table by say 5~10 blocks many times, it could use
> > > > poxis_fallocate() and pwrite() alternatively, which led to the slow
> > > > performance as I reported.
> > > 
> > > To what end? What problem is PostgreSQL trying to solve with this
> > > scheme? I might be missing something but it seems like you've described
> > > the "what" in detail, but no "why."
> > 
> > It's for better scalability. SInce the process who wants to extend the
> > table needs to hold an exclusive lock on the table, we need to
> > minimize the work while holding the lock.
> 
> Ok, but what is the reason for zeroing out the blocks prior to them being
> written with real data? I'm wondering what the core requirement here is for
> the zeroing, either via fallocate (which btw posix_fallocate does not
> guarantee) or pwrites of zeros.

The goal is to avoid ENOSPC at a later time. We do this before filling our own
in-memory buffer pool with pages containing new contents. If we have dirty
pages in our buffer that we can't write out due to ENOSPC, we're in trouble,
because we can't checkpoint. Which typically will make the ENOSPC situation
worse, because we also can't remove WAL / journal files without the checkpoint
having succeeded.  Of course a successful fallocate() / pwrite() doesn't
guarantee that much on a COW filesystem, but there's not much we can do about
that, to my knowledge.

Using fallocate() for small extensions is problematic because it a) causes
fragmentation b) disables delayed allocation, using pwrite() is also bad
because the kernel will have to write out those dirty pages full of zeroes -
very often we won't write out the page with "real content" before the kernel
decides to do so.


Hence using a heuristic to choose between the two. I think all that's needed
here is a bit of tuning of the heuristic, possibly adding some "history"
awareness.


If we could opt into delayed allocation while avoiding ENOSPC for a certain
length, it'd be perfect, but I don't think that's possible today?


We're also working on using DIO FWIW, where using fallocate() is just about
mandatory...


Greetings,

Andres Freund
