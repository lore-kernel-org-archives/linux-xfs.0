Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6558C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jan 2022 08:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiAMIA4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jan 2022 03:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbiAMIAy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jan 2022 03:00:54 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E964C06173F
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jan 2022 00:00:54 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id p1-20020a1c7401000000b00345c2d068bdso4898338wmc.3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jan 2022 00:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=5WmYASBRiTVteKV4tc6fRJET7fcDZ4u4T6/OLs3tnIE=;
        b=AS4HagltFt7GPKVuYIjO1IThjhgBSyPoDiLVF9hx6jA8dxZQSM4vLam8cbZoJZquvq
         8uExZhYDY6Q8lNbVbM33DJC5qMrJanyHvMZv5YwkmgnYNyqDN9Am6bCUYn9S0Gbzh9Ha
         oogbF7gGqOR6IoA+ucu561TUaNmHgyHHnywCleIt6iNFbS7oXnNAWWxGhQ44zpL0fEMD
         0NXhvUkDoMFq8bnD2M/bcpZPEI05UTEx0gFGEAg9EIcECK+ukmUppRz08Eax0NuUDwXi
         P8UPnADjAwvMYcKFV3lTHe8vh0/KXgOIg+ZNN/dsEAqDSTTnpD8QhNA8Mp7u+oTduGXI
         VAhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=5WmYASBRiTVteKV4tc6fRJET7fcDZ4u4T6/OLs3tnIE=;
        b=8CVGCrRoaaoo0bhFjZrvXmXOjQ6ft3Ukos3JnFq6UGj+dSXftgXL85DG59XSSDbfH6
         vWy1+sZt3o7NrTw/h+kS7TgcodusTjeo0IwtkL0+N17Wb1ZZ7pFoNFOXzhPtMX+80jg3
         ZrSOdg1byiJRV9SEMo1J0ndO49xVoiaelS6KQ2x0+pUc9pVPx04HudSzUzAl053BdMQH
         pLytznI6WftkJ1CP013zXQ4gEdImoy/6SQbw/UdsI9GhdlwlNYtGYBuBKdpdN99CcM0v
         leJs6NQlFMf2HL6/UnnwTpYvMY1pgiy0r1BFy2hVijzWzXfYvZTg18EFY1DATxgjqSpQ
         BU/Q==
X-Gm-Message-State: AOAM532oIdVNEiad6wpvojgrayMbNURJzrXB8WEIsv/alldPkDg95FGw
        lKrJeHU58h4HSQp8jqPM9MthRE4h5U4=
X-Google-Smtp-Source: ABdhPJxvJglH0zsp7tVnYnKylSuKYKSnFAbl02y18P/cpp7vox0TGR/3teTUHcXle/6O6UOj137SKg==
X-Received: by 2002:a05:600c:220f:: with SMTP id z15mr2768572wml.30.1642060853196;
        Thu, 13 Jan 2022 00:00:53 -0800 (PST)
Received: from [10.10.6.102] ([41.190.94.198])
        by smtp.gmail.com with ESMTPSA id k31sm889715wms.15.2022.01.13.00.00.52
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jan 2022 00:00:52 -0800 (PST)
Message-ID: <0587a4f6-a0d5-811a-4fdf-fc6bf5f45852@gmail.com>
Date:   Thu, 13 Jan 2022 10:00:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     linux-xfs@vger.kernel.org
From:   Well Loaded <wellloaded@gmail.com>
Subject: Re: XFS volume unmounts itself with lots of kernel logs generated
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Not full but it's 80% currently.


The metadata dump of this broken XFS volume can be found at the link 
here below:

https://ufile.io/5gzf475e

(60MB compressed)


On this topic I have a question. As I have a brother system with 
identical hardware, partition size etc, could I benefit from a 
dump/import of the brother (working) system?
