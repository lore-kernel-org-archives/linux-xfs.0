Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9665BC43334
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jul 2022 08:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbiGSIlS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 04:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233598AbiGSIlE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 04:41:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 952FABF6E
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jul 2022 01:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658220062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aCQLJQOHcJOJ8JmCqZRzHzMUpESxVjd3NNjhzKxLWQs=;
        b=Sk9pVL3nLTNm+GI2UzYgk45qGkMGxqaDTToP1XCcg5rG21ST6Mc/cGy56bbRxVk4oH3FW2
        dCBpyqFP/rK+T0gbeyQuDiE/eFoU0ZTDGHLm+5DoQiDa/VMbgCfw4LpFTpzACdZDk+V7nM
        nFLLkX4+j6eVLz3hIfH52RN/PZk9qgY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-957D7njBO6S2Ez8g741VSw-1; Tue, 19 Jul 2022 04:40:58 -0400
X-MC-Unique: 957D7njBO6S2Ez8g741VSw-1
Received: by mail-wr1-f70.google.com with SMTP id e14-20020adfa74e000000b0021e18a1c29fso837472wrd.22
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jul 2022 01:40:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=aCQLJQOHcJOJ8JmCqZRzHzMUpESxVjd3NNjhzKxLWQs=;
        b=o5HQwGjuEyQb5osyJtmGtwRdGqW/c3qhX0LZAdkme/nJchTfawxZVMPZ0QknU/NCJ9
         IoeE3p6BD6RkUxuaTijefob79JMBb+RR+mPsINDm7VDuS3gtY8xWBBU6gshtutYJKk2T
         MkbpzyFoKDWUOyFFm2w9vAtwR9/TJ+bqnM+H6FHuW9AIbfNfpwHyxMuXXi6K3FX0Xwvc
         0Xswsn4F1xZNHhv3LNWob7RrvIYBzOFStZ75CPOA0uz6xDCST6MRO1hI1htJbgC9mEjO
         glE4zyjC1pL300nrt4q3xDtCBGXXgWbpaTpmqEDGW91IGlViKixqbJk081o7/qpeg4aZ
         kihw==
X-Gm-Message-State: AJIora90VVWPfpHuRpYlN8pigp0NajsElmTc3hUtdZRyJSSdRHSAma50
        8A84YGQnC3FAkw/kDajlBtoltJuWGROdKuNpp2JSNI2v8qTnD79EzS5d6XsD7brtB8rjIRgpXtJ
        nrDDFDePnM7pN73u3Ss/z
X-Received: by 2002:a7b:c381:0:b0:3a2:aef9:8df4 with SMTP id s1-20020a7bc381000000b003a2aef98df4mr37053745wmj.7.1658220057356;
        Tue, 19 Jul 2022 01:40:57 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1toW+ZoFXTJPEFs8reXmrBMtF0NaGli8q7vJKFZ+PCo4DXMfNrAYpetGiTuQdFEWq6RXg/h9w==
X-Received: by 2002:a7b:c381:0:b0:3a2:aef9:8df4 with SMTP id s1-20020a7bc381000000b003a2aef98df4mr37053722wmj.7.1658220057065;
        Tue, 19 Jul 2022 01:40:57 -0700 (PDT)
Received: from ?IPV6:2003:cb:c709:600:7807:c947:bc5a:1aea? (p200300cbc70906007807c947bc5a1aea.dip0.t-ipconnect.de. [2003:cb:c709:600:7807:c947:bc5a:1aea])
        by smtp.gmail.com with ESMTPSA id j23-20020a05600c1c1700b003a32251c3f9sm1833646wms.5.2022.07.19.01.40.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 01:40:56 -0700 (PDT)
Message-ID: <d0e631e1-c7ef-4e03-6c34-189042b84005@redhat.com>
Date:   Tue, 19 Jul 2022 10:40:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v9 06/14] mm/gup: migrate device coherent pages when
 pinning instead of failing
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Alex Sierra <alex.sierra@amd.com>, jgg@nvidia.com,
        Felix.Kuehling@amd.com, linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org
References: <20220715150521.18165-1-alex.sierra@amd.com>
 <20220715150521.18165-7-alex.sierra@amd.com>
 <225554c2-9174-555e-ddc0-df95c39211bc@redhat.com>
 <20220718133235.4fdbd6ec303219e5a3ba49cf@linux-foundation.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220718133235.4fdbd6ec303219e5a3ba49cf@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 18.07.22 22:32, Andrew Morton wrote:
> On Mon, 18 Jul 2022 12:56:29 +0200 David Hildenbrand <david@redhat.com> wrote:
> 
>>>  		/*
>>>  		 * Try to move out any movable page before pinning the range.
>>>  		 */
>>> @@ -1919,7 +1948,8 @@ static long check_and_migrate_movable_pages(unsigned long nr_pages,
>>>  				    folio_nr_pages(folio));
>>>  	}
>>>  
>>> -	if (!list_empty(&movable_page_list) || isolation_error_count)
>>> +	if (!list_empty(&movable_page_list) || isolation_error_count
>>> +		|| coherent_pages)
>>
>> The common style is to
>>
>> a) add the || to the end of the previous line
>> b) indent such the we have a nice-to-read alignment
>>
>> if (!list_empty(&movable_page_list) || isolation_error_count ||
>>     coherent_pages)
>>
> 
> I missed that.  This series is now in mm-stable so any fix will need to
> be a standalone followup patch, please.
> 
>> Apart from that lgtm.
>>
>> Reviewed-by: David Hildenbrand <david@redhat.com>
> 
> And your reviewed-by's will be lost.  Stupid git.

I know, I already raised my concerns regarding the new workflow, so I
won't repeat that. I can understand (too some degree) that we don't want
code to change just before the new merge window opens.

But I do wonder if we really don't even want to do subject+description
updates. Sure, the commit IDs will change. Who cares?

Anyhow, it is what it is.

-- 
Thanks,

David / dhildenb

