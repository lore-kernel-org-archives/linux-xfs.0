Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E41EED60B
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Sep 2023 15:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236130AbjIOPoo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Sep 2023 11:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236202AbjIOPoS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Sep 2023 11:44:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ABD26E50
        for <linux-xfs@vger.kernel.org>; Fri, 15 Sep 2023 08:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694792607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+HjRpUexdgJAehf7Qv6azxAmOLDK2cUSsvpp8na9Sbw=;
        b=OK9AHQfcJjfRryj9S3+lt/2D9UHH2J7ekFKBm7XbS2JclByyhfooR6l54Wr6B9z7mvuCd9
        TlOqrJjcXQYlB4s/QDdEkbbBkxW1qnzsLsohLaXzJwzi4OlhV1hbydxlm2GSmsSPK0j71Q
        lZCaiXcHeXXgQbiBKrVx7pcAOUXSxN8=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-58-MtoSbnLYP9aXi1inHUXOKA-1; Fri, 15 Sep 2023 11:43:24 -0400
X-MC-Unique: MtoSbnLYP9aXi1inHUXOKA-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-50091accc8eso2728019e87.3
        for <linux-xfs@vger.kernel.org>; Fri, 15 Sep 2023 08:43:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694792603; x=1695397403;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+HjRpUexdgJAehf7Qv6azxAmOLDK2cUSsvpp8na9Sbw=;
        b=I3EupUZDQgfca+6qa77mdo5tKNwwYcpYabO7FvFsWXIrh5rIDwupb2Y3M18RIIo6EH
         dBvQRoecepSUpQx/vsVKlMjk82bKn7Qr57m69HBOwuuuuGJ5i9gdg+ty8pdF7PTT1PNx
         EpyNo7NvRX88ufhFyfQn5MQr0u0eJ+5evGoQibGamLOxhCGT6XutUd1i7E4dTBrpF2pG
         NzbUzPDWZOrbmyqb/g0UgT9yLQaddIMWssj+vvn5LQDHAXk7+GqpXuSKiKxwVL0UeCtA
         Z8Mx+opMirD15DOVdX5l94f3TrtDiA/hIypf1o/7Qr3BsQT2kJVVS2/RHFhDHxz38mtA
         7ACg==
X-Gm-Message-State: AOJu0YwXeDVQEUrMNMRED1iDqHs4gWfd1B3OjBkz24gp1OGwEObaXWXV
        u7+Vt9gby7GPpHlxhXAhDJDkTyCIUV3VeG9We3NrmBQD1977UrvYSQNXRnFdd3XiQ5BWytliAwT
        l3qwqGtyfOoO318cC84Ah
X-Received: by 2002:a05:6512:2528:b0:4fd:f84f:83c1 with SMTP id be40-20020a056512252800b004fdf84f83c1mr1921021lfb.64.1694792603012;
        Fri, 15 Sep 2023 08:43:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUlzqnI9IhxadefzLCHSEYLKXLnj68ovmQNeMXOp3JfxSWFhttFec7rrRBDh3udFZ2SJb/Tg==
X-Received: by 2002:a05:6512:2528:b0:4fd:f84f:83c1 with SMTP id be40-20020a056512252800b004fdf84f83c1mr1920990lfb.64.1694792602530;
        Fri, 15 Sep 2023 08:43:22 -0700 (PDT)
Received: from ?IPV6:2003:cb:c728:e000:a4bd:1c35:a64e:5c70? (p200300cbc728e000a4bd1c35a64e5c70.dip0.t-ipconnect.de. [2003:cb:c728:e000:a4bd:1c35:a64e:5c70])
        by smtp.gmail.com with ESMTPSA id x25-20020ac24899000000b004fb738796casm685274lfc.40.2023.09.15.08.43.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Sep 2023 08:43:22 -0700 (PDT)
Message-ID: <15b067d7-8f95-d409-64be-d22359f0942a@redhat.com>
Date:   Fri, 15 Sep 2023 17:43:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 0/6] shmem: high order folios support in write path
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Daniel Gomez <da.gomez@samsung.com>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "djwong@kernel.org" <djwong@kernel.org>,
        "hughd@google.com" <hughd@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "gost.dev@samsung.com" <gost.dev@samsung.com>,
        Pankaj Raghav <p.raghav@samsung.com>
References: <CGME20230915095123eucas1p2c23d8a8d910f5a8e9fd077dd9579ad0a@eucas1p2.samsung.com>
 <20230915095042.1320180-1-da.gomez@samsung.com>
 <b8f75b8e-77f5-4aa1-ce73-6c90f7d87d43@redhat.com>
 <ZQR5nq7mKBJKEFHL@casper.infradead.org>
 <a5c37d6e-ca0f-65cf-a264-d1220d3c3c6d@redhat.com>
 <ZQR7CyddIQQAs3yb@casper.infradead.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <ZQR7CyddIQQAs3yb@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 15.09.23 17:40, Matthew Wilcox wrote:
> On Fri, Sep 15, 2023 at 05:36:27PM +0200, David Hildenbrand wrote:
>> On 15.09.23 17:34, Matthew Wilcox wrote:
>>> No, it can't.  This patchset triggers only on write, not on read or page
>>> fault, and it's conservative, so it will only allocate folios which are
>>> entirely covered by the write.  IOW this is memory we must allocate in
>>> order to satisfy the write; we're just allocating it in larger chunks
>>> when we can.
>>
>> Oh, good! I was assuming you would eventually over-allocate on the write
>> path.
> 
> We might!  But that would be a different patchset, and it would be
> subject to its own discussion.
> 
> Something else I've been wondering about is possibly reallocating the
> pages on a write.  This would apply to both normal files and shmem.
> If you read in a file one byte at a time, then overwrite a big chunk of
> it with a large single write, that seems like a good signal that maybe
> we should manage that part of the file as a single large chunk instead
> of individual pages.  Maybe.
> 
> Lots of things for people who are obsessed with performance to play
> with ;-)

:) Absolutely. ... because if nobody will be consuming that written 
memory any time soon, it might also be the wrong place for a large/huge 
folio.

-- 
Cheers,

David / dhildenb

