Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA723C0015E
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Aug 2023 01:57:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjHDB5y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Aug 2023 21:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjHDB5y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2023 21:57:54 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDD7B9
        for <linux-xfs@vger.kernel.org>; Thu,  3 Aug 2023 18:57:52 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-56433b1b0e0so1104196a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 03 Aug 2023 18:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1691114271; x=1691719071;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sq31AbHZAJOaAaB/RK/I9P4a5b6nKqiXAZqsQ7DWAYM=;
        b=LZUAK0z5RTxy9Rx3e/lp++bj7MzsJY94UTb/X33Ctmx4MdyxhuCLkRBBkgykToA3Tf
         xsQyw5PSbruocgzA71Zib9k++fpoQgRmD5cqPx0b9XQm9gB0aumZwVmV1ZG9wGpvvD+V
         23wffKyrte3LYl8PPTZEiMkPCCSez7wduurBtzQyyAx0xI33IdiwFy6oTftxKSBNuBVs
         6P/IpdfuPCHW1Tz0uaHVz2TmgskUAVHGMN4qNcVhK13lLzmRw7bg+s1BXDz/JZUZ2W6B
         0rRxiLacpWNFrnF8BTRfojf6bGXU/gnhgW9YeKSQ105mnTDQSYcxeoz0JBstwQJrIPaT
         kAMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691114271; x=1691719071;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sq31AbHZAJOaAaB/RK/I9P4a5b6nKqiXAZqsQ7DWAYM=;
        b=CWorBT+jSgO9dMqK0L5dgWg17GbeNucPlH9ruGZf2ZsLW0IFCtdeAkO2xGkUbGtqqD
         UqRybKbK17BmiElnqH2QTuuyMsDH15UEG93np1EbojgitdpwDI09yBH1D++y1ixPTklx
         ERjXO5lDjGfS+OejHCyztVWYByQnEo3TjXRpDoSmm4XvYls73zE9R4ZRjgOaH4YmlG5v
         hwQfN7d1Sm01O/JY5fcHaqMjFN+TqM5raEFthotpwGqqswXek7+YefcNTRcAwyD2kjqF
         cUeQeiKVydIN7cyIIsdaVnJEpHWmrREg4Q+ww7V9qe6lyce7CVWzo3U+LJst7mssDeuJ
         kZug==
X-Gm-Message-State: AOJu0Yxtg2+BSeD13twICKQpdceWpVaKbzrDaOilpeo5KV6gb0bvR31m
        EictZho5HzhwRb/FFqIfv+X+IA==
X-Google-Smtp-Source: AGHT+IEwaCiECPDj7tkK0mOsFAN9XU91dok27cx0Oj6G//fcAMfSFPzTQP5b4gtX3esvKcS0ZwgGbA==
X-Received: by 2002:a17:90b:18d:b0:268:1217:46bc with SMTP id t13-20020a17090b018d00b00268121746bcmr466389pjs.11.1691114271668;
        Thu, 03 Aug 2023 18:57:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-166-213.pa.nsw.optusnet.com.au. [49.180.166.213])
        by smtp.gmail.com with ESMTPSA id o15-20020a170902d4cf00b001bbab888ba0sm488289plg.138.2023.08.03.18.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 18:57:50 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qRk4Z-000mM3-2e;
        Fri, 04 Aug 2023 11:57:47 +1000
Date:   Fri, 4 Aug 2023 11:57:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: stabilize fs summary counters for online fsck
Message-ID: <ZMxbG2y0k9QZNtKX@dread.disaster.area>
References: <20230803233028.GG11352@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230803233028.GG11352@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 03, 2023 at 04:30:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If the fscounters scrubber notices incorrect summary counters, it's
> entirely possible that scrub is simply racing with other threads that
> are updating the incore counters.  There isn't a good way to stabilize
> percpu counters or set ourselves up to observe live updates with hooks
> like we do for the quotacheck or nlinks scanners, so we instead choose
> to freeze the filesystem long enough to walk the incore per-AG
> structures.
> 
> Past me thought that it was going to be commonplace to have to freeze
> the filesystem to perform some kind of repair and set up a whole
> separate infrastructure to freeze the filesystem in such a way that
> userspace could not unfreeze while we were running.  This involved
> adding a mutex and freeze_super/thaw_super functions and dealing with
> the fact that the VFS freeze/thaw functions can free the VFS superblock
> references on return.
> 
> This was all very overwrought, since fscounters turned out to be the
> only user of scrub freezes, and it doesn't require the log to quiesce,
> only the incore superblock counters.  We prevent other threads from
> changing the freeze level by calling freeze_super_excl with a custom
> freeze cookie to keep everyone else out of the filesystem.
> 
> The end result is that fscounters should be much more efficient.  When
> we're checking a busy system and we can't stabilize the counters, the
> custom freeze will do less work, which should result in less downtime.
> Repair should be similarly speedy, but that's in the next patch.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: remove fscounters.h
> ---
>  fs/xfs/scrub/fscounters.c |  188 ++++++++++++++++++++++++++++++++++++---------
>  fs/xfs/scrub/scrub.c      |    6 +
>  fs/xfs/scrub/scrub.h      |    1 
>  fs/xfs/scrub/trace.h      |   26 ++++++
>  4 files changed, 183 insertions(+), 38 deletions(-)

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
