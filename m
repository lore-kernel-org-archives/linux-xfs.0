Return-Path: <SRS0=AlMJ=EI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD49C388F9
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 19:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FF0F2071E
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 19:47:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OEz9+YGj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgKBTrB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 14:47:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20422 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725838AbgKBTp6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 14:45:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604346357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DE8pElyjPr0cfRSpPEx78xZUW98cDZtjcM1DL4ttUEY=;
        b=OEz9+YGjEBU5AbYU/1Hz9mKC408l22waQ+RcOek4urbs4Jl711Lb0CpK+JEIGqku9p3i7T
        Basxar+p35ygTq36HUOCJtSW9Nax49XfHFCwxqrgZzYsNijHUJbV45DN0fyVWMsxVqo0rL
        QZZ3Mfqvx7l+GIFkQFqpieN0ydbLDUE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-d3R-WnpcNPObl36yK-iLKQ-1; Mon, 02 Nov 2020 14:45:55 -0500
X-MC-Unique: d3R-WnpcNPObl36yK-iLKQ-1
Received: by mail-wm1-f71.google.com with SMTP id c10so2873278wmh.6
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 11:45:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DE8pElyjPr0cfRSpPEx78xZUW98cDZtjcM1DL4ttUEY=;
        b=TFsgmbBzhzO6FflxIB8VUb8b1tHN57A+BXoUUk4dz9p8Zz/7BHSgWE9NeHdjEz+8M5
         mT3WFWN6glepJ9meUQdIlqdy47D0ZtMCENnDRcsw8Wv7b9WIQUrW0V8trCtF1nUCZ3+F
         XzFLevvfnQCSrSFLSFPGHZsKXt3nxL6XShLM8M5QpL+5IhbN3dNvNAsVPhuFo/FtuoiG
         w/REXniSOw0njKyc4fweYv5s7Z0gvVaSQ1Qnakhf7OJpx2FbXamk8CXCa8EmMxfeRqD/
         +FY+zZo4j/uVtIiz0hBpPsiN+zYkRNl/KguCtmQEbYGR6lZ4oM/oIOir8fJTO1O6dm6m
         1A0Q==
X-Gm-Message-State: AOAM531CrOcKt9+14aI5DboslZMKI3LnA/clK/8iQnBSQkXV4HF3G8la
        lT73FtIGMA3A2DrDBIERnCJ8lLEAaNz+9nb3YGJtRapTKTgiuGjqzDjB6Y/s5ir/kP1jCq+zeSn
        eI890H3Qel6kdC3bANdMD
X-Received: by 2002:a1c:63c4:: with SMTP id x187mr19609224wmb.172.1604346354117;
        Mon, 02 Nov 2020 11:45:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwy9K1pVqbg8+2nhTvXMu7Mjhu6aSt024uRjIVWnOcjrEea4fXRrmSeLx9S4l3mlxYKs2eVAA==
X-Received: by 2002:a1c:63c4:: with SMTP id x187mr19609215wmb.172.1604346353983;
        Mon, 02 Nov 2020 11:45:53 -0800 (PST)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id c64sm481562wme.29.2020.11.02.11.45.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 11:45:53 -0800 (PST)
Subject: Re: [PATCH v12 4/4] xfs: replace mrlock_t with rw_semaphores
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201016021005.548850-1-preichl@redhat.com>
 <20201016021005.548850-5-preichl@redhat.com>
 <20201029223534.GP1061252@magnolia>
From:   Pavel Reichl <preichl@redhat.com>
Message-ID: <fa33cd29-9b84-552e-b5f6-d4df723c879a@redhat.com>
Date:   Mon, 2 Nov 2020 20:45:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201029223534.GP1061252@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

 
> Looks ok to me.  Would you mind rebasing this against 5.10-rc1 so I can
> start testing a work branch with all the accumulated 5.11 stuff?

Hi,

version #13 is on the list - it's rebased against 5.10-rc1 and also contains the changes Brian proposed.

Bye.

