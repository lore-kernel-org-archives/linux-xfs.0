Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C95C77B7C
	for <linux-xfs@archiver.kernel.org>; Wed, 10 May 2023 04:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjEJE4P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 May 2023 00:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjEJE4O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2023 00:56:14 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F937F3
        for <linux-xfs@vger.kernel.org>; Tue,  9 May 2023 21:56:13 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-64115e652eeso47596929b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 09 May 2023 21:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1683694572; x=1686286572;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x2IMQ08ZimBHQnx7T8SfrGv5qorsF0wjFs6EWZZhJlg=;
        b=sI1KgiZL3JOnQuAMYEyoZyqz6CF3bhGqqnYnLt0yQoXT/jWCk9R1TpGpCebF0uF6pP
         HJGZ0mvzbdaNYK6d56c0GhTw+UqWwiQ3ijmTOczRB1bCT9oVt+JT8VRuvKAKDyeuCHtx
         skNatbMw0uh4jcb6XWNrPPCu3BhFn3wTXeTItzp6pXt62F2bcEqdlQEVf/mZ5IP26QG0
         XUAgHzT5P+m3KHAoFRPL7Vb9cBHMR9TCDQAouZb9JUwXC0BZAKYL2+ZB3vMPqugRYEBj
         ySTucnB3paC8hlQGnrHHmix8qNgyGpl0JmySzun9g88DKPflg2Vy8yyjfT+AB7N7OLWz
         NSbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683694572; x=1686286572;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x2IMQ08ZimBHQnx7T8SfrGv5qorsF0wjFs6EWZZhJlg=;
        b=hw8leqXZbeTnBYBB7NZCdiEdn4PCiwJHt7yh1+osrnKn9JZk3h2VxN1xQX22IiodX7
         lYDSb+QuuphPEEhhVzpZu9QWtnw9OS4u/xzyPmUC+ov4yRcnTfbiSksw+ACUW5LA+0um
         0xRQ83Crg2BVE5Nhi41WUQ3vB5xPj9tQLkazHSc/lBzvqpOlW9cGnB//VpkpYMU1XCnk
         Wp17vipy5IN7xhcqJRZb5yLo2bANozMz7iRPtWxztkA+b/1raFr/WDphwMQR1fjRW06Q
         Mucu9iRyPRDDk0Mas/gQFnU7iI0Ttq6O/IPvnzbjd6KIhoe8zkya7rdhETQURGhYCJrY
         RYFg==
X-Gm-Message-State: AC+VfDwdyYmLc46uTvb9bq7kihOmZiiuua9tUvXz8cz5vimUYa93wMSP
        TfTg2FMz92hDIGe8taDcIDN356EAK8FNadZNr9Y=
X-Google-Smtp-Source: ACHHUZ4ZxF6we2Oo5TmIs/uUw1V4MwodGFZqjp7h+x843/DRwyMSDRfs+B1sx3rTaqqYa6cX6fOmag==
X-Received: by 2002:a17:903:187:b0:1ab:11d5:4f07 with SMTP id z7-20020a170903018700b001ab11d54f07mr26669731plg.18.1683694572548;
        Tue, 09 May 2023 21:56:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id b2-20020a170902d50200b001ac7794a7eesm2582569plg.288.2023.05.09.21.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 21:56:12 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pwbs1-00DUXn-Kz; Wed, 10 May 2023 14:56:09 +1000
Date:   Wed, 10 May 2023 14:56:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix broken logic when detecting mergeable bmap
 records
Message-ID: <20230510045609.GW3223426@dread.disaster.area>
References: <20230508153107.GB858799@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508153107.GB858799@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 08, 2023 at 08:31:07AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Commit 6bc6c99a944c was a well-intentioned effort to initiate
> consolidation of adjacent bmbt mapping records by setting the PREEN
> flag.  Consolidation can only happen if the length of the combined
> record doesn't overflow the 21-bit blockcount field of the bmbt
> recordset.  Unfortunately, the length test is inverted, leading to it
> triggering on data forks like these:
> 
>  EXT: FILE-OFFSET           BLOCK-RANGE        AG AG-OFFSET               TOTAL
>    0: [0..16777207]:        76110848..92888055  0 (76110848..92888055) 16777208
>    1: [16777208..20639743]: 92888056..96750591  0 (92888056..96750591)  3862536
> 
> Note that record 0 has a length of 16777208 512b blocks.  This
> corresponds to 2097151 4k fsblocks, which is the maximum.  Hence the two
> records cannot be merged.
> 
> However, the logic is still wrong even if we change the in-loop
> comparison, because the scope of our examination isn't broad enough
> inside the loop to detect mappings like this:
> 
>    0: [0..9]:               76110838..76110847  0 (76110838..76110847)       10
>    1: [10..16777217]:       76110848..92888055  0 (76110848..92888055) 16777208
>    2: [16777218..20639753]: 92888056..96750591  0 (92888056..96750591)  3862536
> 
> These three records could be merged into two, but one cannot determine
> this purely from looking at records 0-1 or 1-2 in isolation.
> 
> Hoist the mergability detection outside the loop, and base its decision
> making on whether or not a merged mapping could be expressed in fewer
> bmbt records.  While we're at it, fix the incorrect return type of the
> iter function.
> 
> Fixes: 6bc6c99a944c ("xfs: alert the user about data/attr fork mappings that could be merged")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/bmap.c |   25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)

Looks OK, will throw into the test tree.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
