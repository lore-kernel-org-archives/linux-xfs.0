Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 165E6C77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 19:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbjFETAJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 15:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbjFES75 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 14:59:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D833EC
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 11:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685991551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EEyYVTiGw3OlrG8jSICt8MG1vJ0jvDwR1X9zlI6s70I=;
        b=B4tfSEOI8pbXyfXSPy1SC0pxnFPsscVl4L+iRPhScBFTKX2Z+Z3tPoohgwqFaIl+FqZg3i
        Mhl+gGKcV51drtXDvXsy/dxD9yXD9OPBZfvX2uGXBg1PUTjrSS1DbQuZelk9GWuigQ2iSQ
        aBfgAIt+BhtyCylE7NOX3nUUdpfq0C0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-afy-KAcPNheIT5TJN-OwSQ-1; Mon, 05 Jun 2023 14:59:10 -0400
X-MC-Unique: afy-KAcPNheIT5TJN-OwSQ-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-3f6bb50f250so64396311cf.3
        for <linux-xfs@vger.kernel.org>; Mon, 05 Jun 2023 11:59:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685991549; x=1688583549;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EEyYVTiGw3OlrG8jSICt8MG1vJ0jvDwR1X9zlI6s70I=;
        b=blZXaK44uOmByQ9t0f1FXpmcZHi/ktpl/6rjYoavlyT3ouHQ8APVE28GeRifgXf+OR
         GmTFv/IyaQ+IX2RlR6rWgUg0cpLrij8f9jf8MkQSL+Tdfe+GjB5CRicGUiw/+nCWYJZj
         8NDt4nDQamQIONtEyRBaRQp+Mh7YSNY+g2SlDbunHZxD63qm5V+yRexlQullND8iUIdl
         cNZJV9/6Qkyz5udE6ruroNRC33Jdf1o8MlUZWzbvrLKceAsuyGB9k7A2WiXWpjysj3HX
         R5EzI+KAyM3s4ePoAl61qjWaFSKRpBvKF1Qv5/zhEfc6Hz5qfqgFoMW2wBR1zvjcwfpW
         wblg==
X-Gm-Message-State: AC+VfDxUU7TAHGsXauKuSQmSM4EnLVYpAOjNZUn9fYTyobKWemGvAo3v
        S24aTLFKfhFwQYuuYxL/Q4hsr809B9YqbbvwgakHnka4wYqMNNmvWyhuKTecmZsxVw37YmQDXfB
        eT6NlImxKInpKiTgK62aV
X-Received: by 2002:a05:6214:2687:b0:626:3bb1:b9b3 with SMTP id gm7-20020a056214268700b006263bb1b9b3mr9693199qvb.4.1685991549734;
        Mon, 05 Jun 2023 11:59:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5OUyXN7w3MaZS5peUuKUSLCo/YuBwBr2BrhjK2kpP/42Suo64iI7uuXUq5uFMsqkqV8ypCww==
X-Received: by 2002:a05:6214:2687:b0:626:3bb1:b9b3 with SMTP id gm7-20020a056214268700b006263bb1b9b3mr9693187qvb.4.1685991549510;
        Mon, 05 Jun 2023 11:59:09 -0700 (PDT)
Received: from [192.168.1.103] (gw19-pha-stl-mmo-2.avonet.cz. [131.117.213.218])
        by smtp.gmail.com with ESMTPSA id lw4-20020a05621457c400b006238b37fb05sm4797722qvb.119.2023.06.05.11.59.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 11:59:08 -0700 (PDT)
Message-ID: <40c48265-52da-6015-475a-f396cebc1fa3@redhat.com>
Date:   Mon, 5 Jun 2023 20:59:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCHSET 0/5] xfs_repair: fix corruption messaging with verbose
 mode
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
References: <168597945354.1226461.5438962607608083851.stgit@frogsfrogsfrogs>
From:   Pavel Reichl <preichl@redhat.com>
In-Reply-To: <168597945354.1226461.5438962607608083851.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Whole patchset LGTM & Builds

Reviewed-by: Pavel Reichl <preichl@redhat.com>

