Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C613C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Dec 2022 02:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237050AbiLNCHy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 21:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237047AbiLNCHx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 21:07:53 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701CB5FD6
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 18:07:50 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id t17so5359654pjo.3
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 18:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=45RQdk/Pt1OwbmIBrWKLRwNWhtjQa23QL11BAFqftYk=;
        b=ocNKCykuU+Ywi3AZsTWEajbKc2gIC/LLl6ErnVgVuCDOKGJN7I8q3ycw849ngFZ620
         NOZzGVVD47LdVaNO2YCwqy42O5nKGCe7mJCTjBbAhcveFcFw9m6aJiUfh+Nh6IYJVOoM
         8AkyuCu68Nuh+PYBfvmEE7gVV6o1ldr8iWbMEAvM7SANMqj7kUFRfeXgF3FZbvDmvLXK
         87MAcLt4uGBFeCVhMerd8n14mkHauBYECEq7E638k97OWg8NRAZjUaam2wXcbrHCrN6+
         H34oxGhXnHuSTRUKqZlt7iBgABtM/qNtfpt1oCmKE2xcyh+ZTgty7zdisxsqPmQW1njy
         lJ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=45RQdk/Pt1OwbmIBrWKLRwNWhtjQa23QL11BAFqftYk=;
        b=Vza3ZtxtqsH6slc7dKbzIkSRV020fkzGc1Nc5U9khhny+BqFnKa9JbXFevWxRH8WXh
         GjyZCv5LI1cYgKm+InX67jLgSdTx6PcUruokPoyW9tgIV1cCMUmsjdlMnAxFjXunkbDa
         MuVZtA+gNVQof7191gzs4FyCU4pNoZGr0eqlORCBIfNqGNtBZ3qJCHTD/aXzO0wZ5kJP
         MfcheVdQr1P+ve5lwXqJP5GBkusuR8Brhew+t/Sh/47Oe99uRSisuPA1HU6GEO+oD27z
         +OuVhpAPZuP/J3ITjorQMa1IfS0i43581EQaO5PVZwmGhUPnzGca3jyVdZ51tVoTA5JI
         gpIA==
X-Gm-Message-State: ANoB5pmVDMMQq65StLi1CLJociajXpkj8YsZKYaDrSfvv4A0fYEK8arx
        BEkEqmvNaCP4Z5i1Fd0xajK1yw==
X-Google-Smtp-Source: AA0mqf7NZW3hYUAiFV+ERydRLogNcS7jgs53ctybgx2mB/1dT6V4jw6XA11TfWyAKzoVaJUYMnjWig==
X-Received: by 2002:a05:6a20:a6a0:b0:af:6d54:239a with SMTP id ba32-20020a056a20a6a000b000af6d54239amr116181pzb.38.1670983669765;
        Tue, 13 Dec 2022 18:07:49 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id d3-20020a17090a6f0300b00213ee5a12c9sm162351pjk.55.2022.12.13.18.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 18:07:49 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p5HBS-008AfK-PV; Wed, 14 Dec 2022 13:07:46 +1100
Date:   Wed, 14 Dec 2022 13:07:46 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 08/11] xfs: don't enable large folios on fs-verity
 sealed inode
Message-ID: <20221214020746.GH3600936@dread.disaster.area>
References: <20221213172935.680971-1-aalbersh@redhat.com>
 <20221213172935.680971-9-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213172935.680971-9-aalbersh@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 13, 2022 at 06:29:32PM +0100, Andrey Albershteyn wrote:
> fs-verity doesn't work with large folios. Don't enable large folios
> on those inode which are already sealed with fs-verity (indicated by
> diflag).
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fs/xfs/xfs_iops.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index b229d25c1c3d6..a4c8db588690e 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1294,7 +1294,12 @@ xfs_setup_inode(
>  	gfp_mask = mapping_gfp_mask(inode->i_mapping);
>  	mapping_set_gfp_mask(inode->i_mapping, (gfp_mask & ~(__GFP_FS)));
>  
> -	mapping_set_large_folios(inode->i_mapping);
> +	/*
> +	 * As fs-verity doesn't support folios so far, we won't enable them on
> +	 * sealed inodes
> +	 */
> +	if (!IS_VERITY(inode))
> +		mapping_set_large_folios(inode->i_mapping);
>  
>  	/*
>  	 * If there is no attribute fork no ACL can exist on this inode,

Looks reasonable to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
