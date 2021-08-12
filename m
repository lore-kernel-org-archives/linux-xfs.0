Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35364C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 09:25:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1961B60EB9
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 09:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbhHLJZv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 05:25:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47014 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231392AbhHLJZu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 05:25:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628760324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z4zx7GFzbSPRt4FB62AW4ORZKhBgNfHE8kl/I1y14lA=;
        b=CnymYPzYcmv8dAVxSz+7F83SH709a4x8TJfXG1rQ/3NzHFYp4KPQLgoJesiXPNpciLvo36
        TSEDe5DVS3D8xPQg9Y6FIsv6fMiWekudN/6AKzYmhy1TA6HT8frFSbS/IX81YeSqlL3KpC
        0cwU6Ht6HpoXx+Wq6z7cwpBUb441HRo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-dNoorEg1NVCgJjSHI2_NWg-1; Thu, 12 Aug 2021 05:25:23 -0400
X-MC-Unique: dNoorEg1NVCgJjSHI2_NWg-1
Received: by mail-ed1-f70.google.com with SMTP id e3-20020a50ec830000b02903be5be2fc73so2731662edr.16
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 02:25:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Z4zx7GFzbSPRt4FB62AW4ORZKhBgNfHE8kl/I1y14lA=;
        b=c8xNWiBX0MRJ7LkEt9RNWAAwwgtuzBCjoPgc+QGsBCL3VVv9mP3BlcgFbeoXgr61RP
         PTh14DiPnuFozcxkvZjFvveVlFlaKbaI5eBtZStxXIBAK+dUR44ONiXrG7criIQB4SMB
         VMIygAFxvq/sUc3UntxHBXUrDhsWmHsysimcMyhVLmpvUgjRu3kSoz1JmyR9Dz2nqSj4
         yxnOQQKxQvSNYUt/8PpH3iV/OIJkJjFuSLeGm6xZ+Ed5OCo6qRrYGzieQcbvtYuujhif
         6eVATktQbn2OlQ0ongPyGHVCYwUeBlGMDFOGQtguuaFjMp5nBg2zDSRrH2JybKcJXTo2
         qLOg==
X-Gm-Message-State: AOAM532DkeUwmfCiJbAhB6vd0lecuubnLaFgqqI4LqRW92d0JB36zPAN
        k3JOEGZ9y3xeHOtL/DOczN8A5Psj5t7RGC0q5sr7Qv4R0YVQZG2dxE6KSdvW4GQwe4PNENZiXWD
        zPa0zg1RovRYP2nXD17qvtDlr1zFf6FSL/eqdW2oGjiXyJUs3Dq1lHSfKmW5guz0xrTvon2M=
X-Received: by 2002:a17:906:2ad5:: with SMTP id m21mr2782047eje.88.1628760322262;
        Thu, 12 Aug 2021 02:25:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKI9GnUJgsOh5k+HLvhnTn47HUEW77OUYEXqnpK+r9TGAeTHNj8qtIsxteEDQUl3j2G44bJQ==
X-Received: by 2002:a17:906:2ad5:: with SMTP id m21mr2782033eje.88.1628760322041;
        Thu, 12 Aug 2021 02:25:22 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id qa34sm572133ejc.120.2021.08.12.02.25.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 02:25:21 -0700 (PDT)
Subject: Re: [PATCH 2/3] xfs: remove the xfs_dsb_t typedef
To:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
References: <20210812084343.27934-1-hch@lst.de>
 <20210812084343.27934-3-hch@lst.de>
From:   Pavel Reichl <preichl@redhat.com>
Message-ID: <075ca66f-d72c-4ffc-d840-89e9c1974755@redhat.com>
Date:   Thu, 12 Aug 2021 11:25:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210812084343.27934-3-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Patch applies, builds and LGTM.

Reviewed-by: Pavel Reichl <preichl@redhat.com>

