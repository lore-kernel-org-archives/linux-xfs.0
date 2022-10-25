Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01486FA373E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 21:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiJYVh1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 17:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJYVh0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 17:37:26 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C1A7CA9F
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 14:37:26 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id j12so12139104plj.5
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 14:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MQSkRLu8qOBXwdOXjQzOfC0FrrJB4lt0uDXcScz8eDc=;
        b=vY/f42cg6n0r76kbEfbTWsIp3Q7k5Z0E+Ng6PKQvmtMYrZQijGm5ysDk7nIsQokZqs
         jllzTUpoa78e7eg/VZPVpGgPtQE22LbZ/mrVjIOhuWd04fJ5+iq6pg9+RvORUbE7NkrV
         TrsNiPROQEW58Ju+z8nGeTjQNwIdzFVZVpoj/QNEAnU42+lQ+SMpPOj2rHwLRF9Ja7RR
         8DcB2OWmW5chzJsj3t60IoyWUe7cQgCZYkOr1AkmTFg0OgMZRo4+rhyqPLAd5oiSeV8J
         Cm9jXcmKnvfqilf0fkjHqQwBBVroDk2uJDo9jF4Ry2PqM+wnfium6unNyp69Y9CgEpmT
         4A4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MQSkRLu8qOBXwdOXjQzOfC0FrrJB4lt0uDXcScz8eDc=;
        b=w7ZCJBG6GX2Gtsyk/meXaYlphK5WPN035B4cvOzuPMZjO8Vr6IMNuBC3gsL+NxwRpn
         OvBbL7lmHdbGEb9MPSHzXMR5LqqXTsoToQs869AEUJCjcVkX9K5mI9K7JkLt797qc9cv
         /9VctE7lyWM518YTo/aDSJXfB8+l13smKjBH7EZ0OFmJAYKGVV/iKb6ZQmypmOFtxPrl
         8+QqjpTGxhHQxlvdPpY8OI/+pAgFoe5/jWM+nriX2TO6WKKcrFx4wdZOla0ISNXIYbRw
         XZmQpfnTmPFvttRA0v2LV820lSmzQE/2diOJJArUkQzHaa8NdNSiDu9A+jt1xszHdTGp
         KKtg==
X-Gm-Message-State: ACrzQf0fSxQyi0i1fFhmLK5wkQFkQexqFmAQPXCc2EgmoaL3/T6t4MyR
        HIUhMGK8i1bZTK+mmCU7gEB5C0lwBkCFAQ==
X-Google-Smtp-Source: AMsMyM5pElrA3JTHlmEG/BpVKNCOIZDew7jk9siS399uwtpT2l3BjpVXvdKE/f4jTZrBcAAETiwMZw==
X-Received: by 2002:a17:902:b601:b0:186:9f20:f6a4 with SMTP id b1-20020a170902b60100b001869f20f6a4mr14577366pls.38.1666733845865;
        Tue, 25 Oct 2022 14:37:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id 199-20020a6214d0000000b0056b6a22d6c9sm1792834pfu.212.2022.10.25.14.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 14:37:25 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1onRbv-006N9n-5p; Wed, 26 Oct 2022 08:37:23 +1100
Date:   Wed, 26 Oct 2022 08:37:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: fix memcpy fortify errors in RUI log format
 copying
Message-ID: <20221025213723.GE3600936@dread.disaster.area>
References: <166664715160.2688790.16712973829093762327.stgit@magnolia>
 <166664717418.2688790.4324481950746749054.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166664717418.2688790.4324481950746749054.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 02:32:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Starting in 6.1, CONFIG_FORTIFY_SOURCE checks the length parameter of
> memcpy.  Since we're already fixing problems with BUI item copying, we
> should fix it everything else.
> 
> Refactor the xfs_rui_copy_format function to handle the copying of the
> head and the flex array members separately.  While we're at it, fix a
> minor validation deficiency in the recovery function.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_ondisk.h    |    3 ++
>  fs/xfs/xfs_rmap_item.c |   58 ++++++++++++++++++++++--------------------------
>  2 files changed, 30 insertions(+), 31 deletions(-)

Lokks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
