Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 829B8C07E96
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jul 2021 07:23:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 592F161CE0
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jul 2021 07:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhGHH0O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Jul 2021 03:26:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60048 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229780AbhGHH0N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jul 2021 03:26:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625729012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2BoRKmdRLWbi/guWIRB+yl1calmlJ4Y+YdUeVgI1GuI=;
        b=Tp7WqQ3l3qq5YY9EuI3mLLAuESxwvADf+S3DbYaIk578lv8fqu7LHVoj8SmuCrJ8jF4jO0
        zkhpieU50X8XcptkdcWO9fo8tZhKdPwJ3gMesMOcXZQqYQAJCMIWuS6fwAR4+5CkqdeRlu
        hni+dVuCyje74UQ3iwzoiUZ05Kc43y4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-pHU_ML6kPJG0TMsgh66BYw-1; Thu, 08 Jul 2021 03:23:30 -0400
X-MC-Unique: pHU_ML6kPJG0TMsgh66BYw-1
Received: by mail-ed1-f70.google.com with SMTP id j15-20020a05640211cfb0290394f9de5750so2781012edw.16
        for <linux-xfs@vger.kernel.org>; Thu, 08 Jul 2021 00:23:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=2BoRKmdRLWbi/guWIRB+yl1calmlJ4Y+YdUeVgI1GuI=;
        b=IXcDQqB6D4Q459BtEolWT9BkHx6gB3aFYiPnRtdjRHkxTvAJvZyK2Yb30ZFpWw4AYK
         EEsbQOEwofxYyp/v+YqpnwKeXQppK+bez8LWyuYkzMcFExFciE7fKCAMX+l7Bdg+mT4/
         h//I4ql4v/QQk4RHhd8ghBCrXEFjCPw+H4eV1pPUB3LKjHScoSbQJIzdx0ECSpAS772+
         d85G+k0YauP6qnTTXtTQ3ePODMDiJiJC6qIfqOE9GOVTddKrN2Xt8U2c3OyA03WzFI5o
         klTj4SZfrNBzGQSuwZJFo2fpQeuLUxzZuZvGp2pXepdsiZjf9INBFD1cyRidRp10q3wH
         sEHA==
X-Gm-Message-State: AOAM532lY6sODFJiXK6u3m76s2cdygtJs0zmIcY4TsMLfs9x+vE3ULMg
        lpeXS/0YjcKMaO7LARtwzlkaRm71XQxo9ZnShw1oCznHOXIYTSTDU3zLidfGT/Fnkup+nJ/rNdM
        rjQ00bX4FJmARZiR+jZ5R
X-Received: by 2002:a17:907:9495:: with SMTP id dm21mr28604145ejc.526.1625729009616;
        Thu, 08 Jul 2021 00:23:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwk+vqsnCd6N5qF+AJPQsUPVDRcMUYiw2npOlNzbdgE4588HzsZfaIWetSKqk6O6E+bST5nYw==
X-Received: by 2002:a17:907:9495:: with SMTP id dm21mr28604129ejc.526.1625729009412;
        Thu, 08 Jul 2021 00:23:29 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id r23sm732339edv.26.2021.07.08.00.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 00:23:29 -0700 (PDT)
Date:   Thu, 8 Jul 2021 09:23:27 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_io: fix broken funshare_cmd usage
Message-ID: <20210708072327.tqe636obmab3w5o3@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <162528107717.36401.11135745343336506049.stgit@locust>
 <162528108265.36401.17169382978840037158.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162528108265.36401.17169382978840037158.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 07:58:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a funshare_cmd and use that to store information about the
> xfs_io funshare command instead of overwriting the contents of
> fzero_cmd.  This fixes confusing output like:
> 
> $ xfs_io -c 'fzero 2 3 --help' /
> fzero: invalid option -- '-'
> funshare off len -- unshares shared blocks within the range

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  io/prealloc.c |   17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/io/prealloc.c b/io/prealloc.c
> index 382e8119..2ae8afe9 100644
> --- a/io/prealloc.c
> +++ b/io/prealloc.c
> @@ -43,6 +43,7 @@ static cmdinfo_t fpunch_cmd;
>  static cmdinfo_t fcollapse_cmd;
>  static cmdinfo_t finsert_cmd;
>  static cmdinfo_t fzero_cmd;
> +static cmdinfo_t funshare_cmd;
>  #endif
>  
>  static int
> @@ -467,14 +468,14 @@ prealloc_init(void)
>  	_("zeroes space and eliminates holes by preallocating");
>  	add_command(&fzero_cmd);
>  
> -	fzero_cmd.name = "funshare";
> -	fzero_cmd.cfunc = funshare_f;
> -	fzero_cmd.argmin = 2;
> -	fzero_cmd.argmax = 2;
> -	fzero_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> -	fzero_cmd.args = _("off len");
> -	fzero_cmd.oneline =
> +	funshare_cmd.name = "funshare";
> +	funshare_cmd.cfunc = funshare_f;
> +	funshare_cmd.argmin = 2;
> +	funshare_cmd.argmax = 2;
> +	funshare_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> +	funshare_cmd.args = _("off len");
> +	funshare_cmd.oneline =
>  	_("unshares shared blocks within the range");
> -	add_command(&fzero_cmd);
> +	add_command(&funshare_cmd);
>  #endif	/* HAVE_FALLOCATE */
>  }
> 

-- 
Carlos

