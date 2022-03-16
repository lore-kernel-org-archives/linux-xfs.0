Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B5C6C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 18:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354237AbiCPSv4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 14:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357772AbiCPSvz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 14:51:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C71B16E29D
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 11:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647456639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/UtpTV2UM5hD+2bhl95A0SONELztR0PfRVAcarR3ChU=;
        b=chPZyyeWpWsdMEWgH2aOfSs4BUKU922hNeO8X9DK9MJxneb+rJU47Qd1fTainDTeYNDf0N
        fGPFz7+zEkkBTYPexmY3JM6IzWxnOOL8UCjtk9GVR01eNd2tQhKc2JIHKZh1yZ1IQQJgnn
        z5M89Uw0mMS3LWsdFLSK8wdNQC78hcY=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-tz8nAb4QNlKJZ14fd9LGbg-1; Wed, 16 Mar 2022 14:50:38 -0400
X-MC-Unique: tz8nAb4QNlKJZ14fd9LGbg-1
Received: by mail-io1-f71.google.com with SMTP id u10-20020a5ec00a000000b00648e5804d5bso1818090iol.12
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 11:50:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=/UtpTV2UM5hD+2bhl95A0SONELztR0PfRVAcarR3ChU=;
        b=rxk3VbeFJW6iwxm/cO7iZHf34tOiQKk3QmwvW3om4MmRX+bM1q97aTyroNat9+hBQj
         MvhnJTxYrvx/UITQNXkzbGLyN5zAeWKhd6OZwAiIwA5AgYT7CLPsKiZydMVEJViVKcup
         GrG2xXp3v2YvFKOp0scJU1TNKm7jY5kxMAvcW9pjhJL/XlzHK4o4OkTQel6mhvhHqnBJ
         bfh9l8+c5xZeIgLV8LdJ+MujJFJrE4nn6fUZS+I4OqFW43tF61AJjpICupZoNJIlQMF4
         62kmjNK+yoHrgogzAV6jE09oGPw+TdGMh2UiNsaB/xeEAAAtUWQDp7ihZYurWRfyVK5r
         VVKQ==
X-Gm-Message-State: AOAM531ID8Z6vK3liUlAUjXYO96CgvSW/LiG21BOIrsPWOdrvgs+I5qO
        IRJBRg8zzfHFyiW2DPqs7/qjwUHuE1NsewqMggfq+ZfJVVCvGl7BYIHU2c7uKt6TacpQ60rFcPX
        8ydyqnAymI4FwUseJuOm5
X-Received: by 2002:a05:6e02:1a24:b0:2c7:7bd0:814f with SMTP id g4-20020a056e021a2400b002c77bd0814fmr413444ile.83.1647456637636;
        Wed, 16 Mar 2022 11:50:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzvaQIZyvuIkPBRMcZrRukuVWiAphPvN80TR4XUGUrpZQ42s8+GaYZ+BsbncjwSHSG9pV+Dw==
X-Received: by 2002:a05:6e02:1a24:b0:2c7:7bd0:814f with SMTP id g4-20020a056e021a2400b002c77bd0814fmr413438ile.83.1647456637366;
        Wed, 16 Mar 2022 11:50:37 -0700 (PDT)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id d16-20020a05660225d000b00645c8db7767sm1410208iop.35.2022.03.16.11.50.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 11:50:36 -0700 (PDT)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <822cdfdc-358f-669e-d2db-31745643d614@redhat.com>
Date:   Wed, 16 Mar 2022 13:50:35 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 2/5] mkfs: don't let internal logs consume more than 95%
 of an AG
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
References: <164738660248.3191861.2400129607830047696.stgit@magnolia>
 <164738661360.3191861.16773208450465120679.stgit@magnolia>
In-Reply-To: <164738661360.3191861.16773208450465120679.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/15/22 6:23 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, we don't let an internal log consume every last block in an
> AG.  According to the comment, we're doing this to avoid tripping AGF
> verifiers if freeblks==0, but on a modern filesystem this isn't
> sufficient to avoid problems.  First, the per-AG reservations for
> reflink and rmap claim up to about 1.7% of each AG for btree expansion,

Hm, will that be a factor if the log consumes every last block in that
AG? Or is the problem that if we consume "most" blocks, that leaves the
possibility of reflink/rmap btree expansion subsequently failing because
we do have a little room for new allocations in that AG?

Or is it a problem right out of the gate because the per-ag reservations
collide with a maximal log before the filesystem is even in use?

> and secondly, we need to have enough space in the AG to allocate the
> root inode chunk, if it should be the case that the log ends up in AG 0.
> We don't care about nonredundant (i.e. agcount==1) filesystems, but it
> can also happen if the user passes in -lagnum=0.
> 
> Change this constraint so that we can't leave less than 5% free space
> after allocating the log.  This is perhaps a bit much, but as we're
> about to disallow tiny filesystems anyway, it seems unlikely to cause
> problems with scenarios that we care about.

This is only modifying the case where we automatically calculated a
log size, and doesn't affect a manually-specified size. Is that
intentional? (I guess we already had this discrepancy, whether it was
the old "-1" heuristic or the new "95%" heuristic...

But 5% is likely to be a fair bit bigger than 1 block, so I'm wondering
if the manually-specified case needs to be limited as well.

Thanks,
-Eric

