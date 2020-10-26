Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCCF9C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 13:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 942C922242
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 13:55:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="j13Zm+0X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780782AbgJZNzr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 09:55:47 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:34714 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1770770AbgJZNzq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 09:55:46 -0400
Received: by mail-il1-f194.google.com with SMTP id v18so2992279ilg.1
        for <linux-xfs@vger.kernel.org>; Mon, 26 Oct 2020 06:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T34Jne3WnifRc7iEE9z5MUbPKqS9loF5a16qtrLnLG8=;
        b=j13Zm+0XnwOqcOGOpuQET9O2RfehNckeb8yaPUyDzmtyqhCdwkEKn1I9C2QpMi5U9U
         2lIk4rBKl1/VajB7yyDvgkoWFWMg+AuX62uIyF1Qic0dsnPlz6c/9aS7zesD/7REIdud
         9ZyPYuia+JMp67LRB3AxAihbvlBN1iq+FE0G0j+9WQXZsEseZo3i218DB5TAgu15HsGv
         EebICGF+VNRtM0z01N9Ls10+g87Zn64WNjwWTfW0pCzyAD6QBRx6MAlM2SJfwbNg9jx/
         SI7m+jC+QKREaYWL5MUj2ByZwvaq6JIhdqwZbiPkGwzZFPjkZKftD6g1QNp46MWdzJeQ
         KrSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T34Jne3WnifRc7iEE9z5MUbPKqS9loF5a16qtrLnLG8=;
        b=gBpv63HqhxNosSgXueDSp5RomBkdgrR2SsSwobm+ekV+eY2K/9ND4LRkFAeqzNHiae
         m6DZyogEFgAgAufor0K+9F2TKqztYrqCTJhVu+k5BT+UdbGeA5/b5nyIhUXu5SyjYDrl
         I22Bvqj8qkJj+4L0COcA2uKgmNVuAD56gB0VEIdmRNhg9PoAo02xM+OmYJgpI+DAZKdf
         lQOE3VjOL10R5jUUl9Elwrklr+bXnN5AwEB7ImWh5nDVoTCIbLLvkUgvtbLMJr6Ef7bs
         pVUBmfBvUvIKcEdbk439mheE3YYFajS0OgLCr9+D5JThfMihXC87XmoxfVYiDTpJzWC4
         xcDg==
X-Gm-Message-State: AOAM533wv1rFjyr1f2fwM3XQ1qMtrF74TuPjCop+vxGOFck7hNtK7JoI
        1MlyzXf8QuqhApdKHBZlViJ5Qg==
X-Google-Smtp-Source: ABdhPJwK5V1blQj7A/QIgGgFf9Cdacir5v6joT876+ZwpB24wbUU3k/sgn/wFZ3NJkNxVSUkcPHV+A==
X-Received: by 2002:a05:6e02:5c7:: with SMTP id l7mr11066619ils.43.1603720545201;
        Mon, 26 Oct 2020 06:55:45 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v85sm6156874ilk.50.2020.10.26.06.55.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2020 06:55:44 -0700 (PDT)
Subject: Re: kernel BUG at mm/page-writeback.c:2241 [
 BUG_ON(PageWriteback(page); ]
To:     Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc:     Qian Cai <cai@lca.pw>, Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <645a3f332f37e09057c10bc32f4f298ce56049bb.camel@lca.pw>
 <20201022004906.GQ20115@casper.infradead.org>
 <20201026094948.GA29758@quack2.suse.cz>
 <20201026131353.GP20115@casper.infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d06d3d2a-7032-91da-35fa-a9dee4440a14@kernel.dk>
Date:   Mon, 26 Oct 2020 07:55:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201026131353.GP20115@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/26/20 7:13 AM, Matthew Wilcox wrote:
> On Mon, Oct 26, 2020 at 10:49:48AM +0100, Jan Kara wrote:
>> On Thu 22-10-20 01:49:06, Matthew Wilcox wrote:
>>> On Wed, Oct 21, 2020 at 08:30:18PM -0400, Qian Cai wrote:
>>>> Today's linux-next starts to trigger this wondering if anyone has any clue.
>>>
>>> I've seen that occasionally too.  I changed that BUG_ON to VM_BUG_ON_PAGE
>>> to try to get a clue about it.  Good to know it's not the THP patches
>>> since they aren't in linux-next.
>>>
>>> I don't understand how it can happen.  We have the page locked, and then we do:
>>>
>>>                         if (PageWriteback(page)) {
>>>                                 if (wbc->sync_mode != WB_SYNC_NONE)
>>>                                         wait_on_page_writeback(page);
>>>                                 else
>>>                                         goto continue_unlock;
>>>                         }
>>>
>>>                         VM_BUG_ON_PAGE(PageWriteback(page), page);
>>>
>>> Nobody should be able to put this page under writeback while we have it
>>> locked ... right?  The page can be redirtied by the code that's supposed
>>> to be writing it back, but I don't see how anyone can make PageWriteback
>>> true while we're holding the page lock.
>>
>> FWIW here's very similar report for ext4 [1] and I strongly suspect this
>> started happening after Linus' rewrite of the page bit waiting logic. Linus
>> thinks it's preexisting bug which just got exposed by his changes (which is
>> possible). I've been searching a culprit for some time but so far I failed.
>> It's good to know it isn't ext4 specific so we should be searching in the
>> generic code ;). So far I was concentrating more on ext4 bits...
>>
>> 								Honza
>>
>> [1] https://lore.kernel.org/lkml/000000000000d3a33205add2f7b2@google.com/
> 
> Oh good, I was wondering if it was an XFS bug ;-)
> 
> I hope Qian gets it to reproduce soon with the assert because that will
> tell us whether it's a spurious wakeup or someone calling SetPageWriteback
> without holding the page lock.

I've tried to reproduce this as well, to no avail. Qian, could you perhaps
detail the setup? What kind of storage, kernel config, compiler, etc.

-- 
Jens Axboe

