Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BF7E92704
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Oct 2023 14:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbjJEOJD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231990AbjJEOGx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 10:06:53 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8B01A4
        for <linux-xfs@vger.kernel.org>; Wed,  4 Oct 2023 20:00:24 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1bf55a81eeaso3697445ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 04 Oct 2023 20:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696474824; x=1697079624; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uWrvFPQaX1n1TWDkUcftSAygg7bG+8974v7JVxyDd/M=;
        b=bMNi7Ctw//q2+BSsuUnZ/O3J97CU6JMmO/Bldo//NYxOwXIvkCPfFnSISBXrIBNyym
         QGof5PVgHelKJ/tRWZnjoM689GGxBjfegQ7MWRDNFhKGi+/tXfsbM0knmNs6b6IztS0Y
         4/4D05/FWIk2HlkiJ7idbxuM7Z4byo/Qfc7vGQZjiZJ1jrdUKEw1UuVx4QAha6e1Vo62
         gCLP1msvDqt/11mJIhap+AsAYPZQXpmvP0OGbxZ9cC4csYrswW+fMVNv8Za+KTdB/glL
         wAv9pzwMG/To8/HCGD4E6FHm2C9JBL7/49p2zeKIgfkb2lJtg6xYPVr47vwW2hH2nKMs
         x5IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696474824; x=1697079624;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uWrvFPQaX1n1TWDkUcftSAygg7bG+8974v7JVxyDd/M=;
        b=Y5/1aLUIbIz3VLq2zwOen8cfQI4WXe9hW0M9DmyPgGi1YjHldA2i1jU9r4HgP3kuPq
         3bUyBrEIlwwBz0p18C99ZoegSguzQmSSQcxIvbrHBtJJ4IojUVaBu2amzk/pI6iMw9Id
         S6FEU7wdsPNf917zzr3zqjbDKLfnOdN55fjmiEX2exIVDmZS5t78bPIiMRZ6EJ64p3ex
         77gpQly9/G2XO4gp20Q7KO77SeDspnRpACVPmsOfl4tzkUfUpqgFLZFJ31VHm4gFrMs/
         TPOKMIPjQjiQvLsLk3q5K8FnYj8p1zsNA4YlbNGDGMNO5lXgv9QNgIvuqSiekUvWeYau
         8nyw==
X-Gm-Message-State: AOJu0YyX4Y5EViW510s5uDV4i+r5EMkXyQxMbI0GtszxB8Am/6yiTrAP
        KsA57/iuJBSqr7y2VbeCBMtS3N8QVOqKmsW28UA=
X-Google-Smtp-Source: AGHT+IEv2ys0w9fb3nZMQ+S8eUFPlgnW/lpCEg0AKY733gIX8DdeeTLmHpLo6n5DLIwi2rV1roIIJA==
X-Received: by 2002:a17:902:f7d3:b0:1c4:32da:2037 with SMTP id h19-20020a170902f7d300b001c432da2037mr3566560plw.64.1696474824017;
        Wed, 04 Oct 2023 20:00:24 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id b10-20020a170903228a00b001b03a1a3151sm324662plh.70.2023.10.04.20.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Oct 2023 20:00:23 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qoEb6-009bk9-2g;
        Thu, 05 Oct 2023 14:00:20 +1100
Date:   Thu, 5 Oct 2023 14:00:20 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: allow pausing of pending deferred work items
Message-ID: <ZR4mxG5x2rOWGnMU@dread.disaster.area>
References: <169577059140.3312911.17578000557997208473.stgit@frogsfrogsfrogs>
 <169577059178.3312911.7770487562460001097.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169577059178.3312911.7770487562460001097.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 26, 2023 at 04:31:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Traditionally, all pending deferred work attached to a transaction is
> finished when one of the xfs_defer_finish* functions is called.
> However, online repair wants to be able to allocate space for a new data
> structure, format a new metadata structure into the allocated space, and
> commit that into the filesystem.
> 
> As a hedge against system crashes during repairs, we also want to log
> some EFI items for the allocated space speculatively, and cancel them if
> we elect to commit the new data structure.
> 
> Therefore, introduce the idea of pausing a pending deferred work item.
> Log intent items are still created for paused items and relogged as
> necessary.  However, paused items are pushed onto a side list before we
> start calling ->finish_item, and the whole list is reattach to the
> transaction afterwards.  New work items are never attached to paused
> pending items.
> 
> Modify xfs_defer_cancel to clean up pending deferred work items holding
> a log intent item but not a log intent done item, since that is now
> possible.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_defer.c |   98 +++++++++++++++++++++++++++++++++++++++------
>  fs/xfs/libxfs/xfs_defer.h |   17 +++++++-
>  fs/xfs/xfs_trace.h        |   13 +++++-
>  3 files changed, 112 insertions(+), 16 deletions(-)

Not 100% certain how this will be used, but the mechanism itself
looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
