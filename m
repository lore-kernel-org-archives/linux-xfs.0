Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07683C3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 05:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CECF5217F5
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 05:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbfH0FUw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 01:20:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49532 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbfH0FUv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Aug 2019 01:20:51 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7A4B385363
        for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2019 05:20:51 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id w11so10812820wru.17
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 22:20:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=mBxlnfKYqmP8Z1+51l1s6eAlG7YCvyTWbZhjmeHRn6E=;
        b=XJ9gRDt4XKTKdGHhIlHOTMF9EgF6b9o4Uoq3uc07onWtra4Job9YXciwxOEeKDmxlY
         hAx+XIBDlCuMVEaEi+uhcvSh6rM9V4IDjY9bLu3uXo3JabnBmkfH1G871uV4h1uMdDJt
         u5aFzJeh3rtC/BQ/66Id9hbSNmKn9R3XI47q0mAsdNNhVbbTBK7ge4s01A2DVOt1KI5s
         nYDntSB7pzHX1+YyvCyear475jffcy29fNgLx8k5xMEMiswoUKlC2RRN6U8cDugWUw9H
         BjtNeUSDNOdplCub+u1/HegecyT+JoQNf9YSIUJBaj1EiKlzjn1ivwrj3h4cL5+D7YxI
         It6Q==
X-Gm-Message-State: APjAAAUXHrsPWsGEp0XuRQOOJYMagle2V8hr+4UopTwBpc+kHbQagLxh
        lvDYwn7IJWNNL0jXdKrkFxSgYZQ2YTJ8ByZzvh2KlAMtAqgZjUv8d6VWJF2lSqfYqIJIpKW87tT
        YSMz05AgeTnQSkqupUG1n
X-Received: by 2002:a05:600c:2056:: with SMTP id p22mr24019443wmg.159.1566883250265;
        Mon, 26 Aug 2019 22:20:50 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzzVohFuaLix/bueFV/WdMh4Bkn5ZIjjRZE0HAsXWq5hlWwk7d4GAwu9j7mMpiGgoNApQGK8g==
X-Received: by 2002:a05:600c:2056:: with SMTP id p22mr24019421wmg.159.1566883250044;
        Mon, 26 Aug 2019 22:20:50 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id x9sm1855056wmi.10.2019.08.26.22.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 22:20:49 -0700 (PDT)
Date:   Tue, 27 Aug 2019 07:20:47 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix maxicount division by zero error
Message-ID: <20190827052046.2l4wjcbyvyqevoog@pegasus.maiolino.io>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
References: <20190826163436.GO1037350@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826163436.GO1037350@magnolia>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi.

On Mon, Aug 26, 2019 at 09:34:36AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_ialloc_setup_geometry, it's possible for a malicious/corrupt fs
> image to set an unreasonably large value for sb_inopblog which will
> cause ialloc_blks to be zero.  If sb_imax_pct is also set, this results
> in a division by zero error in the second do_div call.  Therefore, force
> maxicount to zero if ialloc_blks is zero.
> 
> Note that the kernel metadata verifiers will catch the garbage inopblog
> value and abort the fs mount long before it tries to set up the inode
> geometry; this is needed to avoid a crash in xfs_db while setting up the
> xfs_mount structure.
> 
> Found by fuzzing sb_inopblog to 122 in xfs/350.

The patch looks good, but maybe a comment is worth so we don't need to check the
git log to understand why we need to check ialloc_blks here?

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 1a14067aa4d4..5e95648c346c 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2811,7 +2811,7 @@ xfs_ialloc_setup_geometry(
>  			inodes);

Something like:


	/*
	 * Set the maximum inode count for this filesystem, being careful
	 * ialloc_blks is not zeroed due a corrupted sb_agblklog
	 */
	if (sbp->sb_imax_pct) {
	if (sbp->sb_imax_pct && igeo->ialloc_blks) {
>  		/*
>  		 * Make sure the maximum inode count is a multiple
>  		 * of the units we allocate inodes in.

The comment is just a suggestion anyway, you can add to the patch:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
Carlos
