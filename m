Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A96C4320A
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 07:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76C9D61179
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 07:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243576AbhHFHTX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 03:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243579AbhHFHTP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 03:19:15 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA1FC061798
        for <linux-xfs@vger.kernel.org>; Fri,  6 Aug 2021 00:18:58 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so12315206pjn.4
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 00:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:date:message-id
         :in-reply-to:mime-version;
        bh=NpGe5ZYMwua3ZGXDZj5TQsZfCAwBw07KXtQtiVlgX7U=;
        b=FRMa1JGLrmbFMn9obvFAJLshVpyfPmqXf1xgiLROOXTPn/5zKRuAUun+xCYDRssT9X
         fyiLE5AuP2hTQiVAikAgM7EUMFwx3zxcMo4JBtwxeDnooROvKGSE2BzjyeIN2Q4qSP5p
         ACoeOemfpWaCZbcB/OH5eferk8u9x0f2zv1i82D0bICioP5I+u077YIJSpGDoKPwOnZh
         Gqg9C17rlzXCkOp5jXthVl7A2Y6JPWj3C6/fce6ssxgYdd7/xZVisAbNSAHmYI3QS3qC
         x/spHtIZpPD/eJP/59CU9d7YmpSnsELJG/wt1Tj0zhEm2B//J81gcjl74L4Mj3xMd2pC
         wlVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :message-id:in-reply-to:mime-version;
        bh=NpGe5ZYMwua3ZGXDZj5TQsZfCAwBw07KXtQtiVlgX7U=;
        b=VM1dGbyaW6qZI07otC2bLgClMM3kedC+obEkbiWSiOxjuhMS1vVuRxzhZAhY9xgzwv
         K9Wn4YiVJ4m6iLXYRXw602Y9s9JYVpw0zwN8Vrgq7EA5cvnKUMU2lqHsTRaapSYh+KbG
         rLdqBKXeeyXyAsKHMJOytrVhfUKy6WD9uWIQGgK+8aijuo6D+uHFeUtHCwh1kSa0wd3I
         ce4sjheMhXGQ4wiQK6CjQKmV1TMFFBg/qpEsnCPbG8xHuy7EExIj0bmAbnZCzx3OTcMe
         ScW/n62i6sNo6/klYFH+DdWssl2b13fUnyyTJMIHDeqTrPjOV/GC6PPuf8xojydlGZ6X
         wyMw==
X-Gm-Message-State: AOAM530lfR/IOoVF1Otb3oZfGQe911v5/+pcjHpnSJUPLNkvWYa4yD/7
        82Nf5Vx43oFIzMZzlC/vWRsEMdffu0w=
X-Google-Smtp-Source: ABdhPJz321ZZzsv5B7Z8PKEh+RlCjbKcJUEqQ4E1M/xBQLBOSht6NkW8x5dbkHmUtNZrgVxGT4S4nw==
X-Received: by 2002:a05:6a00:1c59:b029:3bb:8d49:c2a2 with SMTP id s25-20020a056a001c59b02903bb8d49c2a2mr8996075pfw.77.1628234338416;
        Fri, 06 Aug 2021 00:18:58 -0700 (PDT)
Received: from garuda ([122.179.62.73])
        by smtp.gmail.com with ESMTPSA id y9sm10857532pgr.10.2021.08.06.00.18.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 06 Aug 2021 00:18:58 -0700 (PDT)
References: <162814684332.2777088.14593133806068529811.stgit@magnolia> <162814685444.2777088.14865867141337716049.stgit@magnolia>
User-agent: mu4e 1.6.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Carlos Maiolino <cmaiolino@redhat.com>,
        Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: drop experimental warnings for bigtime and inobtcount
Date:   Fri, 06 Aug 2021 11:21:36 +0530
Message-ID: <875ywjjf2k.fsf@garuda>
In-reply-to: <162814685444.2777088.14865867141337716049.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 Aug 2021 at 00:00, "Darrick J. Wong" <djwong@kernel.org> wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> These two features were merged a year ago, userspace tooling have been
> merged, and no serious errors have been reported by the developers.
> Drop the experimental tag to encourage wider testing.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> Reviewed-by: Bill O'Donnell <billodo@redhat.com>
> ---
>  fs/xfs/xfs_super.c |    8 --------
>  1 file changed, 8 deletions(-)
>
>
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 2bab18ed73b9..c4ba5c712284 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1599,10 +1599,6 @@ xfs_fs_fill_super(
>  	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
>  		sb->s_flags |= SB_I_VERSION;
>  
> -	if (xfs_sb_version_hasbigtime(&mp->m_sb))
> -		xfs_warn(mp,
> - "EXPERIMENTAL big timestamp feature in use. Use at your own risk!");
> -
>  	if (mp->m_flags & XFS_MOUNT_DAX_ALWAYS) {
>  		bool rtdev_is_dax = false, datadev_is_dax;
>  
> @@ -1658,10 +1654,6 @@ xfs_fs_fill_super(
>  		goto out_filestream_unmount;
>  	}
>  
> -	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
> -		xfs_warn(mp,
> - "EXPERIMENTAL inode btree counters feature in use. Use at your own risk!");
> -
>  	error = xfs_mountfs(mp);
>  	if (error)
>  		goto out_filestream_unmount;


-- 
chandan
