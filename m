Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3D6C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Nov 2021 01:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0727C611BF
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Nov 2021 01:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhKJB7n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Nov 2021 20:59:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27632 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229470AbhKJB7n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Nov 2021 20:59:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636509416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=4voTsQ2NOR++mhYo6YSDxe5eUYfW9Dvn6FZd4VsW7Wg=;
        b=IsMwaSS4veZtbIZcRguvJgcy2KbHGsnnQ4CK6DgOOgHZYCV0q9QEfha44/C5XjLfIKscqS
        sfN+HRNaISq/CllRPz9k5sFEVRArbiunXSyGIXPlQtoIrRc8jk+nft1yngHuMQvzgg8wqU
        kAayZ6altznXgERlBSI5UuhcnZLyY9s=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-wDlqMBKxNb6KYwq0wYJMjQ-1; Tue, 09 Nov 2021 20:56:54 -0500
X-MC-Unique: wDlqMBKxNb6KYwq0wYJMjQ-1
Received: by mail-il1-f199.google.com with SMTP id k5-20020a92c245000000b0026d8bebbff7so702496ilo.2
        for <linux-xfs@vger.kernel.org>; Tue, 09 Nov 2021 17:56:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :content-language:to:subject:content-transfer-encoding;
        bh=4voTsQ2NOR++mhYo6YSDxe5eUYfW9Dvn6FZd4VsW7Wg=;
        b=OTFcu73nIHApDdmKWza+RGebD6scigjTD+JzjQ6i0yipL+4n8QH2ZlXNBSOe/tigfx
         Ezdj3YV6YwOw51MFBwIStMtmBxhXMUmYjMH+T9pVvkpzmA8+Q6jCGgkwZDffjSNmfT/o
         sV6cxpegAbn5mPVOFdbes0tKSNiowAMt5YEcDUS2i++5PhFBdYRdTzJqmDc1yP6jsrj/
         R4AwgdriaeGuXZo1N1YZE1Tz4Edm+FSzsZLD8Z/aDcjqx5YgSbePbq0bxEdBIhxqRfCt
         TtDChuFvgzggy198YG1BwJ6jKa/m8piwQS+2af+giMrsct1okq1chCshK4qf7/AqHee1
         +4FA==
X-Gm-Message-State: AOAM533ObcQNE99LfrVyIFBJZoOjFhbJ7AJUj9nFYa7pZujOswhZZgGG
        u9iZXbrGvMQthSV28JBdOdnAcXp4BV2vOu0idocleMjXmWyUekBu/F2md4uXOJ8paZGKVVmfEmO
        m/sEMOjAS13fcY6sLmAuxdRclbBEZyX2XdTVpSPuuUwnKo7la1Na1tYFtu4LDvddM0+DdChB8
X-Received: by 2002:a05:6e02:20ea:: with SMTP id q10mr8599477ilv.10.1636509414116;
        Tue, 09 Nov 2021 17:56:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwi9UlXMUrI3T28VN64xkEp8P/gByp8cDuhc56eWQk8RLPESNm/iTROpgwY/YYCdwlpPo1gMg==
X-Received: by 2002:a05:6e02:20ea:: with SMTP id q10mr8599461ilv.10.1636509413874;
        Tue, 09 Nov 2021 17:56:53 -0800 (PST)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id e25sm916319ioc.43.2021.11.09.17.56.53
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 17:56:53 -0800 (PST)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <a98ed48b-7297-34af-2a2a-795b15b35f12@redhat.com>
Date:   Tue, 9 Nov 2021 19:56:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH 0/3] xfs: #ifdef out perag code for userspace
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Series of patches to get userspace and kernelspace to the point where
xfsprogs can sync up ok and build with a minimum of stub functions etc.

