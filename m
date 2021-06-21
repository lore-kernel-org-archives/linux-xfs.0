Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C7AC49EA2
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 04:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8BDC61206
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 04:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhFUEnk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 00:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhFUEnk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jun 2021 00:43:40 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60150C061574
        for <linux-xfs@vger.kernel.org>; Sun, 20 Jun 2021 21:41:24 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id e33so13145246pgm.3
        for <linux-xfs@vger.kernel.org>; Sun, 20 Jun 2021 21:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=AhoCmjPfm5EZk4GqKXv6JfAseGVDE2BytxKCu3vHfmQ=;
        b=YDuOB1KQsDi0mUZae8IzWc9JDPiVysua8MwOrK9Sqjb7Z8wbNYt5hknbULL90aCwTZ
         ovDLnPfMNzosm4xmdO2SQqUTV2To0trisXi2PY1z2EUv5psyZu33t7lTE47LwRoDGvD4
         yv9yikW8sqqxVcFL3k4k5Ye/au54JBPJsy0OEMhtirkPIiYhzhVLyJyWBUMrCn7l9yx9
         QROrJ1g0zIXS+H82S8JLVyR8hjIGJxQEJS22TUcMkXfA1eQjkCSWCAOena/4Whvu993p
         Kp/GBT4rZfggoO3Tt3foHCka4nWzJktzz0xXgsGhCOQs7laoJ3r8IQBs+x5eOKb+n1n8
         UCUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=AhoCmjPfm5EZk4GqKXv6JfAseGVDE2BytxKCu3vHfmQ=;
        b=s0349ezzsTF8miXT4wLtguTKPhk02N6yDRoU1b+ZbmV5cNbCFVKcVwTshg7YLgWXhJ
         eZu6Lw4WnSAQ//RmvWl/iaM+hPzz3KIAqcHyDpxdgpiEba54K9NxceSaea0TMvP9813Q
         6/PRjUVRl09/AHSik3zta0ohrjgGbr1cb7ivdYOyEGeRLt8p4JGfciB2c+rWG1ygg99S
         5Vna0wyGsmyaxsSCjQoaR3496aGIX+ReKKzJkEfTVkMzaoxfzvNqwqas+1OmfCDBPkyX
         8bRSPtEhy3d0PdDTPFt+QYPbF31ZGWMJVp5c+T0jRTLCsAXBPydhkP7EXZV6HExaawL6
         kryQ==
X-Gm-Message-State: AOAM532495aFIsjewq9blpl7jETwrvDTEY22iuau29522KNPpSgbrhgA
        rfe5BT+x5gFsd4tJ9nv3cDk=
X-Google-Smtp-Source: ABdhPJy0RvEYXIZnTNvNghJ/0HWUfgHDQAPjnt5qewUJ6OE5qIx1NxxSx7GYdxabS3nd52e7hOkXyw==
X-Received: by 2002:a63:ec43:: with SMTP id r3mr21884280pgj.344.1624250483902;
        Sun, 20 Jun 2021 21:41:23 -0700 (PDT)
Received: from garuda ([122.171.54.242])
        by smtp.gmail.com with ESMTPSA id s11sm17193990pjz.42.2021.06.20.21.41.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 20 Jun 2021 21:41:23 -0700 (PDT)
References: <162404243382.2377241.18273624393083430320.stgit@locust> <162404245053.2377241.2678360661858649500.stgit@locust>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, bfoster@redhat.com
Subject: Re: [PATCH 3/3] xfs: shorten the shutdown messages to a single line
In-reply-to: <162404245053.2377241.2678360661858649500.stgit@locust>
Date:   Mon, 21 Jun 2021 10:11:20 +0530
Message-ID: <87lf73de33.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 19 Jun 2021 at 00:24, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Consolidate the shutdown messages to a single line containing the
> reason, the passed-in flags, the source of the shutdown, and the end
> result.  This means we now only have one line to look for when
> debugging, which is useful when the fs goes down while something else is
> flooding dmesg.
>

Looks good.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_fsops.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
>
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index b7f979eca1e2..6ed29b158312 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -538,25 +538,25 @@ xfs_do_force_shutdown(
>  
>  	if (flags & SHUTDOWN_FORCE_UMOUNT) {
>  		xfs_alert(mp,
> -"User initiated shutdown received. Shutting down filesystem");
> +"User initiated shutdown (0x%x) received. Shutting down filesystem",
> +				flags);
>  		return;
>  	}
>  
> -	xfs_notice(mp,
> -"%s(0x%x) called from line %d of file %s. Return address = %pS",
> -		__func__, flags, lnnum, fname, __return_address);
> -
>  	if (flags & SHUTDOWN_CORRUPT_INCORE) {
>  		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_CORRUPT,
> -"Corruption of in-memory data detected.  Shutting down filesystem");
> +"Corruption of in-memory data (0x%x) detected at %pS (%s:%d).  Shutting down filesystem",
> +				flags, __return_address, fname, lnnum);
>  		if (XFS_ERRLEVEL_HIGH <= xfs_error_level)
>  			xfs_stack_trace();
>  	} else if (logerror) {
>  		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_LOGERROR,
> -			"Log I/O Error Detected. Shutting down filesystem");
> +"Log I/O error (0x%x) detected at %pS (%s:%d). Shutting down filesystem",
> +				flags, __return_address, fname, lnnum);
>  	} else {
>  		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
> -			"I/O Error Detected. Shutting down filesystem");
> +"I/O error (0x%x) detected at %pS (%s:%d). Shutting down filesystem",
> +				flags, __return_address, fname, lnnum);
>  	}
>  
>  	xfs_alert(mp,


-- 
chandan
