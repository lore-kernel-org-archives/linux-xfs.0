Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8277AC3404E
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 05:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5907424656
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 05:08:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="RgOjpyIf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbgBSFIo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 00:08:44 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41366 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgBSFIo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 00:08:44 -0500
Received: by mail-qt1-f193.google.com with SMTP id l21so16323885qtr.8
        for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2020 21:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=vc6YlYlAOA1rjbOsb82NsogOb2ZpbnqN2uw8PfRTHEY=;
        b=RgOjpyIfFjR6B0uA5D7zCDTmXyORi0w762l2y9wVQMniaUPR8ADbaN6wIVsjdtf5AE
         7yMsZGFGNQ1tXXRpZAAOWcYhWyj6zYRrwC7Drxn23pkXSCI0ZS40HofwVn9a3RcgfBUr
         rcSa/X6PjkllY/Lb2Fo5b66yOrLcldwJtu8bsxATXDPCnzNjb4mYgZsz7mzsrDJMJVva
         MR7SJyTgQgBZ2l6B/3b8fWxTEQ7Tpk5qkOTYCGUpoxAiLVoXYKAtf3WnsYBI7xwNmiS5
         cNqtQ05I/5HSP0JTPtk/yqOLuQcPjQ3jwD6woh+qV74hz9xqXPMcqy5q9h+eXyWzsgcG
         ST+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=vc6YlYlAOA1rjbOsb82NsogOb2ZpbnqN2uw8PfRTHEY=;
        b=SKfv1GfuuYE4EZ4kMbNPsJyCsdKhs4JIo3SOm4pkqQfDbmBskqi7LKddoFr9xaWJhB
         yel85Scz33/dXyzSaIybf6V+7EahPd1Pdsbjk/Nxhemo/BEFlc3gxNviwh+zKmloCJ8J
         tatnDUS4quOf4sH1lH7IsIrQkPNxvghNQVZEK/7I+KcZrjjksNWDSnQAt8jXTfIm1zsP
         4K6yXb91eYuEp+5cMdGTKD/IAjuOAcKGkpiIhbsBzHRpBUDkJ7QFZMf0aJ/rz34Rx1YN
         PmXDBSezm7R/ggiw2KqblE6Pq2ih32IOquD8ZVh3Dl514JN2MPq6nAJU2aoVwbwzwqqV
         6ZqQ==
X-Gm-Message-State: APjAAAWXGAJQvVEXrK3RS3V+dkxs7Llq0SzyFZp3KpuQIQfBbCh6iieI
        h5wU/7sVTqsV5R9kn6iIfCfsSw==
X-Google-Smtp-Source: APXvYqxCqNwfVCmC7sgampv6A9mG/doIeARVc33qlprpJA7If5awjnN8E9j3V1vBlbDoiUhAa+iT2A==
X-Received: by 2002:aed:3f32:: with SMTP id p47mr20990813qtf.374.1582088922202;
        Tue, 18 Feb 2020 21:08:42 -0800 (PST)
Received: from [192.168.1.183] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id m17sm446719qki.128.2020.02.18.21.08.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 21:08:41 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] fs: fix a data race in i_size_write/i_size_read
Date:   Wed, 19 Feb 2020 00:08:40 -0500
Message-Id: <EDCBB5B9-DEE4-4D4B-B2F4-F63179977D6C@lca.pw>
References: <20200219045228.GO23230@ZenIV.linux.org.uk>
Cc:     hch@infradead.org, darrick.wong@oracle.com, elver@google.com,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20200219045228.GO23230@ZenIV.linux.org.uk>
To:     Al Viro <viro@zeniv.linux.org.uk>
X-Mailer: iPhone Mail (17D50)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



> On Feb 18, 2020, at 11:52 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>=20
> If aligned 64bit stores on 64bit host (note the BITS_PER_LONG ifdefs) end u=
p
> being split, the kernel is FUBAR anyway.  Details, please - how could that=

> end up happening?

My understanding is the compiler might decide to split the load into saying t=
wo 4-byte loads. Then, we might have,

Load1
Store
Load2

where the load value could be a garbage. Also, Marco (the KCSAN maintainer) w=
ho knew more of compiler than me mentioned that there is no guarantee that t=
he store will not be split either. Thus, the WRITE_ONCE().

