Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87552C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Feb 2022 13:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241007AbiBYNNQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Feb 2022 08:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241020AbiBYNNP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Feb 2022 08:13:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98958181E61
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 05:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645794761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q5m/jO7lh5udnKQzVaUijMT/vcP8DIr3AnFBCv6X8sA=;
        b=A+whudTHBepKndncnELDJctBP6oue4vB3ufQvbGVHmaOmN0NNDVYUiY70U9rMqGdsgRxP3
        Ehk1454R3uy3G6MRabXy6klxw8OQP0fYbFDUlY1TnHXriHha4Kgyu9/jPlNfaeTupNCJuS
        PreZpfbiNMAyA3fZUXDuGSyiffPuIO0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-6xyLQXTcMMetCi8ONTN0Og-1; Fri, 25 Feb 2022 08:12:40 -0500
X-MC-Unique: 6xyLQXTcMMetCi8ONTN0Og-1
Received: by mail-wm1-f70.google.com with SMTP id w3-20020a7bc743000000b0037c5168b3c4so1539809wmk.7
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 05:12:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=Q5m/jO7lh5udnKQzVaUijMT/vcP8DIr3AnFBCv6X8sA=;
        b=CYUQAvShiIke6D7yu+XBDNM+TF1cZS8djwzIi+wcNq4LdmLXvWFJFYl+WJpq/rUdSD
         x21Dq7P//fgaJRnN0pz4f4seNCRJPBeioyoaGd70Sm1A6BObWovR+Zc3uadesbVfTevV
         H+WCDsTRMw95YgC4wqIIaHeznrLtri+4D3sie2q8ytTf1YgnxHQOtlduXBLQqDHuU5/z
         3VjZsYEOQ4mDErt73p0FH1qKeDvVAgns8Q3x9rEyQLrxq8mTgaKToo0anGZPcfrOF+mV
         pwvuhsgzJbgyb6/Vf1Ka+GklMJ8XuEsyqqjV6rdxGRHuSpHhoqfBzGWExmzWJdDEqH2W
         xZSQ==
X-Gm-Message-State: AOAM530Twvr7vNYQzXtDktcjMlTrS6p5J8QOvKTBrq+DwdbI9Gdqq+fy
        ReWlF2W05J0VttAG3gy12tukUYBqYaAytNRersFweufNDC/ayP2MfGGJpfqEI1wyzYAa5RdAk1j
        pI+5r3syyvbHDdyStxwUB
X-Received: by 2002:a05:600c:230d:b0:37d:5882:ec9b with SMTP id 13-20020a05600c230d00b0037d5882ec9bmr2621771wmo.162.1645794759008;
        Fri, 25 Feb 2022 05:12:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwI4b9vBHcOeQt/ZmS1/e52HNSF01bwScuFUG5ZV9CohndqVjI+TJ4cckBrt1RE2I3tNlK5oQ==
X-Received: by 2002:a05:600c:230d:b0:37d:5882:ec9b with SMTP id 13-20020a05600c230d00b0037d5882ec9bmr2621744wmo.162.1645794758739;
        Fri, 25 Feb 2022 05:12:38 -0800 (PST)
Received: from ?IPV6:2003:cb:c706:1900:f2f7:d2ad:80d9:218f? (p200300cbc7061900f2f7d2ad80d9218f.dip0.t-ipconnect.de. [2003:cb:c706:1900:f2f7:d2ad:80d9:218f])
        by smtp.gmail.com with ESMTPSA id m5-20020a05600c3b0500b00380da3ac789sm2535021wms.1.2022.02.25.05.12.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Feb 2022 05:12:38 -0800 (PST)
Message-ID: <ad29be74-d296-a9fb-41d7-00d2ba15ea5c@redhat.com>
Date:   Fri, 25 Feb 2022 14:12:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH 0/7] block, fs: convert Direct IO to FOLL_PIN
Content-Language: en-US
To:     John Hubbard <jhubbard@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chaitanya Kulkarni <kch@nvidia.com>
Cc:     linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20220225085025.3052894-1-jhubbard@nvidia.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220225085025.3052894-1-jhubbard@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 25.02.22 09:50, John Hubbard wrote:
> Hi,
> 
> Summary:
> 
> This puts some prerequisites in place, including a CONFIG parameter,
> making it possible to start converting and testing the Direct IO part of
> each filesystem, from get_user_pages_fast(), to pin_user_pages_fast().
> 
> It will take "a few" kernel releases to get the whole thing done.
> 
> Details:
> 
> As part of fixing the "get_user_pages() + file-backed memory" problem
> [1], and to support various COW-related fixes as well [2], we need to
> convert the Direct IO code from get_user_pages_fast(), to
> pin_user_pages_fast(). Because pin_user_pages*() calls require a
> corresponding call to unpin_user_page(), the conversion is more
> elaborate than just substitution.
> 
> Further complicating the conversion, the block/bio layers get their
> Direct IO pages via iov_iter_get_pages() and iov_iter_get_pages_alloc(),
> each of which has a large number of callers. All of those callers need
> to be audited and changed so that they call unpin_user_page(), rather
> than put_page().

vmsplice is another candidate that uses iov_iter_get_pages() and should
be converted to FOLL_PIN. For that particular user, we have to also pass
FOLL_LONGTERM -- vmsplice as it stands can block memory hotunplug / CMA
/ ... for all eternity.

-- 
Thanks,

David / dhildenb

