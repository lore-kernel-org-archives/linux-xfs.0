Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F1EDC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 17:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350316AbiCPRvk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 13:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348621AbiCPRvk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 13:51:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EBD556CA41
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 10:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647453025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R86B1Cd5QvbPKD2MQNO9L5FOAxqYaMZbCz75S6HXYIQ=;
        b=cDmdwxUl0Ssb0S8krRhq6fFcKUKEB10AmVdPFSm3Awxy9SeGNWomR0lQ69xSbIO8sbPtE/
        Q1ZVMTOPztARyP1OFT3mNI1wFf+gFI1X7YuqWLzoMhV/cA9KCSKifNBjw16H9oNWEpFRG2
        cSj/vIO3gvvsC+tKBl6hTnFm90+lJww=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-Sq49-CdsN-ykJiZZT4aasg-1; Wed, 16 Mar 2022 13:50:23 -0400
X-MC-Unique: Sq49-CdsN-ykJiZZT4aasg-1
Received: by mail-il1-f199.google.com with SMTP id f18-20020a926a12000000b002be48b02bc6so1654740ilc.17
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 10:50:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=R86B1Cd5QvbPKD2MQNO9L5FOAxqYaMZbCz75S6HXYIQ=;
        b=6bgjownQndzv9xO5pRfcQuGWj0d5Hx4A2C67ggICvCaQ6fLUr1Oyytqs2+v/9DF3jg
         zuvk2vpbvvULQJ2yrCkLTEZNxKAhDKEvgHIPNq8b9uKH9m3cqRNR8jX5/94BE0/G9qGD
         6JIZAGk7B37NfP2jrClZxck56Rh9rb3BiT+RltK8NlZZc2Z75dgvkxbA607c6mRshc15
         LhVlCh6INm3ig4GSw2iqie3vvdPNhtV3SyOUGbarERjWgB61gIfRgTU/cmGitoJFQNV/
         nindj2/KT379uvGugVA2U0JBA9BiOgJgzrXshtv99ffMHXVm72h7FLWv/D6e08T/bIhw
         zPCA==
X-Gm-Message-State: AOAM530VGbWB4qNy4MHFbXfSE0g5CvKukfLrTA8V9sSNieCjzVeGf62i
        p0HuXkiXbwQgLzFwkmYECvsh0FT3mCoTPIOG+H0YGkIu1oOP0WsjTHE6MUBh2uyxA9zDERpsXQW
        e5XG6JlhPqIl3WxE3ImS8
X-Received: by 2002:a05:6638:1a12:b0:317:bdd9:e405 with SMTP id cd18-20020a0566381a1200b00317bdd9e405mr356794jab.28.1647453022836;
        Wed, 16 Mar 2022 10:50:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZs5UhI6cztBDL6FAd8D8h4Tei+DOn24LW+ZpgeiHDaXqL5vUVBoPzdlB2kYqL616xcLIgeQ==
X-Received: by 2002:a05:6638:1a12:b0:317:bdd9:e405 with SMTP id cd18-20020a0566381a1200b00317bdd9e405mr356786jab.28.1647453022590;
        Wed, 16 Mar 2022 10:50:22 -0700 (PDT)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id e3-20020a056e020b2300b002c7c4fb7400sm1555076ilu.8.2022.03.16.10.50.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 10:50:21 -0700 (PDT)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <d3be9080-3fca-9e4b-8eb5-4495df4c4040@redhat.com>
Date:   Wed, 16 Mar 2022 12:50:20 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 1/2] xfs_scrub: fix xfrog_scrub_metadata error reporting
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
References: <164738658769.3191772.13386518564409172970.stgit@magnolia>
 <164738659344.3191772.10477029754314882992.stgit@magnolia>
In-Reply-To: <164738659344.3191772.10477029754314882992.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/15/22 6:23 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Commit de5d20ec converted xfrog_scrub_metadata to return negative error
> codes directly, but forgot to fix up the str_errno calls to use
> str_liberror.  This doesn't result in incorrect error reporting
> currently, but (a) the calls in the switch statement are inconsistent,
> and (b) this will matter in future patches where we can call library
> functions in between xfrog_scrub_metadata and str_liberror.
> 
> Fixes: de5d20ec ("libfrog: convert scrub.c functions to negative error codes")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

wow how could you possibly have forgotten the difference between
str_errno, str_liberror, and str_error? ;)

So the net effect here is sending our own error, not errno. Looks right.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

