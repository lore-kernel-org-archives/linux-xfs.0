Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B907EC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 18:41:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92BF360FD7
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 18:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbhHLSls (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 14:41:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35961 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234899AbhHLSlr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 14:41:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628793681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TUWfVxTXiwJwkrsnYcDVbNgZzktmFbalhggCMORMxBE=;
        b=YHXYaTWYGtY1B5qKNnee9HDtTHA9+zWV/UgdRfv7OAKflFgaFCK5XHfmRG9zfXJXynu0bW
        RnO0K8IUS5RTrNf9qwvIiUVKYY1SiPbhasiz8ywhCruAxJerOsRj1M1k16PoFPHN5To9Kc
        0tcz39ML7xQ/M9T5C2m9URFK95dz4tg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-QpZOr3VoPbiVd2I52OlcsQ-1; Thu, 12 Aug 2021 14:41:18 -0400
X-MC-Unique: QpZOr3VoPbiVd2I52OlcsQ-1
Received: by mail-ed1-f70.google.com with SMTP id b16-20020a0564022790b02903be6352006cso3465365ede.15
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 11:41:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=TUWfVxTXiwJwkrsnYcDVbNgZzktmFbalhggCMORMxBE=;
        b=ADHh0ECT3D6zP/o1K3Gj/FPjlcX9ucp7F3awvkLxJ1aEFsS0ojxQI5KpawhcEbn4wQ
         Nqqgs92/wnHjTDIwEP4JToRl4jGptUNGbFBYGn0C99PEU+EEIi1pwog6Rw2WXET7NhmY
         LqGutodnkJVbnWXCn9zG65UqAqzcexnqZPUOg2JlAGe4x/ql4QuBZpRXuSF/k1e8EFKo
         95TNc629XMu99EqxBYkcC3AyJ46Cjt+h4NENyvDPTElEt/4QFxTlgeWHWP7gaLqdq79Y
         ArojxJQJ6f1JrOqYA6Y26HmAROMNe7HIC2biCuN4ncoLta8WC0uJUxFbDlVKY3Jy759i
         wERA==
X-Gm-Message-State: AOAM530H7WAlECz1lCJDun7cfxQKQQBE6/LDSghB0kyhQechOSfGl5m5
        N2LEWUS7chkn62k6MPlFqPQ8OaVTj+sLqayL/SYAPxCZX6adAziQD7KknVF0Sht6E6cPWnl2cSU
        IcZ2B54dvTHbWP7zdmvgib05a+rSEaha4yIdzsZEc+ojBzytJBMPI4Fg6m456OaI1l/O041Q=
X-Received: by 2002:aa7:cb0f:: with SMTP id s15mr7290247edt.190.1628793676552;
        Thu, 12 Aug 2021 11:41:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDSMMlUiiNJI+zvFxG7oc4KOeDI/qiVJg/hsBh9MmwuDsYhuo8L7pz38AzcetdGuadKtX+Xw==
X-Received: by 2002:aa7:cb0f:: with SMTP id s15mr7290234edt.190.1628793676409;
        Thu, 12 Aug 2021 11:41:16 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id bx11sm1129517ejb.107.2021.08.12.11.41.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 11:41:15 -0700 (PDT)
Subject: Re: [PATCH 1/3] xfs: remove the xfs_dinode_t typedef
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
References: <20210812084343.27934-1-hch@lst.de>
 <20210812084343.27934-2-hch@lst.de>
 <6d28d82c-4113-3b74-c7bd-f430cf8fbfb3@redhat.com>
 <20210812171613.GT3601443@magnolia>
From:   Pavel Reichl <preichl@redhat.com>
Message-ID: <49db010a-b776-1fe8-4393-9d4a0753d6c8@redhat.com>
Date:   Thu, 12 Aug 2021 20:41:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210812171613.GT3601443@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 8/12/21 7:16 PM, Darrick J. Wong wrote:
> On Thu, Aug 12, 2021 at 11:31:31AM +0200, Pavel Reichl wrote:
>> On 8/12/21 10:43 AM, Christoph Hellwig wrote:
>>>    	/*
>>>    	 * If the size is unreasonable, then something
>>> @@ -162,8 +162,8 @@ xfs_iformat_extents(
>>>     */
>>>    STATIC int
>>>    xfs_iformat_btree(
>>> -	xfs_inode_t		*ip,
>>> -	xfs_dinode_t		*dip,
>>> +	struct xfs_inode	*ip,
>>> +	struct xfs_dinode	*dip,
>>>    	int			whichfork)
>> Hi,
>>
>> since you are also removing xfs_inode_t I'd like to ask if it is a good idea
> [assuming you meant xfs_dinode_t here]

Hmm, I'm sorry but I really did mean xfs_inode_t.

Since the patch is named "remove the xfs_dinode_t  typedef" removing 
xfs_dinode_t is quite expected. But removing xfs_inode_t not so much, 
hence I'm asking if I should send a patch that removes completely 
xfs_inode_t as is done for xfs_dinode_t by this very patch.

I hope I'm not missing something :-).


>
>> to send a separate patch removing all other instances of xfs_inode_t? (I'm
>> happy to do it).
> Seems like a reasonable thing to me.
>
Great, thanks!

