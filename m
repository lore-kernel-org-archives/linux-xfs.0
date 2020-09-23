Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 525FEC4363D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 03:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06D4D218AC
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 03:21:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z+Q+9Kwb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgIWDVZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 23:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgIWDVZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 23:21:25 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14483C061755
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 20:21:25 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id r19so6106717pls.1
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 20:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+4IBECz9C37VesjeKwZRJYwAu7lpoaRAwOnOf0IcQAs=;
        b=Z+Q+9KwbxhtHKWPhcydo5PSw4F2c264m4bKeTAMwQg+SAazgCS0Mwx0Gg1Do/0Dn2Y
         Xx7ZoKNpjE69pJXbKG10hwLbCQa1DAchu8rFcCeuZuYWMABDHE/M168tGWy5++J1CsTP
         dtQbvZNu9H+v7TbZ4kDMFn4qm+GIphN/4U2PELtAgIEd2PfuY6Fz0PoO3+6ebYxCt7+c
         hwiWNipzEpNZv9RlOXbZUyJNWcjdEiWza9wpLZZcBpsH37rLcJW7igeZOJQ/Cj3nrlE7
         XSYbUOah4GiVM7wqSDxDbfefbmSCoxnaeDsnLknNL+/XjEJiKkq40+tLlH/waJO5JPAe
         Wf+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+4IBECz9C37VesjeKwZRJYwAu7lpoaRAwOnOf0IcQAs=;
        b=pB2pvkKhZ04MNuIHvhLlgzu05QpNjAMVVnaabX9e9QfCpuvJB7Rc4Z5P+KZVUt1ecZ
         CYjsndvRu0loJrlNJ8TVsWRhbwNx2uQIYHOSFxHYV8w4qn1rBt3mRg57SHnxnz0673uT
         vJMgcznkZxQ80QeWlPUjGkDCgL47jJG80DjZf0crlHhVgUHULpaB6qomykfccu2N2Seg
         ZH9Ji3iS7OjcDQMGDKnKxIROV7Wq9WlsjZmYEU0p2IolX5T8vy+04pKmpAqcSYPOtbFu
         aOrUwQgjJxp8t0JplGk8MF21wEL5w1d8uyDpR4Tj2iDyz+KzlWqD5x+CcwhtQ4Zz4eil
         0fiA==
X-Gm-Message-State: AOAM531zkF/3fPb+rBjBoOLAwXhlvJ9o9sGSDHgEMHhkn37AKnCU3mKi
        /GPjeFCNm/Tby2CMbvVOIA==
X-Google-Smtp-Source: ABdhPJwVmQtQ3WK+D0O06qBXIuf0DAhC3IL/lvydrr9G/sPFieXbbWAiwF0BDe2OezRHqmnz6wu1Hw==
X-Received: by 2002:a17:90a:b302:: with SMTP id d2mr6268387pjr.150.1600831284380;
        Tue, 22 Sep 2020 20:21:24 -0700 (PDT)
Received: from [10.76.92.41] ([103.7.29.7])
        by smtp.gmail.com with ESMTPSA id q18sm16063287pfg.158.2020.09.22.20.21.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 20:21:23 -0700 (PDT)
Subject: Re: [PATCH v2 6/7] xfs: code cleanup in
 xfs_attr_leaf_entsize_{remote,local}
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
References: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
 <1600342728-21149-7-git-send-email-kaixuxia@tencent.com>
 <20200919062935.GD13501@infradead.org>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <87b07068-d71a-d25d-0ffd-39df88a57e1b@gmail.com>
Date:   Wed, 23 Sep 2020 11:21:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200919062935.GD13501@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/9/19 14:29, Christoph Hellwig wrote:
> On Thu, Sep 17, 2020 at 07:38:47PM +0800, xiakaixu1987@gmail.com wrote:
>>  static inline int xfs_attr_leaf_entsize_local(int nlen, int vlen)
>>  {
>> -	return ((uint)sizeof(xfs_attr_leaf_name_local_t) - 1 + (nlen) + (vlen) +
>> -		XFS_ATTR_LEAF_NAME_ALIGN - 1) & ~(XFS_ATTR_LEAF_NAME_ALIGN - 1);
>> +	return round_up(sizeof(struct xfs_attr_leaf_name_local) - 1 + nlen + vlen,
> 
> Please avoid the overly long line here.

Okay, will fix it in the next version.

Thanks,
Kaixu
> 

-- 
kaixuxia
