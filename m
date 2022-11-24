Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C49C43219
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Nov 2022 20:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiKXUpB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Nov 2022 15:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiKXUpA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Nov 2022 15:45:00 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036CF81FAC
        for <linux-xfs@vger.kernel.org>; Thu, 24 Nov 2022 12:45:00 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id a22-20020a17090a6d9600b0021896eb5554so5970782pjk.1
        for <linux-xfs@vger.kernel.org>; Thu, 24 Nov 2022 12:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D77u237wgxEadOqm6nQieA3HK3Q7LdUQB41qqXnSgSY=;
        b=KZ25/ZOt5eDSpF+P3y/548DDNntXvIfsrclemDEeFOr9bWUgXjsDZl9c3h13C30FfD
         7Lm6o/0MVWfbIqiqJgPA1eh0Wa9J2n8r9K5FQhCEJIi0vYFxIAQYyZaIw6nnt8h/ZZ8+
         pid/eESn16vcYlNP345jgoS9p94pCSNicPsCttNPPUNV03EnnKC5N4apSz2Ps0P678py
         kKtYAxtvxnD843CzJn5SGDiVU8zxlr1V0LVrQm9glVRzyG8T/kZgQsBvNf0WtVkj7Jmt
         iKRRqTcK5XnjWvrdw9Z7dJUyTfnppatPPSX3VmD99QIe4DBITx4Uke4B5Tjodn03Ss5V
         c7TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D77u237wgxEadOqm6nQieA3HK3Q7LdUQB41qqXnSgSY=;
        b=Y3dNbeQkGMFHFkeFDXeJCMuUaIZ9yQlChZBEudO6e/GvoGopEJ4fdzOxT1tT237dzu
         21EoqOK1Zpszt9XEl+bIzgDD735WyYVHt9XEQKHiFfVB/UxxgDfsXG46igVJ0ePKkEPH
         S/dOACH2RtuOXPPFofV8ELhlMkGs5o4elw/RO8vS6On0qXnJ26xngksxn//+qB753cUh
         A7sHA9KUEa5hRNlaw3QjTBWPfYHMiz0Q083qPchUv5jeOBBDbkpMOpNnKHKxbnzKUKKG
         +h76EEW5NSA+Z4czxfQOEjw5BzPpK9sBT694IZsbXjZ3M6bGnFyzBm/XrsMim+Z+ha/m
         xu8Q==
X-Gm-Message-State: ANoB5pkiQvO3DhOfPGE061Jk0qJKChrpTUYGVuACcgEIFmusi7YSqg1b
        l95jLIkygtIsWq4bWuwJ/KRmW5GWTmzsDg==
X-Google-Smtp-Source: AA0mqf7jACWT5WjIx7Giiqv9BkuP5xfTPl4kxMLqJ68w4DExv1qSG0AwlIvPD849Av3YqoHOKOYr/w==
X-Received: by 2002:a17:90b:8d:b0:218:c14b:4e6e with SMTP id bb13-20020a17090b008d00b00218c14b4e6emr18196132pjb.171.1669322699166;
        Thu, 24 Nov 2022 12:44:59 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id d1-20020a170903230100b0017a0668befasm1781233plh.124.2022.11.24.12.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 12:44:58 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oyJ5b-000awe-P7; Fri, 25 Nov 2022 07:44:55 +1100
Date:   Fri, 25 Nov 2022 07:44:55 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: moar weird metadata corruptions, this time on arm64
Message-ID: <20221124204455.GV3600936@dread.disaster.area>
References: <Y3wUwvcxijj0oqBl@magnolia>
 <20221122015806.GQ3600936@dread.disaster.area>
 <Y3579xWtwQEdBFw6@magnolia>
 <20221124044023.GU3600936@dread.disaster.area>
 <Y38TNTspBy9RPuBz@magnolia>
 <Y3+fdyRj6tV9/WZu@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3+fdyRj6tV9/WZu@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 24, 2022 at 08:44:39AM -0800, Darrick J. Wong wrote:
> Also, last night's run produced this:
> 
> ino 0x140bb3 func xfs_bmapi_reserve_delalloc line 4164 data fork:
>     ino 0x140bb3 nr 0x0 nr_real 0x0 offset 0xb9 blockcount 0x1f startblock 0x935de2 state 1
>     ino 0x140bb3 nr 0x1 nr_real 0x1 offset 0xe6 blockcount 0xa startblock 0xffffffffe0007 state 0
>     ino 0x140bb3 nr 0x2 nr_real 0x1 offset 0xd8 blockcount 0xe startblock 0x935e01 state 0
> ino 0x140bb3 fork 0 oldoff 0xe6 oldlen 0x4 oldprealloc 0x6 isize 0xe6000
>     ino 0x140bb3 oldgotoff 0xea oldgotstart 0xfffffffffffffffe oldgotcount 0x0 oldgotstate 0
>     ino 0x140bb3 crapgotoff 0x0 crapgotstart 0x0 crapgotcount 0x0 crapgotstate 0
>     ino 0x140bb3 freshgotoff 0xd8 freshgotstart 0x935e01 freshgotcount 0xe freshgotstate 0
>     ino 0x140bb3 nowgotoff 0xe6 nowgotstart 0xffffffffe0007 nowgotcount 0xa nowgotstate 0
>     ino 0x140bb3 oldicurpos 1 oldleafnr 2 oldleaf 0xfffffc00f0609a00
>     ino 0x140bb3 crapicurpos 2 crapleafnr 2 crapleaf 0xfffffc00f0609a00
>     ino 0x140bb3 freshicurpos 1 freshleafnr 2 freshleaf 0xfffffc00f0609a00
>     ino 0x140bb3 newicurpos 1 newleafnr 3 newleaf 0xfffffc00f0609a00
> 
> The old/fresh/nowgot have the same meaning as yesterday.  "crapgot" is
> the results of duplicating the cursor at the start of the body of
> xfs_bmapi_reserve_delalloc and performing a fresh lookup at @off.
> I think @oldgot is a HOLESTARTBLOCK extent because the first lookup
> didn't find anything, so we filled in imap with "fake hole until the
> end".  At the time of the first lookup, I suspect that there's only one
> 32-block unwritten extent in the mapping (hence oldicurpos==1) but by
> the time we get to recording crapgot, crapicurpos==2.

Ok, that's much simpler to reason about, and implies the smoke is
coming from xfs_buffered_write_iomap_begin() or
xfs_bmapi_reserve_delalloc(). I suspect the former - it does a lot
of stuff with the ILOCK_EXCL held.....

.... including calling xfs_qm_dqattach_locked().

xfs_buffered_write_iomap_begin
  ILOCK_EXCL
  look up icur
  xfs_qm_dqattach_locked
    xfs_qm_dqattach_one
      xfs_qm_dqget_inode
        dquot cache miss
        xfs_iunlock(ip, XFS_ILOCK_EXCL);
        error = xfs_qm_dqread(mp, id, type, can_alloc, &dqp);
        xfs_ilock(ip, XFS_ILOCK_EXCL);
  ....
  xfs_bmapi_reserve_delalloc(icur)

Yup, that's what is letting the magic smoke out -
xfs_qm_dqattach_locked() can cycle the ILOCK. If that happens, we
can pass a stale icur to xfs_bmapi_reserve_delalloc() and it all
goes downhill from there.

> IOWS, I think I can safely eliminate FIEXCHANGE shenanigans and
> concentrate on finding an unlocked unwritten -> written extent
> conversion.  Or possibly a written -> unwritten extent conversion?
> 
> Anyway, long holiday weekend, so I won't get back to this until Monday.
> Just wanted to persist my notes to the mailing list so I can move on to
> testing the write race fixes with djwong-dev.

And I'm on PTO for the next couple of working days, too, so I'm not
going to write a patch for it right now, either.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
