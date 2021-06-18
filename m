Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ACCDC48BDF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 14:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8B206124C
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 14:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234549AbhFROhM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 10:37:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40342 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234482AbhFROhL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jun 2021 10:37:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624026902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6su+Q6nXOW6t4vMKuxHSk50B7FVzWJ+bPx2dJoO5i+I=;
        b=Ncb0GUpww6lFnb7INpDC8HzKJOAq/J08+ZOXwGjsTQVd4SLkmnVIgysJRtQl7Af0v8SPA3
        +f90dd8SSuvzZM0PGWQmheyp5CRs/UHZXgscHwzg1cKkVczYu/kZgofuHkdWhRkUGW6e2c
        V8hJAQSQ43t/f1NgYiHm7khI9KzaaCE=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-Wp_IeDm_MkWfyXCc2-Wvqw-1; Fri, 18 Jun 2021 10:35:01 -0400
X-MC-Unique: Wp_IeDm_MkWfyXCc2-Wvqw-1
Received: by mail-oo1-f70.google.com with SMTP id c25-20020a4ad7990000b029020e67cc1879so5890803oou.18
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jun 2021 07:35:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6su+Q6nXOW6t4vMKuxHSk50B7FVzWJ+bPx2dJoO5i+I=;
        b=Ij/r3Cy3awNi2aTVeh/5Ato990n63Qah3yQ3g/egcI8mh/OjhbpE04/61+kfgqEuxK
         7rsoceELX1bUXOcd9pf2o+laBE1nTbALKdVTAbnWHwF5KttWTuYhAnfKxXSy5SFh/MBh
         K2KgT8Lybek/OT0Qzp6See3tgPbPXuzyIvkZyVoxJECKZKbGR5BsTuXVJ3uMbKABtmXK
         5qiXYMS3cc9AD19eR303WKjTseuhuuC1yewFyoxXHA2711EKnlW8Dg0T7L8XOfbGFGbo
         jhxGGVlZK8o1UKPs5nElBZo8OLMRsHnYfRsHCwJeUQfd8a16RW62efjlLz2cAC9zdfG/
         aAUw==
X-Gm-Message-State: AOAM533jWNpeB3lRdixkjob4pm+ruQKdQ/QaTJd2X7pXgnXpnoxlbvnh
        2Ei1iebiiz1Jq+m0vuasle/9JRLzowzp6R2wwTeBYaXWZJTqkk143mTgqD+t2ndO7Gomt7d/SbD
        uZBSk0yYlSrqD8aH0vGy3
X-Received: by 2002:a9d:6c89:: with SMTP id c9mr9510795otr.163.1624026900337;
        Fri, 18 Jun 2021 07:35:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQeuH1RN1ij2MsRQI+4MzPWCJJIlfBCJw4TbET4vdCeZ33bBGOCD/DTlGMSl0694K2IZMWCA==
X-Received: by 2002:a9d:6c89:: with SMTP id c9mr9510780otr.163.1624026900209;
        Fri, 18 Jun 2021 07:35:00 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id h11sm1443552oov.8.2021.06.18.07.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 07:34:59 -0700 (PDT)
Date:   Fri, 18 Jun 2021 10:34:57 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: print name of function causing fs shutdown
 instead of hex pointer
Message-ID: <YMyvEfTF93siqWDE@bfoster>
References: <162388772484.3427063.6225456710511333443.stgit@locust>
 <162388773604.3427063.17701184250204042441.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162388773604.3427063.17701184250204042441.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 04:55:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In xfs_do_force_shutdown, print the symbolic name of the function that
> called us to shut down the filesystem instead of a raw hex pointer.
> This makes debugging a lot easier:
> 
> XFS (sda): xfs_do_force_shutdown(0x2) called from line 2440 of file
> 	fs/xfs/xfs_log.c. Return address = ffffffffa038bc38
> 
> becomes:
> 
> XFS (sda): xfs_do_force_shutdown(0x2) called from line 2440 of file
> 	fs/xfs/xfs_log.c. Return address = xfs_trans_mod_sb+0x25
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

No objection to what Christoph suggests, but ISTM it could be a tack on
patch to improving the existing message:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_fsops.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 07c745cd483e..b7f979eca1e2 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -543,7 +543,7 @@ xfs_do_force_shutdown(
>  	}
>  
>  	xfs_notice(mp,
> -"%s(0x%x) called from line %d of file %s. Return address = "PTR_FMT,
> +"%s(0x%x) called from line %d of file %s. Return address = %pS",
>  		__func__, flags, lnnum, fname, __return_address);
>  
>  	if (flags & SHUTDOWN_CORRUPT_INCORE) {
> 

