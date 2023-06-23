Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE41C001B0
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Jun 2023 10:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbjFWKJQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Jun 2023 06:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjFWKIo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Jun 2023 06:08:44 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B9330F8
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jun 2023 03:07:29 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-553a1f13d9fso447424a12.1
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jun 2023 03:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687514848; x=1690106848;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eqpph6BhYxGRpPSQVY/2+QTLWY04QDtQbiANBuVNTPc=;
        b=Lqi8SYS9c2ZHNFqlmDxTakgbajLF16h+KjyRTyyVJWkCdPgE1bfq/UCbc5L2/zpnJ/
         X63Coq//UJ6s1s9kzQDY1p06R88xlU8H4C75f/nzs2Nzw/+rXEy262BgoTv9bzOYtudX
         UVkoCJrmiMjQlTaTa7hOPUeb3n8uyAguYDnTVzw7SeIBVjpg15XPvlZ8oYrO1fQsXrC+
         dpXInLqztmkcfHxIzZJtSqO3wKMWz1x5ksOtMP+8n2JQLvUz/4S81yKJV48crhWJbXoG
         9nyXnhjaXJkivjGKXKbtLwDynH8MpKgmK4Gg2hFGvVTFR9GshFVWr9VLHspQe5NQbzpW
         zitA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687514848; x=1690106848;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eqpph6BhYxGRpPSQVY/2+QTLWY04QDtQbiANBuVNTPc=;
        b=DMtY5a9eRCpUt+I+ChQiDclGNOXSgJ84bbpGlNH00dtzymAU3AbTqpccQf8Vt+EJYi
         H/uXfFDAw1cAx7EeEae6bEGqy15QJIg94ErW2mxU+JpE+CGkFE4vnBFgu2zjw0qNYWJz
         M8hQbS2DKGjLdyAG9VUymfi1h0xcv0olMhzOzgUx8jHtzCZyqsDZJz+TKxEspvQGBc0M
         F65vbwZ6S97W5MUhzg1p34C0/IIXaeYP4edT/k6dYZHqsQ/N1Ays458hPMGo+sYyGiEy
         k9fYx2aRDbwipv3Pfff15s0oqZuLzGq01yzLXHjHSkq2EnYv6JNQ20uq9OrG2FaVg+ZQ
         Gu+A==
X-Gm-Message-State: AC+VfDw7DfqG/G5ISP9ndpbr0WpeEoWxlyU1+j9u4/L2TiMc1gibrj1Q
        UekHTX0Yf+sKfkPaFzzkrrr+xw==
X-Google-Smtp-Source: ACHHUZ6QIMa5fvNGlV+qdMZJbn2aZKPFd81C/dFpHi16DJTaT9HYfJV9b0AlFjDUfIJ9zd3zdYz+hQ==
X-Received: by 2002:a17:90a:194e:b0:262:ad89:8e22 with SMTP id 14-20020a17090a194e00b00262ad898e22mr394709pjh.24.1687514847938;
        Fri, 23 Jun 2023 03:07:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-94-37.pa.vic.optusnet.com.au. [49.186.94.37])
        by smtp.gmail.com with ESMTPSA id ei16-20020a17090ae55000b0024de39e8746sm1145949pjb.11.2023.06.23.03.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 03:07:27 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qCdhM-00FCbZ-1O;
        Fri, 23 Jun 2023 20:07:24 +1000
Date:   Fri, 23 Jun 2023 20:07:24 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     Masahiko Sawada <sawada.mshk@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: Question on slow fallocate
Message-ID: <ZJVu3Kf/HTWGnA/O@dread.disaster.area>
References: <ZJTrrwirZqykiVxn@dread.disaster.area>
 <874jmy4m49.fsf@doe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874jmy4m49.fsf@doe.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 23, 2023 at 01:59:58PM +0530, Ritesh Harjani wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > On Thu, Jun 22, 2023 at 02:34:18PM +0900, Masahiko Sawada wrote:
> >> Hi all,
> >> 
> >> When testing PostgreSQL, I found a performance degradation. After some
> >> investigation, it ultimately reached the attached simple C program and
> >> turned out that the performance degradation happens on only the xfs
> >> filesystem (doesn't happen on neither ext3 nor ext4). In short, the
> >> program alternately does two things to extend a file (1) call
> >> posix_fallocate() to extend by 8192 bytes
> >
> > This is a well known anti-pattern - it always causes problems. Do
> > not do this.
> >
> >> and (2) call pwrite() to
> >> extend by 8192 bytes. If I do only either (1) or (2), the program is
> >> completed in 2 sec, but if I do (1) and (2) alternatively, it is
> >> completed in 90 sec.
> >
> > Well, yes. Using fallocate to extend the file has very different
> > constraints to using pwrite to extend the file.
> >
> >> $ gcc -o test test.c
> >> $ time ./test test.1 1
> >> total   200000
> >> fallocate       200000
> >> filewrite       0
> >
> > No data is written here, so this is just a series of 8kB allocations
> > and file size extension operations. There are no constraints here
> > because it is a pure metadata operation.
> >
> >> real    0m1.305s
> >> user    0m0.050s
> >> sys     0m1.255s
> >> 
> >> $ time ./test test.2 2
> >> total   200000
> >> fallocate       100000
> >> filewrite       100000
> >>
> >> real    1m29.222s
> >> user    0m0.139s
> >> sys     0m3.139s
> >
> > Now we have fallocate extending the file and doing unwritten extent
> > allocation, followed by writing into that unwritten extent which
> > then does unwritten extent conversion.
> >
> > This introduces data vs metadata update ordering constraints to the
> > workload.
> >
> > The problem here in that the "truncate up" operation that
> > fallocate is doing to move the file size. The "truncate up" is going
> > to move the on-disk file size to the end of the fallocated range via
> > a journal transaction, and so it will expose the range of the
> > previous write as containing valid data.
> >
> > However, the previous data write is still only in memory and not on
> > disk. The result of journalling the file size change is that if we
> > crash after the size change is made but the data is not on disk,
> > we end up with lost data - the file contains zeros (or NULLs) where
> > the in memory data previously existed.
> >
> > Go google for "NULL file data exposure" and you'll see this is a
> > problem we fixed in ~2006, caused by extending the file size on disk
> > without first having written all the in-memory data into the file.
> 
> I guess here is the <patch> you are speaking of. So this prevents from
> exposing nulls within a file in case of a crash.

Well, we're not really "exposing NULLs". No data got written before
the crash, so a read from that range after a crash will find a hole
or unwritten extents in the file and return zeros.

> I guess the behavior is not the same with ext4. ext4 does not seem to be
> doing filemap_write_and_wait_range() if the new i_disksize is more than
> oldsize. So then I think ext4 must be ok if in case of a crash the
> file has nulls in between. That's why I think the observation of slow
> performance is not seen in ext4.

ext4 also has a similar problem issue where crashes can lead to
files full of zeroes, and many of the mitigations they use were
copied from the XFS mitigations for the same problem.  However, ext4
has a completely different way of handling failures after truncate
(via an orphan list, IIRC) so it doesn't need to actually write
the data to avoid potential stale data exposure issues.

> Few queres-
> - If the user doesn't issue a flush and if the system crashes, then
>   anyways it is not expected that the file will have all the data right?

Correct.

> - Also is that "data/inode size update order" which you are mentioning in
>   this patch. Is this something that all filesystems should follow?

No, it's the specific fix for the inode size update ordering problem
that lead to user visible symptoms after a crash. We avoid the
problem in two ways now - first we always journal inode size
updates, and second we always write dependent data before we journal
said size updates.

> - I was wondering what exactly it breaks which the applications depend
>   upon? Because not all filesystems tend to follow this practice right?

The filesystems didn't break anything - applications failed to write
and/or overwrite data safely, and when they did this data got lost.

However, because the same type of failure didn't result in data loss
on ext3, then the data loss was considered by users and application
developers as a filesystem bug, rather than an inevitable result of
an application failing to ensure the user's data was actually
written to the filesystem in a crash-safe manner.

i.e. users and application developers demanded that filesystem's
provide be omnipotent and provide a higher level of data integrity
than the application/user asks them to provide.

The result is that we provided that higher level of data integrity
that users demanded, but it came at a cost....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
