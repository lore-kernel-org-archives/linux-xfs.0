Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B6D9C433B4
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Apr 2021 10:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33827610D0
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Apr 2021 10:41:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbhDAKk7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Apr 2021 06:40:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30546 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233553AbhDAKki (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Apr 2021 06:40:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617273638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MtiouDf2YbF6Ko8LHYP21qq4Koys+qZRSH/r6v4C2fs=;
        b=Oi+o2PtwbfSVDLlSIQ4XrGfdlcSFkk84BY/SsuAjxamQ8qV8mt89zCCfpKHrnOKckVnxl2
        b1F6VpAGQ7i2HtUVpgTiQTmRSji1LEjKWvrWp/EYCiteUA0WX41XSb/eD/Y9IYj7p6V453
        kJ7lEWu1sy/u3GvuttCZEFY8WYBtD3g=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-EEzK2cOUMpG9AEfhyQcmLg-1; Thu, 01 Apr 2021 06:40:36 -0400
X-MC-Unique: EEzK2cOUMpG9AEfhyQcmLg-1
Received: by mail-ed1-f71.google.com with SMTP id a2so2633187edx.0
        for <linux-xfs@vger.kernel.org>; Thu, 01 Apr 2021 03:40:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=MtiouDf2YbF6Ko8LHYP21qq4Koys+qZRSH/r6v4C2fs=;
        b=flLe6mzhs9uEuVz6qFuCRHqXstVAIDtrTDFWh3QQaWB21mYuXf/b5GBz3fOGeqRUON
         k0HLX7ppiMZFwiuxrkQprfytRnz9dztJa+bYXMF1JHXjzr2rWYSAtZiUXewJX/54KFyY
         FvOP9Pbx+c5F24554rgzYaD5waWIqn/H0uPtkPJY/Py4xytUMeTX/XNdsCJHYb+c4sLs
         Cdd3ErdreFiq3EhjafIGXXRJ5tERkUmXI8Gz/ozkf35lunjXBYmX6VxOPnqBgtsBA4+3
         f40nwXinz3sRrD0Yg3R6uZZzq/5V9JDJTURTGbzFby3ABipfxoSscKlECmrVHiZm7Cyh
         Ijcg==
X-Gm-Message-State: AOAM531hLTFcAbwRPPOb0lzha28768WBknhj1KwE+O6Rgd9tuU03z9fY
        JsLBVpgGXVqKsGjlYZVFWeXxhyEam0rU65Q8ean51GITMp4zhvLnuLcwzbno8h0rYAViiQw3rnt
        q19WZqocn48UFagMNsrbvfOtCd9I+2ogBK82eHlXD7sZdoiqKGMB/0MlkubaUtTNidK610662YQ
        ==
X-Received: by 2002:a05:6402:1c86:: with SMTP id cy6mr8947001edb.276.1617273635311;
        Thu, 01 Apr 2021 03:40:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCFSHHqq6b+NPUb1tiQANGPvFYOQnavAWm8sCAmm/0BH38rgBk/zoVb8mZWRxq+++IJVlHAg==
X-Received: by 2002:a05:6402:1c86:: with SMTP id cy6mr8946979edb.276.1617273635026;
        Thu, 01 Apr 2021 03:40:35 -0700 (PDT)
Received: from andromeda.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id h17sm3203284eds.26.2021.04.01.03.40.33
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 03:40:33 -0700 (PDT)
Date:   Thu, 1 Apr 2021 12:40:31 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] Add dax mount option to man xfs(5)
Message-ID: <20210401104031.zovqwnucsvhkdncf@andromeda.lan>
Mail-Followup-To: linux-xfs@vger.kernel.org
References: <20210315150250.11870-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315150250.11870-1-cmaiolino@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 15, 2021 at 04:02:50PM +0100, Carlos Maiolino wrote:
> Details are already in kernel's documentation, but make dax mount option
> information accessible through xfs(5) manpage.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---

Polite ping :)


>  man/man5/xfs.5 | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
> index 7642662f..46b0558a 100644
> --- a/man/man5/xfs.5
> +++ b/man/man5/xfs.5
> @@ -133,6 +133,24 @@ by the filesystem.
>  CRC enabled filesystems always use the attr2 format, and so
>  will reject the noattr2 mount option if it is set.
>  .TP
> +.BR dax=value
> +Set DAX behavior for the current filesystem. This mount option accepts the
> +following values:
> +
> +"dax=inode" DAX will be enabled only on files with FS_XFLAG_DAX applied.
> +
> +"dax=never" DAX will be disabled by the whole filesystem including files with
> +FS_XFLAG_DAX applied"
> +
> +"dax=always" DAX will be enabled to every file in the filesystem inclduing files
> +without FS_XFLAG_DAX applied"
> +
> +If no option is used when mounting a pmem device, dax=inode will be used as
> +default.
> +
> +For details regarding DAX behavior in kernel, please refer to kernel's
> +documentation at filesystems/dax.txt
> +.TP
>  .BR discard | nodiscard
>  Enable/disable the issuing of commands to let the block
>  device reclaim space freed by the filesystem.  This is
> -- 
> 2.29.2
> 

-- 
Carlos

