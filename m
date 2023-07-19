Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B407BEB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 07:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjGSHZn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jul 2023 03:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjGSHZn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2023 03:25:43 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B09A4
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 00:25:41 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-5633fd47763so1008946a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 00:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1689751541; x=1692343541;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xUmrlJ2xV7xQV7xBkOmBLfaixDb/GWoWwthK9DGy8A8=;
        b=FG/k2sWtEXxivuF1iiBKP3vqf+Jk6cbzS//2lxpwA7xXrj8s56VCq7a7qmDoviJ3cD
         ctXlEGvfZfz0mNg2CnjK1EEqfxgabwKfBOMzi08prgbO6xy1VFFShzxoAvpOtghcLwLy
         Mz9lzPWgWApqMRNfRMd6SMScqwdEHUvrTI63wLyuLb88WTFHmhtHpo4gy7yG5KOe4aZ4
         ygK45kYHD7z78gAHftpWmMx6hI21HO3lngxYH01tP4Ra0VxPF69KpwKR8OQld7AF2l2Q
         nYutoU6RsElEKa97FQpqhTLI/cM/dCtr3vPl9CHljg1L7w4XW1ndgHI7QtpV6kq5e1SE
         2f4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689751541; x=1692343541;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xUmrlJ2xV7xQV7xBkOmBLfaixDb/GWoWwthK9DGy8A8=;
        b=C3sRvcBNBkOd57apkKjAuOWj2rv7DfKUHMs0RbUtgWWUqb3k92fOpNR6Su2h8g0Kcd
         LKqSlhqrtIJqk9QEZuK1dO7BcA3bLdwzdXaTUe8LXjE5ulrHdEHWj3XI4XdEoB0nvZLj
         6uG1WepC7dRmaZhG+iMGxU26QcCW3KtVfBEchEqUoYuiAwJU5/GURbA9LJ8G0+Ql0F82
         I5DPZNzMaG6kPT+kgW/TCjS9bS155WNiChHfLp2G4Vk5FanftQllQ8V0AI68XgyKkyTS
         dNay9Y5c5KeYKRUxHG2Hn7UsQbyePCt5IEo/f4DVpehCGut9Tvc+EA2UyflkyVGYOExf
         pxeA==
X-Gm-Message-State: ABy/qLapBYkGwBw7obJilH5qJkwyPWECfJjSW7y+bfkLZGMWdj89cpD1
        gcWGMwm2X4j+Dtloo4bb/UigLA==
X-Google-Smtp-Source: APBJJlFZoqaBWcJYxbevfAkTcsCoeRjQsxKmKR90eFD/ZHmQYnYHM9ZkCqBuhm8rdD5PIPlF2htGiA==
X-Received: by 2002:a05:6a21:3294:b0:134:fd58:ce36 with SMTP id yt20-20020a056a21329400b00134fd58ce36mr9136883pzb.7.1689751540950;
        Wed, 19 Jul 2023 00:25:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id i15-20020aa78d8f000000b0063d2dae6247sm2602242pfr.77.2023.07.19.00.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 00:25:40 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qM1Z3-007saO-2T;
        Wed, 19 Jul 2023 17:25:37 +1000
Date:   Wed, 19 Jul 2023 17:25:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Andres Freund <andres@anarazel.de>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Masahiko Sawada <sawada.mshk@gmail.com>,
        linux-xfs@vger.kernel.org
Subject: Re: Question on slow fallocate
Message-ID: <ZLeP8VwYuXGKYC/Z@dread.disaster.area>
References: <CAD21AoCWW20ga6GKR+7RwRtvPU0VyFt3_acut_y+Fg7E-4nzWw@mail.gmail.com>
 <ZJTrrwirZqykiVxn@dread.disaster.area>
 <CAD21AoC9=8Q2o3-+ueuP05+8298z--5vgBWtvSxMHHF2jdyr_w@mail.gmail.com>
 <3f604849-877b-f519-8cae-4694c82ac7e4@sandeen.net>
 <CAD21AoBHd35HhFpbh9YBHPsLN+F_TZX5b47iy+-s44jPT+fyZQ@mail.gmail.com>
 <82b74cbc-8a1d-6b6f-fa2f-5f120d958dad@sandeen.net>
 <20230711224911.yd3ns6qcrlepbptq@awork3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230711224911.yd3ns6qcrlepbptq@awork3.anarazel.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 11, 2023 at 03:49:11PM -0700, Andres Freund wrote:
> Hi,
> 
> On 2023-06-27 11:12:01 -0500, Eric Sandeen wrote:
> > On 6/27/23 10:50 AM, Masahiko Sawada wrote:
> > > On Tue, Jun 27, 2023 at 12:32 AM Eric Sandeen <sandeen@sandeen.net> wrote:
> > > > 
> > > > On 6/25/23 10:17 PM, Masahiko Sawada wrote:
> > > > > FYI, to share the background of what PostgreSQL does, when
> > > > > bulk-insertions into one table are running concurrently, one process
> > > > > extends the underlying files depending on how many concurrent
> > > > > processes are waiting to extend. The more processes wait, the more 8kB
> > > > > blocks are appended. As the current implementation, if the process
> > > > > needs to extend the table by more than 8 blocks (i.e. 64kB) it uses
> > > > > posix_fallocate(), otherwise it uses pwrites() (see the code[1] for
> > > > > details). We don't use fallocate() for small extensions as it's slow
> > > > > on some filesystems. Therefore, if a bulk-insertion process tries to
> > > > > extend the table by say 5~10 blocks many times, it could use
> > > > > poxis_fallocate() and pwrite() alternatively, which led to the slow
> > > > > performance as I reported.
> > > > 
> > > > To what end? What problem is PostgreSQL trying to solve with this
> > > > scheme? I might be missing something but it seems like you've described
> > > > the "what" in detail, but no "why."
> > > 
> > > It's for better scalability. SInce the process who wants to extend the
> > > table needs to hold an exclusive lock on the table, we need to
> > > minimize the work while holding the lock.
> > 
> > Ok, but what is the reason for zeroing out the blocks prior to them being
> > written with real data? I'm wondering what the core requirement here is for
> > the zeroing, either via fallocate (which btw posix_fallocate does not
> > guarantee) or pwrites of zeros.
> 
> The goal is to avoid ENOSPC at a later time. We do this before filling our own
> in-memory buffer pool with pages containing new contents. If we have dirty
> pages in our buffer that we can't write out due to ENOSPC, we're in trouble,
> because we can't checkpoint. Which typically will make the ENOSPC situation
> worse, because we also can't remove WAL / journal files without the checkpoint
> having succeeded.  Of course a successful fallocate() / pwrite() doesn't
> guarantee that much on a COW filesystem, but there's not much we can do about
> that, to my knowledge.

Yup, which means you're screwed on XFS, ZFS and btrfs right now, and
also bcachefs when people start using it.

> Using fallocate() for small extensions is problematic because it a) causes
> fragmentation b) disables delayed allocation, using pwrite() is also bad
> because the kernel will have to write out those dirty pages full of zeroes -
> very often we won't write out the page with "real content" before the kernel
> decides to do so.

Yes, that why we allow fallocate() to preallocate space that extends
beyond the current EOF. i.e. for optimising layouts on append-based
workloads. posix_fallocate() does not allow that - it forces file
size extension, whilst a raw fallocate(FALLOC_FL_KEEP_SIZE) call
will allow preallocation anywhere beyond EOF without changing the
file size. IOws, with FALLOC_FL_KEEP_SIZE you don't have to
initialise buffer space in memory to cover the preallocated space
until you actually need to extend the file and write to it.

i.e. use fallocate(FALLOC_FL_KEEP_SIZE) to preallocate
chunks megabytes beyond the current EOF and then grow into them with
normal extending pwrite() calls. When that preallocate space is
done, preallocate another large chunk beyond EOF and continue
onwards extending the file with your small write()s...

> Hence using a heuristic to choose between the two. I think all that's needed
> here is a bit of tuning of the heuristic, possibly adding some "history"
> awareness.

No heuristics needed: just use FALLOC_FL_KEEP_SIZE and preallocate
large chunks beyond EOF each time. It works for both cases equally
well, which results in less code and is easier to understand.

AFAIC, nobody should ever use posix_fallocate() - it's impossible to
know what it is doing under the covers, or even know when it fails
to provide you with any guarantee at all (e.g. COW files).

> If we could opt into delayed allocation while avoiding ENOSPC for a certain
> length, it'd be perfect, but I don't think that's possible today?

Nope. Not desirable, either, because we currently need to have dirty
data in the page cache over delalloc regions.

> We're also working on using DIO FWIW, where using fallocate() is just about
> mandatory...

No, no it isn't. fallocate() is even more important to avoid with
DIO than buffered IO because fallocate() completely serialises *all*
IO to the file. That's the last thing you want with DIO given the
only reason for using DIO is to maximising IO concurrency and
minimise IO latency to individual files.

If you want to minimise fragmentation with DIO workloads, then you
should be using extent size hints of an appropriate size. That will
align and size extents to the hint regardless of fallocate/write
ranges, hence this controls worst case fragmentation effectively.

If you want enospc guarantees for future writes, then large,
infrequent fallocate(FALLOC_FL_KEEP_SIZE) calls should be used. Do
not use this mechanism as an anti-fragmentation mechanism, that's
what extent size hints are for.

Use fallocate() as *little as possible*.

In my experience, fine grained management of file space by userspace
applications via fallocate() is nothing but a recipe for awful
performance, highly variable IO latency, bad file fragmentation, and
poor filesystem aging characteristics. Just don't do it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
