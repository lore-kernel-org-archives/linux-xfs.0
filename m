Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA627C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Nov 2022 02:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiKBCUh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Nov 2022 22:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiKBCUg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Nov 2022 22:20:36 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E04BA3
        for <linux-xfs@vger.kernel.org>; Tue,  1 Nov 2022 19:20:35 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 78so15012859pgb.13
        for <linux-xfs@vger.kernel.org>; Tue, 01 Nov 2022 19:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RzREr7hqySV/Xa4RROAEq7tb1q8dOo6K/KhFusNPaUU=;
        b=jzXcr/aZj4yVRYDFG9X4GcqzVCqv0b6sm1XnDSrT+UTXpIBP8gEMRUUZtD+mN6rqgG
         5wap3vwYDqksypwcyyh4HjViI01CSPGJFq3m7dOc3X1wzYHa6zc7kS8FY457OTAFJ5u4
         +ubdTz3mTBLiEoVwQqyb4nsfkcASrHSqGvn87/SHmsX0kXuHqikLxAbUwieyTQzf/I8y
         s6CFlA0lMjhdUDJu85fJihm2SIWxGW0k3hIyCR5k2Dlay06oY5714A1avD6ZYEWsK6R+
         et8cNgzCxQvwozmd/ITLUDKVK9zAzb0Ts4tUDQ8Q3yodvZAtiaF24SaVNaJXOwHFnmpj
         Y5Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RzREr7hqySV/Xa4RROAEq7tb1q8dOo6K/KhFusNPaUU=;
        b=ptbl7fImVAfKpzgpt+lOOQVdTSuV3yHOUkuOFG4ae5hXyGKtghq/NwqNZbVOl+LH9S
         irvw5zRVWcGLiD/yVWyMOZrlBlsF2tltqnfXzz1wYfFCPfl7wDoQfr4wkkrnUz0MpQVf
         n6mjRtKEBIDO2rs2qnbSmgrQ3KmtFMZsALbAFNyaziNzsmNgs6E/SI4AY5tj7imeKE5S
         baDCeIV0DjDLe252nc6TESyiTfDW4QedkE3eI1xgCTJjmg6DyyFV7/WIRc9pjNOprGWx
         swbQ7yO9MeXMguBWAnaEbWZ/4TOwPi/OeqL16nSz7Anjx4tSNz58Tl3R28mY33wJ/sOm
         16iA==
X-Gm-Message-State: ACrzQf0Mj5Y1jKC3kjozsAszkbXiOEooH6A7fJbClTrrKdxF6Krc5YoU
        S1V4lHB2XLQXDG+woaUeGyOO1w==
X-Google-Smtp-Source: AMsMyM7OZPg70U/VbVu3xTJhSq94MSZjF3zHIqoohdedouSitxU7mwtd660zKSHN+IoE4P8Dkux4sA==
X-Received: by 2002:a63:ed14:0:b0:470:740:6042 with SMTP id d20-20020a63ed14000000b0047007406042mr1561169pgi.439.1667355635328;
        Tue, 01 Nov 2022 19:20:35 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id 14-20020a17090a0cce00b00213d28a6dedsm227637pjt.13.2022.11.01.19.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 19:20:34 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oq3Mm-009D5x-4X; Wed, 02 Nov 2022 13:20:32 +1100
Date:   Wed, 2 Nov 2022 13:20:32 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: check the reference counts of gaps in the
 refcount btree
Message-ID: <20221102022032.GV3600936@dread.disaster.area>
References: <166473481572.1084209.5434516873607335909.stgit@magnolia>
 <166473481642.1084209.18220457727847413785.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473481642.1084209.18220457727847413785.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:20:16AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Gaps in the reference count btree are also significant -- for these
> regions, there must not be any overlapping reverse mappings.  We don't
> currently check this, so make the refcount scrubber more complete.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/refcount.c |   84 ++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 79 insertions(+), 5 deletions(-)

Makes sense.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
