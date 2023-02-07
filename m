Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5057EC636CC
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Feb 2023 18:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbjBGSrg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Feb 2023 13:47:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbjBGSrU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Feb 2023 13:47:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F83733473
        for <linux-xfs@vger.kernel.org>; Tue,  7 Feb 2023 10:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675795593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X2XeUDSc5+zJsuSlSiabULeVAKK0BXLAlNRHeyKAxH8=;
        b=FNhaC3eSNzYCBAZZ0Fynb16CItvgiFtaGP/xkXuIhwChxECMRexf98P7NN2c5+UVEZT8kk
        bbPN+Ll1w5/vNG5RGgDmli2XFwft8TQS0uNT+IH6/l/kIHIu+QXkosnzZoM5JB0Uuk9nmZ
        j+G1qdh2pHZXd4JSvsazBeWOWQR50ck=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-48-tjQQBnGmNFS74HoXgLnMrQ-1; Tue, 07 Feb 2023 13:46:32 -0500
X-MC-Unique: tjQQBnGmNFS74HoXgLnMrQ-1
Received: by mail-pl1-f199.google.com with SMTP id q14-20020a170902eb8e00b00198d45368eeso7600760plg.23
        for <linux-xfs@vger.kernel.org>; Tue, 07 Feb 2023 10:46:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X2XeUDSc5+zJsuSlSiabULeVAKK0BXLAlNRHeyKAxH8=;
        b=CzNGR/D0g5jgJBJr8LbvbVkTJqWBNrfnpkEMomF/NjPn0zW2C3DkcrmwA5p1O+bDxW
         1twMkduNZdCrVQ7g+xMnFFU1sU7e/3/8eujpSedelYcGVEJOjHWAIX4luhDfF1HLnxa4
         cHE9Bws10UOeS/j7zNNvW41A4qQDta7hRZHte1qQ2Wabh6F513apdJT9SRZDOvNRl1NV
         sWwM5HYNcium0B5gO0Y1m84c98qB2AxzJoWMGWORf4t4XZ8il99sXvpAoS9qNfFTXEmH
         pcQdBsPkW1VZIuGurxk1oSSV7OhMYkT1DDhDNb9PFITrXkdCOl1Qx/UagKHsVLdQNkUl
         apiw==
X-Gm-Message-State: AO0yUKXTV30hY0Xi9uY+zHDoX4LBgVlGvsOeH7XIlEnvE/7+uLT5RyI4
        6FaA98QMEon9PLdpSrNYyeHxrMhz2w5WMPNAN0mrcMpRKcfWC0059u5YBtjtAZSRgqmjovLEijo
        O8Ht/qJIqMB1MFwaCN+x2s9pEvu8lEUY=
X-Received: by 2002:a17:902:d0d2:b0:199:1f12:87d2 with SMTP id n18-20020a170902d0d200b001991f1287d2mr2941095pln.42.1675795590206;
        Tue, 07 Feb 2023 10:46:30 -0800 (PST)
X-Google-Smtp-Source: AK7set+WJf8Ptm9Z1RBJ1TToICrC/Bb9Zdg7FXi1NJbuRI68h3z8+AJL/WMWiShAN/GvdweTGCTl4A==
X-Received: by 2002:a17:902:d0d2:b0:199:1f12:87d2 with SMTP id n18-20020a170902d0d200b001991f1287d2mr2941083pln.42.1675795589890;
        Tue, 07 Feb 2023 10:46:29 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ja18-20020a170902efd200b001990a94a487sm5275802plb.293.2023.02.07.10.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 10:46:29 -0800 (PST)
Date:   Wed, 8 Feb 2023 02:46:25 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs/357: switch fuzzing to agi 1
Message-ID: <20230207184625.rtdl42fzwfjksdva@zlang-mailbox>
References: <167243874614.722028.11987534226186856347.stgit@magnolia>
 <167243874627.722028.4085306307237352574.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167243874627.722028.4085306307237352574.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 30, 2022 at 02:19:06PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Since we now require a working AGI 0 to mount the system, fuzz AGI 1
> instead.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Looks good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/357 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/357 b/tests/xfs/357
> index 8a2c920ef4..25af8624db 100755
> --- a/tests/xfs/357
> +++ b/tests/xfs/357
> @@ -25,7 +25,7 @@ echo "Format and populate"
>  _scratch_populate_cached nofill > $seqres.full 2>&1
>  
>  echo "Fuzz AGI"
> -_scratch_xfs_fuzz_metadata '' 'online' 'agi 0' >> $seqres.full
> +_scratch_xfs_fuzz_metadata '' 'online' 'agi 1' >> $seqres.full
>  echo "Done fuzzing AGI"
>  
>  # success, all done
> 

