Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3DF9C77B73
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Apr 2023 23:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbjDTXYd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 19:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbjDTXYb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2023 19:24:31 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2631744AF
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 16:24:30 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-52019617020so1430988a12.3
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 16:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682033069; x=1684625069;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sEDVmlWJdnMCSwxs855UJAdadMMbH6jXlIrPy6fUwVY=;
        b=OUublQCzx/12w8N+EJeBnq6d7w3JQJvNV5122IDC5OK2WX04ETPG1cb7/Xey0pf450
         rd7f5CAuq1jfnpBwh0yE/ECSwDgY1Y+Iwuaar8gP6vv0NxyF+RpIrMe9pMgKRgsgg0nl
         69zMAb0AMbfZGckvXO+FWkE8eyu+1VNiiIBfn8FHsTLJnKiRL689gGFkO4vtXTBdH+bV
         V+Dd9SgAezYaVETlUgDUkiRNSsI8w8VDv9m9dLxkGYpbM0f6Yea2B/TVGG2YjXc8XBEU
         ZHyJ08ZuJUb4PjAdvY/vDvTwxI+Rw5UTghPQK39oLq22euFVpZgjxVtJ/WKPifvyqpcK
         tMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682033069; x=1684625069;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sEDVmlWJdnMCSwxs855UJAdadMMbH6jXlIrPy6fUwVY=;
        b=XiqGnVRBPeVbLQaiL8YPpin9cKayFedrE3nKe1vlgEorcAtMzb1vyO2iF6NLVUrtVI
         1y0OorUP1TdJpDF3bJza6elSt9eUyQ9q2gZraS6B+HwS4+QaHkHr+AEvbM2oOhMgd+en
         ewHGy91qEk8caE9IfsCAMxM7kxYtVT0F65E4pYR+4vnTWcLn7mye34H/QofL85Ew8Znl
         4rZM4kcqictfavZZ32JD/Sj3mNkq3PTKgoMBxQYtVT5I3z18lm1WXnI5U6SPvLXdIB30
         6/VolBMobuXAfv3fbe/G1EYig3ns5UAkiCv7tapFHxUPapOA4jwdYOjZXYm4jhzQ4i28
         2OoQ==
X-Gm-Message-State: AAQBX9e7TvG494JWGLWRFOKTBVmSlvQGjbykt1G252zFx8uvI1s6tVoT
        vG6HmeAXXd9kLpAPlCZy2Mvuzg==
X-Google-Smtp-Source: AKy350aK28sfkXNega+ecctc4eKW5ylHA0DVXGJXbHIje41ZBIS2GFtl4TPSOdg5Kz2uTwRIlc65tQ==
X-Received: by 2002:a17:903:40ce:b0:1a6:82ac:f277 with SMTP id t14-20020a17090340ce00b001a682acf277mr3048596pld.14.1682033069645;
        Thu, 20 Apr 2023 16:24:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id jo3-20020a170903054300b001a4ee93efa2sm1616299plb.137.2023.04.20.16.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 16:24:29 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ppdda-005q2q-Qd; Fri, 21 Apr 2023 09:24:26 +1000
Date:   Fri, 21 Apr 2023 09:24:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        xfs <linux-xfs@vger.kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: drop EXPERIMENTAL tag for large extent counts
Message-ID: <20230420232426.GA3223426@dread.disaster.area>
References: <20230420151000.GH360889@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420151000.GH360889@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 20, 2023 at 08:10:00AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This feature has been baking in upstream for ~10mo with no bug reports.
> It seems to work fine here, let's get rid of the scary warnings?

Are you proposing this for the 6.4 cycle (next weeks merge window)
or for the cycle after this?  I don't see an issue with removing the
experimental tag, but I do think it's a bit late for this cycle....

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_super.c |    4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 4d2e87462ac4..dc13ff4ea25e 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1683,10 +1683,6 @@ xfs_fs_fill_super(
>  		goto out_filestream_unmount;
>  	}
>  
> -	if (xfs_has_large_extent_counts(mp))
> -		xfs_warn(mp,
> -	"EXPERIMENTAL Large extent counts feature in use. Use at your own risk!");
> -

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
