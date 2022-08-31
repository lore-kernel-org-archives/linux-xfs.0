Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 213BDECAAD4
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Aug 2022 00:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiHaASj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 20:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiHaASe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 20:18:34 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360A09DB66;
        Tue, 30 Aug 2022 17:18:31 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id v4so12095570pgi.10;
        Tue, 30 Aug 2022 17:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=xH0M4e5esAqM96Nf2Fl2I1Tb8x4y2NZChmoD48mDk/E=;
        b=JbBU0u/2yskA2qh5lu9jRik+XHMhYPIDYY65Pny/EofY+Oi3Q9Lm2wwtWXCn3rMP9S
         F4XmBabno2YHSmclQxN4VUVXExD4+SIuWT4ey1mhli6l50ZbdYlKKIj6NsYu2DqNd09t
         S+zx2aYS+WEHvO8t/knjT/O+gfnQJXilTfaK4TH61TtGWs2RSuKB2wYQTMWGN9MagqAV
         hdspsS0ZwARSSTNYTbso7B8xhgPzeKipPu7NhEN63Gclx9tHAfPRf47o9i19p2kk9hRN
         FfU5iZ5HgqcRKrUxjRVyhulGjk+lOO80pedj+D/dzR7ji8Iji+/s18VzFpedZEfTPLs4
         xJMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=xH0M4e5esAqM96Nf2Fl2I1Tb8x4y2NZChmoD48mDk/E=;
        b=Fa+b6SOnO9ewx80bi4iB3BsbR5UnnVzA+4upH1ZVS5Pwj9kCsnMDsZyBezCIBsiCHt
         /ImDF8v7IKFrKjZCSf+m8WqyoNkTfCeGdTMz9lhD9qCAzF76VyDdTQpmL3PK8OWKtH1k
         GCXCwSogPG3NPo3kcK5p61tDXpI4h+e1GU/3v5QKUIepC66ZBkWThIY1i0yCYM7Ve1SY
         VpFpGnUh5ndc6MxoxcZX88PnnfFF92syXseXSOaNZE63npoYqW2k4xsASdinXBR+mXt9
         bZf9oL7qhlFRnWAt8bY/8wYWe57fCf01lYQWHe/Ejgt+1TvyHs+cRRqUdsXWOi9YFPag
         QL+Q==
X-Gm-Message-State: ACgBeo06MRjcqxRQiEcoj8QocZ6198l+e9P+6RryYEfZDnZyVFgh6jrn
        WMhOSkYimjvD2YoMidqI4rqTa25AKn6Lb31drhQ=
X-Google-Smtp-Source: AA6agR4rubVNgj1JqK5JCzl2eJ7WlOwSsp92tDt+048P8vka/r9o//ORfL9nctaQ/jeEYicMCv9tVLzPCuylwTlP208=
X-Received: by 2002:a63:4e25:0:b0:41c:62a2:ecc3 with SMTP id
 c37-20020a634e25000000b0041c62a2ecc3mr20162396pgb.596.1661905109991; Tue, 30
 Aug 2022 17:18:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220830044433.1719246-1-jencce.kernel@gmail.com>
 <20220830044433.1719246-2-jencce.kernel@gmail.com> <20220830073634.7qklqvl2la53kbv4@zlang-mailbox>
 <Yw4i0Pxz80ez7m0X@magnolia> <20220830190748.nnylphtuugxxmoy3@zlang-mailbox>
In-Reply-To: <20220830190748.nnylphtuugxxmoy3@zlang-mailbox>
From:   Murphy Zhou <jencce.kernel@gmail.com>
Date:   Wed, 31 Aug 2022 08:18:18 +0800
Message-ID: <CADJHv_tFtH_fihVFGLUB=GyjGJ+Neo-pj8S5DGJDFOHrW12EOA@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] tests: increase fs size for mkfs
To:     Zorro Lang <zlang@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 31, 2022 at 3:07 AM Zorro Lang <zlang@redhat.com> wrote:
>
> On Tue, Aug 30, 2022 at 07:46:40AM -0700, Darrick J. Wong wrote:
> > On Tue, Aug 30, 2022 at 03:36:34PM +0800, Zorro Lang wrote:
> > > On Tue, Aug 30, 2022 at 12:44:30PM +0800, Murphy Zhou wrote:
> > > > Since this xfsprogs commit:
> > > >   6e0ed3d19c54 mkfs: stop allowing tiny filesystems
> > > > XFS requires filesystem size bigger then 300m.
> > >
> > > I'm wondering if we can just use 300M, or 512M is better. CC linux-xfs to
> > > get more discussion about how to deal with this change on mkfs.xfs.
> > >
> > > >
> > > > Increase thoese numbers to 512M at least. There is no special
> > > > reason for the magic number 512, just double it from original
> > > > 256M and being reasonable small.
> > >
> > > Hmm... do we need a global parameter to define the minimal XFS size,
> > > or even minimal local fs size? e.g. MIN_XFS_SIZE, or MIN_FS_SIZE ...
> >
> > I think it would be a convenient time to create a helper to capture
> > that, seeing as the LTP developers recently let slip that they have such
> > a thing somewhere, and min fs size logic is scattered around fstests.
>
> It's a little hard to find out all cases which use the minimal fs size.
> But for xfs, I think we can do that with this chance. We can have:
>
>   export XFS_MIN_SIZE=$((300 * 1024 * 1024))
>   export XFS_MIN_LOG_SIZE=$((64 * 1024 * 1024))
>
> at first, then init minimal $FSTYP size likes:
>
>   init_min_fs_size()
>   {
>       case $FSTYP in
>       xfs)
>           FS_MIN_SIZE=$XFS_MIN_SIZE
>           ;;
>       *)
>           FS_MIN_SIZE="unlimited"  # or a big enough size??
>           ;;
>       esac
>   }
>
> Then other fs can follow this to add their size limitation.
> Any better ideas?

In generic/042 f2fs has a similar kind of limitation.

Let me check how LTP guys handle this.

Thanks,
Murphy

>
> Thanks,
> Zorro
>
> >
>
snipped
>
