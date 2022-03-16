Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB355C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 18:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239661AbiCPSLY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 14:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353512AbiCPSLY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 14:11:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B5AF527E0
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 11:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647454208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jmH5e+rszrJ83tL98TZ6JUKiBJ/2ckGWjAX2jbuCI0c=;
        b=i3HhQgCfQ0liuzimSdODhHbOdQiDoTcUBdaEufNcbxYdRvSTO2OgCdTjSba9ymzt569d2n
        WNC7aB4tn+Z/RwnYyxSDbegcmDG24xurLpGo8O0QzGFLn4u+BXdrHon3T3iXavGfcwx6x9
        0YoyScGtaO9hj1Zk+SsZAUlWPWKyThY=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-C_hwSqBnNY-rNaYX5NAqzQ-1; Wed, 16 Mar 2022 14:10:07 -0400
X-MC-Unique: C_hwSqBnNY-rNaYX5NAqzQ-1
Received: by mail-il1-f200.google.com with SMTP id k5-20020a926f05000000b002be190db91cso1701414ilc.11
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 11:10:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=jmH5e+rszrJ83tL98TZ6JUKiBJ/2ckGWjAX2jbuCI0c=;
        b=MRO/8jgj4Pd0MjGXv4gvwpDKBYn0rar50wN6LpPMfQSOWKKjV41XCx2MdSEvy+89XG
         2wIbWeRvOMcWT70LyW0DlqTwJ10bWaTy0QOFdESZ4Yk+vGvte7Zc1RyXeEligbYudRfx
         QIzZHQdt/qSHWtKTERhErn04EVxcnVzHQxs8j50hmCZKKyTHJcnTGPdk26X23I3hqU2+
         kupi5icnFicfo9nzQPI8rcOPvYDDHEIf6bYR8owvBoEjcDpFQDqGnAgbnsmGVEPA0cg6
         Uvep2YMyQ4AaRHIk+GK4E51gjcH2/XN5+OLMcYB6PsY+ke1FFOFN10+c840d2BWdvKiP
         JCfA==
X-Gm-Message-State: AOAM532BejCLpSstgcYoLS7Fga0QFHO9UHhQLE2kIq3bPjeKk6HJTB6e
        rdx4+DKpjkAEJ4JGz2H+hxw4XtWeFhRIinCaSGb46P/8CrW5ojGnW9W3qYb1DI52J2itPMW7xQa
        FqNfgYcM0VjMKPynUTgXX
X-Received: by 2002:a05:6638:31d:b0:319:af5b:7b0d with SMTP id w29-20020a056638031d00b00319af5b7b0dmr371759jap.176.1647454206330;
        Wed, 16 Mar 2022 11:10:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxOUnaeXf6MQMb32P6sWaSddpatUvCzlrPtRlqOGC3wquqcBzchx7qTW2rXRBNpfmv1mXLlg==
X-Received: by 2002:a05:6638:31d:b0:319:af5b:7b0d with SMTP id w29-20020a056638031d00b00319af5b7b0dmr371748jap.176.1647454206048;
        Wed, 16 Mar 2022 11:10:06 -0700 (PDT)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id b25-20020a5d8059000000b00644ddaad77asm1363447ior.29.2022.03.16.11.10.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 11:10:05 -0700 (PDT)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <2da6c114-34d1-cf0b-07e5-e21da6c387db@redhat.com>
Date:   Wed, 16 Mar 2022 13:10:04 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 2/2] xfs_scrub: retry scrub (and repair) of items that are
 ok except for XFAIL
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
References: <164738658769.3191772.13386518564409172970.stgit@magnolia>
 <164738659907.3191772.7906348523548262156.stgit@magnolia>
In-Reply-To: <164738659907.3191772.7906348523548262156.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/15/22 6:23 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Sometimes a metadata object will pass all of the obvious scrubber
> checks, but we won't be able to cross-reference the object's records
> with other metadata objects (e.g. a file data fork and a free space
> btree both claim ownership of an extent).  When this happens during the
> checking phase, we should queue the object for a repair, which means
> that phase 4 will keep re-evaluating the object as repairs proceed.
> Eventually, the hope is that we'll fix the filesystem and everything
> will scrub cleanly; if not, we recommend running xfs_repair as a second
> attempt to fix the inconsistency.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

I'm not a scrub-master, but this seems to make sense.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

