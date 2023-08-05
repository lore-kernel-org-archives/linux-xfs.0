Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED5C4C04A94
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Aug 2023 13:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjHENws (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Aug 2023 09:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjHENws (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Aug 2023 09:52:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97529E4A
        for <linux-xfs@vger.kernel.org>; Sat,  5 Aug 2023 06:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691243515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E97UB8xbtwjBZ/700mdBa45izV7GQAIkEwB+bI/3Wb0=;
        b=B/Vp6uCn3g/OBYpeqqsLoLSOep5daQjYIZNKsf9KivvEgeoM1jyjTFUz/yrkemR2sd2oVC
        l5JSD4kqV42UOjJj2hMKpDc93JGwFDkiB8Re3uRaJk/X7nJWjc+V5s8Lgli4CTqxzNLXoW
        qHGZTYSxX6FusiHwfEGGVQXnKkTSffg=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-6cQtGDIkNQWr6g071dpAJQ-1; Sat, 05 Aug 2023 09:51:53 -0400
X-MC-Unique: 6cQtGDIkNQWr6g071dpAJQ-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-563379fe16aso2791162a12.3
        for <linux-xfs@vger.kernel.org>; Sat, 05 Aug 2023 06:51:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691243513; x=1691848313;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E97UB8xbtwjBZ/700mdBa45izV7GQAIkEwB+bI/3Wb0=;
        b=katFVBo23/oh4kSkF2L6IWB3rIsmNSvupSuK9Up57z1IQjj1B+fNJlFE3QwY1FrKi6
         PPrzHO5KEBU9RBgnn7oZtmrUOfGyqb3eECnnHgsW5Oo8+7ncRrTDX/SqXkY65n2tyVI9
         JaRlWyqk2tl6auBQrUmB3lQgpyH4aEtte0PZfWI/Gx6OC9G8v+AOx1NF3hvopz5SWmlu
         BYbqWyhf5X/JCfw3lFlxmCwAxYD17g/zHZfADf4G0S4NDKkeeJ/F04sriyKPJ4HIbZPw
         7FqG8tFpeNNbIl8u/tMkWNq5hyd9aIMhPEn6YHScdXR0V+mvOPPW2qj4d7UDq4+DRuft
         Xs1g==
X-Gm-Message-State: AOJu0YwEQaisRHfPidoMKI4awlXYmBH4JgwXBbbG2t5fHFqXyGElbTJz
        C/z33W+wwoOZaDMaU/68DE9y1ZVIjWRmw5BdPGalC9KPhaoLXhPtpetqg2ZAQtfNdZrB2VjiZlP
        /ot5DU42VTGbQ77uQTV9u
X-Received: by 2002:a05:6a21:1f25:b0:11c:fc27:cda4 with SMTP id ry37-20020a056a211f2500b0011cfc27cda4mr4373066pzb.11.1691243512951;
        Sat, 05 Aug 2023 06:51:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGIgdN4FmyGZUI8Zo+TGqqCvqPGEnD+0QM/K2vkOXJiB8PLuymuquuDdeeliCO6s9X6SMcXoQ==
X-Received: by 2002:a05:6a21:1f25:b0:11c:fc27:cda4 with SMTP id ry37-20020a056a211f2500b0011cfc27cda4mr4373056pzb.11.1691243512585;
        Sat, 05 Aug 2023 06:51:52 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q24-20020a62e118000000b00679a4b56e41sm3182616pfh.43.2023.08.05.06.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Aug 2023 06:51:52 -0700 (PDT)
Date:   Sat, 5 Aug 2023 21:51:48 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: skip fragmentation tests when alwayscow mode is
 enabled, part 2
Message-ID: <20230805135148.rbk7uo7ldsxj7e56@zlang-mailbox>
References: <20230804213419.GO11340@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230804213419.GO11340@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 04, 2023 at 02:34:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If the always_cow debugging flag is enabled, all file writes turn into
> copy writes.  This dramatically ramps up fragmentation in the filesystem
> (intentionally!) so there's no point in complaining about fragmentation.
> 
> I missed these two in the original commit because readahead for md5sum
> would create large folios at the start of the file.  This resulted in
> the fdatatasync after the random writes issuing writeback for the whole
> large folio, which reduced file fragmentation to the point where this
> test started passing.
> 
> With Ritesh's patchset implementing sub-folio dirty tracking, this test
> goes back to failing due to high fragmentation (as it did before large
> folios) so we need to mask these off too.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Good to me, this patch is simple enough and no risk, will be inserted into
the release directly tomorrow.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/180 |    1 +
>  tests/xfs/208 |    1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/tests/xfs/180 b/tests/xfs/180
> index cfea2020ce..d2fac03a9e 100755
> --- a/tests/xfs/180
> +++ b/tests/xfs/180
> @@ -23,6 +23,7 @@ _require_scratch_reflink
>  _require_cp_reflink
>  _require_xfs_io_command "fiemap"
>  _require_xfs_io_command "cowextsize"
> +_require_no_xfs_always_cow
>  
>  echo "Format and mount"
>  _scratch_mkfs > $seqres.full 2>&1
> diff --git a/tests/xfs/208 b/tests/xfs/208
> index 9a71b74f6f..1e7734b822 100755
> --- a/tests/xfs/208
> +++ b/tests/xfs/208
> @@ -26,6 +26,7 @@ _require_scratch_reflink
>  _require_cp_reflink
>  _require_xfs_io_command "fiemap"
>  _require_xfs_io_command "cowextsize"
> +_require_no_xfs_always_cow
>  
>  echo "Format and mount"
>  _scratch_mkfs > $seqres.full 2>&1
> 

