Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3CE2C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Jan 2022 19:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242447AbiAQTce (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Jan 2022 14:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiAQTcd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jan 2022 14:32:33 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F20FC061574
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jan 2022 11:32:33 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id b13so70086527edn.0
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jan 2022 11:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:cc:in-reply-to:content-transfer-encoding;
        bh=6QwBAhvG2NB12Pu4h1OSTAy0qqffWGrIfhyaHy9ccFw=;
        b=gYGv9VO0HhHbkjCGK51aNdEsjhzZkuA+EtEnOOh6PtP7Z1QeJr99/CokrNI4ckP4Oy
         danSj4zV6Gu5AaQ8LZTkRIjz5xFFJH0pYO36nuN1qGFMR7E7QhZEYuJz79dVzkTFdQld
         6KGNLnyfCbEwDIST6DxjIhz1zfugqEQTpC445tSLiuP4Iug6DhfsDcnf2R7AcnHFZ8Gu
         Oc43fX51jiINYDEEDfOMS6VLwswkj9DES6Ga14QqoGq2gZCeQLHTANjJm3aeaePXrlsm
         r3+OVgo63Gsp9gh8D7ptdH965OZwv3hE3/7RWge1xccqzoDueYTZJbFl7gE2YFbvVLSv
         3IgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:cc:in-reply-to
         :content-transfer-encoding;
        bh=6QwBAhvG2NB12Pu4h1OSTAy0qqffWGrIfhyaHy9ccFw=;
        b=ejO6ZyXeMz6Z1GP1SmXW24qFhHWgz5XBoMceWwhBfWkX+OeC8l4yal1iRondx8Wx0c
         s4da9x9iH2uvuIc6Gn131WV8WnibjzN8bvlvlj2+Ac+eh4oyP3qc+BWmGFCBqd12x5gi
         j2LbT9rtwSLFby8wvjEjISsmmd5k817Zi5oFCOt4xw9FpZeGVJPB9FERIzOcxSb9N6aD
         0b3fVlIsKB2XGAub0gENAm0oD4nEAlDnbYQfq3nataNcdNrzXRAWjvfUpUr9g+2T5vIX
         xEL479ugzvBmhwK45p/fBc9t/XthIXgY4uVzv8Iyc03784oFyfxZUSSc3EwA5/Khiu/7
         +OZQ==
X-Gm-Message-State: AOAM530AAh4C40Q8bStjOhIxlHdvFtjZ9FfX5KlZ1UAgtjQzTnc1lcc7
        DNzPFwZQ1B0AF4ZY9XCIGuIeTkw2NBQ=
X-Google-Smtp-Source: ABdhPJzUC0404AG7xCOMPxxsk5MIQ+epUBLHrWPxEk2s738aCFthBUjZgHlnDVWDi69KpnJ/5Lr4tA==
X-Received: by 2002:aa7:c79a:: with SMTP id n26mr15628953eds.350.1642447951965;
        Mon, 17 Jan 2022 11:32:31 -0800 (PST)
Received: from [10.10.6.103] ([41.190.94.55])
        by smtp.gmail.com with ESMTPSA id v2sm4638931ejd.185.2022.01.17.11.32.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 11:32:31 -0800 (PST)
Message-ID: <3c16ab63-3542-c810-dd5f-6e1dd70d5b6c@gmail.com>
Date:   Mon, 17 Jan 2022 21:32:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: XFS volume unmounts itself with lots of kernel logs generated
Content-Language: en-US
From:   Well Loaded <wellloaded@gmail.com>
To:     linux-xfs@vger.kernel.org
References: <0587a4f6-a0d5-811a-4fdf-fc6bf5f45852@gmail.com>
Cc:     bf0b1c63-8fee-112b-fc6c-801593ef4f23@gmail.com
In-Reply-To: <0587a4f6-a0d5-811a-4fdf-fc6bf5f45852@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I am really stuck with this, can I please get some help?
