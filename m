Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88573C48BD1
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 19:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 729E76128A
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 19:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhFKTEn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 15:04:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38325 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230511AbhFKTEn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Jun 2021 15:04:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623438164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o1CjsBioh2hstd42gxLCjHB3tKLx67HhhpF4TG+ofKM=;
        b=JfARhZoklAgRMRE5emzEcXpLcQuWTeIcAcVruxStm49XgrjOf/q4yHd74RdoKZR+fb7V85
        WGwI+DTgMa63B+XDd9DnT9CBDTygT+eRyAUxpKPjBDaXAv56ffg8gB88wy+IML60IIlLxu
        KUxfc7HxYN7DDR11+XGQN4B8xmAQfOY=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-X0ukhzvVNZSVqj6-SPE3XQ-1; Fri, 11 Jun 2021 15:02:43 -0400
X-MC-Unique: X0ukhzvVNZSVqj6-SPE3XQ-1
Received: by mail-oi1-f198.google.com with SMTP id f84-20020aca38570000b02901f424a672b7so3324589oia.18
        for <linux-xfs@vger.kernel.org>; Fri, 11 Jun 2021 12:02:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o1CjsBioh2hstd42gxLCjHB3tKLx67HhhpF4TG+ofKM=;
        b=NaDERZmnw2vXrEju46e8FCZcvhq74+E6eDFtYW0nvle30Gjs/sQpM+jAjL7AxB+n/x
         7j/A1+fVpYRFHhchESfl9xrjSXUc5mGxcg9WIQ9uCHvKTggV6Qc4K+2DKChxIYev8AYu
         CV9QqWfh0rZTJwsMvr1a6hB1/rWgty2XpAwH9sswi8+K2nTsn8nrTiv33hPN64r5odbq
         UCUMRMV6cXX5YGZ38X6wnxdczt6di2NvSJ7AOUgpNEDomMIXvIrBCCilu2tz+0PlDSQ3
         9hx2WqnLu8DKIDlRvtvDA/IffQsyW5/NAq6sdHo6Rzt3MSohGlaZ3wfe8ZTz8Yj8Ucgt
         LCGQ==
X-Gm-Message-State: AOAM531rcoO2VbRhwXtTfp3VgArDLEk5knPGE2n9ysPDz7vBTUaxt4K1
        IaFXQaYXsev67yyHT1qBt7QJFk43KA7dEigomIt48ihMpQAd+7mBKvJDRHnVmnrqf22ZJ2/80RH
        ey7bWUUrkf4Nd9PTbG5yBd8NzQBUw1Ir6P7PcnhkLbiPDwXiPsjhttSWT0S+4DFLfnf3JhTA=
X-Received: by 2002:a9d:6c46:: with SMTP id g6mr4022160otq.119.1623438162641;
        Fri, 11 Jun 2021 12:02:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJztJo2gM5vXT0jL7PiG5eErIHq04ak7DxKXI2VvvKv2rpi3TDgs6qtNy3v1TJcN3EveSHrfuw==
X-Received: by 2002:a9d:6c46:: with SMTP id g6mr4022142otq.119.1623438162336;
        Fri, 11 Jun 2021 12:02:42 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id h18sm1427075otm.46.2021.06.11.12.02.41
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:02:41 -0700 (PDT)
Date:   Fri, 11 Jun 2021 15:02:39 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [BUG] generic/475 recovery failure(s)
Message-ID: <YMOzT1goreWVgo8S@bfoster>
References: <YMIsWJ0Cb2ot/UjG@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMIsWJ0Cb2ot/UjG@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 10, 2021 at 11:14:32AM -0400, Brian Foster wrote:
> Hi all,
> 
> I'm seeing what looks like at least one new generic/475 failure on
> current for-next. (I've seen one related to an attr buffer that seems to
> be older and harder to reproduce.). The test devices are a couple ~15GB
> lvm devices formatted with mkfs defaults. I'm still trying to establish
> reproducibility, but so far a failure seems fairly reliable within ~30
> iterations.
> 
> The first [1] looks like log recovery failure processing an EFI. The
> second variant [2] looks like it passes log recovery, but then fails the
> mount in the COW extent cleanup stage due to a refcountbt problem. I've
> also seen one that looks like the same free space corruption error as
> [1], but triggered via the COW recovery codepath in [2], so these could
> very well be related. A snippet of the dmesg output for each failed
> mount is appended below.
> 
...

A couple updates..

First (as noted on irc), the generic/475 failure is not new as I was
able to produce it on vanilla 5.13.0-rc4. I'm not quite sure how far
back that one goes, but Dave noted he's seen it on occasion for some
time.

The generic/019 failure I'm seeing does appear to be new as I cannot
reproduce on 5.13.0-rc4. This failure looks more like silent fs
corruption. I.e., the test or log recovery doesn't explicitly fail, but
the post-test xfs_repair check detects corruption. Example xfs_repair
output is appended below (note that 'xfs_repair -n' actually crashes,
while destructive repair seems to work). Since this reproduces fairly
reliably on for-next, I bisected it (while also navigating an unmount
hang that I don't otherwise have data on) down to facd77e4e38b ("xfs:
CIL work is serialised, not pipelined"). From a quick glance at that I'm
not quite sure what the problem is there, just that it doesn't occur
prior to that particular commit.

Brian

--- 8< ---

019.full:

*** xfs_repair -n output ***
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
bad btree key (is 2222043, should be 2222328) in inode 2201
		data fork, btree block 3411717
bad nblocks 54669 for inode 2201, would reset to 54667
bad nextents 54402 for inode 2201, would reset to 54400
out-of-order bmap key (file offset) in inode 2202, data fork, fsbno 1056544
bad data fork in inode 2202
would have cleared inode 2202
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 2
        - agno = 3
entry "stress_dio_aio_activity.2.0" in shortform directory 128 references free inode 2202
        - agno = 1
would have junked entry "stress_dio_aio_activity.2.0" in directory inode 128
bad btree key (is 2222043, should be 2222328) in inode 2201
		data fork, btree block 3411717
bad nblocks 54669 for inode 2201, would reset to 54667
bad nextents 54402 for inode 2201, would reset to 54400
out-of-order bmap key (file offset) in inode 2202, data fork, fsbno 1056544
would have cleared inode 2202
xfs_repair: rmap.c:1267: fix_inode_reflink_flags: Assertion `(irec->ino_is_rl & irec->ir_free) == 0' failed.
Incorrect reference count: saw (3/3386) len 1 nlinks 29; should be (3/4370) len 1 nlinks 2
*** end xfs_repair output

