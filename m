Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E7BCC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 18:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238425AbiCPSUC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 14:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237492AbiCPSUB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 14:20:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E8E6929CBF
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 11:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647454725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tp/svqAsXtLbGznQCb0nzhfamRETS5Inpu+xbQwP3zQ=;
        b=Dy9uppIsxGjVv9yTYpKMhuPXNk/anBEuFe/aRKvZLeEP4TvfMVfBXjJBQNBU1EzGCd6Yi2
        fxzYlc3NxinwEDjev9utWyVODPaAnVZvockF0jJQ8eOkfVMzfaF6nCb3n3+YN9LG5VOY6T
        7Snmq8S/9bamQeshztJOn3yXZXM6tzQ=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-LuESOUq0P8qaA3vLGLPLvw-1; Wed, 16 Mar 2022 14:18:43 -0400
X-MC-Unique: LuESOUq0P8qaA3vLGLPLvw-1
Received: by mail-il1-f197.google.com with SMTP id y18-20020a927d12000000b002c2e830dc22so1690718ilc.20
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 11:18:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=tp/svqAsXtLbGznQCb0nzhfamRETS5Inpu+xbQwP3zQ=;
        b=HSYBwWMB4SxvcYGvoCNeW/oj+jGIsnGbw+SlYt1VA9QtDol+XlsSfoDSFjyn1YkGV2
         T1kg38Zy52siIKX47QN3mk0j/7Yuc60eciDaYA1AMjQVp8QUsoLXhqeTxnBLS8FrFQo4
         5MKDVFaE7AnZD21nsbP4bCkGCX7eZ47zTtYlcudtX+qTjF1CCGfgnLU2reZMJ/EaFuAH
         K+PE2uB3lYMTbzBiuDSXq3H35aWrga2Af5MS2OWlA8LDpJbQ3ygROzjy1++sDvw1KSuH
         NwAIq9a33IgZ3zIaSmf3HZtZmd90eYrY3bAKB1QeHnJoI2BEtE5+FhrU6eKDSlrAeQlB
         rmHA==
X-Gm-Message-State: AOAM532DT2XhMp51AlRMO6eRcTRGLw7ZR43zPA1Xb2M12AW/Z7RnPbPa
        TAL9lFPvRYz+Hl56kk+xYpMfjaUZ/dOTsDSDov3pndH6d4xTkkGYnzi+Gcu5CBeOs4JnW/tWXGS
        8ipHgh9/F0pdvZuxZPyPj
X-Received: by 2002:a05:6e02:1a25:b0:2c6:5c9b:3951 with SMTP id g5-20020a056e021a2500b002c65c9b3951mr353658ile.81.1647454722971;
        Wed, 16 Mar 2022 11:18:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxi9d4ktsRiTJjqv1km+Ds71rm+WNy4TNHifXa2Pv2nVPqnJvUMa+44w5pBeOt7Z8jWkmRfaw==
X-Received: by 2002:a05:6e02:1a25:b0:2c6:5c9b:3951 with SMTP id g5-20020a056e021a2500b002c65c9b3951mr353652ile.81.1647454722741;
        Wed, 16 Mar 2022 11:18:42 -0700 (PDT)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id e18-20020a5d85d2000000b00649254a855fsm1323144ios.26.2022.03.16.11.18.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 11:18:42 -0700 (PDT)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <82e279f1-942c-6220-acc9-55f83a46effe@redhat.com>
Date:   Wed, 16 Mar 2022 13:18:41 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 1/5] mkfs: hoist the internal log size clamp code
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
References: <164738660248.3191861.2400129607830047696.stgit@magnolia>
 <164738660804.3191861.18340705401255216811.stgit@magnolia>
In-Reply-To: <164738660804.3191861.18340705401255216811.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/15/22 6:23 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Move the code that clamps the computation of the internal log size so
> that we can begin to enhnace mkfs without turning calculate_log_size
> into more spaghetti.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  mkfs/xfs_mkfs.c |   49 +++++++++++++++++++++++++++++--------------------
>  1 file changed, 29 insertions(+), 20 deletions(-)

no functional changes detected ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

