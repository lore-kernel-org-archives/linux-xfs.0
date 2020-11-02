Return-Path: <SRS0=AlMJ=EI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C08EAC00A89
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 10:18:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D91A2225E
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 10:18:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K/Xf1PJ3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgKBKSi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 05:18:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24711 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728005AbgKBKSi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 05:18:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604312317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CeWbDhDo2Gw9STZku/FwuhApJ6x2gXsMqFCyGJfbl10=;
        b=K/Xf1PJ3xJkUYLZ+/2QqTXwrJRlVR1zMXn6uAgFmNJpJ7RVpffld+LTnnpDkrzy6iQ5rNx
        Y1IhPYvOThKkN3+TZHaZZcoaHOmx4zRLSJP7Wtxs4W/IO10y+b1CRizuv397DvszYvnx7F
        qlXhwubtHMlmD6/0NQ3D2HYKYd2WF8k=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-RYriyQcSNF238qzscoaorQ-1; Mon, 02 Nov 2020 05:18:35 -0500
X-MC-Unique: RYriyQcSNF238qzscoaorQ-1
Received: by mail-pg1-f197.google.com with SMTP id c9so5921719pgk.10
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 02:18:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CeWbDhDo2Gw9STZku/FwuhApJ6x2gXsMqFCyGJfbl10=;
        b=ZnkrAEaqm33I+mHdJIhnDgXwZ/uRl+LyBVFq2N+HG1N/2f3hqBWvfVFP8HBGsZrMMA
         ZzjCiEgtOHZoKifgoxF55sQntGeYW/iMIPVIr6EbxJyUxXhLlM2+/HRTV+B7a8I9sqSS
         vjhaaUUROPeIq9bQLOdM2rGnMDpwUSprJeJZ0sexZpIkt0Ul9eyHWycydll1FsSxtJuI
         zAeCrvV2OY5olMpu25Iq/tj+mFdGh34VIiQ9T/NTw8vBEfyLMQ16/9utBxuESK0wxNz3
         X7R3GN0Qlazigk3UHNGgFJTyXuTCuoP6qungp5jQWyvycbefs6YRZiKOLnI5M/AfI8us
         qFFw==
X-Gm-Message-State: AOAM533sc5XTXnC7pt/lPNkYTbtMopaujAs7q8uFWs+fsvTmWbTkXFTH
        taiAl1oLO6UEPRpPKlhK74+2wRWWXjr5KrGoiUigm2LL53gpFZiJgmqagkyolTxbw1JE0q841pb
        csEvhQuxOSqgWAQImeIXj
X-Received: by 2002:a17:90b:ec9:: with SMTP id gz9mr2252pjb.105.1604312314462;
        Mon, 02 Nov 2020 02:18:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyv4l97rHKve0rJVBYtslAqVYetcWb/r0FiLq7WgFhentaQYCLSKiGfb2B15AnpUT96uL6mNA==
X-Received: by 2002:a17:90b:ec9:: with SMTP id gz9mr2223pjb.105.1604312314203;
        Mon, 02 Nov 2020 02:18:34 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j5sm4426583pji.29.2020.11.02.02.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 02:18:33 -0800 (PST)
Date:   Mon, 2 Nov 2020 18:18:24 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC PATCH] xfsdump: fix handling bind mount targets
Message-ID: <20201102101824.GA661583@xiangao.remote.csb>
References: <20201102100120.660443-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102100120.660443-1-hsiangkao@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 02, 2020 at 06:01:20PM +0800, Gao Xiang wrote:
> Sometimes, it's not true that the root directory is always
> the first result from calling bulkstat with lastino == 0
> assumed by xfsdump.
> 
> Recently XFS_BULK_IREQ_SPECIAL_ROOT was introduced last year,
> yet that doesn't exist in old kernels.
> 
> Alternatively, we can also use bulkstat to walk through
> all dirs and find the exact dir whose ino # of ".." is
> itself by getdents, and that should be considered as the
> root dir.
> 
> Fixes: 25195ebf107d ("xfsdump: handle bind mount targets")
> Cc: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> preliminary test with the original testcase is done...

I think that way is feasible, yet if my own understanding on
xfsdump codebase is correct, xfsdump itself won't record ".."
dirent for all its dir records, so I'm not sure how to find
the root inode # for already broken images easily (maybe we
might use union-find algorithm to scan all dirs, and then
deduce the real root dir via the result of the algorithm,
still looking into that if it's possible and easy to implement
...)

Thanks,
Gao Xiang

