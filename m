Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF671C33CB1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 09:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B75BA2084D
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 09:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578992706;
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:List-ID:From;
	b=yNsD9v2xT0eVSkAkmKrnxg4wLcC3gpVlF1Y62kPxLNh8RvwfJPDHKZ4GWpRb2P9fW
	 FVD4dwxEObtb1YMT0aNG4QqfkpOSHD6o2ZhRv9vFcLFxoaINlx95n5tzg95ji3E0uZ
	 EMmxbqg8boPb3AdpVxlpQtwMmIMDKNZwUOOMRz7Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbgANJFE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 04:05:04 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33740 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgANJFD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 04:05:03 -0500
Received: by mail-wm1-f68.google.com with SMTP id d139so1790478wmd.0;
        Tue, 14 Jan 2020 01:05:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
        b=jT2pbQYlBxbSSWB3OgGJslJsDx53KYYeq5/y/xT6AdHZcpVrBqQ/LBlF798yQVKCt4
         p6NcCaJa3yRmid76phu8WlvsR6MjRXcwwT17zTgo/+mswiFk679hKBhI+E1grtWXCqKz
         yi0TVg7EG2cDpuCK7YzAiAo3mxFT5zOcSsTeGJEfFHg7loA9X+FgwEi8LnLNfA0qaMpp
         2s8xGm+6/ZSMl9fTS9ArN86SEX83fQWbOQPtJHxZEz3DphrMGAhilxUO/wAOA2skHS30
         fn0gEEgm10O5ByNPJ57x3c2Ncm/LnXXm1vNhRZyCP85l8oKwjhFr2Mo9HdVXsk/uVyTj
         K84A==
X-Gm-Message-State: APjAAAVOjwbjpHvS/FSZNDi8R5umWwGxwHTk8MA0Y6HHL9wLRfnOFNaU
        EYGmgGrZD9fBLZsv4yf7LpA=
X-Google-Smtp-Source: APXvYqz4KyHtGND35ojY/631vDAbMq1Lwj5GsUP02LOCP2QEkZChrQmK2l70WkoV6DFuurTtP9+vng==
X-Received: by 2002:a1c:6404:: with SMTP id y4mr25656220wmb.143.1578992702060;
        Tue, 14 Jan 2020 01:05:02 -0800 (PST)
Received: from Johanness-MBP.fritz.box (ppp-46-244-194-230.dynamic.mnet-online.de. [46.244.194.230])
        by smtp.gmail.com with ESMTPSA id r68sm17701861wmr.43.2020.01.14.01.05.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2020 01:05:01 -0800 (PST)
Subject: Re: [PATCH v6 1/2] fs: New zonefs file system
To:     Damien Le Moal <damien.lemoal@wdc.com>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Naohiro Aota <naohiro.aota@wdc.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Hannes Reinecke <hare@suse.de>
References: <20200108083649.450834-1-damien.lemoal@wdc.com>
 <20200108083649.450834-2-damien.lemoal@wdc.com>
From:   Johannes Thumshirn <jth@kernel.org>
Message-ID: <aaacd8bc-8d91-0602-7571-355406fb3812@kernel.org>
Date:   Tue, 14 Jan 2020 10:04:59 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200108083649.450834-2-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
