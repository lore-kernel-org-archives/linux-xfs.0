Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F69AC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 14:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiJMOzZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 10:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJMOzY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 10:55:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462B3AA353
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 07:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665672922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qWUmYZh4xYf2XMKoXQm+CFqb+G2yigbGg+qhtVxZcdI=;
        b=RNrilNukz093VxknR8a5vO3wjkTS66+cASpH7OejpCI9kH5MoQT1hF3E6wS3Vm5shA14ZF
        oEm5LY8sLLKmHubCY7w99N5z187vpv5/KRQySUKT2N9v53YcNdcotC7Ps2zuC0wJBp5CQo
        DazDjjttMyw3Hmmpt+tqUyDTImEVMbs=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-246-FUeCqZk2NlyOA-LgsU5Qig-1; Thu, 13 Oct 2022 10:55:21 -0400
X-MC-Unique: FUeCqZk2NlyOA-LgsU5Qig-1
Received: by mail-qv1-f71.google.com with SMTP id q17-20020a056214019100b004b1d3c9f3acso1536801qvr.0
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 07:55:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qWUmYZh4xYf2XMKoXQm+CFqb+G2yigbGg+qhtVxZcdI=;
        b=Kg4DNNdNxviLoq6kJQsvvhlwfLJDOq2LZ0CSG6fYoOjdq85XxtMYwhSGsALu1hfYL2
         6AOO9tFnYTXxow2bzZTQwibiriDG9SyffkdM/fplH98MV0rdQ/hq5N9e7pVT1KzUCFfF
         C6InPrycE/28vOaumuohJTXnRIDJrFoApWOuKXrp2MfkgCvDUnekIm5G1AZ+9HKP2ZKg
         LsEjhef+p79EImPVBqvL0E5/rIM2neU4Q7Uq747hhPxYr34TNvOqfmf0Viw22hC2y1ke
         p7GRE/NKaMEphXeyNOwfrsyGAsCio9q6lP+tLKRxMdQVrD3NBPF+PhWgPpw16RbEUlIA
         klDw==
X-Gm-Message-State: ACrzQf1QD7b7zZFH7TYtd6L4ERmOkK+Jl6Od9HrYihVSrihBKrf6yExt
        hTO26Qg+aF7WY1K2tzNSFf4BZmb3JowUBGDlw7JtEMCvSinIEng1J3nVAs+DBQ9M12+cuKybvXt
        dqAN/4DsbsSAwDz5yedPf
X-Received: by 2002:a05:620a:244d:b0:6ee:7a23:dfa6 with SMTP id h13-20020a05620a244d00b006ee7a23dfa6mr201939qkn.463.1665672920755;
        Thu, 13 Oct 2022 07:55:20 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5ir6m2yoz+N0yyWHfzNwH0C4fGM0YB8nV7wQImXPL0mtWxZxrvVMr4r7y03MQSm9Vz+m0F2A==
X-Received: by 2002:a05:620a:244d:b0:6ee:7a23:dfa6 with SMTP id h13-20020a05620a244d00b006ee7a23dfa6mr201932qkn.463.1665672920534;
        Thu, 13 Oct 2022 07:55:20 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id t12-20020a37aa0c000000b006eeb25369e9sm2648279qke.25.2022.10.13.07.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 07:55:20 -0700 (PDT)
Date:   Thu, 13 Oct 2022 22:55:15 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/5] populate: export the metadump description name
Message-ID: <20221013145515.2vx3xy6hnf37777o@zlang-mailbox>
References: <166553912229.422450.15473762183660906876.stgit@magnolia>
 <166553912788.422450.6797363004980943410.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166553912788.422450.6797363004980943410.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 11, 2022 at 06:45:27PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Not sure why this hasn't been broken all along, but we should be
> exporting this variable so that it shows up in subshells....

May I ask where's the subshell which uses $POPULATE_METADUMP?

> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/populate |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/common/populate b/common/populate
> index cfdaf766f0..b501c2fe45 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -868,9 +868,9 @@ _scratch_populate_cached() {
>  	local meta_tag="$(echo "${meta_descr}" | md5sum - | cut -d ' ' -f 1)"
>  	local metadump_stem="${TEST_DIR}/__populate.${FSTYP}.${meta_tag}"
>  
> -	# These variables are shared outside this function
> -	POPULATE_METADUMP="${metadump_stem}.metadump"
> -	POPULATE_METADUMP_DESCR="${metadump_stem}.txt"
> +	# This variable is shared outside this function
> +	export POPULATE_METADUMP="${metadump_stem}.metadump"
> +	local POPULATE_METADUMP_DESCR="${metadump_stem}.txt"

If the POPULATE_METADUMP_DESCR is not shared outside anymore, how about change
it to lower-case?

>  
>  	# Don't keep metadata images cached for more 48 hours...
>  	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"
> 

