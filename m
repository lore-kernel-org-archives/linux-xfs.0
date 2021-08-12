Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A17C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 09:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2BF260C3F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 09:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhHLJ0k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 05:26:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23956 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234975AbhHLJ02 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 05:26:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628760363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z4zx7GFzbSPRt4FB62AW4ORZKhBgNfHE8kl/I1y14lA=;
        b=RhWeiptqMV67bQm+UlMZ9Q/EKaZgclWiYWsSeHM8gSHMOOQBiCBL0bzGmwT0fkUC1jKEoJ
        Dm9r0s1gOpS3im2UiiJfe8qH5W4zk+khO9lwilyz6vff3IvCFKyAlNxPSDXIZXeLTUuhSj
        4U2K1/B9eetnobtiCxfQ/3/SWib/Ce4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-R3Mx9tzIMG68EdKK98r05Q-1; Thu, 12 Aug 2021 05:26:02 -0400
X-MC-Unique: R3Mx9tzIMG68EdKK98r05Q-1
Received: by mail-ed1-f72.google.com with SMTP id v20-20020aa7d9d40000b02903be68450bf3so2757968eds.23
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 02:26:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Z4zx7GFzbSPRt4FB62AW4ORZKhBgNfHE8kl/I1y14lA=;
        b=nakLB0SazhBVHVTh3rqB1rL2Kl3B1p8jhOlwuFcyvH0mbud7irdT3xJFoVFRujIJMD
         Db+EH9GiRVdXoR1db2P6iQmEAq+l/sF7LGS2MmgmNbI+cxvSfZTi2911OsKB+cDzq7qZ
         DUWii0hiGls6BapY6kLMNr+xR0AJkzRgAqPePDI1IgsXdqAc2Y0pB4pOQZK0rx/ghoz5
         6XOUvtzlzfKfeNG3AKvvy3iYcvFUoR1yf3xfKtbPpbk9NHb9fCCBjE4bdVmVboguiNtm
         DgVZNLFZDaHjvajPgMaOlZkX+yB2vvw5yhsj+o2Qd/9R/sW0mKPEORMeXqAjTc8y8QGA
         P8Ug==
X-Gm-Message-State: AOAM532SE1+Q/OnnbzlWAPEAaK9qZ7IB5g1K2rEZ+ZUx2Du8pANh9Dlt
        rw89taW8TWyO4H0NpzLwU9JePFJXnQOKFlzLDF4O/JWAQW+2tYWnhyS4G4W6PRwtIvhX/PQ6DWA
        TSTRrJoV/BCSS9jtx6pG96ew2asP9lo3rA0dsBcJ7teOsuLX3zygGxxw5hKUMbw1xTMeON1c=
X-Received: by 2002:aa7:ccc1:: with SMTP id y1mr4298859edt.321.1628760359375;
        Thu, 12 Aug 2021 02:25:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEBq9oFMKPHKC0VVR66AW0femrTFVzF3KVdtJ7+wr139TGR8+oT8sIuuAXze7KXGjYaHg3dA==
X-Received: by 2002:aa7:ccc1:: with SMTP id y1mr4298842edt.321.1628760359188;
        Thu, 12 Aug 2021 02:25:59 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id d3sm107040edv.48.2021.08.12.02.25.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 02:25:58 -0700 (PDT)
Subject: Re: [PATCH 3/3] xfs: remove the xfs_dqblk_t typedef
To:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
References: <20210812084343.27934-1-hch@lst.de>
 <20210812084343.27934-4-hch@lst.de>
From:   Pavel Reichl <preichl@redhat.com>
Message-ID: <cdca9ee2-4b5d-835c-da32-e24cb5a148be@redhat.com>
Date:   Thu, 12 Aug 2021 11:25:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210812084343.27934-4-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Patch applies, builds and LGTM.

Reviewed-by: Pavel Reichl <preichl@redhat.com>

