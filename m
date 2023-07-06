Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD25EB64D9
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jul 2023 21:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjGFVjN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Jul 2023 17:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjGFVjM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jul 2023 17:39:12 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D6F1995
        for <linux-xfs@vger.kernel.org>; Thu,  6 Jul 2023 14:39:11 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1b8c81e36c0so4977065ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 06 Jul 2023 14:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20221208.gappssmtp.com; s=20221208; t=1688679550; x=1691271550;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9C+UJ3oYi5wd5eBkEumXKDOiH3rRFHjq4Q8ee2u43/I=;
        b=R7RmdFbf49yQa8/mt5YrlYmQL13W/h7wopstY4keYzuLK6V2kcbHyjFZ0BR7OXsVKL
         wnWCj0aBfSIQ4aWAJqvB/VIBDdJ4wKbWkPRsYGH+w5S5bYmjEAE6BwLQIl3+YJIY08nr
         F8Grs5nYg0h2FySvMohzERqffV1ZOgvkPTe/EFevGy7c5SdbYkaDWxMJvGLwV5fgl5b0
         deFfhsBVnaPG2/cydOSIDz2NFqljZ9RhUF+7tIDb1hZKD1MOSn1b2eiM8ovqofgWIKcc
         uhMydnFC+5oO68ZPLIwTwlONJXIIp6EaLINY5oXAqQGzSHY521u1rPG9zNzdBeHqGl/1
         fhgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688679550; x=1691271550;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9C+UJ3oYi5wd5eBkEumXKDOiH3rRFHjq4Q8ee2u43/I=;
        b=Wl8BJvHG6BdQUNVjjKwQCG0ZNnVZhrP6ypvxEqExaL9c9F3juEb5qdKYyESIkqkUx6
         nBFgR92kh/RGApli2qusTVNpb5VejTBRqP9JgXitnwAMwlwCUzcEzqvTHg1ZWZNOgBR6
         S8t2suOomouNoDKooXX5dD7evUTgsfjtxh4JGzC3J/y5O0ZNE5q0R7mtTrI8IBUQJH+0
         GKMoAnq/OHLlLn8jJ//2IamMvgVnh80R7C12HntKgLpfNvF3qKSHpXvhY9nONO2QpDpr
         nSDwzfPtIab8DlkTknDpII89dVEdGq3Nk1bdJQZChBzQRyIc3wtIriieEiyFxGIdDb4n
         9gpw==
X-Gm-Message-State: ABy/qLaFV6mmxhjWUzcdRl7c4WkdbWBnwRuCHLmcQ0Mxo3kyqA97vR2n
        ypYbqAlFU384Y7pYjH6tD4XNV6h4zsAOujBslBs=
X-Google-Smtp-Source: APBJJlFSkfq6xOCRUrjNYW9V/15Y9ckh8IGxGNv0XhE6AN1YGzXEsNPoKg4cLngC8kzQ4q+h1fhb3A==
X-Received: by 2002:a17:902:e74f:b0:1b8:c823:a43b with SMTP id p15-20020a170902e74f00b001b8c823a43bmr1901693plf.4.1688679550179;
        Thu, 06 Jul 2023 14:39:10 -0700 (PDT)
Received: from telecaster ([2620:10d:c090:500::5:ff1c])
        by smtp.gmail.com with ESMTPSA id ix12-20020a170902f80c00b001b8a00d4f7asm1865328plb.9.2023.07.06.14.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 14:39:09 -0700 (PDT)
Date:   Thu, 6 Jul 2023 14:39:08 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: Re: [PATCH 0/6] xfs: CPU usage optimizations for realtime allocator
Message-ID: <ZKc0fCe9AtkRtDLB@telecaster>
References: <cover.1687296675.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1687296675.git.osandov@osandov.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 20, 2023 at 02:32:10PM -0700, Omar Sandoval wrote:
> Hello,
> 
> Our distributed storage system uses XFS's realtime device support as a
> way to split an XFS filesystem between an SSD and an HDD -- we configure
> the HDD as the realtime device so that metadata goes on the SSD and data
> goes on the HDD.
> 
> We've been running this in production for a few years now, so we have
> some fairly fragmented filesystems. This has exposed various CPU
> inefficiencies in the realtime allocator. These became even worse when
> we experimented with using XFS_XFLAG_EXTSIZE to force files to be
> allocated contiguously.
> 
> This series adds several optimizations that don't change the realtime
> allocator's decisions, but make them happen more efficiently, mainly by
> avoiding redundant work. We've tested these in production and measured
> ~10% lower CPU utilization. Furthermore, it made it possible to use
> XFS_XFLAG_EXTSIZE to force contiguous allocations -- without these
> patches, our most fragmented systems would become unresponsive due to
> high CPU usage in the realtime allocator, but with them, CPU utilization
> is actually ~4-6% lower than before, and disk I/O utilization is 15-20%
> lower.
> 
> Patches 2 and 3 are preparations for later optimizations; the remaining
> patches are the optimizations themselves.
> 
> This is based on Linus' tree as of today (commit
> 692b7dc87ca6d55ab254f8259e6f970171dc9d01).
> 
> Thanks!
> 
> Omar Sandoval (6):
>   xfs: cache last bitmap block in realtime allocator
>   xfs: invert the realtime summary cache
>   xfs: return maximum free size from xfs_rtany_summary()
>   xfs: limit maxlen based on available space in
>     xfs_rtallocate_extent_near()
>   xfs: don't try redundant allocations in xfs_rtallocate_extent_near()
>   xfs: don't look for end of extent further than necessary in
>     xfs_rtallocate_extent_near()
> 
>  fs/xfs/libxfs/xfs_rtbitmap.c | 173 ++++++++++++++--------------
>  fs/xfs/xfs_mount.h           |   6 +-
>  fs/xfs/xfs_rtalloc.c         | 215 ++++++++++++++++-------------------
>  fs/xfs/xfs_rtalloc.h         |  28 +++--
>  4 files changed, 207 insertions(+), 215 deletions(-)

Gentle ping.
