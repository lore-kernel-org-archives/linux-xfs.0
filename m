Return-Path: <SRS0=2WGG=DC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987CBC4363D
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 13:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 487032087D
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 13:41:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OmDU5HB8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgIYNlA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Sep 2020 09:41:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41525 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727982AbgIYNlA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Sep 2020 09:41:00 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601041259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3XNPRAL+Wod2pMq4gPFxXH27xhCoWxapCyujrBtI33w=;
        b=OmDU5HB8keV5+FG0hK6x5kp3lh+r+Kh1u26WZBgeOh7L1oBTL86crWvOZ6ZXnXdRUECb3Z
        rXyfdI0Um4kFS/wCbVsLDr8b7aPeyQ4TIlwmP4T4PIjXLsVnBN/jlRTNMb3aYZB8b4CFHV
        ECaY0wgpFfsnqxarbgVcI96wp5bJjLE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-JM0JbGZ7MyytJNV_pbI0bg-1; Fri, 25 Sep 2020 09:40:57 -0400
X-MC-Unique: JM0JbGZ7MyytJNV_pbI0bg-1
Received: by mail-wr1-f69.google.com with SMTP id j7so1089416wro.14
        for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2020 06:40:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3XNPRAL+Wod2pMq4gPFxXH27xhCoWxapCyujrBtI33w=;
        b=TnRe+vkD8R7DZymUNTZ2QVF4tTUJvWZxASV2tp/w8MiQYt4cs69h2A4SpOHixmUZ5S
         HmPwWU/MP1hQM6GD3QUKDcmPzUg2tad3fpqP6r4YtABijF6Zk88SHGdfCuWMhAJ4TWgg
         S5u8kzQrlST0DqFN9I82nTzPUkXErYN1fI324NafvhpmM910dA8nCpwonRULOyUfeRJS
         FB0dDekg71CbghX9pL5OYC2XOXKeoxjuwyZcR83SkYhvL1U+4XcrJcV2QUiqVXKucY8T
         0zxNM+Qp76BikQCu8NevU5ITr9S7pN1oBf+nYHi7Vlh/gEPcAMgrRiMoS5SfbU1HVEuD
         eGcg==
X-Gm-Message-State: AOAM530S6BL1kcaDSkVGbXX6ICXlsQWFsDvcfrzjw8VWIV5bj83sljaf
        Z64W3DGtiIGKycXfspr9GlFDC7UuYLuus+9qpvxH8hpee0dfIGIWeHE8i/L1ZSwb8WGa80dCiX5
        hWSXwRWsPCqw4iweAtLC2
X-Received: by 2002:adf:ce01:: with SMTP id p1mr4688228wrn.61.1601041256064;
        Fri, 25 Sep 2020 06:40:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXDhxJHLv6w+CNnFY6HWQ65khEr3xW+nPBpgOL8TuH4oLB4DpZwbCx0bqj5+QYW44qKpseqg==
X-Received: by 2002:adf:ce01:: with SMTP id p1mr4688214wrn.61.1601041255920;
        Fri, 25 Sep 2020 06:40:55 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id n4sm2869621wrp.61.2020.09.25.06.40.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 06:40:55 -0700 (PDT)
Subject: Re: [PATCH 1/2] xfs: remove deprecated mount options
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
References: <20200924170747.65876-1-preichl@redhat.com>
 <20200924170747.65876-2-preichl@redhat.com> <20200924172600.GG7955@magnolia>
 <be017461-6ce9-1d64-51d6-7e85a3e45055@sandeen.net>
 <20200924174913.GI7955@magnolia>
From:   Pavel Reichl <preichl@redhat.com>
Message-ID: <bebb2448-2b0e-6a39-79b2-18b6fb8811ee@redhat.com>
Date:   Fri, 25 Sep 2020 15:40:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200924174913.GI7955@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thanks for discussion, if I get it right, the only thing to change is to add the date when mount options will me removed (September 2025)?

