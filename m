Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC3B6E743ED
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Sep 2023 05:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjI2FXz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Sep 2023 01:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjI2FXy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Sep 2023 01:23:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942F4195
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 22:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695964985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rT7q5ABhiXi4cAWfRmu0uabBW3kY7SYwhq6pFjVOpGs=;
        b=HXGEIbHKm48T9fftdexDhTJiZToGL7c/Ucca1MbGPklE4Qw6y0Q/NuU1rxR/aOOKL+WUoC
        4JgmX87xc98AhMoOrznxprlsfNYISLeu8J3TI8TC9maP5aaTlG7av3pQSkgO+yDeGiIA7z
        /HxKYm9ADbxDLmZBdPCky5UMaBiFR8M=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-p-yC5vTbMdWSLVD5o6D3Wg-1; Fri, 29 Sep 2023 01:23:04 -0400
X-MC-Unique: p-yC5vTbMdWSLVD5o6D3Wg-1
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-6c638c29c8eso1066474a34.1
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 22:23:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695964983; x=1696569783;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rT7q5ABhiXi4cAWfRmu0uabBW3kY7SYwhq6pFjVOpGs=;
        b=hNsKedHI5VvOTKmUBNegcrjtH4fqzapB/s7ZzQ+j4zZNENy/577YHB8703Xmwock58
         UCkJTC2J9g5l+6TIFjpXHwQyrVW0Pc7cLFBp9M7y0KOFK5V2HtukcjLxsJ1tKOf2Bjob
         2nMc919ZegQMBxqvUtJcq3APRtyJqB58M81DJL0CA01axzrcASUcv876qy6Ux7tIjMMY
         H+O1Xz5MJNa0390n4nvgEyRyfx8kc8KAuI26RiHC2sUT8MGuUscJEuqDeVffKbuoSPsY
         9jvgNRyWgpoOkXixcgDg+gjFQCuvNxOnOV/q2xznGCgA5Wh+jIPYra50fInqBDv2Fqh0
         Ytyw==
X-Gm-Message-State: AOJu0YzRLwPl0CZN8VW0V3QVPKzyFbU5iyxVLZbzisKDsY/Jjv3icAVx
        kuVgRL3Qu7UOEzk3irBHed4aviXR0XFkSO9xh3/cEdpdKfS0jH1CezZb4QVJGJ18G2b9Sj0mVTk
        7+TOipJaJAWvWAveza3uL
X-Received: by 2002:a05:6830:124b:b0:6bd:ba2c:fbbd with SMTP id s11-20020a056830124b00b006bdba2cfbbdmr3472489otp.20.1695964983522;
        Thu, 28 Sep 2023 22:23:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFiwhdDJHiM0VK32TkOIKuqOf5Pa+JVy4+/rQWRgR5FJFhd0Ro7XD8L+LRUodOp+KHLh3FXqw==
X-Received: by 2002:a05:6830:124b:b0:6bd:ba2c:fbbd with SMTP id s11-20020a056830124b00b006bdba2cfbbdmr3472486otp.20.1695964983268;
        Thu, 28 Sep 2023 22:23:03 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id p27-20020a63741b000000b0056c2de1f32esm11863594pgc.78.2023.09.28.22.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 22:23:02 -0700 (PDT)
Date:   Fri, 29 Sep 2023 13:22:59 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs/270: update commit id for _fixed_by tag.
Message-ID: <20230929052259.7umlz236g3o4su6r@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <169567817047.2269889.16262169848413312221.stgit@frogsfrogsfrogs>
 <169567817607.2269889.5897696336492740125.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169567817607.2269889.5897696336492740125.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 25, 2023 at 02:42:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Update the commit id in the _fixed_by tag now that we've merged the
> kernel fix.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/270 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/270 b/tests/xfs/270
> index 7d4e1f6a87..4e4f767dc1 100755
> --- a/tests/xfs/270
> +++ b/tests/xfs/270
> @@ -17,7 +17,7 @@ _begin_fstest auto quick mount
>  
>  # real QA test starts here
>  _supported_fs xfs
> -_fixed_by_kernel_commit xxxxxxxxxxxx \
> +_fixed_by_kernel_commit 74ad4693b647 \
>  	"xfs: fix log recovery when unknown rocompat bits are set"

This patch is good to me, but we have more xfs cases have fixed commit which
have been merged:

$ grep -rsni xxxxxxxx tests/xfs|grep _fixed
tests/xfs/600:23:_fixed_by_git_commit kernel XXXXXXXXXXXXX \
tests/xfs/557:21:_fixed_by_kernel_commit XXXXXXXXXXXX \
tests/xfs/270:20:_fixed_by_kernel_commit xxxxxxxxxxxx \

xfs/600: cfa2df68b7ce xfs: fix an agbno overflow in __xfs_getfsmap_datadev
xfs/557: 817644fa4525 xfs: get root inode correctly at bulkstat

Do you want to fix them in one patch, or you hope to merge this
patch at first?

Thanks,
Zorro


>  # skip fs check because superblock contains unknown ro-compat features
>  _require_scratch_nocheck
> 

