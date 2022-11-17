Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD67C43219
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 18:49:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbiKQStW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Nov 2022 13:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234614AbiKQStV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2022 13:49:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E1F8A14C
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 10:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668710901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W6SlBK67YjmI5D5b5boT6ciO6UGU/+eRLZEJjM7xLR8=;
        b=RkIcznc1ZER9jwQb7yupLWSY9aYv2FvKcX7N0V9fD1e6mJh5UnaKvPz0+P+QxCiNerMbyg
        yR2xCdv61v+/XJKGmMYDGSYFA+oZFwAG9nN0eoI3c56mZRCx8SGd3qNGEX7Ri1ScCJy2pZ
        A4H4FKN5VYVbedeMFzprHeZSEjCr3vk=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-596-1ImgpRjOO3mzLMgY4vgybg-1; Thu, 17 Nov 2022 13:48:20 -0500
X-MC-Unique: 1ImgpRjOO3mzLMgY4vgybg-1
Received: by mail-io1-f71.google.com with SMTP id z15-20020a5e860f000000b006c09237cc06so1359020ioj.21
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 10:48:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W6SlBK67YjmI5D5b5boT6ciO6UGU/+eRLZEJjM7xLR8=;
        b=5+o3UHtTYjuf93GPXZNYiBLG0KppLm8Rh8xhUqfHVDefCHZn/o69klPm3LzNK0WjIj
         tkagGHhCuYO/8ehkLBuA/uxairtRzcdN6BCEo8uUSen/szLHCCln0DBNA8aXzrzaIdim
         Z8Jp5/VB8oG1rHvUUVTGVoQfNoShCqLuMZzG7Hq+Spxb58S6YiMQli/UoljY8KFLtVCy
         uTJtlFyQoT0k6wNRQb+XT6xzuLaGzYCzfKrVHXe80vec1iherlyg6rvYvyrsV+9jK8SP
         ihTIO24VcRpV1dLdDGvtRT5uQ4piUAuGsVwWmI2hnGzNUWfeeyjIBv1Y9pCy9y+/Ye9r
         jGJw==
X-Gm-Message-State: ANoB5pl0mXP4hiUWRpDMASmylXn+zRUZ6hKhegabQo02VxwzKbtA0sqy
        +GrNCzs6b4LYBFG1U6MEwq5YyKUlKR+RI2DEcTbXFxOeJ2ius1ZQvhr9gEg0wZkzf2jib3hNcJA
        LBekE85YBAndRHEd7GFte
X-Received: by 2002:a92:dcc4:0:b0:302:568e:b493 with SMTP id b4-20020a92dcc4000000b00302568eb493mr1805731ilr.183.1668710898890;
        Thu, 17 Nov 2022 10:48:18 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6GXTTA4nKXVMAp7Y1uJMvKlZRGzx+hrr6xGFrGpfVyTEmypmJihpdxU+vObauU+wrTIboozw==
X-Received: by 2002:a92:dcc4:0:b0:302:568e:b493 with SMTP id b4-20020a92dcc4000000b00302568eb493mr1805722ilr.183.1668710898551;
        Thu, 17 Nov 2022 10:48:18 -0800 (PST)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id r13-20020a92440d000000b00300df8bfcf5sm569559ila.14.2022.11.17.10.48.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 10:48:18 -0800 (PST)
Message-ID: <39028244-fec6-6717-d8a7-b9f89f5a1f3b@redhat.com>
Date:   Thu, 17 Nov 2022 12:48:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: xfs_repair hangs at "process newly discovered inodes..."
Content-Language: en-US
To:     iamdooser <iamdooser@gmail.com>, linux-xfs@vger.kernel.org
References: <f7f94312-ad1b-36e4-94bf-1b7f47070c1e@gmail.com>
From:   Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <f7f94312-ad1b-36e4-94bf-1b7f47070c1e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/17/22 12:40 PM, iamdooser wrote:
> Hello,
> 
> I'm not sure this is the correct forum; if not I'd appreciate guidance.
> 
> I have a Unraid machine that experienced an unmountable file system on an array disc. Running:
> 
> xfs_repair -nv /dev/md3

Did that find errors?

> works, however when running
> 
> xfs_repair -v /dev/md3
> 
> it stops at "process newly discovered inodes..." and doesn't seem to be doing anything.
> 
> I've asked in the unraid forum and they've directed me to the xfs mailing list.
> 
> Appreciate any help.

Please tell us the version of xfsprogs you're using, and provide the full xfs_repair
output (with and without -n).

If it really looks like a bug, and not simply a slow repair, providing an xfs_metadump
may help us evaluate the problem further.

-Eric

