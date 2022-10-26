Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 763EAC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Oct 2022 20:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbiJZU6o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Oct 2022 16:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233706AbiJZU6n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 16:58:43 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A3C1217F6
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 13:58:42 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id g62so12678790pfb.10
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 13:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tw9DmtFMr03aK4CLShy9uwPUu924zdghLHaBMdz7StA=;
        b=F67rgSXXWFQXYc+Ck+qnq//4GSSDsZdsEQsZ2rbkQJsJMhXdmh1Mfa3FuBUXL+nesK
         +67LWzGR8ss8GKUet0uD9o65xyu4iTXdfzJTK49MSsNzoGxm6xsMWzyYAVzGKB4Gsc17
         Us2lsBOi3Wsgzkmesgsjz21tDPF7JDDTc9GvkYaQObTZtrK7Ml6YGm13He9Pl3vwJVm5
         n9ka5I20J+MLkSoVl5eV5xrC/wCjHVZHl1CtQfHZU2hkPexRPL2WIWpXeANb9Di0/MRr
         8O+19HbXNJA4+QJjUDm/tYHRC636lrotagDBXd6WyDJZVPWOAKkOCL8v7MkvZaGk4C+l
         NdEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tw9DmtFMr03aK4CLShy9uwPUu924zdghLHaBMdz7StA=;
        b=mJfVwDtPHvUGDk8fBXk5nx/sB27HqDr7NwojzYED26unyyzELGqL5FXyMzAc2H7mff
         J/x+Vq9kmTYWkmDdug20NpFf6YJPDj8xrZGNP/r5VWqNgaUY43NQCTlpeSD8mEpc+7kX
         rxs5Mlx+f+Dj8y+Z+EOiQ2Tt/bMkbCkDjscMAnmWzRabFL2rBdA3MzfLqmYYko1w0R4b
         20SwoqxWs3CBjVyvySjX72abAutsavBJTWrNmXnquKkur85zvnulU8jfMYJZ0WS3BIiz
         XGrYXcUMhhJp7cD7dI12rTnYXodE6lBLAI8IKeBtS9xjQ0UaoeAW4IfrwT65oVhft9Y/
         fB2g==
X-Gm-Message-State: ACrzQf3wjc0QBdkZS4vuQrYeXQfvx9RK/wB3uuJjvzQCiORSPaYOU6Ey
        ziQ7+XNG4TZkX3du9cXsNiYJk7XDlFOeqw==
X-Google-Smtp-Source: AMsMyM6YMKObSc6nqdN2VaE11I9SQytmsXtR251L4mhgDi7rctP5ntBzKymqVF0NzUul6YbHs0+nqQ==
X-Received: by 2002:a05:6a00:15cc:b0:563:a6be:6633 with SMTP id o12-20020a056a0015cc00b00563a6be6633mr421668pfu.30.1666817922202;
        Wed, 26 Oct 2022 13:58:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id x1-20020aa79561000000b005633a06ad67sm3404576pfq.64.2022.10.26.13.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 13:58:41 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1onnTy-006l4u-CJ; Thu, 27 Oct 2022 07:58:38 +1100
Date:   Thu, 27 Oct 2022 07:58:38 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: refactor all the EFI/EFD log item sizeof logic
Message-ID: <20221026205838.GN3600936@dread.disaster.area>
References: <166681485271.3447519.6520343630713202644.stgit@magnolia>
 <166681488665.3447519.1169617376665660236.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166681488665.3447519.1169617376665660236.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 26, 2022 at 01:08:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Refactor all the open-coded sizeof logic for EFI/EFD log item and log
> format structures into common helper functions whose names reflect the
> struct names.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> ---
....
> @@ -155,13 +144,11 @@ xfs_efi_init(
>  
>  {
>  	struct xfs_efi_log_item	*efip;
> -	uint			size;
>  
>  	ASSERT(nextents > 0);
>  	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
> -		size = (uint)(sizeof(struct xfs_efi_log_item) +
> -			(nextents * sizeof(xfs_extent_t)));
> -		efip = kmem_zalloc(size, 0);
> +		efip = kzalloc(xfs_efi_log_item_sizeof(nextents),
> +				GFP_KERNEL | __GFP_NOFAIL);

Yup, those allocations look right now :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
