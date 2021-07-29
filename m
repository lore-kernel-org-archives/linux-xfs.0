Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB96C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 11:21:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B9A760E9B
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 11:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbhG2LVc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 07:21:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231834AbhG2LVc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jul 2021 07:21:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627557688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b3qMREP+kjy2z3eCpP2M7VfxHdwU8p0uux4E56vPx+4=;
        b=RNKe0uwkln0hSFsYqnoKnijqexXUGcw5DvABDxondhNrsvKBQXmYpALEPPdpY1AGA3i8ZF
        4DukfMolYv9ffP7hwaP5189Al8vfeafSu42Uh3NlXa70K72ORHBr5haTxkImSC4LGToMMW
        IYZoHgvzjOCsVgTAZtqrOYFiQP1kvhE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-f3cSXJXCNwaw2fZg3UJwrQ-1; Thu, 29 Jul 2021 07:21:27 -0400
X-MC-Unique: f3cSXJXCNwaw2fZg3UJwrQ-1
Received: by mail-ed1-f72.google.com with SMTP id c16-20020aa7d6100000b02903bc4c2a387bso2746514edr.21
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jul 2021 04:21:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=b3qMREP+kjy2z3eCpP2M7VfxHdwU8p0uux4E56vPx+4=;
        b=OyeMd3yCj+jTLAx1rn2bLUn768Ez7v5Oy46x2HUSo5RhUQESOtbHjCWxhaMW+IOCl+
         c2gekqNsb42vAOxkoH4VQ3V28cGZw8fasTj9W82vSVX68lUv4n4P/vbZ64IUQgK9WVAB
         2x/qlB2YAnL/S6HhY8fnq2BtR6oV0yviBXNrNpRv22HaGgXe1c3cS4oCTuxnXZri+SDY
         Nj5jz09JYf6OvCkJmYxRNDyzUWgzxRq8ITFdGx5A775uUNiz6sr4wrPP/+aFtq9RIm5G
         JC9tRmntEzRtO17mjmwFNH3BYTi2abaUoHjcmf49FwgmArkVW3FM3eBAXqRUeYnszikR
         o9FQ==
X-Gm-Message-State: AOAM532df2wi+MekwMCrCGJumPQ1yKKOfSqLaFDC7Xn/Nhho2vp6nwnr
        aXL55Uupr/6sVdaL48tipnyGaAUMsl2RvkQkZibAlqTpHJDzHmBT6UPVBOqsAwRCuxgZHGtK48o
        RBBUOFJnXiGTT2mOp/vy1
X-Received: by 2002:a50:a456:: with SMTP id v22mr5314009edb.333.1627557686395;
        Thu, 29 Jul 2021 04:21:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0ZexexBZ/fyltmnj1pi3IL2JwrysgaOi2IuBwQAXJYjx/Y3/i7vLATRnJ+xAfKintQkamwQ==
X-Received: by 2002:a50:a456:: with SMTP id v22mr5313996edb.333.1627557686228;
        Thu, 29 Jul 2021 04:21:26 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id e13sm852833ejz.79.2021.07.29.04.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 04:21:25 -0700 (PDT)
Date:   Thu, 29 Jul 2021 13:21:24 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] quota: allow users to truncate group and project quota
 files
Message-ID: <20210729112124.kqtftqd73ifvqqou@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
References: <20210728200208.GH3601443@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728200208.GH3601443@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 28, 2021 at 01:02:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In commit 79ac1ae4, I /think/ xfsprogs gained the ability to deal with
> project or group quotas.  For some reason, the quota remove command was
> structured so that if the user passes both -g and -p, it will only ask
> the kernel truncate the group quota file.  This is a strange behavior
> since -ug results in truncation requests for both user and group quota
> files, and the kernel is smart enough to return 0 if asked to truncate a
> quota file that doesn't exist.
> 
> In other words, this is a seemingly arbitrary limitation of the command.
> It's an unexpected behavior since we don't do any sort of parameter
> validation to warn users when -p is silently ignored.  Modern V5
> filesystems support both group and project quotas, so it's all the more
> surprising that you can't do group and project all at once.  Remove this
> pointless restriction.
> 
> Found while triaging xfs/007 regressions.
> 
> Fixes: 79ac1ae4 ("Fix xfs_quota disable, enable, off and remove commands Merge of master-melb:xfs-cmds:29395a by kenmcd.")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good.
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  quota/state.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/quota/state.c b/quota/state.c
> index 3ffb2c88..43fb700f 100644
> --- a/quota/state.c
> +++ b/quota/state.c
> @@ -463,7 +463,8 @@ remove_extents(
>  	if (type & XFS_GROUP_QUOTA) {
>  		if (remove_qtype_extents(dir, XFS_GROUP_QUOTA) < 0)
>  			return;
> -	} else if (type & XFS_PROJ_QUOTA) {
> +	}
> +	if (type & XFS_PROJ_QUOTA) {
>  		if (remove_qtype_extents(dir, XFS_PROJ_QUOTA) < 0)
>  			return;
>  	}
> 

-- 
Carlos

