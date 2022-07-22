Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA3AC43334
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jul 2022 20:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236161AbiGVUUj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Jul 2022 16:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236812AbiGVUUj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jul 2022 16:20:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5CE8F1EAE8
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jul 2022 13:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658521237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H1askPVuIjPbZ/EEmpk/k7Fpq9HEtgzmyzToUW1b4UE=;
        b=h5H+FspC/DgNlAE7OUT0MGG08r9TKJRtISgrF4Uu0T2Fbq+XRnC/UDOH7MR+7DqKiaHBb8
        qC9JnUvaMB8vZ+glmsYT28FubC+j4dQRIZi3qPyHGEYGcq8rQQPltsBqnQ1oxmKDGG9Doo
        j8P8zVeDlWI0VzMcyrCS3d16N7oz+Ds=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-263-3VtPlO3CNGmOJTs-WQSbJg-1; Fri, 22 Jul 2022 16:20:36 -0400
X-MC-Unique: 3VtPlO3CNGmOJTs-WQSbJg-1
Received: by mail-il1-f197.google.com with SMTP id g8-20020a92cda8000000b002dcbd57f808so3316235ild.4
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jul 2022 13:20:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=H1askPVuIjPbZ/EEmpk/k7Fpq9HEtgzmyzToUW1b4UE=;
        b=6xyppJTVkGdAOLxzaaHMnUGeZD2Ypw/jp2Q903bXZczwIrOZFQFSpBQZBafdjyMsPs
         9lUQwoHudnDa/EREcms0qjbPRtwGqot529owVxJ1KYuaMwv3c3ZP4gZk+HvWesbJGklt
         8jkbRCK32v0vuneExcqcTXv9gHT9nXi2ggGKcJoLmsqctOJlrqs+GiFzoNipib8tCnKq
         yxxLaVV683JNYsqloQ9CFcXUKJTXLd1Qtp/gtW4KR18thbdISPehBHOFkMnjJbbsmCdb
         oS5tOQgtVDAukY9bMfIGyC5P13MKqjbhXdFLE/zl2TzYVrt+IXzILEmB+kEbUtuw9bbd
         MN5Q==
X-Gm-Message-State: AJIora846shGq1dQ7Asxm4qJ1OjdQvi76MuP5vba0JMiAFUtvi7Qc5vR
        pcy7tWlnT8MsAchWcizq3ra4hocL0pGyeAqTfHGLCpDWmTFP/c/t8SPLVTP/njP+mbl486o6nmx
        FwbyB+MeLQfI0G4jcWhE3
X-Received: by 2002:a05:6602:379b:b0:67c:70d6:614c with SMTP id be27-20020a056602379b00b0067c70d6614cmr524451iob.2.1658521235464;
        Fri, 22 Jul 2022 13:20:35 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s/HKPmV8e/aqgMYfZNsaxwLTAnGZ2Lsayz8+R5S9SbY2S+qKAt4tUx28m1ulwuWZ0NJKu0Ug==
X-Received: by 2002:a05:6602:379b:b0:67c:70d6:614c with SMTP id be27-20020a056602379b00b0067c70d6614cmr524444iob.2.1658521235260;
        Fri, 22 Jul 2022 13:20:35 -0700 (PDT)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id v3-20020a056e020f8300b002dd0926ee02sm2070930ilo.34.2022.07.22.13.20.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 13:20:34 -0700 (PDT)
Message-ID: <c0cc00bd-9904-9ede-26b2-66737acffaf2@redhat.com>
Date:   Fri, 22 Jul 2022 15:20:32 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH] xfs: Fix comment typo
Content-Language: en-US
To:     Xin Gao <gaoxin@cdjrlc.com>, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220722194328.18365-1-gaoxin@cdjrlc.com>
From:   Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <20220722194328.18365-1-gaoxin@cdjrlc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/22/22 2:43 PM, Xin Gao wrote:
> The double `that' is duplicated in line 575, remove one.
> 
> Signed-off-by: Xin Gao <gaoxin@cdjrlc.com>
> ---
>  fs/xfs/xfs_trans.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 82cf0189c0db..d055b0938eb9 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -572,7 +572,7 @@ xfs_trans_apply_sb_deltas(
>   * xfs_trans_unreserve_and_mod_sb() is called to release unused reservations and
>   * apply superblock counter changes to the in-core superblock.  The
>   * t_res_fdblocks_delta and t_res_frextents_delta fields are explicitly NOT
> - * applied to the in-core superblock.  The idea is that that has already been
> + * applied to the in-core superblock.  The idea is that has already been
>   * done.
>   *
>   * If we are not logging superblock counters, then the inode allocated/free and

NAK

The comment is correct

