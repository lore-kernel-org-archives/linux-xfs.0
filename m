Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE898C6FA82
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 14:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbiIVOoE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 10:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbiIVOoD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 10:44:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4197B7A9
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 07:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663857841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p2A8ib/cugNV2ErbC2kQ1gu2unsdhUUMjY2O8jgaTH4=;
        b=YIGXI5BoIoBJE3/XHG8VCfgyRyZ4uAabWi7PFMKX9ELvI532kR4aYUtpNpYVPi2PjUC2rq
        pGYseEvBW2rEU2NFI3AwyuDEKbliql5JMdDnhbo74sMa3vp/ga2Oo4eOP5QCChnOZQBThg
        YXtBjV/9afGmKAx48X2Ps6B+A5wopH0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-120-XdtrOQBUPJOauw2l9bGmAg-1; Thu, 22 Sep 2022 10:44:00 -0400
X-MC-Unique: XdtrOQBUPJOauw2l9bGmAg-1
Received: by mail-wm1-f71.google.com with SMTP id h133-20020a1c218b000000b003b3263d477eso4155671wmh.8
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 07:44:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=p2A8ib/cugNV2ErbC2kQ1gu2unsdhUUMjY2O8jgaTH4=;
        b=JTR6gfyTCC8dcIXd9P79fQQx7dGONFjCOK4CDaIAt7zMD261L6y4TXnu6DpvmRCF6B
         ZdssXYRxRiclYllxRUttk5fV+/PGf9m9FnVuF4WivaBi3iuyjgxb4qO+Vvquj+mL0n65
         L2Pj83VjGb3xfQuHK2u247vrI+SSU1gownBQlHNhmzNZyzVqkqN5WT89VcnmG9fQY4n7
         yADEWNDmfI5DzjPyibeewUk+QsnQB6QFV/UFsGMYNFmAAsMBl8wEtObdjAfqGbYlK8wR
         Rn8M7pGS3VRyjyB5gdILfWEt3TW55epsXEFSOwBoXF0du58C1YQTk/txeczjOFKlqlox
         MP5w==
X-Gm-Message-State: ACrzQf3u/QZWvoKlBudu6g4fevdyvGUEm3paKrwDBQnIBGlqf/74DS3d
        yDsyqARr0QpEWOdbhvUfo3PhY85hX4eP0BRlV5vzCcXn+gzOkZ9zw8J9RAi0AOc74gSpbxe8Tud
        IqfDeJUcNvgtrkQOJc3QF
X-Received: by 2002:a05:600c:2f9a:b0:3b4:9bd5:1472 with SMTP id t26-20020a05600c2f9a00b003b49bd51472mr9645503wmn.171.1663857839393;
        Thu, 22 Sep 2022 07:43:59 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5o4VzvITb4v+qMFBul+jkICLZk4bPuQBJUlc1tPdug69EqbcVtIdL50GRz0adhdxK+x9p6Zg==
X-Received: by 2002:a05:600c:2f9a:b0:3b4:9bd5:1472 with SMTP id t26-20020a05600c2f9a00b003b49bd51472mr9645473wmn.171.1663857839149;
        Thu, 22 Sep 2022 07:43:59 -0700 (PDT)
Received: from ?IPV6:2003:cb:c708:2200:d595:cc20:2e3a:fc5f? (p200300cbc7082200d595cc202e3afc5f.dip0.t-ipconnect.de. [2003:cb:c708:2200:d595:cc20:2e3a:fc5f])
        by smtp.gmail.com with ESMTPSA id w12-20020a05600c474c00b003a5f3f5883dsm6298293wmo.17.2022.09.22.07.43.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 07:43:58 -0700 (PDT)
Message-ID: <c100fcd6-60fb-6650-fdac-7cc3a3bbc464@redhat.com>
Date:   Thu, 22 Sep 2022 16:43:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2 4/7] iov_iter: new iov_iter_pin_pages*() routines
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jan Kara <jack@suse.cz>, John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
References: <103fe662-3dc8-35cb-1a68-dda8af95c518@nvidia.com>
 <Yxb7YQWgjHkZet4u@infradead.org> <20220906102106.q23ovgyjyrsnbhkp@quack3>
 <YxhaJktqtHw3QTSG@infradead.org> <YyFPtTtxYozCuXvu@ZenIV>
 <20220914145233.cyeljaku4egeu4x2@quack3> <YyIEgD8ksSZTsUdJ@ZenIV>
 <20220915081625.6a72nza6yq4l5etp@quack3> <YyPXqfyf37CUbOf0@ZenIV>
 <YylJU+BKw5R8u7dw@ZenIV> <Yyxy4HFMhpbU/wLu@infradead.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <Yyxy4HFMhpbU/wLu@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 22.09.22 16:36, Christoph Hellwig wrote:
> On Tue, Sep 20, 2022 at 06:02:11AM +0100, Al Viro wrote:
>> nvme target: nvme read requests end up with somebody allocating and filling
>> sglist, followed by reading from file into it (using ITER_BVEC).  Then the
>> pages are sent out, presumably
> 
> Yes.
> 
>> .  I would be very surprised if it turned out
>> to be anything other than anon pages allocated by the driver, but I'd like
>> to see that confirmed by nvme folks.  Probably doesn't need pinning.
> 
> They are anon pages allocated by the driver using sgl_alloc().

I assume they are not anon pages as in "PageAnon()", but simply not 
pagecache pages, correct?

-- 
Thanks,

David / dhildenb

