Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCFDBC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 May 2022 19:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358117AbiELTjU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 May 2022 15:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358118AbiELTjT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 May 2022 15:39:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A6937252DD0
        for <linux-xfs@vger.kernel.org>; Thu, 12 May 2022 12:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652384357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/p73b26LFIIsS5dVMt8VGvlIvHnG6xxE9qOGLw5C+v0=;
        b=Dutv+rcHsN2Gp2n014YSSFsW1LwDni9+7DvHshyKCaTmS5JjnIQwgD0lLqLviQj4gsjqOg
        12pjU4kXgkM8bZauE0dzDEvslb2zX1CQwvwDNwLKSOePbK2SWYjhG8cT04Qkx3oJeatY1X
        QgYDVvsgVOw9N6CV7ABwjpZGePbTO1E=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-z8iIy-tgMFShjXgnUUkhDw-1; Thu, 12 May 2022 15:39:16 -0400
X-MC-Unique: z8iIy-tgMFShjXgnUUkhDw-1
Received: by mail-il1-f199.google.com with SMTP id j5-20020a056e020ee500b002cbc90840ecso3859407ilk.23
        for <linux-xfs@vger.kernel.org>; Thu, 12 May 2022 12:39:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/p73b26LFIIsS5dVMt8VGvlIvHnG6xxE9qOGLw5C+v0=;
        b=i/PMyKqtoyvvXE3ZsGBQPIoA8iuTcVqpkM01+C0bv+0ZdtcvHgFC5nraRpGcLC3fp2
         O4HsldsQTQhVOzsJVCjPolz+J9VXKc+dWhJHOJ07vMSS1ZVJJ5LbUmxEhxMUaFN6OxGf
         YzmRAJJPAyt+ZhpAVIGbNPGrcIBI3egRACpAHmWXFuOEMRIJb/bHqefyDdQQhmup+Yci
         mIcDQSTAurGZ5JhakCZ0U+E7GVHLu3S72rs364VpYbcuZZkyWqhldxhGgBmgsqAla0CF
         EdC2uciH1v9AHCF4aL0YsjKHsl+r95Z3L3PBl1WDhXy6gzSUux+fujQuvf2V/gYXL0oS
         LKVg==
X-Gm-Message-State: AOAM531Gxi+vBfSlhfEW8mfRJeYyv1XL+YTsZ46EZsTpDPMylvLBGnlO
        tvgGiJ2peLrX0eU9/LQvgKLdS45Uq1CMSs6E0HOeSfXhcNaJ1f+DlZJcuA7tW5hFvUfvXAmED6o
        OjwBj59zXoCA20UcakfTS
X-Received: by 2002:a92:cd83:0:b0:2cf:acf6:6fce with SMTP id r3-20020a92cd83000000b002cfacf66fcemr847445ilb.312.1652384355366;
        Thu, 12 May 2022 12:39:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwv55/i5J0wB/NAZFFvpoWcLiIY8iY2IiMrCHeaAGsLWubSkNi7M/r9hQjeE/RPRu0eZFPpdQ==
X-Received: by 2002:a92:cd83:0:b0:2cf:acf6:6fce with SMTP id r3-20020a92cd83000000b002cfacf66fcemr847433ilb.312.1652384355119;
        Thu, 12 May 2022 12:39:15 -0700 (PDT)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id p27-20020a02781b000000b0032b3a7817a3sm107873jac.103.2022.05.12.12.39.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 12:39:14 -0700 (PDT)
Message-ID: <8f1a6bf5-ad9a-7bbe-c038-2b9a7ba58a69@redhat.com>
Date:   Thu, 12 May 2022 14:39:13 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 2/3] xfs_repair: improve checking of existing rmap and
 refcount btrees
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <165176674590.248791.17672675617466150793.stgit@magnolia>
 <165176675706.248791.4099817268523543427.stgit@magnolia>
From:   Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <165176675706.248791.4099817268523543427.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/5/22 11:05 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There are a few deficiencies in the xfs_repair functions that check the
> existing reverse mapping and reference count btrees.  First of all, we
> don't report corruption or IO errors if we can't read the ondisk
> metadata.  Second, we don't consistently warn if we cannot allocate
> memory to perform the check.

Well, the caller used to report those, right? i.e.

        error = check_refcounts(wq->wq_ctx, agno);
        if (error)
                do_error(
_("%s while checking reference counts"),
                         strerror(-error));

So I think this patch is just changing from reporting strerror(-error)
when these things return, to hand-crafted error messages in the functions
that get called?

AFAICT this patch changes

"Cannot allocate memory while checking reverse-mappings"
to
"Not enough memory to check reverse mappings"

etc.

Granted, strerror(EFSCORRUPTED) isn't very pretty, and your messages are
probably more clear. But I just wanted to be sure I'm not missing something;
I think every error is actually reported today, and this is just changing
the error messages.

Thanks,
-Eric

