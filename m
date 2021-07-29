Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78851C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 11:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F807603E7
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 11:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236399AbhG2LBQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 07:01:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51615 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236611AbhG2LBQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jul 2021 07:01:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627556473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9D28hkXRrTn2MXRDYN4jg/5XenPwtzcq6xQ9DTF9ZLU=;
        b=gcXsJ8TrzU12PKOavRu5TZhfZHh4B0UrrmUjs5UJ05ABVl3R3WHPdLtJH94MbV+YVW6PWP
        XeYSo/unMbbW5sIs6yqB8DTEWn4Si9DcBOSyGhLjVN6nK/xRosdSTGijPOZdFKZqyjxxBU
        EeowioDVhZZ8Vz2KA7GlkdbLahkdmDo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-1KnOR7wqOQGFrThD1Rgdwg-1; Thu, 29 Jul 2021 07:01:11 -0400
X-MC-Unique: 1KnOR7wqOQGFrThD1Rgdwg-1
Received: by mail-ej1-f70.google.com with SMTP id a19-20020a1709063e93b0290551ea218ea2so1856918ejj.5
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jul 2021 04:01:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=9D28hkXRrTn2MXRDYN4jg/5XenPwtzcq6xQ9DTF9ZLU=;
        b=ZJ0fxV3XVnoC5UyXGHBob9/3CGZ0dusp2aq3LEYe5KYBwbac8nTT26oXS2DClQ3cy6
         JJ2VAayZpnq8HOTqrG1AlliviT/jnqJPWU1kgnJoS6nut1cVPyfxTMwZ6eePOgn1CMpw
         ybfvCfSaUZ5DIGOD/QqM3thcPcBdcUXGTvH0rzOEq4IPIogUnoRlGHvPdeesDAQ6Ck3B
         hKX9pIFP56A+j2eEtAq17FWpEEFUReimulMVpNGmWH1xU5mKrteSKXhkx/Z8L3iymOQ4
         V2A0lZd1Hdi07KL8fyIUWAliooZ6iSuaxyAgJbgjoPBsK9yOhwbNNvkrJ1eafp0CcDD6
         zGuA==
X-Gm-Message-State: AOAM533wYC8YAFV9IR6DqKZAz2x9+zViN3nLcGpXUa244kKQYj7L/DAh
        PGlzWsZqdyeXAWh3ik01Sh9tkyVgH/umA9XM+Fm7+zNQednV9oTlYjWIjVBzGqL8WDwO5jnoRCP
        ku8aTxmd9MX8lD5EsoRRy
X-Received: by 2002:a17:906:5e45:: with SMTP id b5mr2053446eju.301.1627556470307;
        Thu, 29 Jul 2021 04:01:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRMnuKsSRi9gJDCTJRiJKe000DtjYkcHe8zdxL4vcKx5X0BxRD5eIz93qGclEs2g8eI2C/1A==
X-Received: by 2002:a17:906:5e45:: with SMTP id b5mr2053429eju.301.1627556470084;
        Thu, 29 Jul 2021 04:01:10 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id g8sm1067824eds.25.2021.07.29.04.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 04:01:09 -0700 (PDT)
Date:   Thu, 29 Jul 2021 13:01:07 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Dave Chinner <dchinner@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_repair: invalidate dirhash entry when junking
 dirent
Message-ID: <20210729110107.ysn6fppfgaf5vp4x@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        sandeen@sandeen.net, Dave Chinner <dchinner@redhat.com>,
        linux-xfs@vger.kernel.org
References: <162750698055.45897.6106668678411666392.stgit@magnolia>
 <162750698605.45897.4760370429656466555.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162750698605.45897.4760370429656466555.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 28, 2021 at 02:16:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In longform_dir2_entry_check_data, we add the directory entries we find
> to the incore dirent hash table after we've validated the name but
> before we're totally done checking the entry.  This sequence is
> necessary to detect all duplicated names in the directory.
> 
> Unfortunately, if we later decide to junk the ondisk dirent, we neglect
> to mark the dirhash entry, so if the directory gets rebuilt, it will get
> rebuilt with the entry that we rejected.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  repair/phase6.c |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 0929dcdf..696a6427 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -237,6 +237,21 @@ dir_hash_add(
>  	return !dup;
>  }
>  
> +/* Mark an existing directory hashtable entry as junk. */
> +static void
> +dir_hash_junkit(
> +	struct dir_hash_tab	*hashtab,
> +	xfs_dir2_dataptr_t	addr)
> +{
> +	struct dir_hash_ent	*p;
> +
> +	p = radix_tree_lookup(&hashtab->byaddr, addr);
> +	assert(p != NULL);
> +
> +	p->junkit = 1;
> +	p->namebuf[0] = '/';
> +}
> +
>  static int
>  dir_hash_check(
>  	struct dir_hash_tab	*hashtab,
> @@ -1729,6 +1744,7 @@ longform_dir2_entry_check_data(
>  				if (entry_junked(
>  	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is not in the the first block"), fname,
>  						inum, ip->i_ino)) {
> +					dir_hash_junkit(hashtab, addr);
>  					dep->name[0] = '/';
>  					libxfs_dir2_data_log_entry(&da, bp, dep);
>  				}
> @@ -1756,6 +1772,7 @@ longform_dir2_entry_check_data(
>  				if (entry_junked(
>  	_("entry \"%s\" in dir %" PRIu64 " is not the first entry"),
>  						fname, inum, ip->i_ino)) {
> +					dir_hash_junkit(hashtab, addr);
>  					dep->name[0] = '/';
>  					libxfs_dir2_data_log_entry(&da, bp, dep);
>  				}
> @@ -1844,6 +1861,7 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
>  				orphanage_ino = 0;
>  			nbad++;
>  			if (!no_modify)  {
> +				dir_hash_junkit(hashtab, addr);
>  				dep->name[0] = '/';
>  				libxfs_dir2_data_log_entry(&da, bp, dep);
>  				if (verbose)
> 

-- 
Carlos

